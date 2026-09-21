import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/database/schemas/ai_model_event.dart';
import 'package:eiga/config/pipelines/pipeline_steps.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';

import '../services/isar_services_providers.dart';

/// Notifier to manage active model selection per step.
class AiModelsNotifier extends Notifier<Map<TranslationPipelineStep, String>> {
  @override
  Map<TranslationPipelineStep, String> build() {
    final configs = ref.watch(appConfigsServiceProvider);
    
    final Map<TranslationPipelineStep, String> stateMap = {};

    for (final step in TranslationPipelineStep.values) {
      final String? activeModel = configs.getActiveModelForStepRaw(step);
      
      if (activeModel == null) {
        stateMap[step] = configs.getActiveModelForStep(step);
      } else {
        stateMap[step] = activeModel;
      }
    }
    
    // We verify model validity in a microtask since it requires async DB lookups
    Future.microtask(() => _verifyAndAutoSelectModels());
    
    // Initial reset check
    _checkAndResetDailyLimits();
    
    return stateMap;
  }

  Future<void> _verifyAndAutoSelectModels() async {
    final aiModelService = ref.read(aiModelServiceProvider);
    final configs = ref.read(appConfigsServiceProvider);
    
    final enabledProviders = {
      if (configs.getIsGeminiEnabled) AiProvider.google,
      if (configs.getIsGroqEnabled) AiProvider.groq,
    };

    final Map<TranslationPipelineStep, String> updates = {};
    
    for (final step in TranslationPipelineStep.values) {
      final currentModelName = state[step];
      bool needsSwitch = false;

      if (currentModelName == null) {
        needsSwitch = true;
      } else {
        final model = await aiModelService.getModelByName(currentModelName);
        if (model == null || !enabledProviders.contains(model.provider)) {
          needsSwitch = true;
        }
      }

      if (needsSwitch) {
        final best = await aiModelService.getBestFallbackModel(step, '', enabledProviders: enabledProviders);
        if (best != null) {
          updates[step] = best.name;
          await configs.setActiveModelForStep(step, best.name);
        }
      }
    }
    
    if (updates.isNotEmpty) {
      state = {...state, ...updates};
    }
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
}

final aiModelsProvider = NotifierProvider<AiModelsNotifier, Map<TranslationPipelineStep, String>>(AiModelsNotifier.new);

/// Watches all models live from Isar database to ensure reactive UI updates.
final allModelsProvider = StreamProvider<List<AiModel>>((ref) {
  final service = ref.watch(aiModelServiceProvider);
  // Isar v3 collections can watch general changes directly through the collection instance
  return service.isar.aiModels.watchLazy(fireImmediately: true).asyncMap((_) => service.getAllModels());
});

/// Synchronously filters models for a specific step.
final modelsForStepProvider = Provider.family<List<AiModel>, TranslationPipelineStep>((ref, step) {
  final allModelsAsync = ref.watch(allModelsProvider);
  final config = ref.watch(appConfigsServiceProvider);
  
  return allModelsAsync.maybeWhen(
    data: (models) {
      final enabledProviders = {
        if (config.getIsGeminiEnabled) AiProvider.google,
        if (config.getIsGroqEnabled) AiProvider.groq,
      };

      final filtered = models.where((m) {
        if (!enabledProviders.contains(m.provider)) return false;
        
        return m.supportedSteps.contains(step) || 
          m.supportedSteps.contains(TranslationPipelineStep.research) ||
          m.supportedSteps.contains(TranslationPipelineStep.translate) ||
          m.supportedSteps.contains(TranslationPipelineStep.tokenize) ||
          m.supportedSteps.contains(TranslationPipelineStep.morphemes);
      }).toList();
      
      // Fallback: if no models specifically support advanced steps, show all (respecting provider)
      if (filtered.isEmpty) {
        return models.where((m) => enabledProviders.contains(m.provider)).toList();
      }
      return filtered;
    },
    orElse: () => [],
  );
});

/// Watches events for a specific model.
final aiModelEventsProvider = StreamProvider.family<List<AiModelEvent>, String>((ref, modelName) {
  final service = ref.watch(aiModelServiceProvider);
  return service.watchEventsForModel(modelName);
});

/// Provider that emits the duration until the next UTC midnight.

final utcCountdownProvider = StreamProvider<Duration>((ref) async* {
  while (true) {
    final now = DateTime.now().toUtc();
    final tomorrow = DateTime.utc(now.year, now.month, now.day + 1);
    final remaining = tomorrow.difference(now);
    
    if (remaining.inSeconds <= 0) {
      ref.read(aiModelsProvider.notifier)._checkAndResetDailyLimits();
    }
    
    yield remaining;
    await Future.delayed(const Duration(seconds: 1));
  }
});
