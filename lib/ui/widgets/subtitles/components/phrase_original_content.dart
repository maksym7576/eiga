import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../backend/database/schemas/phrase.dart';
import '../../../../backend/database/schemas/specific_word_style.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'ruby_text.dart';
import 'outlined_text.dart';

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
    
    // High-performance dynamic stroke thickness calculation
    final double computedOutlineWidth = useShadows 
        ? (baseFontSize * 0.055) * modeSettings.originalOutlineWidth 
        : 0.0;

    final originalTokens = phrase.originalTokens ?? [];

    if (originalTokens.isEmpty) {
      final trimmedFallback = fallbackText?.trim() ?? '';
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: baseFontSize * 0.15,
          vertical: baseFontSize * 0.05,
        ),
        child: OutlinedText(
          text: trimmedFallback,
          key: ValueKey('words_fallback_${phrase.id}'),
          textAlign: textAlign,
          useOutline: useShadows,
          outlineWidth: computedOutlineWidth,
          outlineColor: Colors.black,
          style: TextStyle(
            fontFamily: 'Noto Serif JP',
            fontSize: baseFontSize * modeSettings.originalScale, 
            color: isFullscreen ? Colors.white : textColor,
            height: 1.8,
            fontWeight: useShadows ? FontWeight.w800 : FontWeight.w700,
            letterSpacing: modeSettings.originalLetterSpacing,
          ),
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
          key: ValueKey('ruby_${phrase.id}_${token.wordPosition}_$i'),
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
          removeSpaces: removeSpaces,
          useShadows: useShadows,
          outlineWidth: computedOutlineWidth,
          selectionAnchorType: anchorType,
          selectionLayerLink: selectionLayerLink,
          baseStyle: TextStyle(
            fontFamily: 'Noto Serif JP',
            fontSize: baseFontSize,
            color: isFullscreen ? Colors.white : textColor,
            height: 1.8,
            fontWeight: useShadows ? FontWeight.w800 : FontWeight.w700,
            letterSpacing: modeSettings.originalLetterSpacing,
          ),
          annotationStyle: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: baseFontSize * 0.55,
            color: useShadows 
                ? (isFullscreen ? Colors.white.withValues(alpha: 0.9) : textColor.withValues(alpha: 0.9)) 
                : const Color(0xFF94A3B8),
            fontWeight: FontWeight.normal,
            height: 1.0,
          ),
        );
      }),
    );
  }
}
