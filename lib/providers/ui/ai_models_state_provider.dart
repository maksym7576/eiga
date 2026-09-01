import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/database/schemas/translation_pipeline_step.dart';
import 'package:eiga/providers/database/database_providers.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';

/// Notifier to manage active model selection per step.
class AiModelsNotifier extends Notifier<Map<TranslationPipelineStep, String>> {
  @override
  Map<TranslationPipelineStep, String> build() {
    final configs = ref.watch(appConfigsServiceProvider);
    
    final Map<TranslationPipelineStep, String> stateMap = {};
    for (final step in TranslationPipelineStep.values) {
      stateMap[step] = configs.getActiveModelForStep(step);
    }
    
    // Initial reset check
    _checkAndResetDailyLimits();
    
    return stateMap;
  }

  Future<void> _checkAndResetDailyLimits() async {
    final configs = ref.read(appConfigsServiceProvider);
    final now = DateTime.now().toUtc();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final lastReset = configs.getLastResetDate;

    if (lastReset != todayStr) {
      await ref.read(aiModelServiceProvider).resetDailyUsage();
      await configs.setLastResetDate(todayStr);
      ref.invalidate(allModelsProvider);
    }
  }

  Future<void> updateActiveModel(TranslationPipelineStep step, String modelName) async {
    await ref.read(appConfigsServiceProvider).setActiveModelForStep(step, modelName);
    state = {...state, step: modelName};
  }

  Future<void> toggleStreaming(AiModel model) async {
    final service = ref.read(aiModelServiceProvider);
    model.currentStreamingEnabled = !model.currentStreamingEnabled;
    model.isStreamingCustom = true;
    await service.updateModel(model);
    ref.invalidate(allModelsProvider);
  }

  bool get isThreeStepMethod => ref.read(appConfigsServiceProvider).getIsThreeStepMethod;

  Future<void> setThreeStepMethod(bool value) async {
    await ref.read(appConfigsServiceProvider).setIsThreeStepMethod(value);
    ref.invalidateSelf(); 
  }
}

final aiModelsProvider = NotifierProvider<AiModelsNotifier, Map<TranslationPipelineStep, String>>(AiModelsNotifier.new);

/// Pre-fetches all models once to ensure instant switching in the UI.
final allModelsProvider = FutureProvider<List<AiModel>>((ref) async {
  final service = ref.watch(aiModelServiceProvider);
  return await service.getAllModels();
});

/// Synchronously filters models for a specific step.
/// Research, Translation, and Morphemes share the same pool of models.
final modelsForStepProvider = Provider.family<List<AiModel>, TranslationPipelineStep>((ref, step) {
  final allModelsAsync = ref.watch(allModelsProvider);
  
  return allModelsAsync.maybeWhen(
    data: (models) {
      // If we are looking for Advanced steps (research, translate, morphemes)
      if (step != TranslationPipelineStep.fullTranslate) {
        final filtered = models.where((m) => 
          m.supportedSteps.contains(step) || 
          m.supportedSteps.contains(TranslationPipelineStep.research) ||
          m.supportedSteps.contains(TranslationPipelineStep.translate) ||
          m.supportedSteps.contains(TranslationPipelineStep.morphemes)
        ).toList();
        
        // Fallback: if no models specifically support advanced steps, show all that support fullTranslate
        if (filtered.isEmpty) {
          return models.where((m) => m.supportedSteps.contains(TranslationPipelineStep.fullTranslate)).toList();
        }
        return filtered;
      }
      
      // For Standard method, show models that support fullTranslate
      return models.where((m) => m.supportedSteps.contains(TranslationPipelineStep.fullTranslate)).toList();
    },
    orElse: () => [],
  );
});

/// Provider that emits the duration until the next UTC midnight.
final utcCountdownProvider = StreamProvider<Duration>((ref) async* {
  while (true) {
    final now = DateTime.now().toUtc();
    final tomorrow = DateTime.utc(now.year, now.month, now.day + 1);
    final remaining = tomorrow.difference(now);
    
    // If remaining is exactly 0 (or slightly negative due to timing), trigger a reset check
    if (remaining.inSeconds <= 0) {
      ref.read(aiModelsProvider.notifier)._checkAndResetDailyLimits();
    }
    
    yield remaining;
    await Future.delayed(const Duration(seconds: 1));
  }
});
