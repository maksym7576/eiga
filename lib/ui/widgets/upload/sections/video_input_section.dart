import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import '../components/upload_drop_box.dart';

class VideoInputSection extends ConsumerWidget {
  const VideoInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);

    final isFile = state.videoSource == VideoSource.file;

    return UploadDropBox(
      onTap: isFile ? notifier.pickVideo : () {},
      title: 'Upload Video File',
      subtitle: 'Tap to add the video',
      filePath: state.videoPath,
      icon: Icons.movie_outlined,
    );
  }
}
