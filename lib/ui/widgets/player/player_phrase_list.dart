import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'player_phrase_item.dart';

class _MouseDraggableScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class PlayerPhraseList extends HookConsumerWidget {
  final String playerScope;
  const PlayerPhraseList({super.key, this.playerScope = 'main'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrasesAsync = ref.watch(phrasesStreamProvider);
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider(playerScope));
    
    final itemScrollController = useMemoized(() => ItemScrollController());
    final itemPositionsListener = useMemoized(() => ItemPositionsListener.create());
    final lastScrolledIdRef = useRef<int?>(null);

    // Listen to active phrase changes using ref.listen to prevent full list rebuilds on every time tick!
    ref.listen<int?>(stickyActivePhraseIdProvider(playerScope), (prev, activePhraseId) {
      if (!isAutoScrollEnabled) return;
      
      final phrases = phrasesAsync.value ?? [];
      if (phrases.isEmpty || activePhraseId == null) return;
      
      if (lastScrolledIdRef.value == activePhraseId) return;

      final index = phrases.indexWhere((p) => p.id == activePhraseId);
      if (index != -1 && itemScrollController.isAttached) {
        lastScrolledIdRef.value = activePhraseId;
        itemScrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
          alignment: 0.2,
        );
      }
    });

    return phrasesAsync.when(
      data: (phrases) {
        if (phrases.isEmpty) {
          return const Center(
            child: Text(
              'No phrases found for this video',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          );
        }

        return Container(
          color: Colors.white,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is UserScrollNotification) {
                if (notification.direction != ScrollDirection.idle) {
                  if (ref.read(isAutoScrollEnabledProvider(playerScope))) {
                    Future.microtask(() {
                      ref.read(playerProvider(playerScope).notifier).setAutoScroll(false);
                    });
                  }
                  
                  final playerState = ref.read(playerProvider(playerScope));
                  if (playerState.clickedWordId != null || 
                      playerState.clickedTranslationWordId != null ||
                      playerState.highlightedWordIds.isNotEmpty) {
                    Future.microtask(() {
                      ref.read(playerProvider(playerScope).notifier).clearSelection();
                    });
                  }
                }
              }
              return false;
            },
            child: ScrollConfiguration(
              behavior: _MouseDraggableScrollBehavior(),
              child: ScrollablePositionedList.builder(
                itemCount: phrases.length,
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                addAutomaticKeepAlives: false,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(bottom: 120),
                itemBuilder: (context, index) {
                  final phrase = phrases[index];
                  return PlayerPhraseItem(
                    key: ValueKey('phrase_${phrase.id}'),
                    phrase: phrase,
                    playerScope: playerScope,
                  );
                },
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
