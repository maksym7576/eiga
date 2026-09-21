import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/ui/styles/app_colors.dart';
import '../components/upload_drop_box.dart';
import '../components/video_track_selector.dart';
import '../../player/app_player.dart';

class VideoInputSection extends ConsumerWidget {
  const VideoInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uploadProvider);
    final notifier = ref.read(uploadProvider.notifier);

    if (state.videoPath != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPlayer(
            scope: 'preview',
            videoPath: state.videoPath!,
            phrases: state.previewPhrases,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.fileName ?? 'Unknown Video',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (state.resolution != null) _infoTag(state.resolution!),
                        if (state.fileSize != null) _infoTag(state.fileSize!),
                        if (state.codec != null) _infoTag(state.codec!),
                        if (state.audioTracks.isNotEmpty)
                          _infoTag('${state.audioTracks.length} audio tracks', color: AppColors.brandBlue50, textColor: AppColors.brandBlue),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const VideoTrackSelector(),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: notifier.pickVideo,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Replace File'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: AppColors.slate200),
              foregroundColor: AppColors.slate700,
            ),
          ),
          if (state.isParsing) ...[
            const SizedBox(height: 24),
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(strokeWidth: 3),
                  const SizedBox(height: 12),
                  const Text(
                    'Extracting video information...',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    final isFile = state.videoSource == VideoSource.file;

    return UploadDropBox(
      onTap: isFile ? notifier.pickVideo : () {},
      title: 'Upload Video File',
      subtitle: 'Tap to add the video',
      filePath: state.videoPath,
      icon: Icons.movie_outlined,
    );
  }

  Widget _infoTag(String text, {Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.slate100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.slate200.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.slate600,
        ),
      ),
    );
  }
}
