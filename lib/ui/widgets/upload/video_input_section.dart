import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import '../../../providers/ui/upload_provider.dart';
import '../../styles/additional_window_theme.dart';

class VideoInputSection extends ConsumerWidget {
  const VideoInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AdditionalWindowTheme.of(context);
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);

    final isFile = state.videoSource == VideoSource.file;
    final hasPath = state.videoPath != null;

    return GestureDetector(
      onTap: isFile ? notifier.pickVideo : null,
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
                  state.videoSource == VideoSource.file 
                      ? Icons.movie_outlined 
                      : state.videoSource == VideoSource.url 
                          ? Icons.link 
                          : Icons.search,
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
                      state.videoPath != null 
                          ? p.basename(state.videoPath!) 
                          : 'Upload Video File',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: theme.normalText,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (state.videoPath == null)
                      Text(
                        'MP4, MKV, AVI (Max 2GB)',
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
