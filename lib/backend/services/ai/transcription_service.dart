import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/backend/database/schemas/phrase.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/config/pipelines/pipeline_steps.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import 'package:eiga/backend/services/ai/ai_model_scorer.dart';
import 'package:eiga/backend/services/ai/audio_ai_service.dart';
import 'package:eiga/backend/services/audio/ffmpeg_service.dart';
import 'package:eiga/backend/services/petition_ai/gemini/gemini_service.dart';
import 'package:eiga/backend/services/petition_ai/gemini/gemini_streaming_service.dart';
import 'package:eiga/backend/services/database/ai_model_service.dart';
import 'package:eiga/backend/services/database/phrase_service.dart';
import 'package:eiga/backend/services/database/video_service.dart';
import 'package:eiga/backend/services/background/translation_background_manager.dart';
import 'package:eiga/backend/services/utils/ai_exceptions.dart';
import 'package:eiga/backend/services/utils/ai_error_handler.dart';
import 'package:eiga/utils/logger.dart';
import 'package:eiga/config/secure_storage.dart';
import 'package:eiga/config/prompts/prompt_manager.dart';

class TranscriptionService {
  final Ref ref;
  final AudioAiService audioAiService;
  final GeminiStreamingService geminiStreamingService;
  final FFmpegService ffmpegService;

  TranscriptionService({
    required this.ref, 
    required this.audioAiService,
    required this.geminiStreamingService,
    required this.ffmpegService,
  });

  Future<AiRequestResult> transcribeVideo({
    required Video video,
    required String spokenLanguage,
    Future<void> Function(String phase, double progress)? onProgress,
  }) async {

    logger.i('[Transcription] Starting for video ${video.id}, lang: $spokenLanguage');

    // Ensure state is reset at start safely - ONLY if not resuming
    final startOffset = video.transcriptionResumeSeconds ?? 0;
    if (startOffset == 0) {
      await _updateVideoMetadata(video.id, (v) {
        v.isSubtitleReady = false;
        v.audioStatus = 'processing';
        v.transcriptionStatus = 'pending';
        v.processingProgress = 0.05;
      });
    } else {
      await _updateVideoMetadata(video.id, (v) {
        v.audioStatus = 'processing';
        v.transcriptionStatus = 'pending';
        // Keep existing processingProgress
      });
    }


    // 1. Initial Ranking of models

    final modelService = ref.read(aiModelServiceProvider);
    final phraseService = ref.read(phraseServiceProvider);
    final videoService = ref.read(videoServiceProvider);
    
    final allModels = await modelService.getAllModels();
    List<AiModel> candidates = AiModelScorer.rankModels(allModels, AiTaskType.transcription);

    if (candidates.isEmpty) {
      logger.e('[Transcription] No suitable AI model found for transcription.');
      return AiRequestResult.failure(AiErrorType.unknown, message: 'No transcription model found. Please check AI settings.');
    }

    AiModel currentModel = candidates.first;
    int modelIndex = 0;

    logger.i('[Transcription] Primary model: ${currentModel.name}');

    await onProgress?.call('Extracting Audio', 0.1);

    await _updateVideoMetadata(video.id, (v) {
      v.audioStatus = 'processing';
      v.transcriptionStatus = 'pending';
    });


    // 2. Extract Audio & Chunk
    final config = ref.read(appConfigsServiceProvider);
    
    // Calculate adaptive chunk size based on model TPM
    int chunkMin = config.getAudioChunkDurationMinutes;
    
    if (config.getIsAdaptiveChunkSizeEnabled) {
      final int maxPossibleMin = (currentModel.tpmLimit / (currentModel.tokensPerAudioSecond * 60)).floor();
      
      if (chunkMin > maxPossibleMin) {
        logger.w('[Transcription] Requested chunk $chunkMin min exceeds model ${currentModel.name} TPM limit. Reducing to $maxPossibleMin min.');
        chunkMin = maxPossibleMin;
      }
    }
    
    // Safety floor: don't go below 1 minute if possible
    chunkMin = max(chunkMin, 1);


    final overlapSec = config.getTranscriptionOverlapSeconds;
    
    final tempDir = await getTemporaryDirectory();
    final audioDir = Directory('${tempDir.path}/transcription_${video.id}');
    if (audioDir.existsSync()) audioDir.deleteSync(recursive: true);
    audioDir.createSync();

    final videoPath = video.videoPath;
    if (videoPath == null) return AiRequestResult.failure(AiErrorType.unknown, message: 'Video path missing');

    try {
      // Get total duration
      final totalSeconds = await ffmpegService.getDuration(videoPath) ?? 1800;

      final int chunkSeconds = chunkMin * 60;
      final int totalChunks = (totalSeconds / (chunkSeconds - overlapSec)).ceil();
      final Set<String> seenPhrases = {};
      int globalPhraseOrder = 1;

      // Handle Resuming: ALWAYS load existing phrases to prevent duplicates
      final existing = await phraseService.getPhrasesByVideoId(video.id);
      for (var p in existing) {
        final key = '${p.startTime?.millisecondsSinceEpoch}_${p.originalPhrase?.trim()}';
        seenPhrases.add(key);
      }
      int totalPhrasesFound = existing.length;
      globalPhraseOrder = existing.isNotEmpty 
          ? (existing.map((e) => e.phraseOrder ?? 0).reduce(max) + 1) 
          : 1;

      int startOffset = video.transcriptionResumeSeconds ?? 0;
      
      // Smart recovery of startOffset if it was not saved correctly
      if (startOffset == 0 && existing.isNotEmpty) {
        final lastPhrase = existing.reduce((a, b) => 
          (a.endTime?.millisecondsSinceEpoch ?? 0) > (b.endTime?.millisecondsSinceEpoch ?? 0) ? a : b);
        if (lastPhrase.endTime != null) {
          final baseDate = DateTime(1970, 1, 1);
          startOffset = lastPhrase.endTime!.difference(baseDate).inSeconds;
          logger.i('[Transcription] Recovered startOffset from phrases: ${startOffset}s');
        }
      }

      if (startOffset > 0) {
        logger.i('[Transcription] Resuming for video ${video.id} from ${startOffset}s. Found $totalPhrasesFound existing phrases.');
      }
      
      int chunkIndex = (startOffset / (chunkSeconds - overlapSec)).floor() + 1;
      for (int start = startOffset; start < totalSeconds; start += (chunkSeconds - overlapSec)) {
        final end = min(start + chunkSeconds, totalSeconds);
        final actualDuration = end - start;
        if (actualDuration <= 0) break;

        final String progressPrefix = '[$chunkIndex/$totalChunks]';
        final double progressValue = (chunkIndex - 1) / totalChunks;
        
        await onProgress?.call('$progressPrefix Extracting audio... ($totalPhrasesFound subtitles)', progressValue);

        // Update essential status without overwriting everything
        await _updateVideoMetadata(video.id, (v) {
          v.audioStatus = 'processing';
          // progress is handled by onProgress call above
        });

        final chunkPath = '${audioDir.path}/chunk_$start.mp3';

        logger.d('[Transcription] [$chunkIndex/$totalChunks] Extracting $actualDuration sec to $chunkPath');
        
        final success = await ffmpegService.extractAudio(
          inputPath: videoPath, 
          outputPath: chunkPath, 
          startSeconds: start, 
          durationSeconds: actualDuration,
        );

        if (!success) {
          onProgress?.call('$progressPrefix FFmpeg Error', (chunkIndex - 1) / totalChunks);
          continue;
        }

        await onProgress?.call('$progressPrefix Transcribing via AI... ($totalPhrasesFound subtitles)', (chunkIndex - 0.5) / totalChunks);

        await _updateVideoMetadata(video.id, (v) {
          v.transcriptionStatus = 'processing';
          v.audioStatus = 'completed';
        });


        // 3. Transcribe Chunk
        bool chunkSuccess = false;
        List<Phrase> chunkPhrases = [];
        while (!chunkSuccess) {
          try {
            // Respect Free Tier limits: Add a safe delay between chunks
            if (chunkIndex > 1) {
               // More aggressive delay for low-TPM models like Transcribe (10K)
               final isLowTpm = currentModel.tpmLimit < 50000;
               final delaySec = isLowTpm ? 30 : 15;
               logger.d('[Transcription] Free Tier safety delay (${delaySec}s) for ${currentModel.name}...');
               await Future.delayed(Duration(seconds: delaySec));
            }


            final bytes = await File(chunkPath).readAsBytes();
            final base64Audio = base64Encode(bytes);
            
            final contextInfo = video.researchInformation != null && video.researchInformation!.isNotEmpty
                ? '\n\nCONTEXT (Use for proper nouns and terms):\n${video.researchInformation}'
                : '';

            final prompt = PromptManager.getPrompt(
              type: PromptType.transcription,
              sourceLanguage: spokenLanguage,
              targetLanguage: '', // Not needed for transcription
              contextBlock: video.researchInformation != null && video.researchInformation!.isNotEmpty
                  ? '\n\nCONTEXT (Use for proper nouns and terms):\n${video.researchInformation}'
                  : '',
            );

            // Use robust Unary call for audio transcription instead of streaming
            // Free Tier streaming with audio+JSON is currently unstable
            chunkPhrases = await _transcribeChunk(
              base64Audio: base64Audio,
              prompt: prompt,
              model: currentModel,
              startTimeOffset: Duration(seconds: start),
            );

            if (chunkPhrases.isEmpty) {
              throw GeminiGeneralException("AI returned empty results for this audio segment");
            }
            
            logger.i('[Transcription] [$chunkIndex/$totalChunks] Success! Received ${chunkPhrases.length} phrases from ${currentModel.name}');
            
            // Log Success Event via Handler
            await ref.read(aiErrorHandlerProvider).recordResult(
              modelName: currentModel.name,
              result: AiRequestPhase.success,
              step: 'transcription',
            );
            
            chunkSuccess = true;
          } catch (e) {
            logger.e('[Transcription] AI Chunk error with ${currentModel.name}: $e');

            // Log Error Event via Handler
            await ref.read(aiErrorHandlerProvider).recordException(
              e, 
              modelName: currentModel.name, 
              step: 'transcription'
            );
            
            // If it's a server error, rate limit, not found (404), Internal Error (500) or Empty, switch!

            final bool isRecoverable = e is GeminiServerException || 
                                       e is GeminiModelExpiredException ||
                                       e.toString().contains('503') || 
                                       e.toString().contains('500') ||
                                       e.toString().contains('demand') || 
                                       e.toString().contains('429') ||
                                       e.toString().contains('404') || 
                                       e.toString().contains('empty') ||
                                       e.toString().contains('limit');
            
            if (isRecoverable) {
              // Penalty with specific error message
              await modelService.incrementErrorCount(currentModel.name, errorMessage: e.toString());


              if (e.toString().contains('429')) {
                logger.w('[Transcription] Quota exceeded for ${currentModel.name}. Marking as exhausted.');
                await modelService.markModelAsExhausted(currentModel.name);
              }
              
              // Smart delay based on server feedback (429 retry-after)
              int delaySec = 10;
              if (e is GeminiException && e.retryAfter != null) {
                delaySec = e.retryAfter!.inSeconds + 1;
                logger.i('[Transcription] API requested specific wait time: ${delaySec}s');
              } else if (e.toString().contains('429')) {
                delaySec = 30; // Default for rate limit
              }
              
              // Re-rank candidates before next try to see if someone else is better now
              final updatedModels = await modelService.getAllModels();
              candidates = AiModelScorer.rankModels(updatedModels, AiTaskType.transcription);
              
              if (modelIndex < candidates.length - 1) {
                modelIndex++;
                currentModel = candidates[modelIndex];
                logger.i('[Transcription] Switching model to ${currentModel.name} and retrying chunk...');
                await onProgress?.call('$progressPrefix Switching to ${currentModel.name}... ($totalPhrasesFound subtitles)', (chunkIndex - 0.5) / totalChunks);
                await Future.delayed(Duration(seconds: min(delaySec, 5))); // Wait a bit before switching
              } else {
                logger.w('[Transcription] All models exhausted for this chunk. Waiting ${delaySec}s before full retry...');
                await onProgress?.call('$progressPrefix Quota limit. Waiting ${delaySec}s...', (chunkIndex - 0.5) / totalChunks);
                await Future.delayed(Duration(seconds: delaySec));
                modelIndex = 0; // Start over with best model after waiting
                currentModel = candidates.first;
              }
              continue; 
            } else {
              // Unrecoverable error
              await modelService.incrementErrorCount(currentModel.name);
              rethrow;
            }
          }
        }

        // 4. Save Phrases Immediately (with deduplication for overlaps)
        final List<Phrase> phrasesToSave = [];
        for (var p in chunkPhrases) {
          final key = '${p.startTime?.millisecondsSinceEpoch}_${p.originalPhrase?.trim()}';
          if (!seenPhrases.contains(key)) {
            seenPhrases.add(key);
            p.videoId = video.id;
            p.phraseOrder = globalPhraseOrder++;
            phrasesToSave.add(p);
          }
        }

        if (phrasesToSave.isNotEmpty) {
          final processedPhrases = _postProcessPhrases(phrasesToSave);
          await phraseService.putPhrases(processedPhrases);
          totalPhrasesFound += processedPhrases.length;
          
          // Update Resume position and metadata safely
          await _updateVideoMetadata(video.id, (v) {
            v.transcriptionResumeSeconds = end;
          });

          // Reward the model for success
          await modelService.incrementUsage(currentModel.name, 1);
          
          logger.d('[Transcription] Saved ${processedPhrases.length} phrases from chunk $chunkIndex. Total: $totalPhrasesFound');
          await onProgress?.call('$progressPrefix Saved $totalPhrasesFound subtitles', (chunkIndex) / totalChunks);
        }

        
        chunkIndex++;
      }

      // 5. Finalize safely
      if (totalPhrasesFound == 0) {
        return AiRequestResult.failure(AiErrorType.unknown, message: 'Transcription yielded no results');
      }

      await _updateVideoMetadata(video.id, (v) {
        v.isSubtitleReady = true;
        v.audioStatus = 'completed';
        v.transcriptionStatus = 'completed';
        v.processingProgress = 1.0;
        v.originalLanguage = spokenLanguage;
      });


      // Auto-translate first batch if enabled
      if (config.getAutoTranslateOnImport) {
        final savedPhrases = await phraseService.getPhrasesByVideoId(video.id);
        if (savedPhrases.isNotEmpty) {
          final batchSize = config.getNumberOfPhrases;
          final firstChunk = savedPhrases.take(batchSize).toList();
          ref.read(translationBackgroundManagerProvider).addTask(
            TranslationTask(
              videoId: video.id,
              phraseIds: firstChunk.map((e) => e.id).toList(),
              phraseOrders: firstChunk.map((e) => e.phraseOrder ?? 0).toList(),
              priority: TaskPriority.normal,
            )
          );
        }
      }

      await onProgress?.call('Finished ($totalPhrasesFound subtitles)', 1.0);

      return AiRequestResult.success();
    } catch (e) {
      logger.e('[Transcription] Error: $e');
      if (e is GeminiException) {
         return AiRequestResult.failure(e.type, message: e.message);
      }
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString());
    } finally {
      if (audioDir.existsSync()) audioDir.deleteSync(recursive: true);
    }
  }

  Future<List<Phrase>> _transcribeChunk({
    required String base64Audio,
    required String prompt,
    required AiModel model,
    required Duration startTimeOffset,
  }) async {
    final url = await _buildUrl(model);
    
    String response = '';
    int retries = 2; // Reduced retries to switch models faster if needed
    while (retries >= 0) {
      try {
        logger.v('[Transcription] Sending request to ${model.name}. Retries left: $retries');
        response = await audioAiService.sendAudioRequest(url, prompt, base64Audio, model: model);
        logger.v('[Transcription] Response received (${response.length} chars)');
        break; 
      } catch (e) {
        if (retries == 0) rethrow;
        retries--;
        
        // Better error detection: 503 (Server Busy) or 429 (Rate Limit)
        final bool isRateLimit = e is GeminiModelExpiredException;
        final bool isServerBusy = e is GeminiServerException || e.toString().contains('503') || e.toString().contains('demand');
        
        final int delaySec = isRateLimit ? 20 : (isServerBusy ? 10 : 5);
        
        logger.w('[Transcription] Chunk failed (${e.runtimeType}), retrying in ${delaySec}s... ($retries left)');
        await Future.delayed(Duration(seconds: delaySec));
      }
    }
    
    try {
      final decodedRaw = jsonDecode(response);
      if (decodedRaw == null || decodedRaw is! List || decodedRaw.isEmpty) {
        logger.w('[Transcription] AI returned empty or invalid JSON: $response');
        return [];
      }
      
      final List<dynamic> decoded = decodedRaw;
      final List<Phrase> phrases = [];
      final baseDate = DateTime(1970, 1, 1);
      
      for (var item in decoded) {
        final startMs = item['start_ms'] as int;
        final endMs = item['end_ms'] as int;
        final text = item['text'] as String;
        
        phrases.add(Phrase()
          ..originalPhrase = text
          ..startTime = baseDate.add(startTimeOffset + Duration(milliseconds: startMs))
          ..endTime = baseDate.add(startTimeOffset + Duration(milliseconds: endMs))
        );
      }
      return phrases;
    } catch (e) {
      logger.e('[Transcription] Failed to transcribe or parse chunk: $e');
      rethrow; // Rethrow to handle in the main loop
    }
  }

  Future<String> _buildUrl(AiModel model) async {
    final token = await SecureTokenStorage.getToken(ApiTokenType.gemini);
    // Smart version selection: 1.x models use v1, others use v1beta
    // Force v1beta for ALL models as v1 returns 404 for this user
    final baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/${model.name}';
    return '$baseUrl:generateContent?key=$token';
  }

  List<Phrase> _postProcessPhrases(List<Phrase> phrases) {
    if (phrases.isEmpty) return phrases;

    final List<Phrase> results = [];
    
    for (var p in phrases) {
      String text = p.originalPhrase?.trim() ?? '';
      if (text.isEmpty) continue;

      // 1. Basic Cleaning
      text = text.replaceAll(RegExp(r'\s+'), ' '); // Remove double spaces
      
      // 2. Remove trailing/leading punctuation that AI sometimes adds wrongly
      text = text.replaceAll(RegExp(r'^[、,，。．. ]+'), '');
      text = text.replaceAll(RegExp(r'[ 、,，。．. ]+$'), '');

      if (text.isEmpty) continue;
      p.originalPhrase = text;
      results.add(p);
    }

    // 3. Intelligent Merging: if phrases are very close and short, join them
    if (results.length > 1) {
      final List<Phrase> merged = [];
      for (int i = 0; i < results.length; i++) {
        if (merged.isEmpty) {
          merged.add(results[i]);
          continue;
        }
        
        final prev = merged.last;
        final curr = results[i];
        
        // If gap is < 300ms and both are short, merge them
        final gapMs = curr.startTime!.difference(prev.endTime!).inMilliseconds;
        if (gapMs < 300 && (prev.originalPhrase!.length + curr.originalPhrase!.length < 25)) {
           prev.originalPhrase = '${prev.originalPhrase} ${curr.originalPhrase}';
           prev.endTime = curr.endTime;
        } else {
           merged.add(curr);
        }
      }
      return merged;
    }

    return results;
  }

  Future<void> _updateVideoMetadata(int videoId, void Function(Video v) update) async {
    final videoService = ref.read(videoServiceProvider);
    final latest = await videoService.getVideoById(videoId);
    if (latest != null) {
      update(latest);
      await videoService.updateVideo(latest);
    }
  }
}

