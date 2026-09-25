import 'dart:convert';
import 'package:eiga/backend/services/ai/text_ai_service.dart';
import 'package:eiga/backend/services/ai/transcription_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/services/database/job_service.dart';
import 'package:eiga/backend/services/database/video_service.dart';
import 'package:eiga/backend/services/database/phrase_service.dart';
import 'package:eiga/backend/services/database/ai_model_service.dart';
import 'package:eiga/config/languages/language_hub.dart';
import 'package:eiga/backend/services/ai/ai_model_scorer.dart';
import 'package:eiga/backend/services/utils/ai_exceptions.dart';
import 'package:eiga/backend/services/utils/ai_error_handler.dart';
import 'package:eiga/utils/logger.dart';
import '../petition_ai/parsers/text_pipeline.dart';

import '../../../config/secure_storage.dart';
import '../../../providers/services/ai_request_state.dart';
import '../../../providers/services/ai_services_providers.dart';
import '../../../providers/services/app_configs_provider.dart';
import '../../../providers/services/isar_services_providers.dart';
import '../../database/schemas/ai_model.dart';
import '../../database/schemas/phrase.dart';
import '../../database/schemas/job.dart';
import '../../database/schemas/video.dart';
import '../pipelines/pipeline_abstract.dart';
import '../pipelines/pipeline_manager.dart';
import '../pipelines/pipeline_step_type.dart';
import 'audio_ai_service.dart';

class AiService {
  final Ref ref;
  final TextAiService textAiService;
  final AudioAiService audioAiService;
  final TranscriptionService transcriptionService;

  AiService({
    required this.ref,
    required this.textAiService,
    required this.audioAiService,
    required this.transcriptionService,
  });

  Future<AiRequestResult> runTranslationForVideo({
    required Video video,
    required List<Phrase> phrases,
  }) async {
    const String pipelineId = 'context_translation_v1';
    
    logger.d('[AiService] Running 4-stage translation for video ${video.id}');

    final phraseOrders = phrases.map((p) => p.phraseOrder ?? 0).toList();
    final jobId = await _startHistoryEntry(video.id, pipelineId, phrases.length, phraseOrders);

    try {
      final result = await processContextTranslationPipeline(
        video: video,
        phrases: phrases,
        jobId: jobId,
      );

      if (result.phase == AiRequestPhase.success) {
        await _completeHistoryEntry(jobId);
      } else {
        await _failHistoryEntry(
          jobId, 
          result.error?.message ?? 'Unknown error',
        );
      }
      return result;
    } catch (e) {
      await _failHistoryEntry(jobId, e.toString());
      rethrow;
    }
  }

  Future<AiRequestResult> runTranscriptionForVideo({
    required Video video,
    required String spokenLanguage,
  }) async {
    const String pipelineId = 'ai_transcription_v1';
    final jobId = await _startHistoryEntry(video.id, pipelineId, 100, []); // 100 as percentage

    try {
      final result = await transcriptionService.transcribeVideo(
        video: video,
        spokenLanguage: spokenLanguage,
        onProgress: (phase, progress) async {
          // Extract phrase count from phase string if present, e.g. "Extracting audio... (45 subtitles)"
          int? subtitleCount;
          final match = RegExp(r'\((\d+) subtitles\)').firstMatch(phase);
          if (match != null) {
            subtitleCount = int.tryParse(match.group(1)!);
          }

          await _updateStageProgress(
            jobId, 
            phase, 
            processed: (progress * 100).toInt(),
            status: progress >= 1.0 ? 'success' : null,
            totalPhrases: subtitleCount,
            videoId: video.id,
          );
        },
      );

      if (result.phase == AiRequestPhase.success) {
        await _completeHistoryEntry(jobId);
      } else {
        await _failHistoryEntry(jobId, result.error?.message ?? 'Transcription failed');
      }
      return result;
    } catch (e) {
      await _failHistoryEntry(jobId, e.toString());
      rethrow;
    }
  }

  Future<int> _startHistoryEntry(int videoId, String pipelineId, int totalPhrases, List<int> phraseOrders) async {
    final service = ref.read(jobServiceProvider);
    final config = ref.read(appConfigsServiceProvider);
    
    final job = Job(
      videoId: videoId,
      pipelineId: pipelineId,
      status: 'active',
      startTime: DateTime.now(),
      totalPhrases: totalPhrases,
      processedPhrases: 0,
      phraseOrders: phraseOrders,
      isAuto: config.getIsAutomaticModelSwitch,
      stageHistory: [],
    );

    return await service.saveJob(job);
  }

  Future<void> _updateStageProgress(int jobId, String stageName, {int? processed, String? status, String? modelName, int? totalPhrases, int? videoId}) async {
    final service = ref.read(jobServiceProvider);
    final job = await service.getJobById(jobId);
    if (job == null) return;

    job.phase = stageName;
    if (processed != null) job.processedPhrases = processed;
    if (modelName != null) job.modelName = modelName;
    
    // For transcription, totalPhrases is used as percentage base (100)
    // For translation, it's the actual phrase count.
    if (totalPhrases != null && !job.pipelineId!.contains('transcription')) {
      job.totalPhrases = totalPhrases;
    }
    
    // Proactively update Video progress to trigger UI animations
    if (videoId != null && processed != null) {
      final videoService = ref.read(videoServiceProvider);
      final video = await videoService.getVideoById(videoId);
      if (video != null) {
        // Use the job's own calculation for consistency
        final double progressValue;
        if (job.totalPhrases != null && job.totalPhrases! > 0) {
          progressValue = (job.processedPhrases ?? 0) / job.totalPhrases!;
        } else {
          progressValue = (processed / 100.0);
        }
        
        // Ensure progress NEVER goes backwards
        final newProgress = 0.05 + (progressValue * 0.95);
        if (newProgress > (video.processingProgress ?? 0.0)) {
           video.processingProgress = newProgress;
           await videoService.updateVideo(video);
        }
      }
    }


    if (status != null) {
      final startTime = job.stageHistory?.isEmpty == true 
          ? job.startTime 
          : job.startTime?.add(Duration(milliseconds: job.stageHistory!.fold(0, (sum, e) => sum + (e.durationMs ?? 0))));
      
      final duration = DateTime.now().difference(startTime ?? DateTime.now()).inMilliseconds;
      
      final stages = List<AiStageHistory>.from(job.stageHistory ?? []);
      stages.add(AiStageHistory(
        stageName: stageName,
        durationMs: duration,
        status: status,
        modelName: job.modelName,
      ));
      job.stageHistory = stages;
    }

    await service.updateJob(job);
  }

  Future<void> _completeHistoryEntry(int jobId) async {
    final service = ref.read(jobServiceProvider);
    final job = await service.getJobById(jobId);
    if (job == null) return;

    job.status = 'success';
    job.endTime = DateTime.now();
    job.translatedAt = DateTime.now();
    job.processedPhrases = job.totalPhrases;

    await service.updateJob(job);
  }

  Future<void> _failHistoryEntry(int jobId, String error) async {
    final service = ref.read(jobServiceProvider);
    final job = await service.getJobById(jobId);
    if (job == null) return;

    job.status = 'error';
    job.endTime = DateTime.now();
    job.errorMessage = error;
    job.errorStage = job.phase;

    await service.updateJob(job);
  }

  Future<String> _buildUrl(AiModel model, {bool? forceStreaming}) async {
    final bool isStreaming = forceStreaming ?? 
        (model.supportsStreaming && model.currentStreamingEnabled);

    switch (model.provider) {
      case AiProvider.google:
        final token = await SecureTokenStorage.getToken(ApiTokenType.gemini);
        final endpoint = isStreaming ? ':streamGenerateContent' : ':generateContent';
        final sse = isStreaming ? '&alt=sse' : '';
        
        // Force v1beta for ALL models for consistency and compatibility
        return 'https://generativelanguage.googleapis.com/v1beta/models/${model.name}$endpoint?key=$token$sse';
      
      case AiProvider.groq:
        return 'https://api.groq.com/openai/v1/chat/completions';

      case AiProvider.openai:
      case AiProvider.anthropic:
      case AiProvider.custom:
        return model.url;
    }
  }

  Future<AiRequestResult> processContextTranslationPipeline({
    required Video video,
    required List<Phrase> phrases,
    required int jobId,
  }) async {
    final pipelineResult = await PipelineManager.build(ref, videoId: video.id, pipelineId: 'context_translation_v1');

    if (pipelineResult == null) throw Exception('Pipeline build failed: ID ${video.pipelineIndetificator ?? 'context_translation_v1'} not found or video missing');

    if (video.pipelineIndetificator == null) {
      video.pipelineIndetificator = 'context_translation_v1';
      await ref.read(videoServiceProvider).updateVideo(video);
    }

    final plan = await _buildExecutionPlan(video, phrases);
    
    final phraseService = ref.read(phraseServiceProvider);
    final jobService = ref.read(jobServiceProvider);
    final config = ref.read(appConfigsServiceProvider);
    final initialJob = await jobService.getJobById(jobId);
    
    if (initialJob != null) {
      if (plan.isNotEmpty) {
        // If automatic model switch is ON, let's proactively pick the best model for the first step
        if (config.getIsAutomaticModelSwitch) {
           final firstStepType = _mapTypeToStep(plan[0]['type']);
           if (firstStepType != null) {
              final allModels = await ref.read(aiModelServiceProvider).getAllModels();
              final enabledProviders = {
                if (config.getIsGeminiEnabled) AiProvider.google,
                if (config.getIsGroqEnabled) AiProvider.groq,
              };
              final ranked = AiModelScorer.rankModels(
                allModels, 
                _mapStepToScorerTask(firstStepType),
                enabledProviders: enabledProviders,
              );
              if (ranked.isNotEmpty) {
                 initialJob.modelName = ranked.first.name;
              }
           }
        } else {
          final firstStepType = _mapTypeToStep(plan[0]['type']);
          if (firstStepType != null) {
             final stepResult = pipelineResult.steps.where((s) => s.type == firstStepType).firstOrNull;
             if (stepResult != null) {
               initialJob.modelName = stepResult.model.name;
             }
          }
        }
      }
      initialJob.executionPlan = jsonEncode(plan);
      initialJob.completedSteps = 0;
      await jobService.updateJob(initialJob);
    }

    if (plan.isEmpty) return AiRequestResult.success();

    try {
      for (int i = 0; i < plan.length; i++) {
        final step = plan[i];
        final type = step['type'] as String;
        final List<dynamic> stepIds = step['ids'] ?? [];
        
        AiRequestResult result;
        logger.d('[AiService] Executing step $i: $type for ${stepIds.length} phrases');
        
        final stepType = _mapTypeToStep(type);
        PipelineStepResult currentStepResult = pipelineResult.stepOf(stepType!);
        
        // Dynamic model selection for every step if Auto-Switch is enabled
        if (config.getIsAutomaticModelSwitch) {
           final allModels = await ref.read(aiModelServiceProvider).getAllModels();
           final enabledProviders = {
             if (config.getIsGeminiEnabled) AiProvider.google,
             if (config.getIsGroqEnabled) AiProvider.groq,
           };
           final ranked = AiModelScorer.rankModels(
             allModels, 
             _mapStepToScorerTask(stepType),
             enabledProviders: enabledProviders,
           );
           if (ranked.isNotEmpty) {
              currentStepResult = PipelineStepResult(
                type: stepType, 
                model: ranked.first, 
                prompt: currentStepResult.prompt
              );
           }
        }

        switch (type) {
          case 'context':
            await phraseService.setStages(stepIds.cast<int>(), StageKey.context, StageState.processing);
            result = await _executeContextStep(video, currentStepResult, jobId);
            await phraseService.setStages(stepIds.cast<int>(), StageKey.context, result.phase == AiRequestPhase.success ? StageState.completed : StageState.error);
            break;
          case 'translation':
            await phraseService.setStages(stepIds.cast<int>(), StageKey.translation, StageState.processing);
            result = await _executeTranslationBatch(stepIds, currentStepResult, jobId);
            await phraseService.setStages(stepIds.cast<int>(), StageKey.translation, result.phase == AiRequestPhase.success ? StageState.completed : StageState.error);
            break;
          case 'tokenize_source':
            await phraseService.setStages(stepIds.cast<int>(), StageKey.tokenizeSource, StageState.processing);
            result = await _executeTokenizeBatch(stepIds, currentStepResult, jobId, isOrig: true);
            await phraseService.setStages(stepIds.cast<int>(), StageKey.tokenizeSource, result.phase == AiRequestPhase.success ? StageState.completed : StageState.error);
            break;
          case 'tokenize_translation':
            await phraseService.setStages(stepIds.cast<int>(), StageKey.tokenizeTranslation, StageState.processing);
            result = await _executeTokenizeBatch(stepIds, currentStepResult, jobId, isOrig: false);
            await phraseService.setStages(stepIds.cast<int>(), StageKey.tokenizeTranslation, result.phase == AiRequestPhase.success ? StageState.completed : StageState.error);
            break;
          case 'morphology':
            await phraseService.setStages(stepIds.cast<int>(), StageKey.morphology, StageState.processing);
            result = await _executeMorphologyBatch(stepIds, currentStepResult, jobId);
            await phraseService.setStages(stepIds.cast<int>(), StageKey.morphology, result.phase == AiRequestPhase.success ? StageState.completed : StageState.error);
            break;
          case 'grammar_role':
            await phraseService.setStages(stepIds.cast<int>(), StageKey.grammarRole, StageState.processing);
            result = await _executeGrammarRoleBatch(stepIds, currentStepResult, jobId);
            await phraseService.setStages(stepIds.cast<int>(), StageKey.grammarRole, result.phase == AiRequestPhase.success ? StageState.completed : StageState.error);
            break;
          default:
            result = AiRequestResult.success();
        }

        if (result.phase == AiRequestPhase.error) {
          logger.e('[AiService] Step $type FATAL ERROR: ${result.error?.message}');
          
          if (result.error?.message?.contains('429') == true && currentStepResult.model != null) {
            logger.w('[AiService] Quota exceeded for ${currentStepResult.model.name}. Marking as exhausted.');
            await ref.read(aiModelServiceProvider).markModelAsExhausted(currentStepResult.model.name);
          }

          await _failHistoryEntry(jobId, result.error?.message ?? 'Step failed');
          return result;
        }

        if (result.phase == AiRequestPhase.partialSuccess) {
          logger.w('[AiService] Step $type partially succeeded. Continuing...');
        }
        
        logger.d('[AiService] Step $type completed (Phase: ${result.phase.name})');

        final currentJob = await jobService.getJobById(jobId);
        if (currentJob != null) {
          currentJob.completedSteps = i + 1;
          
          // Update processed count incrementally for terminal stages
          if (type == 'grammar_role' || type == 'translation') {
            final int currentProcessed = currentJob.processedPhrases ?? 0;
            currentJob.processedPhrases = (currentProcessed + stepIds.length).clamp(0, currentJob.totalPhrases ?? 0);
          }
          
          await jobService.updateJob(currentJob);
        }
      }
      return AiRequestResult.success();
    } catch (e, st) {
      logger.e('Pipeline execution failed', error: e, stackTrace: st);
      await _failHistoryEntry(jobId, e.toString());
      if (e is GeminiException) return AiRequestResult.failure(e.type);
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString());
    }
  }

  AiTaskType _mapStepToScorerTask(PipelineStepType step) {
    switch (step) {
      case PipelineStepType.contextResearch: return AiTaskType.research;
      case PipelineStepType.translation: return AiTaskType.translation;
      case PipelineStepType.tokenize: return AiTaskType.tokenization;
      case PipelineStepType.morphemes: return AiTaskType.tokenization; // Shared logic for now
      case PipelineStepType.grammarRole: return AiTaskType.translation; // Quality matters here
    }
  }

  Future<List<Map<String, dynamic>>> _buildExecutionPlan(Video video, List<Phrase> phrases) async {
    final config = ref.read(appConfigsServiceProvider);
    final List<Map<String, dynamic>> plan = [];
    
    final origLangName = video.originalLanguage ?? 'Japanese';
    final destLangName = video.translatedLanguage ?? 'English';
    
    final origMethod = config.getTokenizationMethod(origLangName);
    final destMethod = config.getTokenizationMethod(destLangName);

    final toTranslateIds = phrases.where((p) => p.translatedPhrase == null || p.translatedPhrase!.isEmpty).map((e) => e.id).toList();
    final toTokenizeOrigIds = phrases.where((p) => p.originalTokens == null || p.originalTokens!.isEmpty).map((e) => e.id).toList();
    final toTokenizeDestIds = phrases.where((p) => p.translatedWords == null || p.translatedWords!.isEmpty).toList();
    final toMorphIds = phrases.where((p) => p.stageStatuses[StageKey.morphology] != 'completed').map((e) => e.id).toList();
    final toGrammarRoleIds = phrases.where((p) => p.stageStatuses[StageKey.grammarRole] != 'completed').map((e) => e.id).toList();

    if (video.isResearchDone != true && toTranslateIds.isNotEmpty) {
      plan.add({
        'type': 'context', 
        'method': 'ai',
        'ids': phrases.map((e) => e.id).toList(),
      });
    }

    if (toTranslateIds.isNotEmpty) {
      _addBatchesToPlan(plan, 'translation', toTranslateIds, config.getBatchSizeTranslate, extra: {'method': 'ai'});
    }

    // 3. Tokenization (Predictive)
    // For original language
    if (toTokenizeOrigIds.isNotEmpty) {
      final methodStr = (origMethod == TokenizationMethod.ai) ? 'ai' : 'local';
      _addBatchesToPlan(plan, 'tokenize_source', toTokenizeOrigIds, config.getBatchSizeTokenize, extra: {'method': methodStr});
    }

    // For translated language
    final List<int> destTokenizeIds = {
      ...toTranslateIds, 
      ...phrases.where((p) => p.translatedWords == null || p.translatedWords!.isEmpty).map((e) => e.id)
    }.toList();

    if (destTokenizeIds.isNotEmpty) {
      final methodStr = (destMethod == TokenizationMethod.ai) ? 'ai' : 'local';
      _addBatchesToPlan(plan, 'tokenize_translation', destTokenizeIds, config.getBatchSizeTokenize, extra: {'method': methodStr});
    }

    // 4. Morphology (Predictive)
    final List<int> morphologyNeededIds = {
      ...toTranslateIds,
      ...toTokenizeOrigIds,
      ...toTokenizeDestIds.map((e) => e.id),
      ...toMorphIds,
    }.toList();

    if (morphologyNeededIds.isNotEmpty) {
      _addBatchesToPlan(plan, 'morphology', morphologyNeededIds, config.getBatchSizeMorphemes, extra: {'method': 'ai'});
    }

    // 5. Grammar Role & Sentence Diagram (Predictive)
    final List<int> grammarRoleNeededIds = {
      ...morphologyNeededIds,
      ...toGrammarRoleIds,
    }.toList();

    if (grammarRoleNeededIds.isNotEmpty) {
      _addBatchesToPlan(plan, 'grammar_role', grammarRoleNeededIds, config.getBatchSizeGrammarRole, extra: {'method': 'ai'});
    }

    return plan;
  }

  PipelineStepType? _mapTypeToStep(String type) {
    switch (type) {
      case 'context': return PipelineStepType.contextResearch;
      case 'translation': return PipelineStepType.translation;
      case 'tokenize': 
      case 'tokenize_source':
      case 'tokenize_translation':
        return PipelineStepType.tokenize;
      case 'morphology': return PipelineStepType.morphemes;
      case 'grammar_role': return PipelineStepType.grammarRole;
      default: return null;
    }
  }

  void _addBatchesToPlan(List<Map<String, dynamic>> plan, String type, List<int> ids, int batchSize, {Map<String, dynamic>? extra}) {
    final batchCount = (ids.length / batchSize).ceil();
    for (int i = 0; i < batchCount; i++) {
      final start = i * batchSize;
      final end = (start + batchSize) > ids.length ? ids.length : (start + batchSize);
      plan.add({
        'type': type,
        'ids': ids.sublist(start, end),
        ...?extra,
      });
    }
  }

  Future<AiRequestResult> _executeContextStep(Video video, PipelineStepResult step, int jobId) async {
    await _updateStageProgress(jobId, 'Context', modelName: step.model.name);
    try {
      final url = await _buildUrl(step.model, forceStreaming: false);
      final response = await textAiService.sendRequest(url, step.prompt, model: step.model);
      
      final videoService = ref.read(videoServiceProvider);
      final latestVideo = await videoService.getVideoById(video.id);

      if (latestVideo != null) {
        latestVideo.isResearchDone = true;
        latestVideo.researchInformation = TextPipeline.clean(response, field: TextField.researchContext);
        await videoService.updateVideo(latestVideo);
      }
      
      final result = AiRequestResult.success();
      
      await ref.read(aiErrorHandlerProvider).recordResult(
        modelName: step.model.name,
        result: result.phase,
        message: result.error?.message,
        step: 'context',
      );

      if (result.phase == AiRequestPhase.success) {
        await _updateStageProgress(jobId, 'Context', status: 'success');
      }
      return result;
    } catch (e) {
      await ref.read(aiErrorHandlerProvider).recordException(
        e, 
        modelName: step.model.name, 
        step: 'context'
      );
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString(), stepType: 'context', model: step.model);
    }
  }

  Future<AiRequestResult> _executeTranslationBatch(List<dynamic> ids, PipelineStepResult step, int jobId) async {
    final phraseService = ref.read(phraseServiceProvider);
    final List<Phrase> batch = [];
    for (var id in ids) {
      final p = await phraseService.getPhraseById(id);
      if (p != null) batch.add(p);
    }
    
    await _updateStageProgress(jobId, 'Translation', modelName: step.model.name);
    try {
      final url = await _buildUrl(step.model, forceStreaming: false);
      final prompt = _formTranslationBatchPrompt(step.prompt, batch);
      final response = await textAiService.sendRequest(url, prompt, model: step.model);
      
      dynamic decoded;
      try {
        decoded = jsonDecode(response);
      } catch (e) {
        logger.e('[AiService] Translation response is NOT valid JSON: $response');
        await ref.read(aiErrorHandlerProvider).recordResult(
          modelName: step.model.name,
          result: AiRequestPhase.error,
          message: 'Invalid JSON response',
          step: 'translation',
        );
        return AiRequestResult.failure(AiErrorType.parse, message: 'Invalid JSON response from AI', stepType: 'translation', model: step.model);
      }

      final result = await ref.read(geminiServiceProvider).phraseResponseHandler.saveTranslationsResponse(decoded, expectedIds: batch.map((e) => e.id).toList());
      
      await ref.read(aiErrorHandlerProvider).recordResult(
        modelName: step.model.name,
        result: result.phase,
        message: result.error?.message,
        step: 'translation',
      );

      if (result.phase == AiRequestPhase.success) {
        await _updateStageProgress(jobId, 'Translation', status: 'success');
      }
      return result;
    } catch (e) {
      await ref.read(aiErrorHandlerProvider).recordException(
        e, 
        modelName: step.model.name, 
        step: 'translation'
      );
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString(), stepType: 'translation', model: step.model);
    }
  }

  Future<AiRequestResult> _executeTokenizeBatch(List<dynamic> ids, PipelineStepResult step, int jobId, {required bool isOrig}) async {
    final phraseService = ref.read(phraseServiceProvider);
    final videoService = ref.read(videoServiceProvider);
    
    final List<Phrase> batch = [];
    for (var id in ids) {
      final p = await phraseService.getPhraseById(id);
      if (p != null) batch.add(p);
    }

    if (batch.isEmpty) return AiRequestResult.success();

    final video = await videoService.getVideoById(batch[0].videoId!);
    final langName = isOrig ? (video?.originalLanguage ?? 'Japanese') : (video?.translatedLanguage ?? 'English');
    
    final appConfig = ref.read(appConfigsServiceProvider);
    final method = appConfig.getTokenizationMethod(langName);
    
    final bool useAi = (method == TokenizationMethod.ai);
    final String stageName = isOrig ? 'Source Tokenization' : 'Translation Tokenization';

    await _updateStageProgress(jobId, stageName, modelName: useAi ? step.model.name : 'Local Engine');
    
    try {
      if (useAi) {
        final prompt = _formTokenizeBatchPrompt(step.prompt, batch, isOriginal: isOrig);
        final url = await _buildUrl(step.model, forceStreaming: false);
        final response = await textAiService.sendRequest(url, prompt, model: step.model);
        await ref.read(geminiServiceProvider).phraseResponseHandler.processTokenizationBatch(jsonDecode(response), batch, isOriginal: isOrig, languageName: langName);
        
        await ref.read(aiErrorHandlerProvider).recordResult(
          modelName: step.model.name,
          result: AiRequestPhase.success,
          step: stageName,
        );
      } else {
        final tokenizer = LanguageHub.getTokenizer(langName);
        for (var p in batch) {
          final text = isOrig ? (p.originalPhrase ?? '') : (p.translatedPhrase ?? '');
          if (text.isEmpty) continue;
          
          final localTokens = await tokenizer.tokenize(text);
          if (isOrig) {
            final tokens = localTokens.map((t) => TokenEntry(
              wordPosition: t.wordPosition, 
              pos: t.pos, 
              blockId: t.wordPosition,
              versions: List.from(t.versions),
            )).toList();
            await phraseService.updateTokens(p.id, original: tokens, translated: null);
          } else {
            final tokens = localTokens.map((t) => TranslationTokenEntry(
              translatedWordPosition: t.wordPosition,
              blockId: t.wordPosition,
              text: t.versions.isNotEmpty ? t.versions.first.text : '',
            )).toList();
            await phraseService.updateTokens(p.id, original: null, translated: tokens);
          }
        }
      }
      
      await _updateStageProgress(jobId, stageName, status: 'success');
      return AiRequestResult.success();
    } catch (e) {
      if (useAi) {
        await ref.read(aiErrorHandlerProvider).recordException(
          e, 
          modelName: step.model.name, 
          step: stageName
        );
      }
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString(), stepType: 'tokenization', model: step.model);
    }
  }

  Future<AiRequestResult> _executeMorphologyBatch(List<dynamic> ids, PipelineStepResult step, int jobId) async {
    final phraseService = ref.read(phraseServiceProvider);
    final List<Phrase> batch = [];
    for (var id in ids) {
      final p = await phraseService.getPhraseById(id);
      // Validate: Morphology MUST have translation and both token lists
      if (p != null && 
          p.translatedPhrase != null && p.translatedPhrase!.isNotEmpty &&
          p.originalTokens != null && p.originalTokens!.isNotEmpty &&
          p.translatedWords != null && p.translatedWords!.isNotEmpty) {
        batch.add(p);
      } else if (p != null) {
        logger.w('[AiService] Skipping phrase ${p.id} for Morphology: missing tokens or translation');
      }
    }

    if (batch.isEmpty) {
      await _updateStageProgress(jobId, 'Morphology', status: 'success', modelName: 'Skipped (No Data)');
      return AiRequestResult.success();
    }
    
    await _updateStageProgress(jobId, 'Morphology', modelName: step.model.name);

    try {
      final url = await _buildUrl(step.model, forceStreaming: false);
      final prompt = _formMorphologyBatchPrompt(step.prompt, batch);
      final response = await textAiService.sendRequest(url, prompt, model: step.model);
      await ref.read(geminiServiceProvider).phraseResponseHandler.processMorphologyBatch(jsonDecode(response), batch);
      
      await ref.read(aiErrorHandlerProvider).recordResult(
        modelName: step.model.name,
        result: AiRequestPhase.success,
        step: 'Morphology',
      );

      await _updateStageProgress(jobId, 'Morphology', status: 'success');
      return AiRequestResult.success();
    } catch (e) {
      await ref.read(aiErrorHandlerProvider).recordException(
        e, 
        modelName: step.model.name, 
        step: 'Morphology'
      );
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString(), stepType: 'morphology', model: step.model);
    }
  }

  String _formTranslationBatchPrompt(String basePrompt, List<Phrase> phrases) {
    final lines = phrases.map((p) => {'id': p.id, 'text': p.originalPhrase ?? ''}).toList();
    return '$basePrompt\n\nINPUT:\n${jsonEncode({'lines': lines})}';
  }

  String _formTokenizeBatchPrompt(String basePrompt, List<Phrase> phrases, {required bool isOriginal}) {
    final lines = phrases.map((p) => {'id': p.id, 'text': isOriginal ? (p.originalPhrase ?? '') : (p.translatedPhrase ?? '')}).toList();
    return '$basePrompt\n\nINPUT:\n${jsonEncode({'lines': lines})}';
  }

  String _formMorphologyBatchPrompt(String basePrompt, List<Phrase> phrases) {
    final lines = phrases.map((p) {
      final Map<int, List<int>> blockGroups = {};
      final tokens = p.originalTokens ?? [];
      for (var t in tokens) {
        final bId = t.blockId ?? (t.wordPosition ?? 0);
        blockGroups.putIfAbsent(bId, () => []).add(t.wordPosition!);
      }
      final jaTokens = (p.originalTokens ?? []).map((t) {
        final Map<String, dynamic> map = {
          "wordPosition": t.wordPosition,
          "partOfSpeech": t.pos.name,
          "lemma": t.lemma,
        };
        for (var v in t.versions) {
          map[v.key == 'original' ? 'text' : v.key!] = v.text;
        }
        return map;
      }).toList();

      final trTokens = (p.translatedWords ?? []).map((t) {
        return {
          "translationPosition": t.translatedWordPosition,
          "text": t.text ?? '',
        };
      }).toList();

      return {
        'id': p.id,
        'original': p.originalPhrase ?? '',
        'translation': p.translatedPhrase ?? '',
        'japanese_tokens': {
          "words": jaTokens,
          "blocks": blockGroups.entries.map((e) => {"blockId": e.key, "wordPositions": e.value}).toList(),
        },
        'translation_tokens': {
          "tokens": trTokens,
        }
      };
    }).toList();
    return '$basePrompt\n\nINPUT:\n${jsonEncode({'lines': lines})}';
  }

  Future<AiRequestResult> _executeGrammarRoleBatch(List<dynamic> ids, PipelineStepResult step, int jobId) async {
    final phraseService = ref.read(phraseServiceProvider);
    final List<Phrase> batch = [];
    for (var id in ids) {
      final p = await phraseService.getPhraseById(id);
      if (p != null && p.originalTokens != null && p.originalTokens!.isNotEmpty) {
        batch.add(p);
      } else if (p != null) {
        logger.w('[AiService] Skipping phrase ${p.id} for GrammarRole: missing original tokens');
      }
    }

    if (batch.isEmpty) {
      await _updateStageProgress(jobId, 'GrammarRole', status: 'success', modelName: 'Skipped (No Data)');
      return AiRequestResult.success();
    }
    
    await _updateStageProgress(jobId, 'GrammarRole', modelName: step.model.name);

    try {
      final url = await _buildUrl(step.model, forceStreaming: false);
      final prompt = _formGrammarRoleBatchPrompt(step.prompt, batch);
      final response = await textAiService.sendRequest(url, prompt, model: step.model);
      await ref.read(geminiServiceProvider).phraseResponseHandler.processGrammarRoleBatch(jsonDecode(response), batch);
      
      await ref.read(aiErrorHandlerProvider).recordResult(
        modelName: step.model.name,
        result: AiRequestPhase.success,
        step: 'GrammarRole',
      );

      await _updateStageProgress(jobId, 'GrammarRole', status: 'success');
      return AiRequestResult.success();
    } catch (e) {
      await ref.read(aiErrorHandlerProvider).recordException(
        e, 
        modelName: step.model.name, 
        step: 'GrammarRole'
      );
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString(), stepType: 'grammar_role', model: step.model);
    }
  }

  String _formGrammarRoleBatchPrompt(String basePrompt, List<Phrase> phrases) {
    final jaTokensLine = phrases.map((p) {
      return {
        'id': p.id,
        'tokens': (p.originalTokens ?? []).map((t) {
          final Map<String, dynamic> map = {
            "wordPosition": t.wordPosition,
            "partOfSpeech": t.pos.name,
            "lemma": t.lemma,
          };
          for (var v in t.versions) {
            if (v.key == 'original') {
              map['text'] = v.text;
            }
          }
          return map;
        }).toList(),
      };
    }).toList();

    final grammarCodesLine = phrases.map((p) {
      return {
        'id': p.id,
        'grammarCodes': (p.originalTokens ?? [])
            .where((t) => t.grammarCode != null && t.grammarCode!.isNotEmpty)
            .map((t) => {
                  "wordPosition": t.wordPosition,
                  "code": t.grammarCode,
                })
            .toList(),
      };
    }).toList();

    String prompt = basePrompt;
    prompt = prompt.replaceAll('{JAPANESE_TOKENS_JSON}', jsonEncode({'lines': jaTokensLine}));
    prompt = prompt.replaceAll('{GRAMMAR_CODES_JSON}', jsonEncode({'lines': grammarCodesLine}));
    return prompt;
  }
}
