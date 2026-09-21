import 'package:isar_community/isar.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/database/schemas/ai_model_event.dart';
import 'package:eiga/config/pipelines/pipeline_steps.dart';
import 'package:eiga/providers/services/ai_request_state.dart';

class AiModelService {
  final Isar isar;

  AiModelService(this.isar);

  Future<List<AiModel>> getAllModels() async {
    return await isar.aiModels.where().findAll();
  }

  Future<List<AiModel>> getModelsForStep(TranslationPipelineStep step) async {
    final allModels = await getAllModels();
    return allModels.where((m) => m.supportedSteps.contains(step)).toList();
  }

  Future<void> updateModel(AiModel model) async {
    await isar.writeTxn(() async {
      await isar.aiModels.put(model);
    });
  }

  Future<AiModel?> getModelByName(String name) async {
    return await isar.aiModels.filter().nameEqualTo(name).findFirst();
  }

  Future<void> logEvent({
    required String modelName,
    required AiRequestPhase result,
    String? message,
    String? step,
  }) async {
    final event = AiModelEvent()
      ..modelName = modelName
      ..timestamp = DateTime.now()
      ..result = result
      ..message = message
      ..step = step;

    await isar.writeTxn(() async {
      await isar.aiModelEvents.put(event);
      
      final model = await isar.aiModels.filter().nameEqualTo(modelName).findFirst();
      if (model != null) {
        if (result == AiRequestPhase.success) {
          model.successCount++;
          model.used++;
          model.dailyUsed++;
        } else if (result == AiRequestPhase.partialSuccess) {
          model.partialSuccessCount++;
          model.used++;
          model.dailyUsed++;
        } else {
          model.errorCount++;
          model.lastErrorAt = DateTime.now();
          model.lastErrorMessage = message;
        }
        await isar.aiModels.put(model);
      }
    });
  }

  Stream<List<AiModelEvent>> watchEventsForModel(String modelName) {
    return isar.aiModelEvents
        .filter()
        .modelNameEqualTo(modelName)
        .sortByTimestampDesc()
        .watch(fireImmediately: true);
  }

  Future<void> incrementUsage(String name, int amount) async {
    // Deprecated: use logEvent for better tracking
    await logEvent(modelName: name, result: AiRequestPhase.success);
  }

  Future<void> incrementErrorCount(String name, {String? errorMessage}) async {
    // Deprecated: use logEvent for better tracking
    await logEvent(modelName: name, result: AiRequestPhase.error, message: errorMessage);
  }

  Future<void> markModelAsExhausted(String name) async {
    final model = await getModelByName(name);
    if (model != null) {
      // Set daily used to max to prevent further selection today
      model.dailyUsed = model.currentDailyMaxLimit;
      // Also penalize reliability score heavily
      model.reliabilityScore -= 100.0;
      await updateModel(model);
    }
  }

  Future<void> resetDailyUsage() async {
    final models = await getAllModels();
    await isar.writeTxn(() async {
      for (var model in models) {
        model.dailyUsed = 0;
        model.errorCount = 0;
        await isar.aiModels.put(model);
      }
    });
  }

  Future<void> resetToDefaults(String name) async {
    final model = await getModelByName(name);
    if (model != null) {
      model.currentMaxLimit = model.defaultLimit;
      model.isMaxLimitCustom = false;
      model.currentDailyMaxLimit = model.defaultDailyMaxLimit;
      model.isDailyMaxLimitCustom = false;
      model.currentPhrasesPerRequest = model.defaultPhrasesPerRequest;
      model.isPhrasesPerRequestCustom = false;
      model.currentStreamingEnabled = model.supportsStreaming;
      model.isStreamingCustom = false;
      model.errorCount = 0;
      await updateModel(model);
    }
  }

  Future<AiModel?> getBestFallbackModel(TranslationPipelineStep step, String excludeName, {Set<AiProvider>? enabledProviders}) async {
    final models = await getModelsForStep(step);
    if (models.isEmpty) return null;

    final candidates = models.where((m) {
      if (m.name == excludeName) return false;
      if (enabledProviders != null && !enabledProviders.contains(m.provider)) return false;
      return true;
    }).toList();
    
    if (candidates.isEmpty) return null;

    // Sort by: 
    // 1. Error count (lowest first) - reliability is priority
    // 2. Remaining daily limit (highest first) - capacity is priority
    // 3. Total daily max limit (highest first) - scale is priority
    // 4. Quality (highest first)
    candidates.sort((a, b) {
      // Priority 1: Reliability (Errors)
      if (a.errorCount != b.errorCount) return a.errorCount.compareTo(b.errorCount);
      
      // Priority 2: Remaining Capacity
      final remainingA = a.currentDailyMaxLimit - a.dailyUsed;
      final remainingB = b.currentDailyMaxLimit - b.dailyUsed;
      if (remainingA != remainingB) return remainingB.compareTo(remainingA);

      // Priority 3: Total Daily Max Limit
      if (a.currentDailyMaxLimit != b.currentDailyMaxLimit) {
        return b.currentDailyMaxLimit.compareTo(a.currentDailyMaxLimit);
      }
      
      // Priority 4: Quality
      return b.quality.index.compareTo(a.quality.index);
    });

    return candidates.first;
  }
}
