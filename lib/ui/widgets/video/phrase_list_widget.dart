import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../providers/ui/video_data_providers.dart';
import 'phrase_item_widget.dart';

class PhraseListWidget extends HookConsumerWidget {
  const PhraseListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrasesAsync = ref.watch(phrasesStreamProvider);
    final activePhraseId = ref.watch(activePhraseIdProvider);
    final languageAsync = ref.watch(videoLanguageProvider);
    final isAutoScrollEnabled = ref.watch(isAutoScrollEnabledProvider);
    
    final itemScrollController = useMemoized(() => ItemScrollController());
    final itemPositionsListener = useMemoized(() => ItemPositionsListener.create());

    // Auto-scroll when active phrase changes OR when auto-scroll is re-enabled
    useEffect(() {
      void scroll() {
        if (!isAutoScrollEnabled) return;
        
        final phrases = phrasesAsync.value ?? [];
        final next = ref.read(activePhraseIdProvider);
        if (next == null) return;
        
        final index = phrases.indexWhere((p) => p.id == next);
        if (index != -1) {
          itemScrollController.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            alignment: 0.3,
          );
        }
      }

      // Initial scroll and listener
      scroll();

      final activeSub = ref.listenManual(activePhraseIdProvider, (prev, next) => scroll());
      final enabledSub = ref.listenManual(isAutoScrollEnabledProvider, (prev, next) {
        if (next == true) scroll();
      });

      return () {
        activeSub.close();
        enabledSub.close();
      };
    }, [isAutoScrollEnabled, phrasesAsync.value]);

    // Detect manual scroll
    useEffect(() {
      void listener() {
        final positions = itemPositionsListener.itemPositions.value;
        if (positions.isEmpty) return;
        
        // This is a bit tricky since programmatic scrolls also trigger this.
        // But scrollable_positioned_list doesn't provide an easy way to distinguish.
        // We'll use a simple heuristic: if the user is scrolling, disable auto-scroll.
        // Actually, we'll listen to the NotificationListener in the builder instead for better accuracy.
      }
      itemPositionsListener.itemPositions.addListener(listener);
      return () => itemPositionsListener.itemPositions.removeListener(listener);
    }, []);

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
                  // User started scrolling
                  if (ref.read(isAutoScrollEnabledProvider)) {
                    Future.microtask(() {
                      ref.read(isAutoScrollEnabledProvider.notifier).state = false;
                    });
                  }
                }
              }
              return false;
            },
            child: ScrollablePositionedList.builder(
              itemCount: phrases.length,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              padding: const EdgeInsets.only(bottom: 120), // Ensure bottom dock doesn't cover last item
              itemBuilder: (context, index) {
                final phrase = phrases[index];
                return PhraseItemWidget(
                  phrase: phrase,
                  isActive: phrase.id == activePhraseId,
                  language: languageAsync.value,
                );
              },
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
