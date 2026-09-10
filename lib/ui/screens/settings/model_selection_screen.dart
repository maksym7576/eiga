import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/ai_model.dart';
import '../../../backend/database/schemas/translation_pipeline_step.dart';
import '../../../providers/ui/ai_models_state_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../widgets/model_selection/model_selection_card.dart';

class ModelSelectionScreen extends ConsumerStatefulWidget {
  final TranslationPipelineStep step;

  const ModelSelectionScreen({
    super.key,
    required this.step,
  });

  @override
  ConsumerState<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends ConsumerState<ModelSelectionScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectModel(String modelName) async {
    await ref.read(aiModelsProvider.notifier).updateActiveModel(widget.step, modelName);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdditionalWindowTheme.of(context);
    final aiState = ref.watch(aiModelsProvider);
    final models = ref.watch(modelsForStepProvider(widget.step));
    final activeName = aiState[widget.step];

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text('${widget.step.displayName} Model', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: models.isEmpty
          ? Center(
              child: ref.watch(allModelsProvider).isLoading 
                  ? const CircularProgressIndicator()
                  : Text('No models available for this step', style: TextStyle(color: theme.mutedText)),
            )
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: models.length,
              itemBuilder: (context, index) {
                // Sort: Active model first
                final sortedModels = [
                  ...models.where((m) => m.name == activeName),
                  ...models.where((m) => m.name != activeName),
                ];
                
                final model = sortedModels[index];
                final isActive = model.name == activeName;
                
                return ModelSelectionCard(
                  model: model,
                  step: widget.step,
                  isActive: isActive,
                  onSelect: () => _selectModel(model.name),
                  onToggleStreaming: () => ref.read(aiModelsProvider.notifier).toggleStreaming(model),
                );
              },
            ),
    );
  }
}
