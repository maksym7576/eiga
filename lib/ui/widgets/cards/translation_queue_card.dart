import 'package:flutter/material.dart';
import '../../../../backend/services/background/translation_background_manager.dart';
import '../../styles/app_colors.dart';

class TranslationQueueCard extends StatelessWidget {
  final TranslationTask task;
  final int index;
  final int total;
  final bool hasHistory;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  const TranslationQueueCard({
    super.key, 
    required this.task,
    required this.index,
    required this.total,
    this.hasHistory = false,
    this.isExpanded = false,
    this.onToggleExpand,
  });

  String _formatPhraseOrders(List<int>? orders) {
    if (orders == null || orders.isEmpty) return 'No phrases';
    if (orders.length == 1) return 'Phrase #${orders.first}';
    
    final sorted = List<int>.from(orders)..sort();
    final List<String> parts = [];
    
    int start = sorted[0];
    int prev = sorted[0];
    
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i] == prev + 1) {
        prev = sorted[i];
      } else {
        parts.add(start == prev ? '#$start' : '#$start-$prev');
        start = sorted[i];
        prev = sorted[i];
      }
    }
    parts.add(start == prev ? '#$start' : '#$start-$prev');
    
    final result = parts.join(', ');
    if (result.length > 30) {
      return '${orders.length} phrases (${parts.first}...)';
    }
    return 'Phrases $result';
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              if (hasHistory) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onToggleExpand,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isExpanded ? const Color(0xFFEFF6FF) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: isExpanded ? const Color(0xFFDBEAFE) : const Color(0xFFE2E8F0)),
                    ),
                    child: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: isExpanded ? const Color(0xFF0A84FF) : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatPhraseOrders(task.phraseOrders),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF94A3B8),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
