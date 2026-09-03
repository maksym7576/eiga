import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../buttons/equal_toggle_buttons.dart';

class VideoSourceSelector extends ConsumerWidget {
  const VideoSourceSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoSource = ref.watch(uploadProvider.select((s) => s.videoSource));

    return EqualToggleButtons<VideoSource>(
      items: VideoSource.values,
      activeItem: videoSource,
      onChanged: (val) => ref.read(uploadProvider.notifier).setVideoSource(val),
      labelBuilder: (val) {
        switch (val) {
          case VideoSource.url: return 'URL';
          case VideoSource.youtube: return 'YouTube';
          case VideoSource.file: return 'File';
        }
      },
      iconBuilder: (val) {
        switch (val) {
          case VideoSource.url: return Icons.link;
          case VideoSource.youtube: return Icons.play_circle_outline;
          case VideoSource.file: return Icons.file_present;
        }
      },
    );
  }
}
