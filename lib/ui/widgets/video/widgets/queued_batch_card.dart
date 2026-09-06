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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.slate300, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.slate600),
                children: [
                  TextSpan(text: 'Phrases ${(task.phraseIds.isNotEmpty) ? 1 : 1}–${task.phraseIds.length}'),
                  const TextSpan(text: '  •  ', style: TextStyle(color: AppColors.slate300, fontWeight: FontWeight.normal)),
                  const TextSpan(text: 'Queued for execution', style: TextStyle(color: AppColors.slate400, fontSize: 10, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(8)),
            child: Text(
              '0 / ${task.phraseIds.length}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: AppColors.slate400),
            ),
          ),
        ],
      ),
    );
  }
}
