import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import '../../shared/base_expandable_selector.dart';

class SubtitleMethodSelector extends ConsumerWidget {
  const SubtitleMethodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final selected = state.subtitleMethod;
    
    // We can use a separate bool for expansion or reuse one from search_provider if we add it
    // For now let's just use a local state or add to search_provider
    final isExpanded = ref.watch(isSubtitleMethodSelectorExpandedProvider);
    
    final bool hasVideoTrack = state.selectedOriginalSubtitle != null;
    final options = SubtitleMethod.values.where((m) {
      if (m == SubtitleMethod.video && !hasVideoTrack) return false;
      return true;
    }).toList();

    return BaseExpandableSelector<SubtitleMethod>(
      title: 'Loading Method:',
      isExpanded: isExpanded,
      selectedValue: selected,
      options: options,
      getTitle: (type) {
        switch (type) {
          case SubtitleMethod.quick: return 'Quick Pick';
          case SubtitleMethod.ai_scan: return 'AI Scan';
          case SubtitleMethod.manual: return 'Manual Override';
          case SubtitleMethod.video: return 'Video Track';
        }
      },
      getSubtitle: (type) {
        switch (type) {
          case SubtitleMethod.quick: return 'Algorithm-based auto selection';
          case SubtitleMethod.ai_scan: return 'Advanced AI matching (Full Base)';
          case SubtitleMethod.manual: return 'Pick file or use video track';
          case SubtitleMethod.video: return 'Embedded in the video file';
        }
      },
      getIcon: (type) {
        switch (type) {
          case SubtitleMethod.quick: return Icons.bolt_rounded;
          case SubtitleMethod.ai_scan: return Icons.auto_awesome_rounded;
          case SubtitleMethod.manual: return Icons.edit_note_rounded;
          case SubtitleMethod.video: return Icons.movie_filter_rounded;
        }
      },
      onExpandedChanged: (expanded) {
        ref.read(isSubtitleMethodSelectorExpandedProvider.notifier).state = expanded;
      },
      onSelected: (type) {
        ref.read(uploadProvider.notifier).setSubtitleMethod(type);
      },
    );
  }
}
