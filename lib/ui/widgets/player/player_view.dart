import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/ui/player_provider.dart';

class PlayerView extends HookConsumerWidget {
  final String playerScope;
  const PlayerView({super.key, this.playerScope = 'main'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(playerProvider(playerScope).select((s) => s.controller));
    final player = ref.watch(playerProvider(playerScope).select((s) => s.player));
    final isInitialized = ref.watch(playerProvider(playerScope).select((s) => s.isInitialized));

    if (controller == null || player == null || !isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return RepaintBoundary(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Video(
            key: GlobalObjectKey('media_kit_video_widget_$playerScope'),
            controller: controller,
            fill: Colors.black,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
