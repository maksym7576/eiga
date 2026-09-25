import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/backend/database/schemas/phrase.dart';
import 'player_view.dart';
import 'player_controls.dart';
import '../subtitles/fullscreen_subtitle.dart';
import '../popovers/word_details_popover.dart';

class AppPlayer extends HookConsumerWidget {
  final String scope;
  final String? videoPath;
  final List<Phrase>? phrases;
  final double? aspectRatio;
  final VoidCallback? onDoubleTap;

  /// false = у віконному режимі субтитрів поверх відео немає.
  /// У фулскріні вони показуються завжди.
  final bool showOverlaySubtitlesInWindowed;

  const AppPlayer({
    super.key,
    this.scope = 'main',
    this.videoPath,
    this.phrases,
    this.aspectRatio = 16 / 9,
    this.onDoubleTap,
    this.showOverlaySubtitlesInWindowed = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final isFullscreen = ref.watch(playerProvider(scope).select((s) => s.isFullscreen));
    final isInitialized = ref.watch(playerProvider(scope).select((s) => s.isInitialized));

    // Auto-init для preview scope або при зміні шляху
    useEffect(() {
      if (videoPath != null && scope == 'preview') {
        final playerState = ref.read(playerProvider(scope));
        if (playerState.videoId != 0 || !playerState.isInitialized) {
          Future.microtask(() {
            ref.read(playerProvider(scope).notifier).initController(0, videoPath!);
          });
        }
      }
      return null;
    }, [videoPath, scope]);

    // Вибір доріжок з upload state (тільки для preview)
    if (scope == 'preview') {
      final uploadState = ref.watch(uploadProvider);
      useEffect(() {
        if (isInitialized) {
          if (uploadState.selectedAudioTrack != null) {
            ref.read(playerProvider(scope).notifier).setAudioTrack(uploadState.selectedAudioTrack!.id);
          }
          // Вбудовані субтитри малює наш оверлей, нативні вимкнені
          ref.read(playerProvider(scope).notifier).setSubtitleTrack(null);
        }
        return null;
      }, [isInitialized, uploadState.selectedAudioTrack, uploadState.selectedOriginalSubtitle]);
    }

    final showSubtitles = isFullscreen || showOverlaySubtitlesInWindowed;

    Widget playerContent = MouseRegion(
      onHover: (_) {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          ref.read(playerProvider(scope).notifier).showControls(fromHover: true);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          PlayerView(playerScope: scope),
          Positioned.fill(
            child: _PlayerInteractionLayer(
              scope: scope,
              onDoubleTap: onDoubleTap ??
                      () => ref.read(playerProvider(scope).notifier).handleLockTap(orientation),
            ),
          ),
          if (showSubtitles)
            FullscreenSubtitle(
              playerScope: scope,
              customPhrases: phrases,
              forceShow: showOverlaySubtitlesInWindowed,
            ),
          Positioned.fill(
            child: RepaintBoundary(
              child: PlayerControls(playerScope: scope),
            ),
          ),
          WordDetailsPopover(playerScope: scope),
        ],
      ),
    );

    if (isFullscreen) {
      if (Platform.isAndroid || Platform.isIOS) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: playerContent,
        );
      }
      return Container(color: Colors.black, child: playerContent);
    }

    if (aspectRatio != null) {
      return AspectRatio(
        aspectRatio: aspectRatio!,
        child: Container(
          color: Colors.black,
          child: playerContent,
        ),
      );
    }

    return playerContent;
  }
}

/// Єдиний шар, що відповідає за тапи по відео.
class _PlayerInteractionLayer extends ConsumerWidget {
  final String scope;
  final VoidCallback onDoubleTap;

  const _PlayerInteractionLayer({
    required this.scope,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final state = ref.read(playerProvider(scope));
        if (state.isLocked) return;
        ref.read(playerProvider(scope).notifier).toggleControls();
        ref.read(playerProvider(scope).notifier).clearSelection();
      },
      onDoubleTap: onDoubleTap,
      behavior: HitTestBehavior.translucent,
      child: const SizedBox.expand(),
    );
  }
}