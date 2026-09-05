import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/ui/player_provider.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../styles/app_colors.dart';

class VideoPlayerControls extends HookConsumerWidget {
  const VideoPlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final isLocked = playerState.isLocked;
    final isPlaying = ref.watch(isPlayingProvider);
    final areVisible = playerState.areControlsVisible;
    
    return Stack(
      children: [
        // 1. Base Interaction Layer (Toggles UI visibility)
        Positioned.fill(
          child: GestureDetector(
            onTap: () => ref.read(playerProvider.notifier).toggleControls(),
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
        ),

        // 2. Persistent Center Button (Only when controls are visible)
        if (!isLocked)
          Center(
            child: AnimatedOpacity(
              opacity: areVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !areVisible,
                child: GestureDetector(
                  onTap: () {
                    ref.read(playerProvider.notifier).togglePlaying();
                    ref.read(playerProvider.notifier).resetHideTimer();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

        // 4. Bottom Controls
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          bottom: areVisible && !isLocked ? 0 : -100,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: areVisible && !isLocked ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: const _BottomBar(),
          ),
        ),
        
        // 5. Top Overlay (Lock button)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          top: areVisible ? 12 : -60,
          right: 12,
          child: AnimatedOpacity(
            opacity: areVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: const _TopOverlay(),
          ),
        ),
      ],
    );
  }
}

class _TopOverlay extends ConsumerWidget {
  const _TopOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = ref.watch(playerProvider.select((s) => s.isLocked));

    return GestureDetector(
      onTap: () {
        ref.read(playerProvider.notifier).toggleLock(MediaQuery.of(context).orientation);
        ref.read(playerProvider.notifier).resetHideTimer();
      },
      child: Container(
        padding: const EdgeInsets.all(10), // Reduced size
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
        ),
        child: Icon(
          isLocked ? Icons.lock : Icons.lock_open,
          color: Colors.white,
          size: 16, // Smaller icon
        ),
      ),
    );
  }
}

class _FrostedPill extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _FrostedPill({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(playerProvider.select((s) => s.duration));
    final position = ref.watch(playerTimeProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4), // Further reduced padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProgressBar(
            position: position,
            duration: duration,
            onSeek: (val) {
              ref.read(playerProvider.notifier).seekTo(val);
              ref.read(playerProvider.notifier).resetHideTimer();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _FrostedPill(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Increased from 8, 2
                child: Text(
                  '${_formatDuration(position)} / ${_formatDuration(duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11, // Increased from 10
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Row(
                children: [
                  _FrostedPill(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Increased from 8, 2
                    child: Text(
                      '1.0x',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8), // Increased from 6
                  _FrostedPill(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Increased from 6, 2
                    child: GestureDetector(
                      onTap: () {
                        ref.read(playerProvider.notifier).toggleFullscreen();
                        ref.read(playerProvider.notifier).resetHideTimer();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Icon(Icons.fullscreen, color: Colors.white, size: 20), // Increased from 18
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

class _ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  const _ProgressBar({
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final double value = duration.inMilliseconds > 0 
        ? position.inMilliseconds / duration.inMilliseconds 
        : 0.0;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2, // Thinner track
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4, elevation: 2), // Smaller thumb
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
        activeTrackColor: AppColors.brandBlue,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
        thumbColor: Colors.white,
        trackShape: const RectangularSliderTrackShape(),
      ),
      child: Container(
        height: 20, // Much smaller vertical footprint
        alignment: Alignment.center,
        child: Slider(
          value: value.clamp(0.0, 1.0),
          onChanged: (val) {
            final newPos = Duration(milliseconds: (val * duration.inMilliseconds).toInt());
            onSeek(newPos);
          },
        ),
      ),
    );
  }
}
