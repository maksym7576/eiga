import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../database/schemas/video.dart';
import '../database/schemas/phrase.dart';
import '../database/schemas/ai_model.dart';
import '../database/schemas/translation_job.dart';
import '../../providers/services/app_configs_provider.dart';
import '../../providers/services/ai_request_state.dart';
import '../../providers/services/database_services_providers.dart';
import '../../config/secure_storage.dart';
import 'petition_ai/gemini/gemini_service.dart';
import 'petition_ai/gemini/gemini_streaming_service.dart';
import 'pipelines/pipeline_manager.dart';
import 'pipelines/pipeline_step_type.dart';
import 'utils/ai_exceptions.dart';
import '../../utils/logger.dart';

class AiService {
  final Ref ref;
  final GeminiService geminiService;
  final GeminiStreamingService geminiStreamingService;

  AiService({
    required this.ref,
    required this.geminiService,
    required this.geminiStreamingService,
  });

  Future<AiRequestResult> runTranslationForVideo({
    required Video video,
    required List<Phrase> phrases,
  }) async {
    final config = ref.read(appConfigsServiceProvider);
    final String defaultPipeline = config.getIsThreeStepMethod 
        ? 'context_translation_v1' 
        : 'total_v1';
        
    final String pipelineId = video.pipelineIndetificator ?? defaultPipeline;
    
    logger.d('Running translation for video ${video.id} using pipeline $pipelineId (Global 3-step: ${config.getIsThreeStepMethod})');

    // Start history entry
    final jobId = await _startHistoryEntry(video.id, pipelineId, phrases.length);

    try {
      final AiRequestResult result;
      switch (pipelineId) {
        case 'context_translation_v1':
          result = await processContextTranslationPipeline(
            video: video,
            phrases: phrases,
            jobId: jobId,
          );
          break;
        case 'total_v1':
          result = await processTotalTranslationPipeline(
            video: video,
            phrases: phrases,
            jobId: jobId,
          );
          break;
        default:
          throw Exception('Unknown pipelineId: "$pipelineId"');
      }

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

  Future<int> _startHistoryEntry(int videoId, String pipelineId, int totalPhrases) async {
    final service = ref.read(translationJobServiceProvider);
    
    final job = TranslationJob(
      videoId: videoId,
      pipelineId: pipelineId,
      status: 'active',
      startTime: DateTime.now(),
      totalPhrases: totalPhrases,
      processedPhrases: 0,
      stageHistory: [],
    );

    return await service.saveJob(job);
  }

  Future<void> _updateStageProgress(int jobId, String stageName, {int? processed, String? status, String? modelName}) async {
    final service = ref.read(translationJobServiceProvider);
    final job = await service.getJobById(jobId);
    if (job == null) return;

    job.phase = stageName;
    if (processed != null) job.processedPhrases = processed;
    if (modelName != null) job.modelName = modelName;
    
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
    final service = ref.read(translationJobServiceProvider);
    final job = await service.getJobById(jobId);
    if (job == null) return;

    job.status = 'success';
    job.endTime = DateTime.now();
    job.translatedAt = DateTime.now();
    job.processedPhrases = job.totalPhrases;

    await service.updateJob(job);
  }

  Future<void> _failHistoryEntry(int jobId, String error) async {
    final service = ref.read(translationJobServiceProvider);
    final job = await service.getJobById(jobId);
    if (job == null) return;

    job.status = 'error';
    job.endTime = DateTime.now();
    job.errorMessage = error;
    job.errorStage = job.phase;

    await service.updateJob(job);
  }

  String _formPrompt(String basePrompt, List<Phrase> phrases) {
    final sortPhraseList = List<Phrase>.from(phrases)
      ..sort((a, b) => (a.phraseOrder ?? 0).compareTo(b.phraseOrder ?? 0));

    final simplifiedPhrasesList = sortPhraseList.map((phrase) {
      return {
        'id': phrase.id,
        'videoId': phrase.videoId,
        'phraseOrder': phrase.phraseOrder,
        'originalText': phrase.originalPhrase ?? '',
        'startTime': phrase.startTime?.toIso8601String(),
        'endTime': phrase.endTime?.toIso8601String(),
      };
    }).toList();

    final payload = {'phrases': simplifiedPhrasesList};
    final String jsonData = jsonEncode(payload);

    return '$basePrompt\n\nINPUT_DATA (JSON):\n$jsonData';
  }

  Future<String> _buildUrl(AiModel model, {bool? forceStreaming}) async {
    final bool isStreaming = forceStreaming ?? 
        (model.supportsStreaming && model.currentStreamingEnabled);

    switch (model.provider) {
      case AiProvider.google:
        final token = await SecureTokenStorage.getToken(ApiTokenType.gemini);
        final endpoint = isStreaming ? ':streamGenerateContent' : ':generateContent';
        final sse = isStreaming ? '&alt=sse' : '';
        return '${model.url}$endpoint?key=$token$sse';
      
      case AiProvider.openai:
        // OpenAI usually has a fixed endpoint, but we use the one from the model
        return model.url;
        
      case AiProvider.anthropic:
        return model.url;
        
      case AiProvider.custom:
        return model.url;
    }
  }

  Future<AiRequestResult> processTotalTranslationPipeline({
    required Video video,
    required List<Phrase> phrases,
    required int jobId,
  }) async {
    final expectedIds = phrases.map((e) => e.id).toList();

    final pipelineResult = await PipelineManager.build(
      ref,
      videoId: video.id,
      pipelineId: 'total_v1',
    );

    if (pipelineResult == null) throw Exception('Pipeline build failed');

    final translationStep = pipelineResult.stepOf(PipelineStepType.translation);
    await _updateStageProgress(jobId, 'Translation', modelName: translationStep.model.name);
    
    final isStreaming = translationStep.model.supportsStreaming && translationStep.model.currentStreamingEnabled;
    final url = await _buildUrl(translationStep.model, forceStreaming: isStreaming);
    final fullPrompt = _formPrompt(translationStep.prompt, phrases);

    try {
      final AiRequestResult result;
      if (isStreaming) {
        logger.d('Total pipeline: using streaming mode for ${phrases.length} phrases');
        result = await geminiStreamingService.fetchParseAndSaveData(
          url,
          fullPrompt,
          model: translationStep.model,
          expectedIds: expectedIds,
          onProgress: (processed) => _updateStageProgress(jobId, 'Translation', processed: processed),
        );
      } else {
        logger.d('Total pipeline: using HTTP mode for ${phrases.length} phrases');
        result = await geminiService.fetchParseAndSaveData(
          url,
          fullPrompt,
          model: translationStep.model,
          expectedIds: expectedIds,
          onProgress: (processed) => _updateStageProgress(jobId, 'Translation', processed: processed),
        );
      }
      
      await _updateStageProgress(jobId, 'Translation', status: result.phase == AiRequestPhase.success ? 'success' : 'error');
      
      logger.i('Total pipeline result: ${result.phase.name}. Failed IDs: ${result.failedPhraseIds.length}');
      ref.read(aiRequestResultProvider.notifier).state = result;
      return result;
    } catch (e, st) {
      logger.e('Total pipeline failed', error: e, stackTrace: st);
      if (e is GeminiException) {
        final res = AiRequestResult.failure(e.type);
        ref.read(aiRequestResultProvider.notifier).state = res;
        return res;
      }
      rethrow;
    }
  }

  Future<AiRequestResult> processContextTranslationPipeline({
    required Video video,
    required List<Phrase> phrases,
    required int jobId,
  }) async {
    final expectedIds = phrases.map((e) => e.id).toList();

    final pipelineResult = await PipelineManager.build(
      ref,
      videoId: video.id,
      pipelineId: 'context_translation_v1',
    );

    if (pipelineResult == null) throw Exception('Pipeline build failed');
    final pipeline = PipelineManager.byId('context_translation_v1');
    if (pipeline == null) throw Exception('Pipeline implementation missing');

    try {
      // 1. Research phase
      if (video.isResearchDone != true || video.researchInformation == null || video.researchInformation!.isEmpty) {
        final researchStep = pipelineResult.stepOf(PipelineStepType.contextResearch);
        await _updateStageProgress(jobId, 'Context', modelName: researchStep.model.name);
        
        logger.d('Context pipeline: starting research phase');
        final researchUrl = await _buildUrl(researchStep.model, forceStreaming: false);
        final researchResult = await geminiService.fetchEpisodeContext(researchUrl, researchStep.prompt, video.id, model: researchStep.model);
        
        if (researchResult.phase != AiRequestPhase.success) {
          await _updateStageProgress(jobId, 'Context', status: 'error');
          logger.w('Context pipeline: research phase failed with ${researchResult.phase.name}');
          return researchResult;
        }
        
        await _updateStageProgress(jobId, 'Context', status: 'success');
        
        // Reload video after update
        final updatedVideo = await ref.read(videoServiceProvider).getVideoById(video.id);
        if (updatedVideo != null) video = updatedVideo;
        logger.d('Context pipeline: research phase completed');
      }

      // 2. Translation phase
      final translationStep = pipelineResult.stepOf(PipelineStepType.translation);
      await _updateStageProgress(jobId, 'Translation', modelName: translationStep.model.name);
      
      String rawTranslationJson;
      final bool allTranslated = phrases.every((p) => p.translatedPhrase != null && p.translatedPhrase!.isNotEmpty);

      if (allTranslated) {
        logger.d('Context pipeline: all phrases already translated in DB, skipping AI request for Stage 2');
        final Map<String, dynamic> resumeData = {
          'lineCount': phrases.length,
          'lines': phrases.map((p) => {
            'id': p.id,
            'translation': p.translatedPhrase,
          }).toList(),
        };
        rawTranslationJson = jsonEncode(resumeData);
      } else {
        logger.d('Context pipeline: starting translation phase');
        final translationStep = pipelineResult.stepOf(PipelineStepType.translation);
        final translationUrl = await _buildUrl(translationStep.model, forceStreaming: false);
        final translationPrompt = _formPrompt(translationStep.prompt, phrases);
        
        rawTranslationJson = await geminiService.sendRequest(translationUrl, translationPrompt, model: translationStep.model);
        
        // Save translations first
        final Map<String, dynamic> parsedTranslation = jsonDecode(rawTranslationJson);
        final saveResult = await geminiService.phraseResponseHandler.saveTranslationsResponse(
          parsedTranslation,
          expectedIds: expectedIds,
        );

        if (saveResult.phase != AiRequestPhase.success) {
          await _updateStageProgress(jobId, 'Translation', status: 'error');
          logger.w('Context pipeline: translation saving failed with ${saveResult.phase.name}');
          return saveResult;
        }
      }
      
      await _updateStageProgress(jobId, 'Translation', status: 'success');
      logger.d('Context pipeline: translation phase completed');

      // 3. Morphemes/Parser phase
      final morphemesStep = pipelineResult.stepOf(PipelineStepType.morphemes);
      await _updateStageProgress(jobId, 'Morphology', modelName: morphemesStep.model.name);
      
      logger.d('Context pipeline: starting morphemes phase');
      final isStreaming = morphemesStep.model.supportsStreaming && morphemesStep.model.currentStreamingEnabled;
      final morphemesUrl = await _buildUrl(morphemesStep.model, forceStreaming: isStreaming);
      final morphemesPrompt = '${morphemesStep.prompt}\n\nTRANSLATION_DATA:\n$rawTranslationJson';

      final AiRequestResult result;

      if (isStreaming) {
        logger.d('Context pipeline: using streaming mode for morphemes');
        result = await geminiStreamingService.fetchParseAndSaveData(
          morphemesUrl,
          morphemesPrompt,
          model: morphemesStep.model,
          expectedIds: expectedIds,
          onProgress: (processed) => _updateStageProgress(jobId, 'Morphology', processed: processed),
        );
      } else {
        logger.d('Context pipeline: using HTTP mode for morphemes');
        result = await geminiService.fetchParseAndSaveData(
          morphemesUrl,
          morphemesPrompt,
          model: morphemesStep.model,
          expectedIds: expectedIds,
          onProgress: (processed) => _updateStageProgress(jobId, 'Morphology', processed: processed),
        );
      }

      await _updateStageProgress(jobId, 'Morphology', status: result.phase == AiRequestPhase.success ? 'success' : 'error');

      logger.i('Context pipeline completed with result: ${result.phase.name}');
      ref.read(aiRequestResultProvider.notifier).state = result;
      return result;
    } catch (e, st) {
      logger.e('Context pipeline failed', error: e, stackTrace: st);
      if (e is GeminiException) {
        final res = AiRequestResult.failure(e.type);
        ref.read(aiRequestResultProvider.notifier).state = res;
        return res;
      }
      rethrow;
    }
  }
}
