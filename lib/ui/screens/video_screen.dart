import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../providers/ui/player_provider.dart';
import '../../providers/ui/video_data_providers.dart';
import '../widgets/video/video_player_widget.dart';
import '../widgets/video/video_player_controls.dart';
import '../widgets/video/video_screen_header.dart';
import '../widgets/video/resizable_player_container.dart';
import '../widgets/video/phrase_list_widget.dart';
import '../widgets/video/video_bottom_dock.dart';
import '../widgets/video/subtitle_overlay.dart';
import '../widgets/video/word_popover.dart';
import '../widgets/shared/loading_splash.dart';
import '../../providers/services/translation_provider.dart';

class VideoScreen extends HookConsumerWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Warm up the translation service
    ref.watch(translationProvider);
    
    final videoAsync = ref.watch(currentVideoProvider);
    final isFullscreen = ref.watch(playerProvider.select((s) => s.isFullscreen));
    final isInitialized = ref.watch(playerProvider.select((s) => s.isInitialized));

    useEffect(() {
      // Allow all orientations when entering the screen
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      
      // Prevent screen from sleeping
      WakelockPlus.enable();

      return () {
        // Restore system UI when leaving the screen
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        
        // Allow screen to sleep again
        WakelockPlus.disable();

        // Clean up providers and dispose player
        ref.read(playerIdProvider.notifier).state = null;
        ref.read(selectedBlockIdProvider.notifier).state = null;
        ref.read(clickedWordIdProvider.notifier).state = null;
        ref.read(clickedWordPositionProvider.notifier).state = null;
        ref.read(playerTimeProvider.notifier).state = Duration.zero;
      };
    }, []);

    return OrientationBuilder(
      builder: (context, orientation) {
        // Sync physical orientation with provider (without forcing system rotation)
        final bool physicalFullscreen = orientation == Orientation.landscape;
        
        // Use Future.microtask to avoid state update during build
        if (physicalFullscreen != isFullscreen) {
          Future.microtask(() {
            ref.read(playerProvider.notifier).setFullscreen(physicalFullscreen, updateSystem: false);
          });
        }

        return Scaffold(
          backgroundColor: isFullscreen ? Colors.black : const Color(0xFFF8FAFC),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: videoAsync.when(
              data: (video) {
                if (video == null || !isInitialized) {
                  return const LoadingSplash(key: ValueKey('splash'));
                }

                return Stack(
                  key: const ValueKey('content'),
                  children: [
                    if (isFullscreen) ...[
                      Stack(
                        children: [
                          Stack(
                            children: [
                              const VideoPlayerWidget(),
                              const Positioned.fill(child: SubtitleOverlay()),
                              const Positioned.fill(child: VideoPlayerControls()),
                            ],
                          ),
                          const WordPopover(),
                        ],
                      ),
                    ] else ...[
                      Column(
                        children: [
                          const VideoScreenHeader(),
                          ResizablePlayerContainer(
                            child: Stack(
                              children: [
                                const VideoPlayerWidget(),
                                const Positioned.fill(child: SubtitleOverlay()),
                                const Positioned.fill(child: VideoPlayerControls()),
                              ],
                            ),
                          ),
                          const Expanded(child: PhraseListWidget()),
                        ],
                      ),
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: VideoBottomDock(),
                      ),
                      const WordPopover(),
                    ],
                  ],
                );
              },
              loading: () => const LoadingSplash(key: ValueKey('splash')),
              error: (err, stack) => Center(
                key: const ValueKey('error'),
                child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
              ),
            ),
          ),
        );
      },
    );
  }
}
