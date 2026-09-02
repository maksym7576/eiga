import 'package:flutter/material.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/database/schemas/translation_pipeline_step.dart';
import 'package:eiga/ui/styles/model_selection_theme.dart';

class ModelSelectionCard extends StatelessWidget {
  final AiModel model;
  final TranslationPipelineStep step;
  final bool isActive;
  final VoidCallback onSelect;
  final VoidCallback onToggleStreaming;

  const ModelSelectionCard({
    super.key,
    required this.model,
    required this.step,
    required this.isActive,
    required this.onSelect,
    required this.onToggleStreaming,
  });

  Color _usageColor(ModelSelectionTheme theme) {
    if (model.currentDailyMaxLimit <= 0) return theme.mutedText;
    final ratio = model.dailyUsed / model.currentDailyMaxLimit;
    if (ratio >= 1.0) return Colors.redAccent;
    if (ratio >= 0.75) return Colors.orangeAccent;
    return theme.primaryAccent;
  }

  int get _limitSegmentsTotal => 10;
  int get _limitSegmentsActive {
    if (model.currentDailyMaxLimit <= 0) return 0;
    final ratio = (model.dailyUsed / model.currentDailyMaxLimit).clamp(0.0, 1.0);
    return (ratio * _limitSegmentsTotal).ceil();
  }

  int get _speedSegmentsActive {
    switch (model.speed) {
      case ModelSpeed.ultraFast: return 4;
      case ModelSpeed.fast: return 3;
      case ModelSpeed.medium: return 2;
      case ModelSpeed.slow: return 1;
    }
  }

  int get _qualitySegmentsActive {
    switch (model.quality) {
      case ModelQuality.frontier: return 4;
      case ModelQuality.high: return 3;
      case ModelQuality.standard: return 2;
      case ModelQuality.basic: return 1;
    }
  }

  Widget _segmentBar({
    required int active,
    required int total,
    required Color activeColor,
    required Color offColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isOn = i < active;
        return Container(
          margin: const EdgeInsets.only(right: 4),
          width: 16,
          height: 9,
          decoration: BoxDecoration(
            color: isOn ? activeColor : offColor,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _labeledBar(String label, Widget bar, ModelSelectionTheme theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 42,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: theme.mutedText, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 6),
        bar,
      ],
    );
  }

  Widget _streamingToggle(ModelSelectionTheme theme) {
    final supportsStreaming = model.supportsStreaming;
    final isOn = supportsStreaming && model.currentStreamingEnabled;

    return GestureDetector(
      onTap: supportsStreaming ? onToggleStreaming : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            !supportsStreaming ? 'No streaming' : (isOn ? 'Streaming' : 'Streaming off'),
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.w700, 
              color: !supportsStreaming ? theme.mutedText : (isOn ? theme.primaryAccent : theme.mutedText),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 44,
            height: 22,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: !supportsStreaming 
                  ? theme.segmentOffColor 
                  : (isOn ? theme.primaryAccent.withOpacity(0.2) : theme.segmentOffColor),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                !supportsStreaming 
                    ? Icons.close_rounded 
                    : (isOn ? Icons.bolt_rounded : Icons.bolt_outlined),
                size: 11,
                color: isOn ? theme.primaryAccent : theme.mutedText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ModelSelectionTheme.of(context);
    final usageColor = _usageColor(theme);

    return GestureDetector(
      onTap: onSelect,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isActive ? theme.activeCardBackground : theme.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive ? theme.activeCardBorder : theme.cardBorder,
                width: isActive ? 2.0 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: usageColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        model.name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.normalText),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: isActive ? 24 : 0),
                      child: Text(
                        '${model.dailyUsed}/${model.currentDailyMaxLimit}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.normalText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _labeledBar('Limit', _segmentBar(active: _limitSegmentsActive, total: _limitSegmentsTotal, activeColor: usageColor, offColor: theme.segmentOffColor), theme),
                const SizedBox(height: 8),
                _labeledBar('Speed', _segmentBar(active: _speedSegmentsActive, total: 4, activeColor: Colors.blue, offColor: theme.segmentOffColor), theme),
                const SizedBox(height: 8),
                _labeledBar('Power', _segmentBar(active: _qualitySegmentsActive, total: 4, activeColor: theme.primaryAccent, offColor: theme.segmentOffColor), theme),
                if (step == TranslationPipelineStep.morphemes || step == TranslationPipelineStep.fullTranslate) ...[
                  const SizedBox(height: 12),
                  Align(alignment: Alignment.bottomRight, child: _streamingToggle(theme)),
                ],
              ],
            ),
          ),
          if (isActive)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: theme.primaryAccent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }
}
