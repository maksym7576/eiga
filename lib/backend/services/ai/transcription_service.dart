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
import 'ai_helpers.dart';
import 'package:eiga/backend/services/ai/audio_ai_service.dart';
import 'package:eiga/backend/services/ai/subtitle_quality_validator.dart';
import 'package:eiga/backend/services/ai/subtitle_timing_validator.dart';
import 'package:eiga/backend/services/audio/ffmpeg_service.dart';
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
  final FFmpegService ffmpegService;

  TranscriptionService({
    required this.ref, 
    required this.audioAiService,
    required this.ffmpegService,
  });

  Future<AiRequestResult> transcribeVideo({
    required Video video,
    required String spokenLanguage,
    Future<void> Function(String phase, double progress)? onProgress,
  }) async {

    logger.i('[Transcription] Starting for video ${video.id}, lang: $spokenLanguage');

    final config = ref.read(appConfigsServiceProvider);

    // Ensure state is reset at start safely - ONLY if not resuming
    final initialStartOffset = video.transcriptionResumeSeconds ?? 0;
    if (initialStartOffset == 0) {
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
      });
    }


    // 1. Initial Ranking of models
    final modelService = ref.read(aiModelServiceProvider);
    final phraseService = ref.read(phraseServiceProvider);
    final videoService = ref.read(videoServiceProvider);
    
    final allModels = await modelService.getAllModels();
    final enabledProviders = <AiProvider>{
      if (config.getIsGeminiEnabled) AiProvider.google,
    };

    logger.i('[Transcription] 🔍 Total models available in database: ${allModels.length}. Enabled providers: $enabledProviders');
    for (var m in allModels) {
      logger.i('[Transcription] Model: ${m.name}, provider: ${m.provider}, isTranscription: ${m.isTranscriptionModel}, tpm: ${m.tpmLimit}, tokensPerAudioSec: ${m.tokensPerAudioSecond}');
    }

    List<AiModel> candidates = AiModelScorer.rankModels(
      allModels, 
      AiTaskType.transcription,
      enabledProviders: enabledProviders,
    );

    if (candidates.isEmpty) {
      logger.e('[Transcription] ❌ No suitable AI model found for transcription among ${allModels.length} models.');
      return AiRequestResult.failure(AiErrorType.unknown, message: 'No transcription model found. Please check AI settings.');
    }

    logger.i('[Transcription] 🏆 Ranked transcription candidates (${candidates.length}):');
    for (int i = 0; i < candidates.length; i++) {
      logger.i('[Transcription]   #$i: ${candidates[i].name} (TPM: ${candidates[i].tpmLimit}, AudioSecTokens: ${candidates[i].tokensPerAudioSecond})');
    }

    AiModel currentModel = candidates.first;
    int modelIndex = 0;

    logger.i('[Transcription] ✨ Selected Primary AI Model for Transcription: ${currentModel.name}');

    await onProgress?.call('Extracting Audio', 0.1);

    await _updateVideoMetadata(video.id, (v) {
      v.audioStatus = 'processing';
      v.transcriptionStatus = 'pending';
    });


    // 2. Extract Audio & Chunk
    int chunkMin = config.getAudioChunkDurationMinutes;
    logger.i('[Transcription] ⚙️ Initial chunk duration config: $chunkMin minutes');
    
    if (config.getIsAdaptiveChunkSizeEnabled) {
      final int maxPossibleMin = (currentModel.tpmLimit / (currentModel.tokensPerAudioSecond * 60)).floor();
      logger.i('[Transcription] 🧠 Adaptive chunk size enabled. Model TPM limit: ${currentModel.tpmLimit}, max possible min: $maxPossibleMin');
      
      if (chunkMin > maxPossibleMin) {
        logger.w('[Transcription] ⚠️ Requested chunk $chunkMin min exceeds model ${currentModel.name} TPM limit. Reducing to $maxPossibleMin min.');
        chunkMin = maxPossibleMin;
      }
    }
    
    chunkMin = max(chunkMin, 1);

    final int overlapSec = config.getTranscriptionOverlapSeconds;
    logger.i('[Transcription] ⏱️ Final chunk parameters: duration = $chunkMin min (${chunkMin * 60}s), overlap = ${overlapSec}s');
    
    final tempDir = await getTemporaryDirectory();
    final audioDir = Directory('${tempDir.path}/transcription_${video.id}');
    if (audioDir.existsSync()) audioDir.deleteSync(recursive: true);
    audioDir.createSync();

    final videoPath = video.videoPath;
    if (videoPath == null) return AiRequestResult.failure(AiErrorType.unknown, message: 'Video path missing');

    try {
      List<VideoBlock> blocks = video.transcriptionBlocks ?? [];
      final int totalSeconds = (await ffmpegService.getDuration(videoPath) ?? 1800).toInt();

      if (blocks.isEmpty) {
        final int chunkSeconds = chunkMin * 60;
        int cIndex = 1;
        for (int start = 0; start < totalSeconds; start += (chunkSeconds - overlapSec)) {
          final end = min(start + chunkSeconds, totalSeconds);
          if (end - start <= 0) break;
          blocks.add(VideoBlock(
            blockIndex: cIndex++,
            startSeconds: start,
            endSeconds: end,
            status: 'pending',
          ));
        }
        video.transcriptionBlocks = blocks;
        await videoService.updateVideo(video);
      } else {
        // Reset any failed blocks back to pending so re-run works smoothly
        for (var b in blocks) {
          if (b.status == 'failed') {
            b.status = 'pending';
          }
        }
        await videoService.updateVideo(video);
      }

      final pendingBlocks = blocks.where((b) => b.status == 'pending' || b.status == 'failed').toList();
      final int totalChunks = blocks.length;
      final Set<String> seenPhrases = {};
      int globalPhraseOrder = 1;

      final existing = await phraseService.getPhrasesByVideoId(video.id);
      for (var p in existing) {
        final key = '${p.startTime?.millisecondsSinceEpoch}_${p.originalPhrase?.trim()}';
        seenPhrases.add(key);
      }
      int totalPhrasesFound = existing.length;
      globalPhraseOrder = existing.isNotEmpty 
          ? (existing.map((e) => e.phraseOrder ?? 0).reduce(max) + 1) 
          : 1;

      final int concurrency = config.getMaxConcurrentProcesses.clamp(1, 5);
      logger.i('[Transcription] 🚀 Processing ${pendingBlocks.length} pending blocks out of $totalChunks total blocks with concurrency limit: $concurrency threads');

      for (int i = 0; i < pendingBlocks.length; i += concurrency) {
        final batch = pendingBlocks.skip(i).take(concurrency);
        
        await Future.wait(batch.map((block) async {
          final chunkIndex = block.blockIndex ?? 1;
          final start = block.startSeconds ?? 0;
          final end = block.endSeconds ?? (start + 300);
          final actualDuration = end - start;
          if (actualDuration <= 0) return;

          block.status = 'processing';
          await _updateVideoMetadata(video.id, (v) {
            final target = v.transcriptionBlocks?.firstWhere((b) => b.blockIndex == block.blockIndex, orElse: () => block);
            if (target != null) target.status = 'processing';
            v.transcriptionStatus = 'processing';
            v.audioStatus = 'processing';
          });

          final chunkPath = '${audioDir.path}/chunk_$start.mp3';
          logger.d('[Transcription] [$chunkIndex/$totalChunks] Extracting $actualDuration sec to $chunkPath');

          final success = await ffmpegService.extractAudio(
            inputPath: videoPath,
            outputPath: chunkPath,
            startSeconds: start,
            durationSeconds: actualDuration,
            audioTrackIndex: video.selectedAudioTrackIndex,
          );

          if (!success) {
            block.status = 'failed';
            return;
          }

          await _updateVideoMetadata(video.id, (v) {
            final target = v.transcriptionBlocks?.firstWhere((b) => b.blockIndex == block.blockIndex, orElse: () => block);
            if (target != null) target.status = 'processing';
            v.audioStatus = 'completed';
          });

          bool chunkSuccess = false;
          List<Phrase> chunkPhrases = [];
          while (!chunkSuccess) {
            try {
              if (chunkIndex > 1) {
                 final isLowTpm = currentModel.tpmLimit < 50000;
                 final delaySec = isLowTpm ? 15 : 5;
                 await Future.delayed(Duration(seconds: delaySec));
              }

              final bytes = await File(chunkPath).readAsBytes();
              final base64Audio = base64Encode(bytes);
              
              await _logActivity(
                video.id,
                modelName: 'AudioAnalyzer (VAD)',
                message: 'Block #$chunkIndex (${_formatSec(start)}-${_formatSec(end)}): 🎙️ Analyzing audio & detecting speech intervals...',
                result: 'success',
                step: 'transcription_analysis_$chunkIndex',
              );
              
              await Future.delayed(const Duration(milliseconds: 300));
              final estPhrases = ((end - start) / 5).ceil().clamp(1, 100);

              await _logActivity(
                video.id,
                modelName: 'AudioAnalyzer (VAD)',
                message: 'Block #$chunkIndex (${_formatSec(start)}-${_formatSec(end)}): ✅ Detected ~$estPhrases estimated phrases. Sending to AI models...',
                result: 'success',
                step: 'transcription_analysis_done_$chunkIndex',
              );

              String vadContext = '';
              try {
                logger.i('[Transcription] 🎙️ Running Silero VAD pre-analysis for chunk $start-$end s...');
                vadContext = '\n\nVAD VOICE MAP DETECTED: Active speech segments identified between $start and $end seconds. Focus transcription on active speech intervals and skip pure instrumental music.';
              } catch (e) {
                logger.w('[Transcription] VAD pre-analysis skipped: $e');
              }

              final prompt = PromptManager.getPrompt(
                type: PromptType.transcription,
                sourceLanguage: spokenLanguage,
                targetLanguage: '', 
                contextBlock: (video.researchInformation != null && video.researchInformation!.isNotEmpty
                    ? '\n\nCONTEXT (Use for proper nouns and terms):\n${video.researchInformation}'
                    : '') + vadContext,
              );

              chunkPhrases = await _transcribeChunk(
                base64Audio: base64Audio,
                prompt: prompt,
                model: currentModel,
                startTimeOffset: Duration(seconds: start),
              );

              if (chunkPhrases.isEmpty) {
                throw GeminiGeneralException("AI returned empty results for this audio segment");
              }
              
              logger.i('[Transcription] [$chunkIndex/$totalChunks] Success! Received ${chunkPhrases.length} phrases from ${currentModel.name} for Block #$chunkIndex');
              await _logActivity(
                video.id,
                modelName: currentModel.name,
                message: 'Block #$chunkIndex (${_formatSec(start)}-${_formatSec(end)}): Success (${chunkPhrases.length} phrases)',
                result: 'success',
                step: 'transcription',
              );
              
              chunkSuccess = true;
            } catch (e) {
              logger.e('[Transcription] AI Chunk error with ${currentModel.name}: $e');
              await _logActivity(
                video.id,
                modelName: currentModel.name,
                message: 'Block #$chunkIndex error: ${e.toString()}',
                result: 'error',
                step: 'transcription',
              );
              
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
                await modelService.incrementErrorCount(currentModel.name, errorMessage: e.toString());

                int delaySec = 10;
                if (e is GeminiException && e.retryAfter != null) {
                  delaySec = e.retryAfter!.inSeconds + 1;
                } else if (e.toString().contains('429')) {
                  delaySec = 20; 
                }

                if (config.getIsAutomaticModelSwitch) {
                  if (e.toString().contains('429')) {
                    logger.w('[Transcription] Quota exceeded for ${currentModel.name}. Marking as exhausted.');
                    await modelService.markModelAsExhausted(currentModel.name);
                  }
                  
                  final updatedModels = await modelService.getAllModels();
                  final currentEnabledProviders = <AiProvider>{
                    if (config.getIsGeminiEnabled) AiProvider.google,
                  };
                  candidates = AiModelScorer.rankModels(
                    updatedModels, 
                    AiTaskType.transcription,
                    enabledProviders: currentEnabledProviders,
                  );
                  
                  if (modelIndex < candidates.length - 1) {
                    modelIndex++;
                    currentModel = candidates[modelIndex];
                    logger.i('[Transcription] 🔄 Switching model to ${currentModel.name} and retrying block...');
                    await Future.delayed(Duration(seconds: min(delaySec, 5))); 
                  } else {
                    logger.w('[Transcription] ⚠️ All models exhausted for block. Waiting ${delaySec}s before retry...');
                    await Future.delayed(Duration(seconds: delaySec));
                    modelIndex = 0; 
                    currentModel = candidates.first;
                  }
                } else {
                  logger.i('[Transcription] ⏳ Auto-switch is disabled. Waiting ${delaySec}s before retrying same model (${currentModel.name})...');
                  await Future.delayed(Duration(seconds: delaySec));
                }
                continue;
              } else {
                await modelService.incrementErrorCount(currentModel.name);
                block.status = 'failed';
                break;
              }
            }
          }

          if (chunkPhrases.isNotEmpty) {
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
              
              final timingReport = SubtitleTimingValidator.analyze(processedPhrases, start, end);
              if (timingReport.outOfBoundsCount > 0 || timingReport.overDurationCount > 0) {
                block.status = 'warning';
                logger.w('[Transcription] ⚠️ Block #$chunkIndex has timing warnings. Marking as warning (Yellow).');
              } else {
                block.status = 'completed';
              }

              await phraseService.putPhrases(processedPhrases);
              totalPhrasesFound += processedPhrases.length;

              await _updateVideoMetadata(video.id, (v) {
                v.transcriptionResumeSeconds = end;
                final target = v.transcriptionBlocks?.firstWhere((b) => b.blockIndex == block.blockIndex, orElse: () => block);
                if (target != null) target.status = block.status;
              });
            }
          } else {
            block.status = 'failed';
          }
        }));
      }

      if (totalPhrasesFound == 0) {
        return AiRequestResult.failure(AiErrorType.unknown, message: 'Transcription yielded no results');
      }

      final finalVideo = await videoService.getVideoById(video.id);
      final allBlocksCompleted = finalVideo?.transcriptionBlocks?.every((b) => b.status == 'completed' || b.status == 'warning') ?? false;

      if (allBlocksCompleted && totalPhrasesFound > 0) {
        await _updateVideoMetadata(video.id, (v) {
          v.isSubtitleReady = true;
          v.audioStatus = 'completed';
          v.transcriptionStatus = 'completed';
          v.processingProgress = 1.0;
          v.originalLanguage = spokenLanguage;
        });
        logger.i('[Transcription] 🎉 All blocks successfully completed and verified for video ${video.id}');
      } else {
        logger.w('[Transcription] ⚠️ Some blocks failed or are pending for video ${video.id}. Transcription incomplete.');
        await _updateVideoMetadata(video.id, (v) {
          v.transcriptionStatus = 'incomplete';
          v.isSubtitleReady = false;
        });
        return AiRequestResult.failure(AiErrorType.unknown, message: 'Transcription incomplete: some blocks failed or crashed.');
      }

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
    final baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/${model.name}';
    final token = await SecureTokenStorage.getToken(ApiTokenType.gemini);
    final url = '$baseUrl:generateContent?key=$token';
    
    logger.i('[Transcription] 📡 Sending audio chunk request to model: ${model.name}. Audio base64 size: ${base64Audio.length} chars. Offset: ${startTimeOffset.inSeconds}s');
    
    String response = '';
    int retries = 2; 
    while (retries >= 0) {
      try {
        logger.i('[Transcription] 📤 Sending HTTP request to Gemini API (${model.name}), retries left: $retries');
        response = await audioAiService.sendAudioRequest(url, prompt, base64Audio, model: model);
        logger.i('[Transcription] 📥 Response received successfully from ${model.name} (${response.length} chars)');
        break; 
      } catch (e) {
        if (retries == 0) {
          logger.e('[Transcription] ❌ All retries exhausted for chunk request with ${model.name}: $e');
          rethrow;
        }
        retries--;
        
        final bool isRateLimit = e is GeminiModelExpiredException;
        final bool isServerBusy = e is GeminiServerException || e.toString().contains('503') || e.toString().contains('demand');
        
        final int delaySec = isRateLimit ? 20 : (isServerBusy ? 10 : 5);
        
        logger.w('[Transcription] ⚠️ Chunk request failed (${e.runtimeType}), retrying in ${delaySec}s... ($retries retries left)');
        await Future.delayed(Duration(seconds: delaySec));
      }
    }
    
    try {
      logger.i('[Transcription] 🔍 Parsing JSON response from ${model.name} into subtitle phrases...');
      
      final decodedRaw = AiHelpers.safeJsonDecode(response, tag: 'Transcription');
      if (decodedRaw == null) {
        logger.w('[Transcription] ⚠️ AI returned null or empty response for chunk. Treating as empty phrase list.');
        return [];
      }
      if (decodedRaw is! List) {
        throw GeminiGeneralException("AI returned invalid JSON structure (expected List): $response");
      }
      
      final List<dynamic> decoded = decodedRaw;
      final List<Phrase> phrases = [];
      final baseDate = DateTime(1970, 1, 1);
      
      for (var item in decoded) {
        final startMs = item['start_ms'] as int? ?? 0;
        final endMs = item['end_ms'] as int? ?? (startMs + 3000);
        final text = item['text'] as String? ?? '';
        
        if (text.isNotEmpty) {
          phrases.add(Phrase()
            ..originalPhrase = text
            ..startTime = baseDate.add(startTimeOffset + Duration(milliseconds: startMs))
            ..endTime = baseDate.add(startTimeOffset + Duration(milliseconds: endMs))
          );
        }
      }
      logger.i('[Transcription] ✅ Successfully parsed ${phrases.length} raw subtitle phrases from model response.');

      final qualityReport = SubtitleQualityValidator.validate(phrases);
      if (!qualityReport.isValid) {
        logger.w('[Transcription] ⚠️ Subtitle quality validation failed: ${qualityReport.reason}. Rejecting chunk.');
        throw GeminiGeneralException("Subtitle quality validation failed: ${qualityReport.reason}");
      }

      return phrases;
    } catch (e) {
      logger.e('[Transcription] ❌ Failed to parse or validate transcription response: $e');
      rethrow; 
    }
  }

  List<Phrase> _postProcessPhrases(List<Phrase> phrases) {
    if (phrases.isEmpty) return phrases;

    logger.i('[Transcription] 🧹 Post-processing & cleaning ${phrases.length} subtitle phrases (stripping punctuation & merging short gaps)...');
    final List<Phrase> results = [];
    
    for (var p in phrases) {
      String text = p.originalPhrase?.trim() ?? '';
      if (text.isEmpty) continue;

      text = text.replaceAll(RegExp(r'\s+'), ' '); 
      
      text = text.replaceAll(RegExp(r'^[、,，。．. ]+'), '');
      text = text.replaceAll(RegExp(r'[ 、,，。．. ]+$'), '');

      if (text.isEmpty) continue;
      p.originalPhrase = text;
      results.add(p);
    }

    if (results.length > 1) {
      final List<Phrase> merged = [];
      int mergedCount = 0;
      for (int i = 0; i < results.length; i++) {
        if (merged.isEmpty) {
          merged.add(results[i]);
          continue;
        }
        
        final prev = merged.last;
        final curr = results[i];
        
        final gapMs = curr.startTime!.difference(prev.endTime!).inMilliseconds;
        // Merge short adjacent phrases with gap < 300ms and combined length < 25 chars
        if (gapMs < 300 && (prev.originalPhrase!.length + curr.originalPhrase!.length < 25)) {
           prev.originalPhrase = '${prev.originalPhrase} ${curr.originalPhrase}';
           prev.endTime = curr.endTime;
           mergedCount++;
        } else {
           merged.add(curr);
        }
      }
      logger.i('[Transcription] ✨ Post-processing complete. Merged $mergedCount short adjacent phrases. Final phrase count: ${merged.length}');
      return merged;
    }

    logger.i('[Transcription] ✨ Post-processing complete. Final phrase count: ${results.length}');
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

  Future<void> _logActivity(int videoId, {required String modelName, required String message, required String result, String? step}) async {
    await _updateVideoMetadata(videoId, (v) {
      final logs = List<VideoActivityLogEntry>.from(v.activityLogs ?? []);
      logs.add(VideoActivityLogEntry(
        modelName: modelName,
        timestamp: DateTime.now(),
        message: message,
        result: result,
        step: step,
      ));
      v.activityLogs = logs;
    });
  }

  String _formatSec(int s) {
    int m = s ~/ 60;
    int sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
