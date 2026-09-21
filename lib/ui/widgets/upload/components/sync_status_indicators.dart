import 'package:flutter/material.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';

Widget buildBatchProgress(UploadState state, AdditionalWindowTheme theme) {
  final isBatch = state.isEvaluatingBatch;
  final progress = state.totalEvaluationCount > 0 ? state.currentEvaluationIndex / state.totalEvaluationCount : 0.0;
  
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: isBatch && progress > 0 ? progress : null,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primaryAccent),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isBatch ? 'Neural Batch Analysis' : 'Syncing Audio Waveform',
                  style: TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.w900, 
                    color: theme.titleColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            if (isBatch)
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13, 
                  fontWeight: FontWeight.w900, 
                  color: theme.primaryAccent,
                  fontFamily: 'monospace',
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 6,
            child: LinearProgressIndicator(
              value: isBatch && progress > 0 ? progress : null,
              backgroundColor: theme.isDark ? Colors.white10 : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryAccent),
            ),
          ),
        ),
        if (isBatch) ...[
          const SizedBox(height: 12),
          Text(
            'Version ${state.currentEvaluationIndex} of ${state.totalEvaluationCount}',
            style: TextStyle(
              fontSize: 11, 
              fontWeight: FontWeight.w800, 
              color: theme.normalText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Current: ${state.subtitleFileName ?? "subtitles"}',
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.w500, 
              color: theme.mutedText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ] else if (state.isCheckingSync) ...[
          const SizedBox(height: 10),
          const Text(
            'Analyzing video segments & synchronizing time markers...',
            style: TextStyle(
              fontSize: 11, 
              fontWeight: FontWeight.w500, 
              color: AppColors.slate500,
            ),
          ),
        ],
      ],
    ),
  );
}
