import 'package:isar_community/isar.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/database/schemas/translation_pipeline_step.dart';

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

  Future<void> incrementUsage(String name, int amount) async {
    final model = await getModelByName(name);
    if (model != null) {
      model.used += amount;
      model.dailyUsed += amount;
      await updateModel(model);
    }
  }

  Future<void> incrementErrorCount(String name) async {
    final model = await getModelByName(name);
    if (model != null) {
      model.errorCount++;
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

  Future<AiModel?> getBestFallbackModel(TranslationPipelineStep step, String excludeName) async {
    final models = await getModelsForStep(step);
    if (models.isEmpty) return null;

    final candidates = models.where((m) => m.name != excludeName).toList();
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
