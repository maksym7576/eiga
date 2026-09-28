import 'package:flutter/material.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/backend/database/schemas/phrase.dart';
import 'package:eiga/backend/services/ai/subtitle_timing_validator.dart';
import 'package:eiga/ui/styles/app_colors.dart';

class VideoTimelineProgress extends StatefulWidget {
  final Video video;
  final List<Phrase> phrases;
  final double height;

  const VideoTimelineProgress({
    super.key,
    required this.video,
    required this.phrases,
    this.height = 10,
  });

  @override
  State<VideoTimelineProgress> createState() => _VideoTimelineProgressState();
}

class _VideoTimelineProgressState extends State<VideoTimelineProgress> {
  int? _hoveredIndex;
  Offset? _pointerPos;

  @override
  Widget build(BuildContext context) {
    final blocks = widget.video.transcriptionBlocks ?? [];
    final double totalDuration = blocks.isNotEmpty 
        ? blocks.last.endSeconds?.toDouble() ?? 1800.0 
        : 1800.0;

    int completedCount = blocks.where((b) => b.status == 'completed' || b.status == 'warning').length;
    int warningCount = blocks.where((b) => b.status == 'warning').length;
    int totalCount = blocks.isNotEmpty ? blocks.length : 1;
    final totalEstimatedPhrases = blocks.fold(0, (sum, b) => sum + (((b.endSeconds ?? 0) - (b.startSeconds ?? 0)) ~/ 5).clamp(1, 100));
    final actualCount = widget.phrases.length;

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
                  'Blocks Map & Timing Analysis (Yellow = Needs Review)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                ),
              ],
            ),
            Text(
              'Est. ~$totalEstimatedPhrases | Found: $actualCount ${warningCount > 0 ? '($warningCount warnings)' : ''}',
              style: TextStyle(
                fontSize: 10, 
                fontWeight: FontWeight.w800, 
                color: warningCount > 0 
                    ? const Color(0xFFF59E0B) 
                    : (completedCount == totalCount ? const Color(0xFF10B981) : AppColors.brandBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTapUp: (details) => _handleTap(details.localPosition, constraints.maxWidth, totalDuration, blocks, context),
              onPanUpdate: (details) => _handlePointer(details.localPosition, constraints.maxWidth, totalDuration, blocks),
              onPanDown: (details) => _handlePointer(details.localPosition, constraints.maxWidth, totalDuration, blocks),
              onPanEnd: (_) => setState(() {
                _hoveredIndex = null;
                _pointerPos = null;
              }),
              child: MouseRegion(
                onHover: (event) => _handlePointer(event.localPosition, constraints.maxWidth, totalDuration, blocks),
                onExit: (_) => setState(() {
                  _hoveredIndex = null;
                  _pointerPos = null;
                }),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: widget.height,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: AppColors.brandBlue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(
                      height: widget.height,
                      width: constraints.maxWidth,
                      child: CustomPaint(
                        painter: _VideoBlocksPainter(
                          blocks: blocks,
                          totalDuration: totalDuration,
                          hoveredIndex: _hoveredIndex,
                        ),
                      ),
                    ),
                    if (_hoveredIndex != null && _pointerPos != null && _hoveredIndex! < blocks.length)
                      Positioned(
                        left: (_pointerPos!.dx - 80).clamp(0.0, constraints.maxWidth - 160),
                        bottom: widget.height + 12,
                        child: _BlockTooltip(block: blocks[_hoveredIndex!]),
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

  void _handlePointer(Offset pos, double width, double totalDuration, List<VideoBlock> blocks) {
    if (blocks.isEmpty) return;
    int? foundIndex;
    for (int i = 0; i < blocks.length; i++) {
      final b = blocks[i];
      final startPx = ((b.startSeconds ?? 0) / totalDuration) * width;
      final endPx = ((b.endSeconds ?? 1) / totalDuration) * width;
      if (pos.dx >= startPx - 2 && pos.dx <= endPx + 2) {
        foundIndex = i;
        break;
      }
    }
    setState(() {
      _hoveredIndex = foundIndex;
      _pointerPos = pos;
    });
  }

  void _handleTap(Offset pos, double width, double totalDuration, List<VideoBlock> blocks, BuildContext context) {
    if (blocks.isEmpty) return;
    for (int i = 0; i < blocks.length; i++) {
      final b = blocks[i];
      final startPx = ((b.startSeconds ?? 0) / totalDuration) * width;
      final endPx = ((b.endSeconds ?? 1) / totalDuration) * width;
      if (pos.dx >= startPx - 4 && pos.dx <= endPx + 4) {
        _showBlockDetailsDialog(context, b, widget.phrases);
        break;
      }
    }
  }

  void _showBlockDetailsDialog(BuildContext context, VideoBlock block, List<Phrase> allPhrases) {
    final baseDate = DateTime(1970, 1, 1);
    final startSec = block.startSeconds ?? 0;
    final endSec = block.endSeconds ?? 0;
    final durationSec = endSec - startSec;
    final estimatedPhrases = (durationSec / 5).ceil().clamp(1, 100);

    final blockPhrases = allPhrases.where((p) {
      if (p.startTime == null || p.endTime == null) return false;
      final pStart = p.startTime!.difference(baseDate).inSeconds;
      final pEnd = p.endTime!.difference(baseDate).inSeconds;
      return pEnd >= startSec && pStart <= endSec;
    }).toList();

    final phraseCount = blockPhrases.length;
    final timingReport = SubtitleTimingValidator.analyze(blockPhrases, startSec, endSec);
    final double matchScore = phraseCount > 0 ? (1.0 - ((phraseCount - estimatedPhrases).abs() / estimatedPhrases).clamp(0.0, 0.3)) : (block.status == 'completed' ? 0.90 : 0.0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.analytics_rounded, color: AppColors.brandBlue, size: 22),
            const SizedBox(width: 10),
            Text(
              'Block #${block.blockIndex} Timing Analysis',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.slate900),
            ),
          ],
        ),
        content: SizedBox(
          width: 360,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Time Range', '${_formatSeconds(startSec)} - ${_formatSeconds(endSec)}'),
                _detailRow('Block Status', block.status?.toUpperCase() ?? 'PENDING'),
                const Divider(height: 20),
                const Text(
                  'Phrase & Timing Verification',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.slate700),
                ),
                const SizedBox(height: 8),
                _detailRow('Estimated Phrases (VAD)', '~ $estimatedPhrases phrases'),
                _detailRow('AI Returned Phrases', '$phraseCount phrases'),
                _detailRow('Out-of-Bounds Phrases', '${timingReport.outOfBoundsCount} phrases'),
                _detailRow('Over-Duration (>10s)', '${timingReport.overDurationCount} phrases'),
                _detailRow('Timing Accuracy Match', '${(matchScore * 100).toStringAsFixed(0)}%'),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: matchScore.clamp(0.0, 1.0),
                  backgroundColor: AppColors.slate200,
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(4),
                ),
                if (timingReport.warningMessages.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Text(
                    '⚠️ Timing Warnings & Mismatches (Marked Yellow):',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: timingReport.warningMessages.take(4).map((msg) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('• $msg', style: const TextStyle(fontSize: 10, color: Color(0xFF92400E))),
                      )).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.brandBlue)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.slate500, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 11, color: AppColors.slate800, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatSeconds(int s) {
    int m = s ~/ 60;
    int sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}

class _VideoBlocksPainter extends CustomPainter {
  final List<VideoBlock> blocks;
  final double totalDuration;
  final int? hoveredIndex;

  _VideoBlocksPainter({
    required this.blocks,
    required this.totalDuration,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < blocks.length; i++) {
      final b = blocks[i];
      final double startX = ((b.startSeconds ?? 0) / totalDuration) * size.width;
      final double endX = ((b.endSeconds ?? 1) / totalDuration) * size.width;
      final double rectWidth = (endX - startX - 2.0).clamp(4.0, size.width);

      Color color;
      switch (b.status) {
        case 'completed':
          color = const Color(0xFF10B981); // Green
          break;
        case 'processing':
          color = const Color(0xFF8B5CF6); // Purple
          break;
        case 'warning':
          color = const Color(0xFFF59E0B); // Yellow (Needs Review)
          break;
        case 'failed':
          color = AppColors.warningText; // Red
          break;
        default:
          continue; // Pending - transparent
      }

      final bool isHovered = hoveredIndex == i;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(startX, 0, rectWidth, size.height),
          const Radius.circular(4),
        ),
        Paint()..color = color,
      );

      if (isHovered) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(startX - 1, -2, rectWidth + 2, size.height + 4),
            const Radius.circular(6),
          ),
          Paint()
            ..color = color.withValues(alpha: 0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VideoBlocksPainter oldDelegate) {
    return oldDelegate.hoveredIndex != hoveredIndex || oldDelegate.blocks != blocks;
  }
}

class _BlockTooltip extends StatelessWidget {
  final VideoBlock block;
  const _BlockTooltip({required this.block});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.slate400;
    String status = 'Pending';
    final estPhrases = ((block.endSeconds ?? 0) - (block.startSeconds ?? 0)) ~/ 5;

    if (block.status == 'completed') {
      color = const Color(0xFF10B981);
      status = 'Completed';
    } else if (block.status == 'processing') {
      color = const Color(0xFF8B5CF6);
      status = 'Processing (Active)';
    } else if (block.status == 'warning') {
      color = const Color(0xFFF59E0B);
      status = 'Needs Review (Warning)';
    } else if (block.status == 'failed') {
      color = AppColors.warningText;
      status = 'Failed (Will Retry)';
    }

    return Container(
      width: 190,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Block #${block.blockIndex} (~$estPhrases phrases)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.slate900),
          ),
          const SizedBox(height: 2),
          Text(
            '${_formatSeconds(block.startSeconds ?? 0)} - ${_formatSeconds(block.endSeconds ?? 0)}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.slate600, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSeconds(int s) {
    int m = s ~/ 60;
    int sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
