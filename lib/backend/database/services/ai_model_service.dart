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

  Future<void> resetDailyUsage() async {
    final models = await getAllModels();
    await isar.writeTxn(() async {
      for (var model in models) {
        model.dailyUsed = 0;
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
      await updateModel(model);
    }
  }
}
