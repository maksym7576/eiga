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
import 'pipelines/pipeline_abstract.dart';
import 'pipelines/pipeline_step_type.dart';
import '../database/schemas/language.dart';
import 'tokenization/tokenization_manager.dart';
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
    const String pipelineId = 'context_translation_v1';
    
    logger.d('[AiService] Running 4-stage translation for video ${video.id}');

    final jobId = await _startHistoryEntry(video.id, pipelineId, phrases.length);

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

  Future<int> _startHistoryEntry(int videoId, String pipelineId, int totalPhrases) async {
    final service = ref.read(translationJobServiceProvider);
    final config = ref.read(appConfigsServiceProvider);
    
    final job = TranslationJob(
      videoId: videoId,
      pipelineId: pipelineId,
      status: 'active',
      startTime: DateTime.now(),
      totalPhrases: totalPhrases,
      processedPhrases: 0,
      isAuto: config.getIsAutomaticModelSwitch,
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
    
    final jobService = ref.read(translationJobServiceProvider);
    final initialJob = await jobService.getJobById(jobId);
    if (initialJob != null) {
      if (plan.isNotEmpty) {
        final firstStepType = _mapTypeToStep(plan[0]['type']);
        if (firstStepType != null) {
           final stepResult = pipelineResult.steps.where((s) => s.type == firstStepType).firstOrNull;
           if (stepResult != null) {
             initialJob.modelName = stepResult.model.name;
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
        
        AiRequestResult result;
        switch (type) {
          case 'context':
            result = await _executeContextStep(video, pipelineResult.stepOf(PipelineStepType.contextResearch), jobId);
            break;
          case 'translation':
            result = await _executeTranslationBatch(step['ids'], pipelineResult.stepOf(PipelineStepType.translation), jobId);
            break;
          case 'tokenize_source':
            result = await _executeTokenizeBatch(step['ids'], pipelineResult.stepOf(PipelineStepType.tokenize), jobId, isOrig: true);
            break;
          case 'tokenize_translation':
            result = await _executeTokenizeBatch(step['ids'], pipelineResult.stepOf(PipelineStepType.tokenize), jobId, isOrig: false);
            break;
          case 'morphology':
            result = await _executeMorphologyBatch(step['ids'], pipelineResult.stepOf(PipelineStepType.morphemes), jobId);
            break;
          default:
            result = AiRequestResult.success();
        }

        if (result.phase != AiRequestPhase.success) {
          await _failHistoryEntry(jobId, result.error?.message ?? 'Step failed');
          return result;
        }

        final currentJob = await jobService.getJobById(jobId);
        if (currentJob != null) {
          currentJob.completedSteps = i + 1;
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

  Future<List<Map<String, dynamic>>> _buildExecutionPlan(Video video, List<Phrase> phrases) async {
    final config = ref.read(appConfigsServiceProvider);
    final List<Map<String, dynamic>> plan = [];
    final langService = ref.read(languageServiceProvider);
    final origLang = await langService.getLanguageByName(video.originalLanguage ?? '');
    final destLang = await langService.getLanguageByName(video.translatedLanguage ?? '');

    final toTranslateIds = phrases.where((p) => p.translatedPhrase == null || p.translatedPhrase!.isEmpty).map((e) => e.id).toList();
    final toTokenizeOrigIds = phrases.where((p) => p.originalTokens == null || p.originalTokens!.isEmpty).map((e) => e.id).toList();
    final toTokenizeDestIds = phrases.where((p) => p.translatedTokens == null || p.translatedTokens!.isEmpty).toList();
    final toMorphIds = phrases.where((p) => !p.isTranslated).map((e) => e.id).toList();

    if (video.isResearchDone != true) {
      plan.add({'type': 'context', 'method': 'ai'});
    }

    if (toTranslateIds.isNotEmpty) {
      _addBatchesToPlan(plan, 'translation', toTranslateIds, config.getBatchSizeTranslate, extra: {'method': 'ai'});
    }

    // 3. Tokenization (Predictive)
    // For original language
    if (toTokenizeOrigIds.isNotEmpty) {
      final method = (origLang?.tokenizationMethod == TokenizationMethod.ai) ? 'ai' : 'local';
      _addBatchesToPlan(plan, 'tokenize_source', toTokenizeOrigIds, config.getBatchSizeTokenize, extra: {'method': method});
    }

    // For translated language
    final List<int> destTokenizeIds = {
      ...toTranslateIds, 
      ...phrases.where((p) => p.translatedTokens == null || p.translatedTokens!.isEmpty).map((e) => e.id)
    }.toList();

    if (destTokenizeIds.isNotEmpty) {
      final method = (destLang?.tokenizationMethod == TokenizationMethod.ai) ? 'ai' : 'local';
      _addBatchesToPlan(plan, 'tokenize_translation', destTokenizeIds, config.getBatchSizeTokenize, extra: {'method': method});
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

    return plan;
  }

  PipelineStepType? _mapTypeToStep(String type) {
    switch (type) {
      case 'context': return PipelineStepType.contextResearch;
      case 'translation': return PipelineStepType.translation;
      case 'tokenize': return PipelineStepType.tokenize;
      case 'morphology': return PipelineStepType.morphemes;
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
      final result = await geminiService.fetchEpisodeContext(url, step.prompt, video.id, model: step.model);
      if (result.phase == AiRequestPhase.success) {
        await _updateStageProgress(jobId, 'Context', status: 'success');
      }
      return result;
    } catch (e) {
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
      final response = await geminiService.sendRequest(url, prompt, model: step.model);
      final result = await geminiService.phraseResponseHandler.saveTranslationsResponse(jsonDecode(response), expectedIds: batch.map((e) => e.id).toList());
      if (result.phase == AiRequestPhase.success) {
        await _updateStageProgress(jobId, 'Translation', status: 'success');
      }
      return result;
    } catch (e) {
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString(), stepType: 'translation', model: step.model);
    }
  }

  Future<AiRequestResult> _executeTokenizeBatch(List<dynamic> ids, PipelineStepResult step, int jobId, {required bool isOrig}) async {
    final phraseService = ref.read(phraseServiceProvider);
    final videoService = ref.read(videoServiceProvider);
    final tokManager = ref.read(tokenizationManagerProvider);
    
    final List<Phrase> batch = [];
    for (var id in ids) {
      final p = await phraseService.getPhraseById(id);
      if (p != null) batch.add(p);
    }

    if (batch.isEmpty) return AiRequestResult.success();

    final video = await videoService.getVideoById(batch[0].videoId!);
    final langName = isOrig ? (video?.originalLanguage ?? 'Japanese') : (video?.translatedLanguage ?? 'English');
    final langService = ref.read(languageServiceProvider);
    final lang = await langService.getLanguageByName(langName);
    
    final bool useAi = (lang?.tokenizationMethod == TokenizationMethod.ai);
    final String stageName = isOrig ? 'Source Tokenization' : 'Translation Tokenization';

    await _updateStageProgress(jobId, stageName, modelName: useAi ? step.model.name : 'Local Engine');
    
    try {
      if (useAi) {
        final prompt = _formTokenizeBatchPrompt(step.prompt, batch, isOriginal: isOrig);
        final url = await _buildUrl(step.model, forceStreaming: false);
        final response = await geminiService.sendRequest(url, prompt, model: step.model);
        await geminiService.phraseResponseHandler.processTokenizationBatch(jsonDecode(response), batch, isOriginal: isOrig, language: lang!);
      } else {
        final tokenizer = tokManager.getTokenizer(langName);
        for (var p in batch) {
          final text = isOrig ? (p.originalPhrase ?? '') : (p.translatedPhrase ?? '');
          if (text.isEmpty) continue;
          
          final localTokens = await tokenizer.tokenize(text);
          final tokens = localTokens.map((t) => TokenEntry(
            wordPosition: t.wordPosition, 
            pos: t.pos.name, 
            blockId: t.wordPosition,
            versions: List.from(t.versions),
          )).toList();
          
          await phraseService.updateTokens(p.id, original: isOrig ? tokens : null, translated: isOrig ? null : tokens);
        }
      }
      
      await _updateStageProgress(jobId, stageName, status: 'success');
      return AiRequestResult.success();
    } catch (e) {
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
          p.translatedTokens != null && p.translatedTokens!.isNotEmpty) {
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
      final response = await geminiService.sendRequest(url, prompt, model: step.model);
      await geminiService.phraseResponseHandler.processMorphologyBatch(jsonDecode(response), batch);
      await _updateStageProgress(jobId, 'Morphology', status: 'success');
      return AiRequestResult.success();
    } catch (e) {
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
          "partOfSpeech": t.pos,
          "lemma": t.lemma,
        };
        for (var v in t.versions) {
          map[v.key == 'original' ? 'text' : v.key!] = v.text;
        }
        return map;
      }).toList();

      final trTokens = (p.translatedTokens ?? []).map((t) {
        final Map<String, dynamic> map = {
          "translationPosition": t.wordPosition,
        };
        for (var v in t.versions) {
          map[v.key == 'original' ? 'text' : v.key!] = v.text;
        }
        return map;
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
}
