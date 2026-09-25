import 'package:flutter/material.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/backend/services/algorithms/sync_scoring_algorithm.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';

class SubtitleSyncPlaque extends StatelessWidget {
  final AnalyzedSubtitle version;
  final bool isSelected;
  final AdditionalWindowTheme theme;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const SubtitleSyncPlaque({
    super.key,
    required this.version,
    this.isSelected = true,
    required this.theme,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (version.confidence * 100).toInt();
    final offsetMs = version.offset?.inMilliseconds ?? 0;
    
    final bool isUnverified = version.totalSegments == 0;
    
    String verdict = isUnverified ? 'Unverified' : SyncScoringAlgorithm.getVerdict(version.confidence);
    Color color = AppColors.warningText;
    
    if (isUnverified) {
      color = AppColors.slate400; // Grey for unverified
    } else if (verdict == 'Excellent') {
      color = const Color(0xFF10B981);
    } else if (verdict == 'Good') {
      color = AppColors.brandBlue;
    } else if (verdict == 'Fair') {
      color = AppColors.warningAmberText;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isSelected ? color.withValues(alpha: 0.08) : Colors.white,
              isSelected ? color.withValues(alpha: 0.02) : Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.3) : AppColors.slate200,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Row(
          children: [
            // Circular progress with accuracy
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    value: isUnverified ? 0 : version.confidence,
                    strokeWidth: 5,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  isUnverified ? '--%' : '$percentage%',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Filename & Offset
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    version.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? theme.normalText : AppColors.slate600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isUnverified ? AppColors.slate100 : color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          verdict,
                          style: TextStyle(
                            fontSize: 9, 
                            fontWeight: FontWeight.w900, 
                            color: isUnverified ? AppColors.slate500 : color, 
                            letterSpacing: 0.3
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.history_rounded, size: 12, color: AppColors.slate400),
                      const SizedBox(width: 4),
                      Text(
                        '${offsetMs >= 0 ? '+' : ''}${offsetMs}ms',
                        style: const TextStyle(
                          fontSize: 11, 
                          color: AppColors.slate500, 
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.slate400),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 24)
            else
              const Icon(Icons.radio_button_off_rounded, color: AppColors.slate300, size: 24),
          ],
        ),
      ),
    );
  }
}
