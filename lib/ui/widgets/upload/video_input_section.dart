import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../providers/ui/upload_provider.dart';
import '../shared/upload_drop_box.dart';

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
      subtitle: 'MP4, MKV, AVI (Max 2GB)',
      filePath: state.videoPath,
      icon: state.videoSource == VideoSource.file 
          ? Icons.movie_outlined 
          : state.videoSource == VideoSource.url 
              ? Icons.link 
              : Icons.search,
    );
  }
}
