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

class VideoScreen extends HookConsumerWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(currentVideoProvider);
    final isFullscreen = ref.watch(playerProvider.select((s) => s.isFullscreen));

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
          body: videoAsync.when(
            data: (video) {
              if (video == null) {
                return const Center(
                  child: Text('No video selected', style: TextStyle(color: Colors.black)),
                );
              }

              final playerContent = Stack(
                children: [
                  // The Player
                  const VideoPlayerWidget(),
                  
                  // Interaction Layer (handles its own lock logic internally)
                  const Positioned.fill(
                    child: VideoPlayerControls(),
                  ),
                ],
              );

              if (isFullscreen) {
                return playerContent;
              }

              return Stack(
                children: [
                  Column(
                    children: [
                      // Header
                      const VideoScreenHeader(),

                      // Resizable Player Area
                      ResizablePlayerContainer(
                        child: playerContent,
                      ),

                      // Content Area
                      const Expanded(
                        child: PhraseListWidget(),
                      ),
                    ],
                  ),

                  // Bottom Dock
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: VideoBottomDock(),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
          ),
        );
      },
    );
  }
}
