import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/translation_pipeline_step.dart';
import 'package:eiga/providers/ui/ai_models_state_provider.dart';
import 'package:eiga/ui/styles/model_selection_theme.dart';
import 'package:eiga/ui/widgets/buttons/equal_toggle_buttons.dart';
import 'model_selection_card.dart';

class ModelSelectionSheet extends ConsumerStatefulWidget {
  final TranslationPipelineStep initialStep;

  const ModelSelectionSheet({
    super.key,
    this.initialStep = TranslationPipelineStep.research,
  });

  @override
  ConsumerState<ModelSelectionSheet> createState() => _ModelSelectionSheetState();
}

class _ModelSelectionSheetState extends ConsumerState<ModelSelectionSheet> {
  late TranslationPipelineStep _activeStep;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _activeStep = widget.initialStep;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectModel(String modelName, TranslationPipelineStep step) async {
    await ref.read(aiModelsProvider.notifier).updateActiveModel(step, modelName);
    if (!mounted) return;
    setState(() => _activeStep = step);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ModelSelectionTheme.of(context);
    final aiState = ref.watch(aiModelsProvider);
    final isThreeStep = ref.watch(aiModelsProvider.notifier).isThreeStepMethod;
    
    // Determine which steps to show based on method
    final visibleSteps = isThreeStep 
        ? [TranslationPipelineStep.research, TranslationPipelineStep.translate, TranslationPipelineStep.morphemes]
        : [TranslationPipelineStep.fullTranslate];

    // Adjust active step if it's not in visible list (e.g. switched from Advanced to Standard)
    // We use a post-frame callback or just handle it during build for immediate UI update, 
    // but ensure we don't trigger infinite rebuilds.
    final effectiveStep = visibleSteps.contains(_activeStep) ? _activeStep : visibleSteps.first;

    final models = ref.watch(modelsForStepProvider(effectiveStep));
    final activeName = aiState[effectiveStep];

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          const SizedBox(height: 8),
          
          // Method Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Translation Method', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 6),
                EqualToggleButtons<bool>(
                  items: const [true, false],
                  activeItem: isThreeStep,
                  onChanged: (val) => ref.read(aiModelsProvider.notifier).setThreeStepMethod(val),
                  labelBuilder: (val) => val ? 'Advanced' : 'Standard',
                  iconBuilder: (val) => val ? Icons.auto_awesome_rounded : Icons.bolt_rounded,
                ),
              ],
            ),
          ),
          
          if (isThreeStep) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: EqualToggleButtons<TranslationPipelineStep>(
                items: visibleSteps,
                activeItem: effectiveStep,
                onChanged: (step) => setState(() => _activeStep = step),
                labelBuilder: (step) => step.displayName,
                iconBuilder: (step) {
                  switch (step) {
                    case TranslationPipelineStep.research:
                      return Icons.search_rounded;
                    case TranslationPipelineStep.translate:
                      return Icons.translate_rounded;
                    case TranslationPipelineStep.morphemes:
                      return Icons.extension_rounded;
                    case TranslationPipelineStep.fullTranslate:
                      return Icons.auto_fix_high_rounded;
                  }
                },
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          Expanded(
            child: models.isEmpty
                ? Center(
                    child: ref.watch(allModelsProvider).isLoading 
                        ? CircularProgressIndicator(color: theme.primaryAccent)
                        : Text('No models available', style: TextStyle(color: theme.mutedText)),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                        step: effectiveStep,
                        isActive: isActive,
                        onSelect: () => _selectModel(model.name, effectiveStep),
                        onToggleStreaming: () => ref.read(aiModelsProvider.notifier).toggleStreaming(model),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ModelSelectionTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.auto_awesome_rounded, size: 24, color: theme.primaryAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Models', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                _buildCountdownTimer(theme),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(ModelSelectionTheme theme) {
    final countdownAsync = ref.watch(utcCountdownProvider);
    
    return countdownAsync.when(
      data: (duration) {
        final hours = duration.inHours.toString().padLeft(2, '0');
        final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
        return Text(
          'Resets in $hours:$minutes:$seconds (UTC)',
          style: TextStyle(fontSize: 11, color: theme.mutedText, fontWeight: FontWeight.w500),
        );
      },
      loading: () => Text('Calculating reset time...', style: TextStyle(fontSize: 11, color: theme.mutedText)),
      error: (_, __) => Text('Reset time error', style: TextStyle(fontSize: 11, color: theme.mutedText)),
    );
  }
}
