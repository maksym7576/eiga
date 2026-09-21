import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import '../../../styles/additional_window_theme.dart';
import '../components/sync_technical_details.dart';

class SyncVersionSelector extends HookConsumerWidget {
  final ValueNotifier<bool>? isExpanded;
  final bool showTechDetails;

  const SyncVersionSelector({
    super.key,
    this.isExpanded,
    this.showTechDetails = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final theme = AdditionalWindowTheme.of(context);
    final notifier = ref.read(uploadProvider.notifier);
    final localExpanded = useState(false);
    final effectiveExpanded = isExpanded ?? localExpanded;

    if (state.analyzedVersions.isEmpty) return const SizedBox.shrink();

    // Сортування версій за впевненістю (accuracy)
    final sortedVersions = List<AnalyzedSubtitle>.from(state.analyzedVersions)
      ..sort((a, b) => b.confidence.compareTo(a.confidence));

    final bestVersion = sortedVersions.first;
    final selectedVersion = state.activeSelection ?? bestVersion;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.auto_awesome_motion_rounded, size: 16, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'SUBTITLE VERSIONS',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 0.5),
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => effectiveExpanded.value = !effectiveExpanded.value,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        children: [
                          Text(
                            effectiveExpanded.value ? 'Collapse' : 'Change version',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                          ),
                          const SizedBox(width: 6),
                          AnimatedRotation(
                            duration: const Duration(milliseconds: 250),
                            turns: effectiveExpanded.value ? 0.5 : 0,
                            child: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Color(0xFF2563EB)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
  
          // 2. Main Unified Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Inline Version List Box
                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutQuart,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: List.generate(
                        effectiveExpanded.value ? sortedVersions.length : 1,
                        (index) {
                          final version = effectiveExpanded.value ? sortedVersions[index] : selectedVersion;
                          final isSelected = version.fileName == selectedVersion.fileName;
                          final isBest = version.fileName == bestVersion.fileName;
                          final isLast = index == (effectiveExpanded.value ? sortedVersions.length - 1 : 0);
  
                          return Column(
                            children: [
                              _VersionRow(
                                version: version,
                                isSelected: isSelected,
                                isBest: isBest,
                                onTap: () {
                                  notifier.selectVersion(version);
                                  // Закриваємо список при виборі
                                  effectiveExpanded.value = false;
                                },
                              ),
                              if (!isLast) const Divider(height: 1, color: Color(0xFFE2E8F0), indent: 16, endIndent: 16),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
  
                // Technical Metrics List
                if (showTechDetails) ...[
                  const SizedBox(height: 24),
                  ...buildTechDetails(
                    context,
                    state,
                    theme,
                    notifier,
                    effectiveExpanded,
                    currentOffset: state.suggestedOffset ?? selectedVersion.offset,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionRow extends StatelessWidget {
  final AnalyzedSubtitle version;
  final bool isSelected;
  final bool isBest;
  final VoidCallback onTap;

  const _VersionRow({
    required this.version,
    required this.isSelected,
    required this.isBest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final offset = version.offset?.inMilliseconds ?? 0;
    final accuracy = (version.confidence * 100).toInt();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio-like indicator
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                    width: isSelected ? 6 : 2,
                  ),
                  color: isSelected ? Colors.white : Colors.transparent,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Version Name & Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          version.fileName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569),
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isBest) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                          ),
                          child: const Text(
                            'Optimal',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.auto_graph_rounded, size: 12, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(
                        '$accuracy% accuracy',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600, 
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2563EB).withValues(alpha: 0.2) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history_rounded, size: 10, color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(
                              '${offset >= 0 ? '+' : ''}${offset}ms',
                              style: TextStyle(
                                fontSize: 11, 
                                fontWeight: FontWeight.w900, 
                                color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF475569), 
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
