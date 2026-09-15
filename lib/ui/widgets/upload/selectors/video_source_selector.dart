import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import '../../shared/base_expandable_selector.dart';

class VideoSourceSelector extends ConsumerWidget {
  const VideoSourceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isVideoSourceSelectorExpandedProvider);
    final selected = ref.watch(uploadProvider.select((s) => s.videoSource));

    return BaseExpandableSelector<VideoSource>(
      title: 'Video Source:',
      isExpanded: isExpanded,
      selectedValue: selected,
      options: const [VideoSource.file],
      getTitle: (type) {
        switch (type) {
          case VideoSource.file: return 'Local File';
        }
      },
      getSubtitle: (type) {
        switch (type) {
          case VideoSource.file: return '';
        }
      },
      getIcon: (type) {
        switch (type) {
          case VideoSource.file: return Icons.file_present_rounded;
        }
      },
      onExpandedChanged: (expanded) {
        ref.read(isVideoSourceSelectorExpandedProvider.notifier).state = expanded;
      },
      onSelected: (type) {
        ref.read(uploadProvider.notifier).setVideoSource(type);
      },
    );
  }
}
