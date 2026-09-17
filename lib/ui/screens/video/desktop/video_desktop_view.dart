import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eiga/ui/widgets/player/player_view.dart';
import 'package:eiga/ui/widgets/player/player_controls.dart';
import 'package:eiga/ui/widgets/app_bar/app_blur_header.dart';
import 'package:eiga/ui/widgets/player/player_phrase_list.dart';
import 'package:eiga/ui/widgets/player/player_bottom_dock.dart';
import 'package:eiga/ui/widgets/subtitles/fullscreen_subtitle.dart';
import 'package:eiga/ui/widgets/popovers/word_details_popover.dart';
import 'package:eiga/ui/widgets/player/resizable_sidebar_container.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';

class VideoDesktopView extends ConsumerWidget {
  const VideoDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final isFullscreen = playerState.isFullscreen;
    final areControlsVisible = playerState.areControlsVisible;

    final video = ref.watch(currentVideoProvider).value;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isFullscreen)
          MouseRegion(
            onHover: (_) {
              ref.read(playerProvider.notifier).showControls(fromHover: true);
            },
            child: Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              child: const Stack(
                children: [
                  PlayerView(),
                  Positioned.fill(child: _VideoPlayerBackgroundLayer()),
                  Positioned.fill(child: PlayerControls()),
                  FullscreenSubtitle(),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              AppBlurHeader(
                title: video?.seriesName ?? video?.fileName ?? '...',
                subtitle: video?.episode != null ? 'Episode ${video!.episode}' : null,
                onBack: () {
                  context.pop();
                },
              ),
              Expanded(
                child: ResizableSidebarContainer(
                  mainChild: MouseRegion(
                    onHover: (_) {
                      ref.read(playerProvider.notifier).showControls(fromHover: true);
                    },
                    child: Container(
                      color: Colors.black,
                      child: const Stack(
                        children: [
                          PlayerView(),
                          Positioned.fill(child: _VideoPlayerBackgroundLayer()),
                          Positioned.fill(child: PlayerControls()),
                          FullscreenSubtitle(),
                        ],
                      ),
                    ),
                  ),
                  sidebarChild: Container(
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
                      color: Colors.white,
                    ),
                    child: const PlayerPhraseList(),
                  ),
                ),
              ),
            ],
          ),
        if (!isFullscreen)
          const Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 450,
              child: PlayerBottomDock(),
            ),
          ),
        // Popover only shown when controls are visible in fullscreen, or always in windowed
        if (!isFullscreen || areControlsVisible)
          const WordDetailsPopover(),
      ],
    );
  }
}

class _VideoPlayerBackgroundLayer extends ConsumerWidget {
  const _VideoPlayerBackgroundLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final playerState = ref.read(playerProvider);
        if (playerState.isLocked) return;
        if (!playerState.areControlsVisible) {
          ref.read(playerProvider.notifier).showControls();
        } else {
          ref.read(playerProvider.notifier).togglePlaying();
          ref.read(playerProvider.notifier).clearSelection();
          ref.read(playerProvider.notifier).resetHideTimer();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: const SizedBox.expand(),
    );
  }
}
