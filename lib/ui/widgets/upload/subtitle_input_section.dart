import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import '../../../providers/ui/upload_provider.dart';
import '../../../providers/ui/search_provider.dart';
import '../../styles/additional_window_theme.dart';
import '../dialogs/app_bottom_sheet.dart';
import 'jimaku_files_sheet.dart';

class SubtitleInputSection extends ConsumerWidget {
  const SubtitleInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);
    final selectedJimaku = ref.watchJimakuSelectedEntry();

    if (state.subtitleSource == SubtitleSource.jimaku) {
      if (selectedJimaku == null) return const SizedBox.shrink();

      final hasFile = state.subtitlePath != null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _openJimakuFiles(context, selectedJimaku),
              icon: Icon(Icons.tune_rounded, size: 20, color: theme.primaryAccent),
              label: Text(
                'Advanced Subtitle Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                  color: theme.normalText,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.primaryAccent, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                backgroundColor: theme.primaryAccent.withValues(alpha: 0.05),
              ),
            ),
          ),
          if (hasFile) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.primaryAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, size: 18, color: theme.primaryAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      p.basename(state.subtitlePath!),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.normalText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.check_circle, size: 16, color: theme.primaryAccent),
                ],
              ),
            ),
          ],
        ],
      );
    }

    // Local source (Matching VideoInputSection design)
    final hasPath = state.subtitlePath != null;

    return GestureDetector(
      onTap: notifier.pickSubtitle,
      behavior: HitTestBehavior.opaque,
      child: CustomPaint(
        painter: hasPath ? null : DashedBorderPainter(
          color: theme.cardBorder.withOpacity(0.8),
          strokeWidth: 2.0,
          gap: 5,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: hasPath 
                ? theme.primaryAccent.withOpacity(0.08) 
                : theme.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: hasPath 
                ? Border.all(color: theme.primaryAccent, width: 2.0) 
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.primaryAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.subtitles_outlined,
                  size: 24,
                  color: theme.primaryAccent,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      state.subtitlePath != null 
                          ? p.basename(state.subtitlePath!) 
                          : 'Upload Subtitle File',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.normalText,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (state.subtitlePath == null)
                      Text(
                        '.srt, .ass, .vtt',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.subtitleColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openJimakuFiles(BuildContext context, dynamic entry) {
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.88,
      child: JimakuFilesSheet(entry: entry),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ));

    final Path dashPath = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
