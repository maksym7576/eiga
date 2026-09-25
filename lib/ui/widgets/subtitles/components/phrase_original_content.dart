import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../backend/database/schemas/phrase.dart';
import '../../../../backend/database/schemas/user_word_status.dart';
import '../../../../config/ui/word_styles.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/config/languages/language_hub.dart';
import 'ruby_text.dart';
import 'outlined_text.dart';
import 'shimmer_text.dart';

class PhraseOriginalContent extends HookConsumerWidget {
  final Phrase phrase;
  final PhraseLinkIndex index;
  final Map<String, UserWordStatus> statusMap;
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
  final Set<int> hiddenWordIds;
  final String playerScope;

  const PhraseOriginalContent({
    super.key,
    required this.phrase,
    required this.index,
    required this.statusMap,
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
    this.hiddenWordIds = const {},
    this.playerScope = 'main',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final video = ref.watch(currentVideoProvider).value;
    final languageName = video?.originalLanguage ?? 'Japanese';
    final languageConfig = LanguageHub.getByName(languageName);

    final bool hideBrackets =
    ref.watch(appConfigsServiceProvider.select((c) => c.getHideParenthesesContent));

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;

    // High-performance dynamic stroke thickness calculation
    final double computedOutlineWidth =
    useShadows ? (baseFontSize * 0.055) * modeSettings.originalOutlineWidth * modeSettings.globalOutlineWidth : 0.0;

    List<TokenEntry> originalTokens = phrase.originalTokens ?? [];

    if (hideBrackets) {
      originalTokens =
          originalTokens.where((t) => !hiddenWordIds.contains(t.wordPosition)).toList();
    }

    if (originalTokens.isEmpty) {
      String trimmedFallback = fallbackText?.trim() ?? '';
      if (hideBrackets) {
        final bracketRegExp = RegExp(r'[([{（［｛].*?[)]}）］｝]');
        trimmedFallback = trimmedFallback.replaceAll(bracketRegExp, '').trim();
      }

      if (trimmedFallback.isEmpty) {
        if (phrase.uiStatus.isProcessing) {
          final stage = phrase.uiStatus.activeStageKey;
          String label = 'Processing...';

          if (stage == StageKey.context) label = 'Researching...';
          if (stage == StageKey.tokenizeSource) label = 'Analyzing source...';

          return ShimmerText(
            blendMode: BlendMode.srcATop,
            shimmerColors: [
              Colors.transparent,
              Colors.transparent,
              const Color(0xFF3B66F5).withValues(alpha: 0.4),
              Colors.transparent,
              Colors.transparent,
            ],
            child: Container(
              decoration: BoxDecoration(
                color: isFullscreen ? Colors.black26 : Colors.black.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: OutlinedText(
                text: label,
                useOutline: isFullscreen,
                outlineWidth: baseFontSize * 0.05,
                outlineColor: Colors.black.withValues(alpha: 0.8),
                style: TextStyle(
                  fontSize: baseFontSize * 0.8,
                  fontWeight: FontWeight.w700,
                  color: isFullscreen ? Colors.white : textColor.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                  height: 1.0,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }

      return OutlinedText(
        text: trimmedFallback,
        key: ValueKey('words_fallback_${phrase.id}'),
        textAlign: textAlign,
        useOutline: useShadows,
        outlineWidth: computedOutlineWidth,
        outlineColor: isFullscreen ? Colors.black.withValues(alpha: 0.8) : Colors.black,
        style: TextStyle(
          fontFamily: 'Noto Serif JP',
          fontSize: baseFontSize * modeSettings.originalScale,
          color: isFullscreen ? Colors.white : textColor,
          height: 1.0,
          fontWeight: useShadows ? FontWeight.w800 : FontWeight.w700,
          letterSpacing: modeSettings.originalLetterSpacing,
        ),
      );
    }

    final bool removeSpaces = languageConfig?.removeAllSpaces ?? false;

    return Wrap(
      key: ValueKey('words_wrap_${phrase.id}'),
      alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 0,
      runSpacing: 0,
      children: List.generate(originalTokens.length, (i) {
        final token = originalTokens[i];

        final bool isFirst = i == 0 || originalTokens[i - 1].blockId != token.blockId;
        final bool isLast =
            i == originalTokens.length - 1 || originalTokens[i + 1].blockId != token.blockId;

        WordStatus? wordStatus;
        if (token.lemma != null) {
          wordStatus = statusMap[token.lemma]?.status;
        }

        return RubyText(
          key: ValueKey('ruby_${phrase.id}_${token.wordPosition}_$i'),
          word: token,
          phraseId: phrase.id,
          index: index,
          blockId: token.blockId,
          status: wordStatus,
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
          playerScope: playerScope,
          baseStyle: TextStyle(
            fontFamily: 'Noto Serif JP',
            fontSize: baseFontSize * modeSettings.originalScale,
            color: isFullscreen ? Colors.white : textColor,
            height: 1.0,
            fontWeight: useShadows ? FontWeight.w800 : FontWeight.w700,
            letterSpacing: modeSettings.originalLetterSpacing,
          ),
          annotationStyle: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: baseFontSize * 0.55 * modeSettings.additionalScale,
            color: useShadows
                ? (isFullscreen
                ? Colors.white.withValues(alpha: 0.9)
                : textColor.withValues(alpha: 0.9))
                : const Color(0xFF94A3B8),
            fontWeight: FontWeight.normal,
            height: 1.0,
          ),
        );
      }),
    );
  }
}