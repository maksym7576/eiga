import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../backend/database/schemas/block.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/player_provider.dart';
import '../../../providers/services/database_services_providers.dart';
import 'ruby_text.dart';
import 'word_popover.dart';

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
    final selectedBlockId = ref.watch(selectedBlockIdProvider);

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
        if (showTranslation && phrase.translatedPhrase != null) ...[
          const SizedBox(height: 6),
          _TranslationStyledContent(
            phraseId: phrase.id,
            baseFontSize: baseFontSize * 0.75,
            textAlign: textAlign,
            textColor: textColor,
            useShadows: useShadows,
            selectedBlockId: selectedBlockId,
          ),
        ],
      ],
    );
  }
}

class _TranslationStyledContent extends ConsumerWidget {
  final int phraseId;
  final double baseFontSize;
  final TextAlign textAlign;
  final Color textColor;
  final bool useShadows;
  final int? selectedBlockId;

  const _TranslationStyledContent({
    required this.phraseId,
    required this.baseFontSize,
    required this.textAlign,
    required this.textColor,
    required this.useShadows,
    this.selectedBlockId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksWithStylesAsync = ref.watch(phraseBlocksWithStylesProvider(phraseId));

    return blocksWithStylesAsync.when(
      skipLoadingOnRefresh: true,
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();

        final List<Shadow>? shadows = useShadows
            ? [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 2.0,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ]
            : null;

        return Wrap(
          alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
          spacing: 0,
          runSpacing: 0,
          children: entries.asMap().entries.map((item) {
            final index = item.key;
            final entry = item.value;
            final block = entry['block'] as Block;
            final style = entry['style'] as SpecificWordStyle?;
            final isSelected = selectedBlockId == block.id;

            String text = block.blockTranslation?.trim() ?? '';
            if (text.isEmpty) return const SizedBox.shrink();

            // Add a space after each block except the last one to keep it continuous but readable
            if (index < entries.length - 1) {
              text = '$text ';
            }

            final bool isFirst = index == 0 || (entries[index - 1]['block'] as Block).id != block.id;
            final bool isLast = index == entries.length - 1 || (entries[index + 1]['block'] as Block).id != block.id;

            return TapRegion(
              groupId: 'word_selection_group',
              child: GestureDetector(
                key: ValueKey('trans_${block.id}_$index'),
                onTap: () async {
                  final currentBlockId = ref.read(selectedBlockIdProvider);
                  
                  if (currentBlockId == block.id) {
                    ref.read(selectedBlockIdProvider.notifier).state = null;
                    ref.read(clickedWordIdProvider.notifier).state = null;
                    ref.read(clickedWordPositionProvider.notifier).state = null;
                    ref.read(playerProvider.notifier).setPlaying(true);
                    return;
                  }

                  ref.read(playerProvider.notifier).setPlaying(false);

                  final wordService = ref.read(wordServiceProvider);
                  final words = await wordService.getWordsByBlockIds([block.id]);
                  if (words.isNotEmpty) {
                    ref.read(clickedWordIdProvider.notifier).state = words.first.id;
                  }
                  
                  ref.read(selectedBlockIdProvider.notifier).state = block.id;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3B66F5).withValues(alpha: 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(isFirst && isSelected ? 4 : 0),
                      right: Radius.circular(isLast && isSelected ? 4 : 0),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: baseFontSize,
                      color: style?.color ?? textColor.withOpacity(0.85),
                      fontWeight: isSelected ? FontWeight.bold : (style?.fontWeight ?? FontWeight.w500),
                      height: 1.5, // Prevents clipping at the bottom
                      shadows: shadows,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
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

    return wordsWithStylesAsync.when(
      skipLoadingOnRefresh: true,
      data: (wordsWithStyles) {
        if (wordsWithStyles.isEmpty) {
          final trimmedFallback = fallbackText?.trim() ?? '';
          return Text(
            trimmedFallback,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: baseFontSize,
              color: textColor,
              shadows: useShadows ? [const Shadow(blurRadius: 2.0, color: Colors.black, offset: Offset(1, 1))] : null,
            ),
          );
        }

        final language = languageAsync.value;
        final bool removeSpaces = language?.removeAllSpaces ?? false;
        
        return Wrap(
          alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: removeSpaces ? 0 : 2, // No spacing for languages like Japanese
          runSpacing: 4,
          children: List.generate(wordsWithStyles.length, (index) {
            final ws = wordsWithStyles[index];
            final clickedWordId = ref.watch(clickedWordIdProvider);
            final bool isClicked = ws.word.id == clickedWordId;

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
                  shadows: useShadows ? [const Shadow(blurRadius: 2.0, color: Colors.black, offset: Offset(1, 1))] : null,
                ),
                annotationStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: baseFontSize * 0.55,
                  color: useShadows ? textColor.withOpacity(0.9) : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.normal,
                  height: 1.0,
                  shadows: useShadows ? [const Shadow(blurRadius: 1.0, color: Colors.black, offset: Offset(0.5, 0.5))] : null,
                ),
              ),
            );

            if (isClicked) {
              return CompositedTransformTarget(
                link: ref.watch(blockLayerLinkProvider),
                child: ruby,
              );
            }
            return ruby;
          }),
        );
      },
      loading: () => Text(fallbackText?.trim() ?? '', style: TextStyle(fontSize: baseFontSize, color: textColor)),
      error: (_, __) => Text(fallbackText?.trim() ?? '', style: const TextStyle(color: Colors.red)),
    );
  }
}
