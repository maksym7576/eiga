import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/word.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import '../../../providers/ui/player_provider.dart';
import '../../../providers/ui/video_data_providers.dart';

class RubyText extends HookConsumerWidget {
  final Word word;
  final String mainOption;
  final String? additionalOption;
  final TextStyle? baseStyle;
  final TextStyle? annotationStyle;
  final SpecificWordStyle? style;
  final int? blockId;
  final bool isFirstInBlock;
  final bool isLastInBlock;

  const RubyText({
    super.key,
    required this.word,
    required this.mainOption,
    this.additionalOption,
    this.baseStyle,
    this.annotationStyle,
    this.style,
    this.blockId,
    this.isFirstInBlock = true,
    this.isLastInBlock = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (word.versions.isEmpty) return const SizedBox.shrink();

    final highlightedWordIds = ref.watch(highlightedWordIdsProvider);
    final isSelected = highlightedWordIds.contains(word.id);
    
    final anchorType = ref.watch(selectionAnchorTypeProvider);
    final clickedWordId = ref.watch(clickedWordIdProvider);
    final bool isAnchor = anchorType == SelectionAnchor.word && clickedWordId == word.id;
    
    // Check if this word has any associated translations via the index
    final linkIndexAsync = ref.watch(phraseLinkIndexProvider(word.phraseId ?? 0));
    final translationInfo = linkIndexAsync.maybeWhen(
      data: (index) {
        final translations = index.wordToTranslations[word.id] ?? [];
        if (translations.isEmpty) return null;
        final t = translations.first;
        final siblings = index.translationToWords[t.id] ?? [];
        return (translation: t, siblings: siblings);
      },
      orElse: () => null,
    );

    final hasNoTranslation = translationInfo == null;

    useEffect(() {
      if (isAnchor) {
        // Use post frame callback to ensure RenderBox is ready and laid out
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

    String baseText = '';
    String? annotationText;

    // Helper to get text for an option
    String? getTextForOption(String opt) {
      if (opt == 'translation') return null; // Handled at Phrase level
      try {
        return word.versions.firstWhere((v) => v.key == opt).text;
      } catch (_) {
        return null;
      }
    }

    baseText = getTextForOption(mainOption) ?? word.mainText;
    
    if (additionalOption != null && additionalOption != 'translation') {
      annotationText = getTextForOption(additionalOption!);
      if (annotationText != null) {
        // Filter: Keep only Letters (\p{L}), Numbers (\p{N}), and Whitespace (\s).
        final pattern = RegExp(r'[^\p{L}\p{N}\s]', unicode: true);
        annotationText = annotationText.replaceAll(pattern, '');
      }
    }

    final wordStyleAsync = ref.watch(wordStyleProvider(word.lemma ?? ''));
    final blockStyleAsync = blockId != null ? ref.watch(blockStyleProvider(blockId!)) : const AsyncValue<SpecificWordStyle?>.data(null);
    
    // Priority: Block Style > Individual Word Style > Default (style prop)
    final effectiveStyle = blockStyleAsync.maybeWhen(data: (s) => s, orElse: () => null) ?? 
                           wordStyleAsync.maybeWhen(data: (s) => s, orElse: () => style);

    final Color? customColor = effectiveStyle?.color;
    final FontWeight? customWeight = effectiveStyle?.fontWeight;

    final effectiveBaseStyle = (baseStyle ?? const TextStyle(fontSize: 17.5, color: Color(0xFF0F172A), fontFamily: 'Noto Serif JP')).copyWith(
      color: customColor ?? (baseStyle?.color),
      fontWeight: isSelected ? FontWeight.bold : (customWeight ?? baseStyle?.fontWeight),
    );

    final effectiveAnnotationStyle = (annotationStyle ?? 
        const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.normal, fontFamily: 'Plus Jakarta Sans')).copyWith(
          color: customColor?.withValues(alpha: 0.6) ?? (annotationStyle?.color),
        );

    final bool isPunctuation = RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(baseText.trim());

    final Widget baseTextWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: (isSelected && word.isClickable && !isPunctuation) ? 2 : 0, 
        vertical: 1
      ),
      decoration: BoxDecoration(
        color: (isSelected && word.isClickable && !isPunctuation) 
            ? (hasNoTranslation ? const Color(0xFFE2E8F0) : const Color(0xFF3B66F5).withValues(alpha: 0.12))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(baseText, style: effectiveBaseStyle),
    );

    final Widget mainContent = annotationText == null || annotationText.isEmpty
        ? baseTextWidget
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  annotationText,
                  style: effectiveAnnotationStyle,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
              baseTextWidget,
            ],
          );

    final playerState = ref.watch(playerProvider);
    final bool canTap = word.isClickable && (!playerState.isFullscreen || playerState.isLocked);

    final Widget gestureContent = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: canTap ? () async {
        final currentHighlighted = ref.read(highlightedWordIdsProvider);
        final selectionAnchor = ref.read(selectionAnchorTypeProvider);
        final playerNotifier = ref.read(playerProvider.notifier);
        
        if (currentHighlighted.contains(word.id) && selectionAnchor == SelectionAnchor.word) {
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
          ref.read(clickedWordIdProvider.notifier).state = word.id;
          ref.read(selectionAnchorTypeProvider.notifier).state = SelectionAnchor.word;
          
          final index = await ref.read(phraseLinkIndexProvider(word.phraseId ?? 0).future);
          final linked = index.getLinkedIdsForWord(word.id);
          
          ref.read(highlightedWordIdsProvider.notifier).state = linked['words']!;
          ref.read(highlightedTranslationIdsProvider.notifier).state = linked['translations']!;
          
          // Also set the clicked translation ID if a link exists for popover content
          if (linked['translations']!.isNotEmpty) {
            ref.read(clickedTranslationWordIdProvider.notifier).state = linked['translations']!.first;
          } else {
            ref.read(clickedTranslationWordIdProvider.notifier).state = null;
          }
        }
      } : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: mainContent,
      ),
    );

    if (isAnchor) {
      return CompositedTransformTarget(
        link: ref.watch(blockLayerLinkProvider),
        child: gestureContent,
      );
    }
    
    return gestureContent;
  }
}
