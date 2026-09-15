import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'ruby_text.dart';

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
          ),
          if (showTranslation) ...[
            SizedBox(height: spacing),
            _TranslationStyledContent(
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
            ),
          ],
        ],
      ),
    );
  }
}

class _TranslationStyledContent extends HookConsumerWidget {
  final Phrase phrase;
  final PhraseLinkIndex index;
  final Map<String, dynamic> statusMap;
  final Map<int, SpecificWordStyle> stylesMap;
  final Set<int> highlightedTranslationIds;
  final int? clickedTranslationId;
  final SelectionAnchor? anchorType;
  final LayerLink? selectionLayerLink;
  final double baseFontSize;
  final TextAlign textAlign;
  final Color textColor;
  final bool useShadows;
  final bool isFullscreen;
  final bool isLocked;

  const _TranslationStyledContent({
    required this.phrase,
    required this.index,
    required this.statusMap,
    required this.stylesMap,
    required this.highlightedTranslationIds,
    this.clickedTranslationId,
    this.anchorType,
    this.selectionLayerLink,
    required this.baseFontSize,
    required this.textAlign,
    required this.textColor,
    required this.useShadows,
    required this.isFullscreen,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = phrase.translatedWords ?? [];

    
    // Performance optimization: use 4-point sharp directional outline
    final List<Shadow>? shadows = useShadows
        ? [
            Shadow(offset: Offset(-baseFontSize * 0.05, -baseFontSize * 0.05), color: Colors.black),
            Shadow(offset: Offset(baseFontSize * 0.05, -baseFontSize * 0.05), color: Colors.black),
            Shadow(offset: Offset(-baseFontSize * 0.05, baseFontSize * 0.05), color: Colors.black),
            Shadow(offset: Offset(baseFontSize * 0.05, baseFontSize * 0.05), color: Colors.black),
          ]
        : null;

    if (tokens.isEmpty) {
      final text = phrase.translatedPhrase ?? '';
      if (text.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: baseFontSize * 0.15, vertical: baseFontSize * 0.05),
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: baseFontSize,
            color: isFullscreen ? Colors.white : textColor.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
            height: 1.5,
            shadows: shadows,
          ),
        ),
      );
    }

    final originalTokens = phrase.originalTokens ?? [];
    final wordPosMap = {for (final w in originalTokens) if (w.wordPosition != null) w.wordPosition!: w};

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;

    return Wrap(
      key: ValueKey('tokens_wrap_${phrase.id}'),
      alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
      spacing: baseFontSize * 0.05, 
      runSpacing: baseFontSize * 0.1, 
      children: tokens.map((token) {
        final tokenText = token.text ?? '';
        final isHighlighted = highlightedTranslationIds.contains(token.translatedWordPosition);
        final bool isAnchor = anchorType == SelectionAnchor.translation && token.translatedWordPosition == clickedTranslationId;
        final bool isPunctuation = RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(tokenText.trim());

        String? lemma;
        if (token.sourceWordPositions.isNotEmpty) {
          lemma = wordPosMap[token.sourceWordPositions.first]?.lemma;
        } else if (token.blockId != null) {
          lemma = originalTokens.where((w) => w.blockId == token.blockId).firstOrNull?.lemma;
        }

        SpecificWordStyle? wordStyle;
        if (lemma != null) {
          final status = statusMap[lemma];
          if (status?.styleId != null) wordStyle = stylesMap[status!.styleId!];
        }

        return _TranslationTokenWidget(
          key: ValueKey('token_${token.translatedWordPosition}'),
          token: token,
          index: index,
          lemma: lemma,
          style: wordStyle,
          phraseId: phrase.id,
          isHighlighted: isHighlighted,
          isAnchor: isAnchor,
          isPunctuation: isPunctuation,
          baseFontSize: baseFontSize,
          textColor: textColor,
          shadows: shadows,
          isFullscreen: isFullscreen,
          isLocked: isLocked,
          selectionAnchorType: anchorType,
          selectionLayerLink: selectionLayerLink,
          modeSettings: modeSettings,
        );
      }).toList(),
    );
  }
}

class _TranslationTokenWidget extends HookConsumerWidget {
  final TranslationTokenEntry token;
  final PhraseLinkIndex index;
  final String? lemma;
  final SpecificWordStyle? style;
  final int phraseId;
  final bool isHighlighted;
  final bool isAnchor;
  final bool isPunctuation;
  final double baseFontSize;
  final Color textColor;
  final List<Shadow>? shadows;
  final bool isFullscreen;
  final bool isLocked;
  final SelectionAnchor? selectionAnchorType;
  final LayerLink? selectionLayerLink;
  final dynamic modeSettings;

  const _TranslationTokenWidget({
    super.key,
    required this.token,
    required this.index,
    this.lemma,
    this.style,
    required this.phraseId,
    required this.isHighlighted,
    required this.isAnchor,
    required this.isPunctuation,
    required this.baseFontSize,
    required this.textColor,
    required this.isFullscreen,
    required this.isLocked,
    this.selectionAnchorType,
    this.selectionLayerLink,
    required this.modeSettings,
    this.shadows,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (isAnchor) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize) {
            final position = box.localToGlobal(Offset(box.size.width / 2, 0));
            ref.read(playerProvider.notifier).setClickedWordPosition(position);
          }
        });
      }
      return null;
    }, [isAnchor]);

    final bool canTap = !isFullscreen || isLocked;

    Widget tokenContent = Container(
      key: ValueKey('token_bg_${token.translatedWordPosition}_$isHighlighted'),
      padding: EdgeInsets.symmetric(
        horizontal: isPunctuation ? 0 : baseFontSize * 0.15, 
        vertical: baseFontSize * 0.05
      ),
      decoration: BoxDecoration(
        color: (isHighlighted && !isPunctuation)
            ? (isFullscreen 
                ? const Color(0xFF3B66F5).withValues(alpha: 0.4)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.8))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(baseFontSize * 0.3),
        border: (isHighlighted && !isPunctuation)
            ? Border.all(
                color: isFullscreen ? const Color(0xFF3B66F5).withValues(alpha: 0.6) : Colors.black12, 
                width: baseFontSize * 0.06
              )
            : null,
      ),
      child: Text(
        token.text ?? '',
        style: TextStyle(
          fontSize: baseFontSize * modeSettings.translationScale,
          color: style?.color ?? (isFullscreen ? Colors.white : textColor.withValues(alpha: (isHighlighted && !isPunctuation) ? 1.0 : 0.85)),
          fontWeight: shadows != null ? FontWeight.w900 : ((isHighlighted && !isPunctuation) ? FontWeight.w900 : (style?.fontWeight ?? FontWeight.w700)),
          height: 1.5,
          shadows: shadows,
          letterSpacing: modeSettings.letterSpacing,
          decoration: TextDecoration.none,
        ),
      ),
    );

    if (!isPunctuation && canTap) {
      tokenContent = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final playerNotifier = ref.read(playerProvider.notifier);
          
          if (isHighlighted && selectionAnchorType == SelectionAnchor.translation) {
            playerNotifier.clearSelection();
          } else {
            final linked = index.getLinkedIdsForTranslation(token.translatedWordPosition ?? 0);
            int? wordId;
            final sourceWords = index.translationToWords[token.translatedWordPosition ?? 0] ?? [];
            if (sourceWords.isNotEmpty) {
              wordId = (sourceWords.first as TokenEntry).wordPosition;
            }

            playerNotifier.selectTranslation(
              token.translatedWordPosition ?? 0,
              linked['words']!,
              linked['translations']!,
              wordId,
              shouldPause: true,
            );
          }
        },
        child: tokenContent,
      );
    }

    if (isAnchor && selectionLayerLink != null) {
      return CompositedTransformTarget(
        link: selectionLayerLink!,
        child: tokenContent,
      );
    }

    return tokenContent;
  }
}

class PhraseOriginalContent extends HookConsumerWidget {
  final Phrase phrase;
  final PhraseLinkIndex index;
  final Map<String, dynamic> statusMap;
  final Map<int, SpecificWordStyle> stylesMap;
  final Set<int> highlightedWordIds;
  final int? clickedWordId;
  final SelectionAnchor? anchorType;
  final LayerLink? selectionLayerLink;
  final String mainOption;
  final String? additionalOption;
  final String? fallbackText;
  final double baseFontSize;
  final TextAlign textAlign;
  final Color textColor;
  final bool useShadows;
  final bool isFullscreen;
  final bool isLocked;

  const PhraseOriginalContent({
    super.key,
    required this.phrase,
    required this.index,
    required this.statusMap,
    required this.stylesMap,
    required this.highlightedWordIds,
    this.clickedWordId,
    this.anchorType,
    this.selectionLayerLink,
    required this.mainOption,
    this.additionalOption,
    this.fallbackText,
    required this.baseFontSize,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF0F172A),
    this.useShadows = false,
    required this.isFullscreen,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageAsync = ref.watch(videoLanguageProvider);

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;
    
    // Performance optimization: use 4-point sharp directional outline
    final List<Shadow>? shadows = useShadows
        ? [
            Shadow(offset: Offset(-baseFontSize * 0.05, -baseFontSize * 0.05), color: Colors.black),
            Shadow(offset: Offset(baseFontSize * 0.05, -baseFontSize * 0.05), color: Colors.black),
            Shadow(offset: Offset(-baseFontSize * 0.05, baseFontSize * 0.05), color: Colors.black),
            Shadow(offset: Offset(baseFontSize * 0.05, baseFontSize * 0.05), color: Colors.black),
          ]
        : null;


    final originalTokens = phrase.originalTokens ?? [];

    if (originalTokens.isEmpty) {
      final trimmedFallback = fallbackText?.trim() ?? '';
      return Text(
        trimmedFallback,
        key: ValueKey('words_fallback_${phrase.id}'),
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: 'Noto Serif JP',
          fontSize: baseFontSize * modeSettings.originalScale, 
          color: isFullscreen ? Colors.white : textColor,
          height: 1.8,
          fontWeight: useShadows ? FontWeight.w900 : FontWeight.w700,
          shadows: shadows,
          letterSpacing: modeSettings.letterSpacing,
        ),
      );
    }

    final language = languageAsync.value;
    final bool removeSpaces = language?.removeAllSpaces ?? false;

    return Wrap(
      key: ValueKey('words_wrap_${phrase.id}'),
      alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: removeSpaces ? 0 : baseFontSize * 0.05, 
      runSpacing: baseFontSize * 0.1, 
      children: List.generate(originalTokens.length, (i) {
        final token = originalTokens[i];

        final bool isFirst = i == 0 || originalTokens[i - 1].blockId != token.blockId;
        final bool isLast = i == originalTokens.length - 1 || originalTokens[i + 1].blockId != token.blockId;

        SpecificWordStyle? wordStyle;
        if (token.lemma != null) {
          final status = statusMap[token.lemma];
          if (status?.styleId != null) wordStyle = stylesMap[status!.styleId!];
        }

        return RubyText(
          key: ValueKey('ruby_${token.wordPosition}_$i'),
          word: token,
          phraseId: phrase.id,
          index: index,
          blockId: token.blockId,
          style: wordStyle,
          mainOption: mainOption,
          additionalOption: additionalOption,
          isFirstInBlock: isFirst,
          isLastInBlock: isLast,
          isFullscreen: isFullscreen,
          isHighlighted: highlightedWordIds.contains(token.wordPosition),
          isAnchor: anchorType == SelectionAnchor.word && clickedWordId == token.wordPosition,
          isLocked: isLocked,
          selectionAnchorType: anchorType,
          selectionLayerLink: selectionLayerLink,
          baseStyle: TextStyle(
            fontFamily: 'Noto Serif JP',
            fontSize: baseFontSize,
            color: isFullscreen ? Colors.white : textColor,
            height: 1.8,
            fontWeight: useShadows ? FontWeight.w900 : FontWeight.w700,
            letterSpacing: modeSettings.letterSpacing,
            shadows: shadows,
          ),
          annotationStyle: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: baseFontSize * 0.55,
            color: useShadows 
                ? (isFullscreen ? Colors.white.withValues(alpha: 0.9) : textColor.withValues(alpha: 0.9)) 
                : const Color(0xFF94A3B8),
            fontWeight: FontWeight.normal,
            height: 1.0,
            shadows: shadows != null ? [shadows![0]] : null,
          ),
        );
      }),
    );
  }
}
