import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/player_provider.dart';
import '../../../providers/services/reading_type_provider.dart';
import '../../../providers/ui/subtitle_settings_provider.dart';
import 'subtitle_text_content.dart';

class SubtitleOverlay extends ConsumerWidget {
  const SubtitleOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullscreen = ref.watch(playerProvider.select((s) => s.isFullscreen));
    if (!isFullscreen) return const SizedBox.shrink();

    final activePhraseId = ref.watch(activePhraseIdProvider);
    if (activePhraseId == null) return const SizedBox.shrink();

    final phrasesAsync = ref.watch(phrasesStreamProvider);
    final phrases = phrasesAsync.value ?? [];
    
    final Phrase? phrase = phrases.cast<Phrase?>().firstWhere(
      (p) => p?.id == activePhraseId, 
      orElse: () => null
    );
    
    if (phrase == null) return const SizedBox.shrink();

    final readingState = ref.watch(readingTypeNotifierProvider).value;
    final mainOpt = readingState?.mainOption ?? 'original';
    final addOpt = readingState?.additionalOption;
    final showTranslation = readingState?.showTranslation ?? true;

    final settings = ref.watch(subtitleSettingsProvider);
    
    final highlightedWords = ref.watch(highlightedWordIdsProvider);
    final highlightedTranslations = ref.watch(highlightedTranslationIdsProvider);
    final bool isBlockSelected = highlightedWords.isNotEmpty || highlightedTranslations.isNotEmpty;

    return Positioned(
      left: 0,
      right: 0,
      bottom: settings.verticalOffset, // Pure offset from the bottom
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          reverseDuration: const Duration(milliseconds: 100),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (Widget child, Animation<double> animation) {
            final isEntering = child.key == ValueKey('phrase_${phrase?.id}');
            
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: isEntering ? 0.96 : 1.0,
                  end: isEntering ? 1.0 : 1.04,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: phrase == null 
              ? const SizedBox.shrink(key: ValueKey('empty_subtitle'))
              : GestureDetector(
                  key: ValueKey('phrase_${phrase.id}'),
                  onTap: isBlockSelected ? () {
                    // Deselect and resume playback
                    ref.read(selectedBlockIdProvider.notifier).state = null;
                    ref.read(clickedWordIdProvider.notifier).state = null;
                    ref.read(clickedTranslationWordIdProvider.notifier).state = null;
                    ref.read(clickedWordPositionProvider.notifier).state = null;
                    ref.read(selectionAnchorTypeProvider.notifier).state = null;
                    ref.read(highlightedWordIdsProvider.notifier).state = {};
                    ref.read(highlightedTranslationIdsProvider.notifier).state = {};
                    ref.read(playerProvider.notifier).resumeFromInteraction();
                  } : null,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.all(settings.backdropPadding),
                    decoration: BoxDecoration(
                      color: settings.showBackdrop
                          ? Colors.black.withOpacity(settings.backdropOpacity)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SubtitleTextContent(
                      phrase: phrase,
                      mainOption: mainOpt,
                      additionalOption: addOpt,
                      showTranslation: showTranslation,
                      baseFontSize: settings.baseFontSize,
                      textAlign: TextAlign.center,
                      textColor: Colors.white,
                      useShadows: settings.outlineWidth > 0,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
