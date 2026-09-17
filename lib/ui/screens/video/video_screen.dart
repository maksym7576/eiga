import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eiga/ui/utils/responsive_helper.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/services/translation_provider.dart';
import 'package:eiga/ui/widgets/shared/loading_splash.dart';

import 'mobile/video_mobile_view.dart';
import 'desktop/video_desktop_view.dart';

class VideoScreen extends HookConsumerWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Warm up the translation service, prefetcher, and phrase streams during loading
    ref.watch(translationProvider);
    ref.watch(phraseDataPrefetcherProvider);
    ref.watch(phrasesStreamProvider);

    final videoAsync = ref.watch(currentVideoProvider);
    final isFullscreen = ref.watch(playerProvider.select((s) => s.isFullscreen));
    final isInitialized = ref.watch(playerProvider.select((s) => s.isInitialized));

    useEffect(() {
      final playerNotifier = ref.read(playerProvider.notifier);
      final playerIdSetter = ref.read(playerIdProvider.notifier);

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

      if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }

      WakelockPlus.enable();

      return () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
        if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }

        WakelockPlus.disable();

        Future.microtask(() {
          playerNotifier.showControls();
          playerNotifier.setPlaying(false);
          playerNotifier.clearSelection();
          playerNotifier.updatePosition(Duration.zero);
          playerNotifier.disposeController();
          playerIdSetter.state = null;
        });
      };
    }, []);

    // Explicitly initialize player controller when video data arrives
    useEffect(() {
      videoAsync.whenData((video) {
        if (video != null) {
          final playerState = ref.read(playerProvider);
          if (playerState.videoId != video.id || !playerState.isInitialized) {
            Future.microtask(() {
              ref.read(playerProvider.notifier).initController(video.id, video.videoPath!);
            });
          }
        }
      });
      return null;
    }, [videoAsync.value]);

    final orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;

    final isLocked = ref.watch(playerProvider.select((s) => s.isLocked));

    // Auto-fullscreen logic: triggers ONLY on physical orientation changes.
    final prevOrientationRef = useRef<Orientation?>(null);

    useEffect(() {
      if (Platform.isAndroid || Platform.isIOS) {
        if (!isLocked) {
          final currentOrientation = orientation;
          final prevOrientation = prevOrientationRef.value;
          
          // Only trigger if orientation has actually changed
          if (prevOrientation != null && prevOrientation != currentOrientation) {
             Future.microtask(() {
              if (context.mounted && !ref.read(playerProvider).isLocked) {
                ref.read(playerProvider.notifier).setFullscreen(isLandscape, updateSystem: true);
              }
            });
          }
          prevOrientationRef.value = currentOrientation;
        }
      }
      return null;
    }, [isLandscape, isLocked]);

    // Ensure screen stays on during video playback and mode changes
    useEffect(() {
      WakelockPlus.enable();
      return null;
    }, [isFullscreen, isLocked]);

    return Focus(
      autofocus: true,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.escape): () {
            final playerState = ref.read(playerProvider);
            if (playerState.isFullscreen) {
              ref.read(playerProvider.notifier).setFullscreen(false);
            }
            // Clear any selections/popovers
            ref.read(playerProvider.notifier).clearSelection();
          },
          const SingleActivator(LogicalKeyboardKey.keyF): () {
            ref.read(playerProvider.notifier).toggleFullscreen();
          },
        },
        child: Scaffold(
          backgroundColor: isFullscreen ? Colors.black : const Color(0xFFF8FAFC),
          body: videoAsync.when(
            data: (video) {
              if (video == null || !isInitialized) {
                return const LoadingSplash(key: ValueKey('splash'));
              }

              if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
                return const VideoDesktopView();
              } else {
                return const VideoMobileView();
              }
            },
            loading: () => const LoadingSplash(key: ValueKey('splash')),
            error: (err, stack) => Center(
              key: const ValueKey('error'),
              child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
            ),
          ),
        ),
      ),
    );
  }
}