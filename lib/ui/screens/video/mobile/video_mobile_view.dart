import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:eiga/ui/widgets/player/player_view.dart';
import 'package:eiga/ui/widgets/player/player_controls.dart';
import 'package:eiga/ui/widgets/app_bar/app_blur_header.dart';
import 'package:eiga/ui/widgets/player/player_phrase_list.dart';
import 'package:eiga/ui/widgets/player/player_bottom_dock.dart';
import 'package:eiga/ui/widgets/subtitles/fullscreen_subtitle.dart';
import 'package:eiga/ui/widgets/popovers/word_details_popover.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';

// --- Snappy motion constants for instant response ---
const _kExpandDuration = Duration(milliseconds: 200);
const _kCollapseDuration = Duration(milliseconds: 180);
const _kExpandCurve = Curves.easeOutCubic;
const _kCollapseCurve = Curves.easeInCubic;
const _kChromeFadeDuration = Duration(milliseconds: 120);

/// Video/player screen for mobile.
///
/// DESIGN NOTE — why this is one flat Stack instead of Column/Expanded:
///
/// Every region (header, video, phrase list, bottom dock) is positioned
/// with explicit numbers derived straight from state (`isFullscreen`,
/// `resizableHeight`, screen size). None of them ask a sibling "how big
/// are you" the way Column/Expanded do. That means:
///
///   - A transient/incorrect number during a mid-rotation frame just draws
///     something in the wrong place for one frame — it can never throw a
///     RenderFlex overflow, because Positioned children don't participate
///     in flex layout at all.
///   - The persistent video widget (which owns the actual video controller
///     state via a GlobalKey) always stays the direct child of the *same*
///     Positioned in the *same* Stack — its depth/ancestry in the tree
///     never changes, only its coordinates animate. This is what keeps the
///     GlobalKey element stable across rotation instead of risking the
///     "_elements.contains(element)" framework assertion that flat
///     structural changes (e.g. swapping which parent wraps it) can cause.
class VideoMobileView extends HookConsumerWidget {
  const VideoMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final isFullscreen = playerState.isFullscreen;
    final orientation = MediaQuery.of(context).orientation;
    final video = ref.watch(currentVideoProvider).value;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    const double headerBaseHeight = 52;
    final double headerTotalHeight = headerBaseHeight + topPadding;

    final minHeight = orientation == Orientation.portrait ? screenWidth * 0.4 : screenHeight * 0.4;
    final maxHeight = orientation == Orientation.portrait ? screenHeight * 0.7 : screenHeight * 0.9;
    final double resizableHeight = (playerState.resizableHeight ?? (screenWidth * 9 / 16)).clamp(minHeight, maxHeight);

    final lastOrientationRef = useRef<Orientation?>(null);
    final isReturningToPortrait = lastOrientationRef.value == Orientation.landscape && orientation == Orientation.portrait;
    lastOrientationRef.value = orientation;

    // Instant snap (Duration.zero) when returning to portrait to eliminate squishing/twitches
    final containerDuration = isReturningToPortrait ? Duration.zero : (isFullscreen ? _kExpandDuration : _kCollapseDuration);
    final containerCurve = Curves.easeInOutCubic;

    // Every region's geometry, computed once from state — nobody reads
    // anybody else's rendered size.
    final double headerHeight = isFullscreen ? 0 : headerTotalHeight;
    final double videoTop = headerHeight;
    final double videoHeight = isFullscreen ? screenHeight : resizableHeight;
    final double listTop = isFullscreen ? screenHeight : headerTotalHeight + resizableHeight;

    // Persistent video content. Only PlayerView itself carries the
    // GlobalKey — everything else around it (background tap layer,
    // controls, subtitle overlay) is free to rebuild normally.
    final videoContent = Stack(
      clipBehavior: Clip.none,
      children: [
        const KeyedSubtree(
          key: GlobalObjectKey('mobile_player_view'),
          child: PlayerView(),
        ),
        const Positioned.fill(child: _VideoPlayerBackgroundLayer()),
        const Positioned.fill(child: PlayerControls()),
        const FullscreenSubtitle(),
      ],
    );

    return Scaffold(
      backgroundColor: isFullscreen ? Colors.black : const Color(0xFFF8FAFC),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {
          ref.read(playerProvider.notifier).handleLockTap(orientation);
        },
        child: Stack(
          // CRITICAL: with the old Column-based layout, the Column's
          // Expanded child incidentally forced the Stack to full screen
          // size. Now that every region is a Positioned/AnimatedPositioned,
          // the only non-positioned child left is WordDetailsPopover — and
          // Stack sizes itself to its non-positioned children's natural
          // size when there is one. WordDetailsPopover has ~zero natural
          // size when nothing is selected, which collapsed the whole Stack
          // (and everything positioned inside it) down to nothing, showing
          // just the Scaffold's white background. StackFit.expand forces
          // the Stack to always fill the available screen size regardless.
          fit: StackFit.expand,
          children: [
            // --- Video (always mounted, only coordinates animate) ---
            AnimatedPositioned(
              duration: containerDuration,
              curve: containerCurve,
              top: videoTop,
              left: 0,
              right: 0,
              height: videoHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (isFullscreen && orientation == Orientation.portrait) {
                    if (!playerState.isLocked) {
                      ref.read(playerProvider.notifier).setFullscreen(false);
                    } else {
                      ref.read(playerProvider.notifier).resetLockAndFullscreen();
                    }
                  }
                },
                child: videoContent,
              ),
            ),

            // --- Header (hidden in fullscreen) ---
            AnimatedPositioned(
              duration: containerDuration,
              curve: containerCurve,
              top: 0,
              left: 0,
              right: 0,
              height: headerHeight,
              child: ClipRect(
                child: OverflowBox(
                  minHeight: 0,
                  maxHeight: headerTotalHeight,
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    duration: _kChromeFadeDuration,
                    curve: Curves.easeOut,
                    opacity: isFullscreen ? 0.0 : 1.0,
                    child: AppBlurHeader(
                      title: video?.seriesName ?? video?.fileName ?? '...',
                      subtitle: video?.episode != null ? 'Episode ${video!.episode}' : null,
                      onBack: () => context.pop(),
                    ),
                  ),
                ),
              ),
            ),

            // --- Phrase list + drag handle (hidden in fullscreen) ---
            // top/bottom come straight from the Stack's own (always-valid)
            // size, so this region's height can never be negative or NaN
            // the way a hand-tracked Container height could be mid-rotation.
            AnimatedPositioned(
              duration: containerDuration,
              curve: containerCurve,
              top: listTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                duration: _kChromeFadeDuration,
                curve: Curves.easeOut,
                opacity: isFullscreen ? 0.0 : 1.0,
                child: IgnorePointer(
                  ignoring: isFullscreen,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxHeight < 24) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          PlayerResizableContainerHandle(
                            currentHeight: resizableHeight,
                            minHeight: minHeight,
                            maxHeight: maxHeight,
                          ),
                          const Expanded(child: PlayerPhraseList()),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // --- Bottom dock (hidden in fullscreen) ---
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                duration: _kChromeFadeDuration,
                curve: Curves.easeOut,
                offset: isFullscreen ? const Offset(0, 1) : Offset.zero,
                child: AnimatedOpacity(
                  duration: _kChromeFadeDuration,
                  curve: Curves.easeOut,
                  opacity: isFullscreen ? 0.0 : 1.0,
                  child: IgnorePointer(
                    ignoring: isFullscreen,
                    child: const PlayerBottomDock(),
                  ),
                ),
              ),
            ),

            const WordDetailsPopover(),

            // --- Silent Offscreen Prerender Cache ---
            // Pre-warm fullscreen subtitle and overlay render trees invisibly
            // so the first fullscreen transition has zero rasterization latency.
            const Offstage(
              offstage: true,
              child: FullscreenSubtitle(),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerResizableContainerHandle extends ConsumerWidget {
  final double currentHeight;
  final double minHeight;
  final double maxHeight;

  const PlayerResizableContainerHandle({
    super.key,
    required this.currentHeight,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        final newHeight = (currentHeight + details.delta.dy).clamp(minHeight, maxHeight);
        ref.read(playerProvider.notifier).updateResizableHeight(newHeight);
      },
      child: const PlayerDragIndicator(),
    );
  }
}

class PlayerDragIndicator extends StatelessWidget {
  const PlayerDragIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 12, child: Icon(Icons.expand_less, size: 15, color: Color(0xFF94A3B8))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: const Color(0xFFE2E8F0).withValues(alpha: 0.6)),
            ),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(width: 12, child: Icon(Icons.expand_more, size: 15, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

class _VideoPlayerBackgroundLayer extends ConsumerWidget {
  const _VideoPlayerBackgroundLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;

    return GestureDetector(
      onTap: () {
        final playerState = ref.read(playerProvider);
        if (playerState.isLocked) return;
        ref.read(playerProvider.notifier).toggleControls();
        ref.read(playerProvider.notifier).clearSelection();
      },
      onDoubleTap: () {
        ref.read(playerProvider.notifier).handleLockTap(orientation);
      },
      behavior: HitTestBehavior.opaque,
      child: const SizedBox.expand(),
    );
  }
}