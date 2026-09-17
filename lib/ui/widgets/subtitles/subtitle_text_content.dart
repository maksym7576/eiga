import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'components/phrase_original_content.dart';
import 'components/translation_styled_content.dart';

// Component for rendering subtitle text with support for interactive blocks
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
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double spacing = baseFontSize * 0.1;
    
    // Create the link index once for this phrase
    final index = useMemoized(
      () => PhraseLinkIndex(phrase.originalTokens ?? [], phrase.translatedWords ?? []),
      [phrase.originalTokens, phrase.translatedWords],
    );

    final appConfig = ref.watch(appConfigsServiceProvider);
    final bool hideBrackets = appConfig.getHideParenthesesContent;

    // Calculate which IDs should be hidden based on brackets and links
    final hiddenIds = useMemoized(() {
      if (!hideBrackets) return {'words': <int>{}, 'translations': <int>{}};

      final originalTokens = phrase.originalTokens ?? [];
      final translatedTokens = phrase.translatedWords ?? [];
      
      final openBrackets = {'(', '[', '{', '（', '［', '｛'};
      final closeBrackets = {')', ']', '}', '）', '］', '｝'};
      final bracketRegExp = RegExp(r'[([{（［｛].*?[)]}）］｝]');

      Set<int> noiseWords = {};
      bool inside = false;
      for (final t in originalTokens) {
        final txt = t.surface?.trim() ?? t.mainText.trim();
        if (txt.isEmpty) continue;
        if (openBrackets.contains(txt)) { inside = true; noiseWords.add(t.wordPosition ?? -1); continue; }
        if (closeBrackets.contains(txt)) { inside = false; noiseWords.add(t.wordPosition ?? -1); continue; }
        if (inside || bracketRegExp.hasMatch(txt)) noiseWords.add(t.wordPosition ?? -1);
      }

      Set<int> noiseTranslations = {};
      inside = false;
      for (final t in translatedTokens) {
        final txt = t.text?.trim() ?? '';
        if (txt.isEmpty) continue;
        if (openBrackets.contains(txt)) { inside = true; noiseTranslations.add(t.translatedWordPosition ?? -1); continue; }
        if (closeBrackets.contains(txt)) { inside = false; noiseTranslations.add(t.translatedWordPosition ?? -1); continue; }
        if (inside || bracketRegExp.hasMatch(txt)) noiseTranslations.add(t.translatedWordPosition ?? -1);
      }

      // Propagate noise via links for synchronization
      Set<int> finalHiddenWords = Set.from(noiseWords);
      Set<int> finalHiddenTranslations = Set.from(noiseTranslations);

      // If a word is noise, hide its linked translations
      for (final wId in noiseWords) {
        final linked = index.getLinkedIdsForWord(wId);
        finalHiddenTranslations.addAll(linked['translations']!);
      }
      // If a translation is noise, hide its linked words
      for (final tId in noiseTranslations) {
        final linked = index.getLinkedIdsForTranslation(tId);
        finalHiddenWords.addAll(linked['words']!);
      }

      return {'words': finalHiddenWords, 'translations': finalHiddenTranslations};
    }, [phrase.originalTokens, phrase.translatedWords, hideBrackets, index]);

    // Watch interactive states at the phrase level (Performance peak)
    final highlightedWordIds = ref.watch(highlightedWordIdsProvider);
    final highlightedTranslationIds = ref.watch(highlightedTranslationIdsProvider);
    final anchorType = ref.watch(selectionAnchorTypeProvider);
    final clickedWordId = ref.watch(clickedWordIdProvider);
    final clickedTranslationId = ref.watch(clickedTranslationWordIdProvider);
    final isLocked = ref.watch(playerProvider.select((s) => s.isLocked));
    final selectionLayerLink = ref.watch(selectionLayerLinkProvider);

    // Watch status map and styles map at the top level ONLY
    final statusMap = ref.watch(lemmaToStatusMapProvider).value ?? {};
    final stylesMap = ref.watch(allStylesMapProvider);

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
            stylesMap: stylesMap,
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
          ),
          if (showTranslation) ...[
            SizedBox(height: spacing),
            TranslationStyledContent(
              phrase: phrase,
              index: index,
              statusMap: statusMap,
              stylesMap: stylesMap,
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
            ),
          ],
        ],
      ),
    );
  }
}
