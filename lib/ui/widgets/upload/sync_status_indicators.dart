import 'package:flutter/material.dart';
import '../../../providers/ui/upload_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../../styles/app_colors.dart';

/// Colored dot + status message (the message text that used to live in the
/// separate status banner below the card), plus the sync explanation text
/// right underneath it. This replaces the old duplicated pair of a short
/// Ukrainian label here and a longer English message in a banner further
/// down the layout.
// buildCompactStatusDot removed as per user request

/// Progress bar + label shown while multiple subtitle versions are being
/// evaluated in a batch.
Widget buildBatchProgress(UploadState state, AdditionalWindowTheme theme) {
  final isBatch = state.isEvaluatingBatch;
  final progress = state.totalEvaluationCount > 0 ? state.currentEvaluationIndex / state.totalEvaluationCount : 0.0;
  
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: theme.isDark ? Colors.white.withValues(alpha: 0.03) : theme.dividerColor.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: theme.dividerColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isBatch ? 'Neural Batch Analysis' : 'Syncing Audio Waveform',
              style: TextStyle(
                fontSize: 11, 
                fontWeight: FontWeight.w800, 
                color: theme.normalText,
                letterSpacing: 0.2,
              ),
            ),
            if (isBatch)
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11, 
                  fontWeight: FontWeight.w900, 
                  color: theme.primaryAccent,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: isBatch && progress > 0 ? progress : null,
            backgroundColor: theme.isDark ? Colors.white10 : Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryAccent),
            minHeight: 8,
          ),
        ),
        if (isBatch) ...[
          const SizedBox(height: 8),
          Text(
            'Processing version ${state.currentEvaluationIndex} of ${state.totalEvaluationCount}...',
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.w600, 
              color: theme.mutedText,
            ),
          ),
        ],
      ],
    ),
  );
}