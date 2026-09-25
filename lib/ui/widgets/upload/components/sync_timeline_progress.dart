import 'package:flutter/material.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import 'package:eiga/backend/services/audio/audio_sync_service.dart';

class SyncTimelineProgress extends StatefulWidget {
  final UploadState state;
  final double height;

  const SyncTimelineProgress({
    super.key,
    required this.state,
    this.height = 8, // Thinner bar like others
  });

  @override
  State<SyncTimelineProgress> createState() => _SyncTimelineProgressState();
}

class _SyncTimelineProgressState extends State<SyncTimelineProgress> {
  int? _hoveredSegmentIndex;
  Offset? _pointerPos;

  @override
  Widget build(BuildContext context) {
    final totalDuration = widget.state.videoDuration?.toDouble() ?? 1800.0;
    final checkpoints = widget.state.syncCheckpoints;
    
    // Рахуємо ТІЛЬКИ успішні (aligned) сегменти. Deviation та Failed не вважаються "detected" для лічильника.
    final detectedCount = checkpoints.where((cp) => cp.statusText == 'aligned').length;
    final totalCount = checkpoints.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.timeline_rounded, size: 14, color: Color(0xFF64748B)),
                SizedBox(width: 8),
                Text(
                  'Sync Timeline Map',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                ),
              ],
            ),
            Text(
              totalCount > 0 ? '$detectedCount / $totalCount detected' : 'Not analyzed',
              style: TextStyle(
                fontSize: 11, 
                fontWeight: FontWeight.w800, 
                color: totalCount == 0 
                    ? AppColors.slate400
                    : (detectedCount == totalCount 
                        ? const Color(0xFF10B981) 
                        : (detectedCount > 0 ? AppColors.brandBlue : AppColors.warningText))
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onPanUpdate: (details) => _handlePointer(details.localPosition, constraints.maxWidth, totalDuration),
              onPanDown: (details) => _handlePointer(details.localPosition, constraints.maxWidth, totalDuration),
              onPanEnd: (_) => setState(() {
                _hoveredSegmentIndex = null;
                _pointerPos = null;
              }),
              child: MouseRegion(
                onHover: (event) => _handlePointer(event.localPosition, constraints.maxWidth, totalDuration),
                onExit: (_) => setState(() {
                  _hoveredSegmentIndex = null;
                  _pointerPos = null;
                }),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Base background track (Blue instead of Grey)
                    Container(
                      height: widget.height,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: AppColors.brandBlue.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    
                    // Markers and segments
                    SizedBox(
                      height: widget.height,
                      width: constraints.maxWidth,
                      child: CustomPaint(
                        painter: _TimelinePainter(
                          checkpoints: checkpoints,
                          totalDuration: totalDuration,
                          hoveredIndex: _hoveredSegmentIndex,
                        ),
                      ),
                    ),

                    // Tooltip (floating above)
                    if (_hoveredSegmentIndex != null && _pointerPos != null)
                      Positioned(
                        left: (_pointerPos!.dx - 75).clamp(0.0, constraints.maxWidth - 150),
                        bottom: widget.height + 10,
                        child: _SyncTooltip(
                          checkpoint: checkpoints[_hoveredSegmentIndex!],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _timeLabel('00:00'),
            _timeLabel(_formatSeconds(totalDuration.toInt())),
          ],
        ),
      ],
    );
  }

  Widget _timeLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.slate400, fontFamily: 'monospace'),
    );
  }

  void _handlePointer(Offset pos, double width, double totalDuration) {
    final checkpoints = widget.state.syncCheckpoints;
    if (checkpoints.isEmpty) return;

    int? foundIndex;
    for (int i = 0; i < checkpoints.length; i++) {
      final cp = checkpoints[i];
      final startPx = (cp.startS / totalDuration) * width;
      final endPx = (cp.endS / totalDuration) * width;

      // Vertical hit area is larger than visual height for better UX
      if (pos.dx >= startPx - 4 && pos.dx <= endPx + 4) {
        foundIndex = i;
        break;
      }
    }

    setState(() {
      _hoveredSegmentIndex = foundIndex;
      _pointerPos = pos;
    });
  }

  String _formatSeconds(int s) {
    int m = s ~/ 60;
    int sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}

class _TimelinePainter extends CustomPainter {
  final List<SyncCheckpoint> checkpoints;
  final double totalDuration;
  final int? hoveredIndex;

  _TimelinePainter({
    required this.checkpoints,
    required this.totalDuration,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < checkpoints.length; i++) {
      final cp = checkpoints[i];
      final double startX = (cp.startS / totalDuration) * size.width;
      final double endX = (cp.endS / totalDuration) * size.width;
      final double rectWidth = (endX - startX).clamp(4.0, size.width);

      bool isFailed = cp.statusText == 'failed';
      bool isHovered = hoveredIndex == i;

      Color color;
      if (isFailed) {
        color = AppColors.warningText;
      } else if (cp.isDeviation) {
        color = AppColors.warningAmberText;
      } else {
        color = const Color(0xFF10B981);
      }

      // Draw active segment
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(startX, 0, rectWidth, size.height),
          const Radius.circular(10),
        ),
        Paint()..color = color,
      );
      
      // Add glow/highlight if hovered
      if (isHovered) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(startX - 2, -2, rectWidth + 4, size.height + 4),
            const Radius.circular(12),
          ),
          Paint()..color = color.withOpacity(0.3)
                 ..style = PaintingStyle.stroke
                 ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TimelinePainter oldDelegate) {
    return oldDelegate.hoveredIndex != hoveredIndex || oldDelegate.checkpoints != checkpoints;
  }
}

class _SyncTooltip extends StatelessWidget {
  final SyncCheckpoint checkpoint;

  const _SyncTooltip({required this.checkpoint});

  @override
  Widget build(BuildContext context) {
    bool isFailed = checkpoint.statusText == 'failed';
    bool isDeviation = checkpoint.statusText == 'deviation';
    Color color = isFailed ? AppColors.warningText : (isDeviation ? AppColors.warningAmberText : const Color(0xFF10B981));
    String statusLabel = isFailed ? 'FAILED' : (isDeviation ? 'DEVIATION' : checkpoint.offsetText);

    return Container(
      width: 170,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12), 
            blurRadius: 12, 
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Segment #${checkpoint.index}', 
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.slate400),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            checkpoint.timeRange,
            style: const TextStyle(
              fontSize: 11, 
              fontWeight: FontWeight.w800, 
              color: AppColors.slate800, 
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isFailed ? 'No voice detected' : checkpoint.phraseText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10, 
              color: isFailed ? AppColors.warningText : AppColors.slate500, 
              fontWeight: isFailed ? FontWeight.w700 : FontWeight.w500,
              fontStyle: isFailed ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
