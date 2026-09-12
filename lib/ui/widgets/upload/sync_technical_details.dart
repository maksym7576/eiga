import 'dart:math';
import 'package:flutter/material.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../../backend/services/sync/audio_sync_service.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

/// "Technical Performance" card: metric rows plus an expandable list of
/// per-checkpoint alignment details, and (optionally) a button to apply the
/// suggested manual offset for the currently selected version.
Widget buildTechDetails(
    UploadState state,
    AdditionalWindowTheme theme,
    UploadNotifier notifier,
    ValueNotifier<bool> isExpanded, {
      Duration? currentOffset,
    }) {
  return Column(
    children: [
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.cardBorder, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(state, theme),
            const SizedBox(height: 16),
            metricRow(
              'Audio Recognition Quality (AI Score)',
              'Accuracy of the AI model on audio',
              state.syncPnr,
              15.0,
              '${state.syncPnr.toStringAsFixed(1)} / 15.0 PNR',
              theme,
            ),
            const SizedBox(height: 14),
            metricRow(
              'Subtitle Match Precision',
              'Similarity of timings and phonetic sequences',
              state.syncUniqueness,
              0.8,
              '${state.syncUniqueness.toStringAsFixed(1)} / 0.8',
              theme,
            ),
            const SizedBox(height: 14),
            metricRow(
              'Alignment Checkpoints',
              'Video points selected for evaluation',
              state.syncConsensus.toDouble(),
              max(3.0, state.syncTotalSegments.toDouble()),
              '${state.syncConsensus} / ${max(3, state.syncTotalSegments)} segments',
              theme,
            ),
            const SizedBox(height: 16),

            // Expandable Alignment Checkpoints Details
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => isExpanded.value = !isExpanded.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 200),
                              turns: isExpanded.value ? 0.25 : 0,
                              child: Icon(Icons.keyboard_arrow_right_rounded, size: 16, color: theme.primaryAccent),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Alignment Checkpoints',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.primaryAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isExpanded.value) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    if (state.syncCheckpoints.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            state.isCheckingSync ? 'Analyzing segments...' : 'No checkpoints generated yet',
                            style: TextStyle(fontSize: 12, color: theme.mutedText),
                          ),
                        ),
                      )
                    else
                      ...List.generate(state.syncCheckpoints.length, (i) {
                        final isLast = i == state.syncCheckpoints.length - 1;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: buildCheckpointItem(state.syncCheckpoints[i], theme),
                            ),
                            if (!isLast) Divider(height: 1, color: theme.cardBorder),
                          ],
                        );
                      }),
                  ],
                ],
              ),
            ),
            if (currentOffset != null && currentOffset.inMilliseconds.abs() > 50) ...[
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => notifier.applySyncFix(manualOffset: currentOffset),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Apply Suggested Shift (${(currentOffset.inMilliseconds / 1000.0) > 0 ? '+' : ''}${(currentOffset.inMilliseconds / 1000.0).toStringAsFixed(1)}s)',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

/// Icon-box + colored title + description block shown at the top of the
/// metrics card (matches the "Synchronization optimal (61%)" block in the
/// design: a small icon square, a bold status line, and an explanation
/// paragraph underneath, separated from the metrics below by a divider).
Widget _buildStatusHeader(UploadState state, AdditionalWindowTheme theme) {
  IconData icon;
  Color color;
  String message;

  switch (state.syncStatus) {
    case SyncMatchStatus.idle:
      icon = Icons.sync_problem_rounded;
      color = AppColors.slate400;
      message = 'Select episode to analyze';
      break;
    case SyncMatchStatus.analyzing:
      icon = Icons.search_rounded;
      color = theme.primaryAccent;
      message = 'Analyzing audio waveform...';
      break;
    case SyncMatchStatus.perfect:
      icon = Icons.check_circle_rounded;
      color = theme.primaryAccent;
      message = 'Synchronization optimal (${(state.syncConfidence * 100).toInt()}%)';
      break;
    case SyncMatchStatus.offset:
      icon = Icons.warning_amber_rounded;
      color = theme.primaryAccent;
      final offsetSecs = state.suggestedOffset != null
          ? (state.suggestedOffset!.inMilliseconds / 1000.0).toStringAsFixed(1)
          : '0.0';
      message = 'Offset detected: ${offsetSecs}s';
      break;
    case SyncMatchStatus.mismatch:
      icon = Icons.error_outline_rounded;
      color = AppColors.warningText;
      message = 'No clear match found among available versions';
      break;
    case SyncMatchStatus.error:
      icon = Icons.error_outline_rounded;
      color = AppColors.warningText;
      message = 'Analysis failed. Check file formats.';
      break;
  }

  final explanation = state.syncExplanation;
  final showExplanation = explanation != null && state.syncStatus != SyncMatchStatus.idle;

  return Container(
    padding: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: theme.cardBorder, width: 1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 12, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color),
              ),
            ),
          ],
        ),
        if (showExplanation) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              explanation,
              style: const TextStyle(fontSize: 11, color: AppColors.slate500, height: 1.4, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ],
    ),
  );
}

/// Single row inside the expanded checkpoint list.
///
/// Shows only what's needed to read the alignment result at a glance: the
/// checkpoint number, its time range, and how many seconds it was off by.
/// The subtitle phrase text and the "Aligned successfully" style status
/// label are intentionally not shown. Rendered as a plain row (no separate
/// box background) so it matches the white background of the surrounding
/// card and the other cards on this screen; rows are separated by thin
/// dividers instead.
Widget buildCheckpointItem(SyncCheckpoint cp, AdditionalWindowTheme theme) {
  final statusColor = cp.isDeviation ? AppColors.warningText : theme.primaryAccent;
  final statusBgColor = cp.isDeviation ? AppColors.warningText.withValues(alpha: 0.1) : theme.primaryAccent.withValues(alpha: 0.1);

  return Row(
    children: [
      Expanded(
        child: Row(
          children: [
            Text(cp.index, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.normalText)),
            const SizedBox(width: 6),
            Text(cp.timeRange, style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppColors.slate500)),
          ],
        ),
      ),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: statusBgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          cp.offsetText,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
        ),
      ),
    ],
  );
}

/// Labeled progress bar used for each metric in the technical details card.
Widget metricRow(
    String label,
    String subtitle,
    double current,
    double target,
    String valueText,
    AdditionalWindowTheme theme,
    ) {
  final progress = (current / target).clamp(0.0, 1.0);
  final badgeText = '${(progress * 100).toInt()}%';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: theme.normalText, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: AppColors.slate500, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.primaryAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(fontSize: 10, color: theme.primaryAccent, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valueText,
                style: const TextStyle(fontSize: 10, color: AppColors.slate500, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.slate200.withValues(alpha: 0.7),
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryAccent),
          minHeight: 5,
        ),
      ),
    ],
  );
}