import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/backend/services/algorithms/sync_scoring_algorithm.dart';
import '../../../styles/additional_window_theme.dart';
import '../../../styles/app_colors.dart';
import '../components/sync_technical_details.dart';
import '../components/subtitle_sync_plaque.dart';

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
  
          // 2. Version List (Plaques)
          AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutQuart,
            child: Column(
              children: [
                if (!effectiveExpanded.value)
                  SubtitleSyncPlaque(
                    version: selectedVersion,
                    isSelected: true,
                    theme: theme,
                    onTap: () => effectiveExpanded.value = true,
                  )
                else
                  Column(
                    children: sortedVersions.map((v) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SubtitleSyncPlaque(
                        version: v,
                        isSelected: v.fileName == selectedVersion.fileName,
                        theme: theme,
                        onTap: () {
                          notifier.selectVersion(v);
                          effectiveExpanded.value = false;
                        },
                      ),
                    )).toList(),
                  ),
              ],
            ),
          ),

          // 3. Technical Metrics List
          if (showTechDetails) ...[
            const SizedBox(height: 12),
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
    );
  }
}

