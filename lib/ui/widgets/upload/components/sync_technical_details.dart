import 'dart:math';
import 'package:flutter/material.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import '../../../../backend/services/audio/audio_sync_service.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';

import 'sync_fix_button.dart';
import 'sync_timeline_progress.dart';

List<Widget> buildTechDetails(
    BuildContext context,
    UploadState state,
    AdditionalWindowTheme theme,
    UploadNotifier notifier,
    ValueNotifier<bool> isExpanded, {
      Duration? currentOffset,
      bool showHeader = false,
    }) {
  final confidence = state.syncConfidence > 0 ? state.syncConfidence : (state.activeSelection?.confidence ?? 0.0);
  
  // Показуємо інфо-бокс лише якщо ще не було спроби аналізу
  if (state.syncStatus == SyncMatchStatus.idle && !state.isCheckingSync) {
    return [
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF64748B)),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Subtitles selected. Run "Check Sync" to analyze timing accuracy and match quality.',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  return [
    const SizedBox(height: 16),
    if (showHeader) ...[
      _buildStatusHeader(state, theme, confidence),
      const SizedBox(height: 16),
    ],
    // Видалили _buildGeneralScoreCard, бо тепер версія сама виглядає як ця картка
    // 1. Audio Recognition
    if (state.syncPnr > 1.0) ...[
      metricRow(
        'Audio Recognition',
        'AI voice activity confidence',
        state.syncPnr,
        15.0,
        '${state.syncPnr.toStringAsFixed(1)} PNR',
        theme,
        Icons.settings_voice_rounded,
      ),
      const SizedBox(height: 16),
    ],

    // 2. Match Precision
    if (state.syncUniqueness > 0.05) ...[
      metricRow(
        'Match Precision',
        'Phonetic alignment accuracy',
        state.syncUniqueness,
        0.8,
        '${(state.syncUniqueness * 100).toInt()}% score',
        theme,
        Icons.biotech_rounded,
      ),
      const SizedBox(height: 16),
    ],

    // 3. Interactive Timeline (Replaces Verified Segments)
    if (state.syncCheckpoints.isNotEmpty) ...[
      SyncTimelineProgress(state: state),
      const SizedBox(height: 16),
    ],
    
    AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: (currentOffset != null && currentOffset != Duration.zero)
          ? Padding(
              key: ValueKey(currentOffset.inMilliseconds),
              padding: const EdgeInsets.only(top: 8),
              child: SyncFixButton(offset: currentOffset),
            )
          : const SizedBox.shrink(),
    ),
  ];
}

// Видалили старий ExpansionTile та _buildGeneralScoreCard (бо він тепер у плашці)



Widget _buildStatusHeader(UploadState state, AdditionalWindowTheme theme, double confidence) {
  IconData icon;
  Color color;
  String message;
  String? subMessage;

  final bool isPerfect = state.syncConsensus >= 3 && state.syncTotalSegments > 0 && state.syncConsensus == state.syncTotalSegments;

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
    case SyncMatchStatus.offset:
      final isOffset = state.syncStatus == SyncMatchStatus.offset;
      icon = isOffset ? Icons.warning_amber_rounded : Icons.check_circle_rounded;
      color = theme.primaryAccent;
      message = isOffset 
          ? 'Offset detected (${(confidence * 100).toInt()}%)' 
          : 'Synchronization optimal (${(confidence * 100).toInt()}%)';
      subMessage = isPerfect 
          ? 'Perfect consensus: all video segments agree on this timing.'
          : 'High confidence match found based on multiple points.';
      break;
    case SyncMatchStatus.mismatch:
      icon = Icons.error_outline_rounded;
      color = AppColors.warningText;
      message = 'No clear match found';
      subMessage = 'The audio does not seem to match these subtitles.';
      break;
    case SyncMatchStatus.error:
      icon = Icons.error_outline_rounded;
      color = AppColors.warningText;
      message = 'Analysis failed';
      subMessage = 'Please check if the video file has a valid audio track.';
      break;
  }

  final explanation = state.syncExplanation;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color, letterSpacing: -0.3),
                ),
                if (subMessage != null)
                  Text(
                    subMessage,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.mutedText, height: 1.3),
                  ),
              ],
            ),
          ),
        ],
      ),
      if (explanation != null && state.syncStatus != SyncMatchStatus.idle) ...[
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.slate50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            explanation,
            style: const TextStyle(fontSize: 11, color: AppColors.slate600, height: 1.4, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ],
  );
}

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

Widget _buildGeneralScoreCard(double confidence, AdditionalWindowTheme theme) {
  final percentage = (confidence * 100).toInt();
  Color color = AppColors.warningText;
  String label = 'Poor';
  
  if (percentage >= 80) {
    color = const Color(0xFF10B981);
    label = 'Excellent';
  } else if (percentage >= 50) {
    color = AppColors.brandBlue;
    label = 'Good';
  } else if (percentage >= 30) {
    color = AppColors.warningAmberText;
    label = 'Fair';
  }

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color.withValues(alpha: 0.08), color.withValues(alpha: 0.02)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
    ),
    child: Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 54,
              height: 54,
              child: CircularProgressIndicator(
                value: confidence,
                strokeWidth: 6,
                backgroundColor: color.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overall Confidence',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate500),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color, letterSpacing: -0.5),
              ),
            ],
          ),
        ),
        Icon(Icons.verified_rounded, color: color.withValues(alpha: 0.2), size: 32),
      ],
    ),
  );
}

Widget metricRow(
    String label,
    String subtitle,
    double current,
    double target,
    String valueText,
    AdditionalWindowTheme theme,
    IconData icon, {
      Widget? additionalContent,
    }) {
  final progress = (current / target).clamp(0.0, 1.0);
  final badgeText = '${(progress * 100).toInt()}%';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.brandBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 14, color: AppColors.brandBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w800, letterSpacing: -0.1),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                badgeText,
                style: const TextStyle(fontSize: 15, color: Color(0xFF2563EB), fontWeight: FontWeight.w900, height: 1.0),
              ),
              const SizedBox(height: 2),
              Text(
                valueText,
                style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8), fontWeight: FontWeight.w700, fontFamily: 'monospace'),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 10),
      Container(
        height: 6,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.brandBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      if (additionalContent != null) additionalContent,
    ],
  );
}
