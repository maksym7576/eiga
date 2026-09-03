import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../backend/database/schemas/ai_model.dart';
import '../../../backend/database/schemas/translation_pipeline_step.dart';
import '../../../providers/database/database_providers.dart';
import '../../../providers/ui/ai_models_state_provider.dart';
import '../../styles/settings_theme.dart';

class AiModelsSettingsWidget extends ConsumerWidget {
  const AiModelsSettingsWidget({super.key});

  Future<void> _openEditDialog(BuildContext context, WidgetRef ref, AiModel model) async {
    final theme = SettingsTheme.of(context);
    final maxLimitController = TextEditingController(text: model.currentMaxLimit.toString());
    final phrasesController = TextEditingController(text: model.currentPhrasesPerRequest.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.dialogBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            model.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.normalText),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: maxLimitController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: theme.normalText),
                decoration: InputDecoration(
                  labelText: 'Daily request limit',
                  labelStyle: TextStyle(color: theme.mutedText),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phrasesController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: theme.normalText),
                decoration: InputDecoration(
                  labelText: 'Phrases per request',
                  labelStyle: TextStyle(color: theme.mutedText),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: theme.mutedText)),
            ),
            ElevatedButton(
              style: theme.primaryButtonStyle(),
              onPressed: () async {
                final newLimit = int.tryParse(maxLimitController.text.trim());
                final newPhrases = int.tryParse(phrasesController.text.trim());

                if (newLimit != null) {
                  model.currentMaxLimit = newLimit;
                  model.isMaxLimitCustom = true;
                }
                if (newPhrases != null) {
                  model.currentPhrasesPerRequest = newPhrases;
                  model.isPhrasesPerRequestCustom = true;
                }

                await ref.read(aiModelServiceProvider).updateModel(model);
                ref.invalidate(allModelsProvider);

                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _modelTile(BuildContext context, WidgetRef ref, AiModel model, SettingsTheme theme, Map<TranslationPipelineStep, String> activeModels) {
    final bool isUsedInAnyStep = activeModels.values.contains(model.name);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isUsedInAnyStep
            ? theme.primaryAccent.withValues(alpha: 0.08)
            : theme.backgroundColor,
        border: Border.all(
          color: isUsedInAnyStep ? theme.primaryAccent : theme.dialogBorder,
          width: isUsedInAnyStep ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isUsedInAnyStep ? theme.primaryAccent : theme.normalText,
                  ),
                ),
              ),
              if (isUsedInAnyStep)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.primaryAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'active',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              IconButton(
                onPressed: () => _openEditDialog(context, ref, model),
                icon: Icon(Icons.settings_outlined, size: 20, color: theme.primaryAccent),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Used: ${model.dailyUsed}/${model.currentMaxLimit}',
                style: TextStyle(fontSize: 12, color: theme.mutedText),
              ),
              const Spacer(),
              Text(
                '${model.currentPhrasesPerRequest} phr/req',
                style: TextStyle(fontSize: 12, color: theme.mutedText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = SettingsTheme.of(context);
    final modelsAsync = ref.watch(allModelsProvider);
    final activeModels = ref.watch(aiModelsProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'AI Models',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: theme.primaryAccent),
        ),
        const SizedBox(height: 16),
        modelsAsync.when(
          data: (models) => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: models.length,
            itemBuilder: (context, index) => _modelTile(context, ref, models[index], theme, activeModels),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e', style: TextStyle(color: theme.normalText)),
        ),
      ],
    );
  }
}
