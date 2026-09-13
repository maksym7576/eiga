import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/player_provider.dart';
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

  const SubtitleTextContent({
    super.key,
    required this.phrase,
    required this.mainOption,
    this.additionalOption,
    this.showTranslation = true,
    this.baseFontSize = 17.5,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF0F172A),
    this.useShadows = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        ),
        if (showTranslation) ...[
          const SizedBox(height: 2),
          _TranslationStyledContent(
            phraseId: phrase.id,
            baseFontSize: baseFontSize * 0.75,
            textAlign: textAlign,
            textColor: textColor,
            useShadows: useShadows,
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

  const _TranslationStyledContent({
    required this.phraseId,
    required this.baseFontSize,
    required this.textAlign,
    required this.textColor,
    required this.useShadows,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokensAsync = ref.watch(phraseTranslationTokensProvider(phraseId));
    final highlightedTranslationIds = ref.watch(highlightedTranslationIdsProvider);
    final anchorType = ref.watch(selectionAnchorTypeProvider);
    final clickedTranslationId = ref.watch(clickedTranslationWordIdProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: tokensAsync.when(
        skipLoadingOnRefresh: true,
        data: (tokens) {
          if (tokens.isEmpty) return SizedBox.shrink(key: ValueKey('tokens_empty_$phraseId'));

          final List<Shadow>? shadows = useShadows
              ? [
                  const Shadow(offset: Offset(-1, -1), blurRadius: 0.0, color: Colors.black),
                  const Shadow(offset: Offset(1, -1), blurRadius: 0.0, color: Colors.black),
                  const Shadow(offset: Offset(-1, 1), blurRadius: 0.0, color: Colors.black),
                  const Shadow(offset: Offset(1, 1), blurRadius: 0.0, color: Colors.black),
                  const Shadow(offset: Offset(0, -1), blurRadius: 0.0, color: Colors.black),
                  const Shadow(offset: Offset(0, 1), blurRadius: 0.0, color: Colors.black),
                  const Shadow(offset: Offset(-1, 0), blurRadius: 0.0, color: Colors.black),
                  const Shadow(offset: Offset(1, 0), blurRadius: 0.0, color: Colors.black),
                ]
              : null;

          return Wrap(
            key: ValueKey('tokens_data_$phraseId'),
            alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
            spacing: 1, 
            runSpacing: 2, 
            children: tokens.map((tokenWithStyle) {
              final tokenText = tokenWithStyle.token.text ?? '';
              final isHighlighted = highlightedTranslationIds.contains(tokenWithStyle.token.id);
              final bool isAnchor = anchorType == SelectionAnchor.translation && tokenWithStyle.token.id == clickedTranslationId;
              
              // Check if token is just punctuation
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
              );
            }).toList(),
          );
        },
        loading: () => SizedBox.shrink(key: ValueKey('tokens_loading_$phraseId')),
        error: (_, _) => SizedBox.shrink(key: ValueKey('tokens_error_$phraseId')),
      ),
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

  const _TranslationTokenWidget({
    super.key,
    required this.ts,
    required this.phraseId,
    required this.isHighlighted,
    required this.isAnchor,
    required this.isPunctuation,
    required this.baseFontSize,
    required this.textColor,
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
            ref.read(clickedWordPositionProvider.notifier).state = position;
          }
        });
      }
      return null;
    }, [isAnchor]);

    final playerState = ref.watch(playerProvider);
    final bool canTap = !playerState.isFullscreen || playerState.isLocked;

    return TapRegion(
      groupId: 'word_selection_group',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (isPunctuation || !canTap) ? null : () async {
          final currentAnchorType = ref.read(selectionAnchorTypeProvider);
          final currentClickedId = ref.read(clickedTranslationWordIdProvider);
          final playerNotifier = ref.read(playerProvider.notifier);
          
          if (currentClickedId == ts.token.id && currentAnchorType == SelectionAnchor.translation) {
            // Deselect
            ref.read(highlightedWordIdsProvider.notifier).state = {};
            ref.read(highlightedTranslationIdsProvider.notifier).state = {};
            ref.read(clickedWordIdProvider.notifier).state = null;
            ref.read(clickedTranslationWordIdProvider.notifier).state = null;
            ref.read(selectionAnchorTypeProvider.notifier).state = null;
            playerNotifier.resumeFromInteraction();
          } else {
            // Select
            playerNotifier.pauseForInteraction();
            
            final index = await ref.read(phraseLinkIndexProvider(phraseId).future);

            final linked = index.getLinkedIdsForTranslation(ts.token.id);
            
            ref.read(highlightedTranslationIdsProvider.notifier).state = linked['translations']!;
            ref.read(highlightedWordIdsProvider.notifier).state = linked['words']!;
            
            ref.read(clickedTranslationWordIdProvider.notifier).state = ts.token.id;
            
            // User wants popover above ORIGINAL word.
            // Find the first source word and set it as anchor.
            final sourceWords = index.translationToWords[ts.token.id] ?? [];
            if (sourceWords.isNotEmpty) {
              ref.read(clickedWordIdProvider.notifier).state = sourceWords.first.id;
              ref.read(selectionAnchorTypeProvider.notifier).state = SelectionAnchor.word;
            } else {
              ref.read(clickedWordIdProvider.notifier).state = null;
              ref.read(selectionAnchorTypeProvider.notifier).state = SelectionAnchor.translation;
            }
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isPunctuation ? 0 : 3, 
            vertical: 1
          ),
          decoration: BoxDecoration(
            color: (isHighlighted && !isPunctuation)
                ? const Color(0xFFE2E8F0).withValues(alpha: 0.8)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: (isHighlighted && !isPunctuation)
                ? Border.all(color: Colors.black12, width: 1.2)
                : null,
          ),
          child: Text(
            ts.token.text ?? '',
            style: TextStyle(
              fontSize: baseFontSize,
              color: currentStyle?.color ?? textColor.withValues(alpha: (isHighlighted && !isPunctuation) ? 1.0 : 0.85),
              fontWeight: (isHighlighted && !isPunctuation) ? FontWeight.w900 : (currentStyle?.fontWeight ?? FontWeight.w500),
              height: 1.5,
              shadows: shadows,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
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

  const PhraseOriginalContent({
    super.key,
    required this.phraseId,
    required this.mainOption,
    this.additionalOption,
    this.fallbackText,
    this.baseFontSize = 17.5,
    this.textAlign = TextAlign.start,
    this.textColor = const Color(0xFF0F172A),
    this.useShadows = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsWithStylesAsync = ref.watch(phraseWordsProvider(phraseId));
    final languageAsync = ref.watch(videoLanguageProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: wordsWithStylesAsync.when(
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
                fontSize: baseFontSize, 
                color: textColor,
                height: 1.8,
                shadows: useShadows
                    ? [
                        const Shadow(offset: Offset(-1, -1), blurRadius: 0.0, color: Colors.black),
                        const Shadow(offset: Offset(1, -1), blurRadius: 0.0, color: Colors.black),
                        const Shadow(offset: Offset(-1, 1), blurRadius: 0.0, color: Colors.black),
                        const Shadow(offset: Offset(1, 1), blurRadius: 0.0, color: Colors.black),
                        const Shadow(offset: Offset(0, -1), blurRadius: 0.0, color: Colors.black),
                        const Shadow(offset: Offset(0, 1), blurRadius: 0.0, color: Colors.black),
                        const Shadow(offset: Offset(-1, 0), blurRadius: 0.0, color: Colors.black),
                        const Shadow(offset: Offset(1, 0), blurRadius: 0.0, color: Colors.black),
                      ]
                    : null,
              ),
            );
          }

          final language = languageAsync.value;
          final bool removeSpaces = language?.removeAllSpaces ?? false;
          
          return Wrap(
            key: ValueKey('words_data_$phraseId'),
            alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: removeSpaces ? 0 : 1, 
            runSpacing: 2, 
            children: List.generate(wordsWithStyles.length, (index) {
              final ws = wordsWithStyles[index];

              final bool isFirst = index == 0 || wordsWithStyles[index - 1].block.id != ws.block.id;
              final bool isLast = index == wordsWithStyles.length - 1 || wordsWithStyles[index + 1].block.id != ws.block.id;

              final ruby = TapRegion(
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
                  baseStyle: TextStyle(
                    fontFamily: 'Noto Serif JP',
                    fontSize: baseFontSize,
                    color: textColor,
                    height: 1.8,
                    shadows: useShadows
                        ? [
                            const Shadow(offset: Offset(-1, -1), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(1, -1), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(-1, 1), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(1, 1), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(0, -1), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(0, 1), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(-1, 0), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(1, 0), blurRadius: 0.0, color: Colors.black),
                          ]
                        : null,
                  ),
                  annotationStyle: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: baseFontSize * 0.55,
                    color: useShadows ? textColor.withValues(alpha: 0.9) : const Color(0xFF94A3B8),
                    fontWeight: FontWeight.normal,
                    height: 1.0,
                    shadows: useShadows
                        ? [
                            const Shadow(offset: Offset(-0.5, -0.5), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(0.5, -0.5), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(-0.5, 0.5), blurRadius: 0.0, color: Colors.black),
                            const Shadow(offset: Offset(0.5, 0.5), blurRadius: 0.0, color: Colors.black),
                          ]
                        : null,
                  ),
                ),
              );

              return ruby;
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
            color: textColor,
            height: 1.8,
            shadows: useShadows
                ? [
                    const Shadow(offset: Offset(-1, -1), blurRadius: 0.0, color: Colors.black),
                    const Shadow(offset: Offset(1, -1), blurRadius: 0.0, color: Colors.black),
                    const Shadow(offset: Offset(-1, 1), blurRadius: 0.0, color: Colors.black),
                    const Shadow(offset: Offset(1, 1), blurRadius: 0.0, color: Colors.black),
                    const Shadow(offset: Offset(0, -1), blurRadius: 0.0, color: Colors.black),
                    const Shadow(offset: Offset(0, 1), blurRadius: 0.0, color: Colors.black),
                    const Shadow(offset: Offset(-1, 0), blurRadius: 0.0, color: Colors.black),
                    const Shadow(offset: Offset(1, 0), blurRadius: 0.0, color: Colors.black),
                  ]
                : null,
          ),
        ),
        error: (_, st) => Text(
          fallbackText?.trim() ?? '', 
          key: ValueKey('words_error_$phraseId'),
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
