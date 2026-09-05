import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/player_provider.dart';
import '../../styles/app_colors.dart';

class VideoScreenHeader extends ConsumerWidget implements PreferredSizeWidget {
  const VideoScreenHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final video = ref.watch(currentVideoProvider).value;
    final areVisible = ref.watch(playerProvider.select((s) => s.areControlsVisible));

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 52 + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            border: const Border(
              bottom: BorderSide(color: AppColors.slate100, width: 0.9),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 20, color: AppColors.slate600),
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video?.videoName ?? '...',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slate900,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (video?.episode != null)
                        Text(
                          'Episode ${video!.episode}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate400,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.help_outline, size: 20, color: AppColors.slate500),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
