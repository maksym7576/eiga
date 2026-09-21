import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../backend/database/schemas/user_word_status.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'components/phrase_original_content.dart';
import 'components/translation_styled_content.dart';

class SubtitleTextContent extends HookConsumerWidget {
  final Phrase phrase;
  final String mainOption;
  final String? additionalOption;
  final bool showTranslation;
  final double baseFontSize;
  final TextAlign textAlign;
  final Color textColor;
  final bool useShadows;
  final bool isFullscreen;
  final String playerScope;

  const SubtitleTextContent({
    super.key,
    required this.phrase,
    required this.mainOption,
    this.additionalOption,
    this.showTranslation = true,
    required this.baseFontSize,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF0F172A),
    this.useShadows = false,
    this.isFullscreen = false,
    this.playerScope = 'main',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPhraseId = ref.watch(selectedPhraseIdProvider(playerScope));
    final bool isThisPhraseSelected = selectedPhraseId == phrase.id;

    final highlightedWordIds = isThisPhraseSelected ? ref.watch(highlightedWordIdsProvider(playerScope)) : const <int>{};
    final highlightedTranslationIds = isThisPhraseSelected ? ref.watch(highlightedTranslationIdsProvider(playerScope)) : const <int>{};
    
    final anchorType = isThisPhraseSelected ? ref.watch(selectionAnchorTypeProvider(playerScope)) : null;
    final clickedWordId = isThisPhraseSelected ? ref.watch(clickedWordIdProvider(playerScope)) : null;
    final clickedTranslationId = isThisPhraseSelected ? ref.watch(clickedTranslationWordIdProvider(playerScope)) : null;
    final isLocked = ref.watch(playerProvider(playerScope).select((s) => s.isLocked));
    final selectionLayerLink = isThisPhraseSelected ? ref.watch(selectionLayerLinkProvider(playerScope)) : null;

    final statusMap = ref.watch(lemmaToStatusMapProvider).value ?? {};
    final index = PhraseLinkIndex(phrase.originalTokens ?? [], phrase.translatedWords ?? [], phrase.linkGroups);

    final hiddenIds = ref.watch(dimmedWordIdsProvider(playerScope)).isEmpty 
        ? {'words': <int>{}, 'translations': <int>{}} 
        : {
            'words': ref.watch(dimmedWordIdsProvider(playerScope)),
            'translations': ref.watch(dimmedTranslationIdsProvider(playerScope)),
          };

    const double spacing = 6.0;

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: textAlign == TextAlign.center 
            ? CrossAxisAlignment.center 
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PhraseOriginalContent(
            phrase: phrase,
            index: index,
            statusMap: statusMap,
            highlightedWordIds: highlightedWordIds,
            clickedWordId: clickedWordId,
            anchorType: anchorType,
            selectionLayerLink: selectionLayerLink,
            mainOption: mainOption,
            additionalOption: additionalOption,
            fallbackText: phrase.originalPhrase,
            baseFontSize: baseFontSize,
            textAlign: textAlign,
            textColor: textColor,
            useShadows: useShadows,
            isFullscreen: isFullscreen,
            isLocked: isLocked,
            hiddenWordIds: hiddenIds['words']!,
            playerScope: playerScope,
          ),
          if (showTranslation) ...[
            SizedBox(height: spacing),
            TranslationStyledContent(
              phrase: phrase,
              index: index,
              statusMap: statusMap,
              highlightedTranslationIds: highlightedTranslationIds,
              clickedTranslationId: clickedTranslationId,
              anchorType: anchorType,
              selectionLayerLink: selectionLayerLink,
              baseFontSize: baseFontSize * 0.75,
              textAlign: textAlign,
              textColor: textColor,
              useShadows: useShadows,
              isFullscreen: isFullscreen,
              isLocked: isLocked,
              hiddenTranslationIds: hiddenIds['translations']!,
              playerScope: playerScope,
            ),
          ],
        ],
      ),
    );
  }
}
