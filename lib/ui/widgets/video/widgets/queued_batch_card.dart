import 'package:flutter/material.dart';
import '../../../../backend/services/background/translation_background_manager.dart';
import '../../../styles/app_colors.dart';

class QueuedBatchCard extends StatelessWidget {
  final TranslationTask task;
  final int index;
  final int total;

  const QueuedBatchCard({
    super.key, 
    required this.task,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Row(
              children: [
                Icon(Icons.hourglass_empty_rounded, size: 16, color: Color(0xFF94A3B8)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Queue Batch • Waiting',
                    style: TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w700, 
                      color: Color(0xFF475569),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Text(
              '0 / ${task.phraseIds.length}',
              style: const TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.w800, 
                fontFamily: 'monospace', 
                color: Color(0xFF64748B)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
