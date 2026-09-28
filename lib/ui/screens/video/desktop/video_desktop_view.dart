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
    const String scope = 'main';
    final isInitialized = ref.watch(playerProvider(scope).select((state) => state.isInitialized));
    final isFullscreen = ref.watch(playerProvider(scope).select((state) => state.isFullscreen));
    final areControlsVisible = ref.watch(playerProvider(scope).select((state) => state.areControlsVisible));

    final video = ref.watch(currentVideoProvider).value;
    final bool isReady = isInitialized && video != null;

    if (!isReady) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.white70),
              const SizedBox(height: 16),
              Text(
                'Loading video & initializing player...',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    // --- Unified Player Layer ---
    // Стабільна глибина дерева, щоб не ламався MouseTracker
    // і не перемонтовувався GlobalKey відеотекстури.
    final playerContent = MouseRegion(
      key: const ValueKey('player_content_region'),
      onHover: (_) {
        ref.read(playerProvider(scope).notifier).showControls(fromHover: true);
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            const PlayerView(playerScope: scope),
            const Positioned.fill(child: _VideoPlayerBackgroundLayer(playerScope: scope)),
            // Субтитри поверх відео тільки у фулскріні
            if (isFullscreen)
              const FullscreenSubtitle(
                playerScope: scope,
                forceShow: true,
              ),
            const Positioned.fill(child: PlayerControls(playerScope: scope)),
          ],
        ),
      ),
    );

    // Список субтитрів + плаваюча панель (прогрес / Tracking / налаштування)
    final sidebarContent = Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: PlayerPhraseList(playerScope: scope)),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PlayerBottomDock(playerScope: scope),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Main Layout (Video + Sidebar)
          Column(
            children: [
              Visibility(
                visible: !isFullscreen,
                maintainState: true,
                child: AppBlurHeader(
                  title: video?.seriesName ?? video?.fileName ?? '...',
                  subtitle: video?.episode != null ? 'Episode ${video!.episode}' : null,
                  onBack: () => context.pop(),
                ),
              ),
              Expanded(
                child: ResizableSidebarContainer(
                  isSidebarHidden: isFullscreen,
                  mainChild: playerContent,
                  sidebarChild: sidebarContent,
                ),
              ),
            ],
          ),

          // 2. Overlays
          if (!isFullscreen || areControlsVisible)
            const WordDetailsPopover(playerScope: scope),
        ],
      ),
    );
  }
}

class _VideoPlayerBackgroundLayer extends ConsumerWidget {
  final String playerScope;
  const _VideoPlayerBackgroundLayer({required this.playerScope});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final playerState = ref.read(playerProvider(playerScope));
        if (playerState.isLocked) return;
        if (!playerState.areControlsVisible) {
          ref.read(playerProvider(playerScope).notifier).showControls();
        } else {
          ref.read(playerProvider(playerScope).notifier).togglePlaying();
          ref.read(playerProvider(playerScope).notifier).clearSelection();
          ref.read(playerProvider(playerScope).notifier).resetHideTimer();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: const SizedBox.expand(),
    );
  }
}