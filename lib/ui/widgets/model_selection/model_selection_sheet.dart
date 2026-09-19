import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/config/pipelines/pipeline_steps.dart';
import 'package:eiga/providers/ui/ai_models_state_provider.dart';
import 'package:eiga/ui/styles/model_selection_theme.dart';
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
    
    final visibleSteps = TranslationPipelineStep.values;
    final effectiveStep = _activeStep;

    final models = ref.watch(modelsForStepProvider(effectiveStep));
    final activeName = aiState[effectiveStep];

    return Column(
      children: [
        _buildHeader(theme),
        const SizedBox(height: 8),
        
        // Scrollable step buttons (chips) - no text cramming
        SizedBox(
          height: 38,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: visibleSteps.map((step) {
                final isActive = step == effectiveStep;
                IconData stepIcon;
                switch (step) {
                  case TranslationPipelineStep.research:
                    stepIcon = Icons.search_rounded;
                  case TranslationPipelineStep.transcribe:
                    stepIcon = Icons.hearing_rounded;
                  case TranslationPipelineStep.translate:
                    stepIcon = Icons.translate_rounded;
                  case TranslationPipelineStep.tokenize:
                    stepIcon = Icons.extension_rounded;
                  case TranslationPipelineStep.morphemes:
                    stepIcon = Icons.auto_awesome_rounded;
                  case TranslationPipelineStep.grammarRole:
                    stepIcon = Icons.schema_rounded;
                }
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    showCheckmark: false,
                    avatar: Icon(
                      stepIcon, 
                      size: 14, 
                      color: isActive ? Colors.white : theme.mutedText,
                    ),
                    label: Text(
                      step.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                        color: isActive ? Colors.white : theme.normalText,
                      ),
                    ),
                    selected: isActive,
                    onSelected: (_) => setState(() => _activeStep = step),
                    selectedColor: theme.primaryAccent,
                    backgroundColor: theme.segmentOffColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Live data with reactive stream states
        Expanded(
          child: ref.watch(allModelsProvider).when(
            data: (_) {
              if (models.isEmpty) {
                return Center(
                  child: Text(
                    'No models available for this step', 
                    style: TextStyle(color: theme.mutedText),
                  ),
                );
              }
              return ListView.builder(
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
              );
            },
            loading: () => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: theme.primaryAccent),
                  const SizedBox(height: 12),
                  Text(
                    'Loading AI models...', 
                    style: TextStyle(color: theme.mutedText, fontSize: 13),
                  ),
                ],
              ),
            ),
            error: (err, _) => Center(
              child: Text(
                'Error loading models: $err', 
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ),
        ),
      ],
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
