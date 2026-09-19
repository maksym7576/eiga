import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import '../../styles/app_colors.dart';
import 'subtitle_settings_side_panel.dart';

class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final isLocked = playerState.isLocked;
    final isPlaying = ref.watch(isPlayingProvider);
    final areVisible = playerState.areControlsVisible;
    final isFullscreen = playerState.isFullscreen;

    return Stack(
      children: [
        // 1. Persistent Center Button
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
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.all(isFullscreen ? 28 : 20),
                    child: Container(
                      padding: EdgeInsets.all(isFullscreen ? 18 : 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: isFullscreen ? 32 : 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // 3. Bottom Controls
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
        
        // 4. Top Overlay (always clickable when locked or locking or visible so the lock button works!)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          top: (areVisible || playerState.isLocking || isLocked) ? 12 : -60,
          right: 12,
          child: AnimatedOpacity(
            opacity: (areVisible || playerState.isLocking || isLocked) ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: (!areVisible && !playerState.isLocking && !isLocked),
              child: const _TopOverlay(),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopOverlay extends HookConsumerWidget {
  const _TopOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = ref.watch(playerProvider.select((s) => s.isLocked));
    final isLocking = ref.watch(playerProvider.select((s) => s.isLocking));
    final isFullscreen = ref.watch(playerProvider.select((s) => s.isFullscreen));

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    useEffect(() {
      if (isLocking) {
        animationController.repeat(reverse: true);
      } else {
        animationController.stop();
        animationController.reset();
      }
      return null;
    }, [isLocking]);

    final shakeX = useAnimation(
      Tween<double>(begin: -3.0, end: 3.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: Offset(isLocking ? shakeX : 0.0, 0.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref.read(playerProvider.notifier).handleLockTap(MediaQuery.of(context).orientation);
                ref.read(playerProvider.notifier).resetHideTimer();
              },
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
                ),
                child: Icon(
                  isLocked ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        if (isFullscreen && !isLocked) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              SubtitleSettingsSidePanel.show(context);
              ref.read(playerProvider.notifier).resetHideTimer();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
              ),
              child: const Icon(
                Icons.subtitles_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FrostedPill extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const _FrostedPill({required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 0.8),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }
    return content;
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(playerProvider.select((s) => s.duration));
    final position = ref.watch(playerTimeProvider);
    final playbackRate = ref.watch(playerProvider.select((s) => s.playbackRate));

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.85),
            Colors.black.withValues(alpha: 0.4),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
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
          const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _FrostedPill(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Text(
                  '${_formatDuration(position)} / ${_formatDuration(duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Row(
                children: [
                  _FrostedPill(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    onTap: () {
                      final rates = [1.0, 0.85, 0.75];
                      final currentIndex = rates.indexOf(playbackRate);
                      final nextIndex = (currentIndex + 1) % rates.length;
                      ref.read(playerProvider.notifier).setPlaybackRate(rates[nextIndex]);
                      ref.read(playerProvider.notifier).resetHideTimer();
                    },
                    child: Text(
                      '${playbackRate.toStringAsFixed(2)}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _FrostedPill(
                    padding: const EdgeInsets.all(8),
                    onTap: () {
                      ref.read(playerProvider.notifier).toggleFullscreen();
                      ref.read(playerProvider.notifier).resetHideTimer();
                    },
                    child: Icon(
                      ref.watch(playerProvider.select((s) => s.isFullscreen))
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
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

    return RepaintBoundary(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4, // Thicker track
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7, elevation: 4),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          activeTrackColor: AppColors.brandBlue,
          inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
          thumbColor: Colors.white,
          trackShape: const RectangularSliderTrackShape(),
        ),
        child: Container(
          height: 24,
          alignment: Alignment.center,
          child: Slider(
            value: value.clamp(0.0, 1.0),
            onChanged: (val) {
              final newPos = Duration(milliseconds: (val * duration.inMilliseconds).toInt());
              onSeek(newPos);
            },
          ),
        ),
      ),
    );
  }
}
