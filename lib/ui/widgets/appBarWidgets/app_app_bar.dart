import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:eiga/ui/widgets/animations/eiga_logo_animation.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/ui/widgets/appBarWidgets/modelsPreviewWidget.dart';
import 'package:eiga/backend/database/schemas/translation_pipeline_step.dart';
import 'package:eiga/providers/ui/ai_models_state_provider.dart';
import 'package:eiga/ui/styles/AppAppBarTheme.dart';
import 'package:eiga/ui/widgets/dialogs/app_bottom_sheet.dart';
import 'package:eiga/ui/widgets/appBarWidgets/TranslationGlobalBanner.dart';

import 'package:eiga/providers/services/translation_queue_provider.dart';

class AppAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final TranslationPipelineStep step;

  const AppAppBar({
    super.key,
    this.step = TranslationPipelineStep.translate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(translationQueueProvider);
    final isTranslating = queueState.currentlyProcessingVideoId != null && 
                          queueState.status == TranslationQueueStatus.running;
    
    return _AppAppBarInternal(
      step: step, 
      isTranslating: isTranslating,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);
}

class _AppAppBarInternal extends ConsumerStatefulWidget {
  final TranslationPipelineStep step;
  final bool isTranslating;
  
  const _AppAppBarInternal({required this.step, required this.isTranslating});
  
  @override
  ConsumerState<_AppAppBarInternal> createState() => _AppAppBarInternalState();
}

class _AppAppBarInternalState extends ConsumerState<_AppAppBarInternal> {
  bool _isModelDialogOpen = false;

  late int _currentStepIndex;
  Timer? _cycleTimer;

  static const Duration _holdDuration = Duration(seconds: 3);
  static const Duration _slideDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _currentStepIndex = widget.step.index;
    _startCycle();
  }

  void _startCycle() {
    _cycleTimer?.cancel();
    _cycleTimer = Timer.periodic(_holdDuration, (_) {
      if (!mounted || _isModelDialogOpen) return;
      
      final isThreeStep = ref.read(aiModelsProvider.notifier).isThreeStepMethod;
      final visibleSteps = isThreeStep 
          ? [TranslationPipelineStep.research, TranslationPipelineStep.translate, TranslationPipelineStep.morphemes]
          : [TranslationPipelineStep.fullTranslate];

      setState(() {
        // Find next step within visible steps
        final currentStep = TranslationPipelineStep.values[_currentStepIndex];
        int nextVisibleIdx = visibleSteps.indexOf(currentStep);
        
        if (nextVisibleIdx == -1) {
          // If current step is not visible, start from the first visible one
          _currentStepIndex = visibleSteps.first.index;
        } else {
          // Move to next visible step
          nextVisibleIdx = (nextVisibleIdx + 1) % visibleSteps.length;
          _currentStepIndex = visibleSteps[nextVisibleIdx].index;
        }
      });
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    super.dispose();
  }

  TranslationPipelineStep get _currentStep =>
      TranslationPipelineStep.values[_currentStepIndex];

  void _showAllModelsDialog(TranslationPipelineStep step) async {
    _cycleTimer?.cancel();
    setState(() => _isModelDialogOpen = true);
    try {
      await AppBottomSheet.show(
        context: context,
        barrierLabel: "ModelsLabel",
        child: ModelPreviewWidget(initialStep: step),
      );
    } finally {
      if (mounted) setState(() => _isModelDialogOpen = false);
    }
    _startCycle();
  }

  @override
  Widget build(BuildContext context) {
    final step = _currentStep;
    final isThreeStep = ref.watch(aiModelsProvider.notifier).isThreeStepMethod;
    
    // Ensure the step is valid for the current method
    final visibleSteps = isThreeStep 
        ? [TranslationPipelineStep.research, TranslationPipelineStep.translate, TranslationPipelineStep.morphemes]
        : [TranslationPipelineStep.fullTranslate];
    
    final effectiveStep = visibleSteps.contains(step) ? step : visibleSteps.first;

    final aiState = ref.watch(aiModelsProvider);
    final stepModels = ref.watch(modelsForStepProvider(effectiveStep));

    final theme = AppAppBarTheme.of(context);
    
    final isTranslating = widget.isTranslating;

    Widget centerWidget;
    
    final activeName = aiState[effectiveStep];
    final matches = stepModels.where((m) => m.name == activeName);

    final AiModel selectedItem = matches.isNotEmpty
        ? matches.first
        : (AiModel()
      ..name = 'No model'
      ..url = 'No'
      ..currentMaxLimit = 0
      ..defaultLimit = 0
      ..used = 0
      ..currentDailyMaxLimit = 0
      ..defaultDailyMaxLimit = 0
      ..dailyUsed = 0
      ..currentPhrasesPerRequest = 0
      ..defaultPhrasesPerRequest = 0
      ..currentStreamingEnabled = false
      ..supportsStreaming = false);

    centerWidget = GestureDetector(
      onTap: () => _showAllModelsDialog(effectiveStep),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCirc,
        decoration: BoxDecoration(
          color: _isModelDialogOpen
              ? theme.selectorActiveBackground
              : theme.selectorBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isModelDialogOpen
                ? theme.selectorActiveBorder
                : theme.selectorBorder,
            width: _isModelDialogOpen ? 2.0 : 1.5,
          ),
          boxShadow: _isModelDialogOpen
              ? theme.selectorActiveShadow
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AnimatedSwitcher(
            duration: _slideDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              final isIncoming =
                  child.key == ValueKey(effectiveStep.index);

              final offsetTween = isIncoming
                  ? Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              )
                  : Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              );

              return SlideTransition(
                position: offsetTween.animate(animation),
                child: child,
              );
            },
            child: Padding(
              key: ValueKey(effectiveStep.index),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MethodBadge(
                    isThreeStep: isThreeStep,
                    color: isThreeStep ? theme.advancedModeColor : theme.standardModeColor,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          effectiveStep.displayName.toUpperCase(),
                          style: theme.stepLabelStyle,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 1),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            selectedItem.name,
                            style: theme.modelNameStyle,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.badgeBackground,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${selectedItem.used}/${selectedItem.currentDailyMaxLimit}',
                      style: theme.badgeTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return AppBar(
      backgroundColor: theme.backgroundColor,
      elevation: 0,
      title: Row(
        children: [
          const SizedBox(width: 10),
          EigaLogoAnimation(
            style: theme.logoStyle,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: centerWidget,
          ),
          const SizedBox(width: 4),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.iconColor),
          onPressed: () {
            context.push('/settings');
          },
        ),
        const SizedBox(width: 4),
      ],
      bottom: isTranslating ? const TranslationGlobalBanner() : null,
    );
  }
}

class _MethodBadge extends StatelessWidget {
  final bool isThreeStep;
  final Color color;

  const _MethodBadge({
    required this.isThreeStep,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isThreeStep ? Icons.auto_awesome_rounded : Icons.bolt_rounded,
        size: 14,
        color: color,
      ),
    );
  }
}
