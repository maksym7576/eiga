import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/database/schemas/ai_model_event.dart';
import 'package:eiga/config/pipelines/pipeline_steps.dart';
import 'package:eiga/providers/ui/ai_models_state_provider.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
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

  int get _usagePercent {
    if (model.currentDailyMaxLimit <= 0) return 0;
    return ((model.dailyUsed / model.currentDailyMaxLimit) * 100).clamp(0, 100).toInt();
  }

  Color _usageColor(ModelSelectionTheme theme) {
    final percent = _usagePercent;
    if (percent >= 90) return Colors.redAccent;
    if (percent >= 75) return Colors.orangeAccent;
    return theme.primaryAccent;
  }

  String get _speedText {
    switch (model.speed) {
      case ModelSpeed.ultraFast: return 'Ultra Fast';
      case ModelSpeed.fast: return 'Fast';
      case ModelSpeed.medium: return 'Medium';
      case ModelSpeed.slow: return 'Slow';
    }
  }

  String get _qualityText {
    switch (model.quality) {
      case ModelQuality.frontier: return 'Frontier';
      case ModelQuality.high: return 'High Quality';
      case ModelQuality.standard: return 'Standard';
      case ModelQuality.basic: return 'Basic';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ModelSelectionTheme.of(context);
    final usageColor = _usageColor(theme);
    final percent = _usagePercent;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? theme.activeCardBackground : theme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? theme.primaryAccent : theme.cardBorder,
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Status Dot, Name, and Usage Count
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: usageColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    model.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      color: theme.normalText,
                    ),
                  ),
                ),
                Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: usageColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            
            // Subtitle Row: Speed & Quality Info
            Row(
              children: [
                Text(
                  '$_speedText • $_qualityText',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.mutedText,
                  ),
                ),
                if (model.errorCount > 0) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    '${model.errorCount} err',
                    style: const TextStyle(fontSize: 11, color: Colors.orangeAccent, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Clean Linear Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent / 100,
                backgroundColor: theme.segmentOffColor,
                valueColor: AlwaysStoppedAnimation<Color>(usageColor),
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 4),

            // Bottom text: raw limits and streaming if active
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Limit: ${model.dailyUsed} / ${model.currentDailyMaxLimit}',
                      style: TextStyle(fontSize: 10, color: theme.mutedText, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _StatBadge(label: 'OK', count: model.successCount, color: Colors.green),
                        const SizedBox(width: 4),
                        _StatBadge(label: 'PART', count: model.partialSuccessCount, color: Colors.orange),
                        const SizedBox(width: 4),
                        _StatBadge(label: 'ERR', count: model.errorCount, color: Colors.redAccent),
                      ],
                    ),
                  ],
                ),

                if ((step == TranslationPipelineStep.morphemes || step == TranslationPipelineStep.grammarRole) && model.supportsStreaming)
                  GestureDetector(
                    onTap: onToggleStreaming,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          model.currentStreamingEnabled ? 'Streaming' : 'Streaming Off',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: model.currentStreamingEnabled ? theme.primaryAccent : theme.mutedText,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          model.currentStreamingEnabled ? Icons.bolt_rounded : Icons.bolt_outlined,
                          size: 14,
                          color: model.currentStreamingEnabled ? theme.primaryAccent : theme.mutedText,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            // Recent Events / Errors
            _RecentEventsList(modelName: model.name),
          ],
        ),
      ),
    );
  }
}

class _RecentEventsList extends ConsumerWidget {
  final String modelName;
  const _RecentEventsList({required this.modelName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(aiModelEventsProvider(modelName));
    
    return eventsAsync.when(
      data: (events) {
        final errors = events.where((e) => e.result == AiRequestPhase.error).take(3).toList();
        if (errors.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'RECENT ERRORS',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.redAccent.withValues(alpha: 0.7), letterSpacing: 0.5),
            ),
            const SizedBox(height: 6),
            ...errors.map((e) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (e.step ?? 'Unknown').toUpperCase(),
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.redAccent),
                      ),
                      Text(
                        _formatTime(e.timestamp),
                        style: TextStyle(fontSize: 8, color: Colors.redAccent.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    e.message ?? 'Unknown error',
                    style: const TextStyle(fontSize: 10, color: Colors.redAccent),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}.${dt.month}';
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatBadge({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}



