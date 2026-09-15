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
class SubtitleTextContent extends ConsumerWidget {
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

    return Column(
      crossAxisAlignment: textAlign == TextAlign.center 
          ? CrossAxisAlignment.center 
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        PhraseOriginalContent(
          phraseId: phrase.id,
          mainOption: mainOption,
          additionalOption: additionalOption,
          fallbackText: phrase.originalPhrase,
          baseFontSize: baseFontSize,
          textAlign: textAlign,
          textColor: textColor,
          useShadows: useShadows,
          isFullscreen: isFullscreen,
        ),
        if (showTranslation) ...[
          SizedBox(height: spacing),
          _TranslationStyledContent(
            phraseId: phrase.id,
            baseFontSize: baseFontSize * 0.75,
            textAlign: textAlign,
            textColor: textColor,
            useShadows: useShadows,
            isFullscreen: isFullscreen,
          ),
        ],
      ],
    );
  }
}

class _TranslationStyledContent extends HookConsumerWidget {
  final int phraseId;
  final double baseFontSize;
  final TextAlign textAlign;
  final Color textColor;
  final bool useShadows;
  final bool isFullscreen;

  const _TranslationStyledContent({
    required this.phraseId,
    required this.baseFontSize,
    required this.textAlign,
    required this.textColor,
    required this.useShadows,
    required this.isFullscreen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokensAsync = ref.watch(phraseTranslationTokensProvider(phraseId));
    final highlightedTranslationIds = ref.watch(highlightedTranslationIdsProvider);
    final anchorType = ref.watch(selectionAnchorTypeProvider);
    final clickedTranslationId = ref.watch(clickedTranslationWordIdProvider);

    return tokensAsync.when(
      skipLoadingOnRefresh: true,
      data: (tokens) {
        if (tokens.isEmpty) return const SizedBox.shrink();

        final settings = ref.watch(subtitleSettingsProvider);
        final double outlineThickness = settings.outlineWidth;

        final List<Shadow>? shadows = useShadows
            ? [
                Shadow(offset: Offset(-outlineThickness, -outlineThickness), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(outlineThickness, -outlineThickness), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(-outlineThickness, outlineThickness), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(outlineThickness, outlineThickness), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(0, -outlineThickness), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(0, outlineThickness), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(-outlineThickness, 0), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(outlineThickness, 0), blurRadius: 0.0, color: Colors.black),
                
                Shadow(offset: Offset(-outlineThickness * 0.707, -outlineThickness * 0.707), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(outlineThickness * 0.707, -outlineThickness * 0.707), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(-outlineThickness * 0.707, outlineThickness * 0.707), blurRadius: 0.0, color: Colors.black),
                Shadow(offset: Offset(outlineThickness * 0.707, outlineThickness * 0.707), blurRadius: 0.0, color: Colors.black),
              ]
            : null;

        return Wrap(
          key: ValueKey('tokens_data_$phraseId'),
          alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
          spacing: baseFontSize * 0.05, 
          runSpacing: baseFontSize * 0.1, 
          children: tokens.map((tokenWithStyle) {
            final tokenText = tokenWithStyle.token.text ?? '';
            final isHighlighted = highlightedTranslationIds.contains(tokenWithStyle.token.id);
            final bool isAnchor = anchorType == SelectionAnchor.translation && tokenWithStyle.token.id == clickedTranslationId;
            final bool isPunctuation = RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(tokenText.trim());

            return _TranslationTokenWidget(
              key: ValueKey('token_${tokenWithStyle.token.id}'),
              ts: tokenWithStyle,
              phraseId: phraseId,
              isHighlighted: isHighlighted,
              isAnchor: isAnchor,
              isPunctuation: isPunctuation,
              baseFontSize: baseFontSize,
              textColor: textColor,
              shadows: shadows,
              isFullscreen: isFullscreen,
            );
          }).toList(),
        );
      },
      loading: () => SizedBox.shrink(key: ValueKey('tokens_loading_$phraseId')),
      error: (_, __) => SizedBox.shrink(key: ValueKey('tokens_error_$phraseId')),
    );
  }
}

class _TranslationTokenWidget extends HookConsumerWidget {
  final TranslationTokenWithStyle ts;
  final int phraseId;
  final bool isHighlighted;
  final bool isAnchor;
  final bool isPunctuation;
  final double baseFontSize;
  final Color textColor;
  final List<Shadow>? shadows;
  final bool isFullscreen;

  const _TranslationTokenWidget({
    super.key,
    required this.ts,
    required this.phraseId,
    required this.isHighlighted,
    required this.isAnchor,
    required this.isPunctuation,
    required this.baseFontSize,
    required this.textColor,
    required this.isFullscreen,
    this.shadows,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockStyleAsync = ts.token.blockId != null 
        ? ref.watch(blockStyleProvider(ts.token.blockId!)) 
        : const AsyncValue<SpecificWordStyle?>.data(null);
    final styleAsync = ref.watch(wordStyleProvider(ts.lemma ?? ''));
    
    final currentStyle = blockStyleAsync.maybeWhen(data: (s) => s, orElse: () => null) ??
                        styleAsync.maybeWhen(data: (s) => s, orElse: () => ts.style);

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

    final playerState = ref.watch(playerProvider);
    final bool canTap = !playerState.isFullscreen || playerState.isLocked;

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;

    Widget tokenContent = Container(
      key: ValueKey('token_bg_${ts.token.id}_${isHighlighted}_$baseFontSize'),
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
        ts.token.text ?? '',
        style: TextStyle(
          fontSize: baseFontSize * modeSettings.translationScale,
          color: currentStyle?.color ?? (isFullscreen ? Colors.white : textColor.withValues(alpha: (isHighlighted && !isPunctuation) ? 1.0 : 0.85)),
          fontWeight: shadows != null ? FontWeight.w900 : ((isHighlighted && !isPunctuation) ? FontWeight.w900 : (currentStyle?.fontWeight ?? FontWeight.w700)),
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
        onTap: () async {
          final playerState = ref.read(playerProvider);
          final playerNotifier = ref.read(playerProvider.notifier);
          
          if (playerState.clickedTranslationWordId == ts.token.id && playerState.selectionAnchorType == SelectionAnchor.translation) {
            // Deselect
            playerNotifier.clearSelection();
          } else {
            // Select
            final index = await ref.read(phraseLinkIndexProvider(phraseId).future);
            final linked = index.getLinkedIdsForTranslation(ts.token.id);
            
            int? wordId;
            final sourceWords = index.translationToWords[ts.token.id] ?? [];
            if (sourceWords.isNotEmpty) {
              wordId = sourceWords.first.id;
            }

            playerNotifier.selectTranslation(
              ts.token.id, 
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

    return TapRegion(
      groupId: 'word_selection_group',
      child: tokenContent,
    );
  }
}



class PhraseOriginalContent extends HookConsumerWidget {
  final int phraseId;
  final String mainOption;
  final String? additionalOption;
  final String? fallbackText;
  final double baseFontSize;
  final TextAlign textAlign;
  final Color textColor;
  final bool useShadows;
  final bool isFullscreen;

  const PhraseOriginalContent({
    super.key,
    required this.phraseId,
    required this.mainOption,
    this.additionalOption,
    this.fallbackText,
    required this.baseFontSize,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF0F172A),
    this.useShadows = false,
    required this.isFullscreen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsWithStylesAsync = ref.watch(phraseWordsProvider(phraseId));
    final languageAsync = ref.watch(videoLanguageProvider);

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;
    final double outlineThickness = settings.outlineWidth;

    final List<Shadow> originalShadows = [
      Shadow(offset: Offset(-outlineThickness, -outlineThickness), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(outlineThickness, -outlineThickness), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(-outlineThickness, outlineThickness), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(outlineThickness, outlineThickness), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(0, -outlineThickness), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(0, outlineThickness), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(-outlineThickness, 0), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(outlineThickness, 0), blurRadius: 0.0, color: Colors.black),
      
      Shadow(offset: Offset(-outlineThickness * 0.707, -outlineThickness * 0.707), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(outlineThickness * 0.707, -outlineThickness * 0.707), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(-outlineThickness * 0.707, outlineThickness * 0.707), blurRadius: 0.0, color: Colors.black),
      Shadow(offset: Offset(outlineThickness * 0.707, outlineThickness * 0.707), blurRadius: 0.0, color: Colors.black),
    ];

    return wordsWithStylesAsync.when(
      skipLoadingOnRefresh: true,
      data: (wordsWithStyles) {
        if (wordsWithStyles.isEmpty) {
          final trimmedFallback = fallbackText?.trim() ?? '';
          return Text(
            trimmedFallback,
            key: ValueKey('words_fallback_$phraseId'),
            textAlign: textAlign,
            style: TextStyle(
              fontFamily: 'Noto Serif JP',
              fontSize: baseFontSize * modeSettings.originalScale, 
              color: isFullscreen ? Colors.white : textColor,
              height: 1.8,
              fontWeight: useShadows ? FontWeight.w900 : FontWeight.w700,
              shadows: useShadows ? originalShadows : null,
              letterSpacing: modeSettings.letterSpacing,
            ),
          );
        }

        final language = languageAsync.value;
        final bool removeSpaces = language?.removeAllSpaces ?? false;
        
        return Wrap(
          key: ValueKey('words_data_$phraseId'),
          alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: removeSpaces ? 0 : baseFontSize * 0.05, 
          runSpacing: baseFontSize * 0.1, 
          children: List.generate(wordsWithStyles.length, (index) {
            final ws = wordsWithStyles[index];

            final bool isFirst = index == 0 || wordsWithStyles[index - 1].block.id != ws.block.id;
            final bool isLast = index == wordsWithStyles.length - 1 || wordsWithStyles[index + 1].block.id != ws.block.id;

            return TapRegion(
              groupId: 'word_selection_group',
              child: RubyText(
                key: ValueKey('ruby_${ws.word.id}_$index'),
                word: ws.word,
                blockId: ws.block.id,
                style: ws.style,
                mainOption: mainOption,
                additionalOption: additionalOption,
                isFirstInBlock: isFirst,
                isLastInBlock: isLast,
                isFullscreen: isFullscreen,
                baseStyle: TextStyle(
                  fontFamily: 'Noto Serif JP',
                  fontSize: baseFontSize,
                  color: isFullscreen ? Colors.white : textColor,
                  height: 1.8,
                  fontWeight: useShadows ? FontWeight.w900 : FontWeight.w700,
                  letterSpacing: modeSettings.letterSpacing,
                  shadows: useShadows
                      ? [
                          ...originalShadows,
                          Shadow(offset: const Offset(0, 0), blurRadius: baseFontSize * 0.1, color: Colors.black),
                        ]
                      : null,
                ),
                annotationStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: baseFontSize * 0.55,
                  color: useShadows 
                      ? (isFullscreen ? Colors.white.withValues(alpha: 0.9) : textColor.withValues(alpha: 0.9)) 
                      : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.normal,
                  height: 1.0,
                  shadows: useShadows
                      ? [
                          Shadow(offset: Offset(-outlineThickness * 0.33, -outlineThickness * 0.33), blurRadius: 0.0, color: Colors.black),
                          Shadow(offset: Offset(outlineThickness * 0.33, -outlineThickness * 0.33), blurRadius: 0.0, color: Colors.black),
                          Shadow(offset: Offset(-outlineThickness * 0.33, outlineThickness * 0.33), blurRadius: 0.0, color: Colors.black),
                          Shadow(offset: Offset(outlineThickness * 0.33, outlineThickness * 0.33), blurRadius: 0.0, color: Colors.black),
                        ]
                      : null,
                ),
              ),
            );
          }),
        );
      },
      loading: () => Text(
        fallbackText?.trim() ?? '', 
        key: ValueKey('words_loading_$phraseId'),
        textAlign: textAlign,
        style: TextStyle(
          fontFamily: 'Noto Serif JP',
          fontSize: baseFontSize, 
          color: isFullscreen ? Colors.white : textColor,
          height: 1.8,
          fontWeight: useShadows ? FontWeight.w900 : FontWeight.w700,
          shadows: useShadows ? originalShadows : null,
          letterSpacing: modeSettings.letterSpacing,
        ),
      ),
      error: (_, st) => Text(
        fallbackText?.trim() ?? '', 
        key: ValueKey('words_error_$phraseId'),
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
