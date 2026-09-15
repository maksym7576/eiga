import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/word.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import '../../styles/app_colors.dart';

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
  final bool isFullscreen;

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
    this.isFullscreen = false,
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
            ref.read(playerProvider.notifier).setClickedWordPosition(position);
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

        // Fix: Skip rendering the annotation if it's identical to the base text
        // (common with Japanese particles like 'wa' or 'kara')
        if (annotationText.trim() == baseText.trim()) {
          annotationText = null;
        }
      }
    }

    final wordStyleAsync = ref.watch(wordStyleProvider(word.lemma ?? ''));
    final blockStyleAsync = blockId != null ? ref.watch(blockStyleProvider(blockId!)) : const AsyncValue<SpecificWordStyle?>.data(null);
    
    // Priority: Block Style > Individual Word Style > Default (style prop)
    final effectiveStyle = blockStyleAsync.maybeWhen(data: (s) => s, orElse: () => null) ?? 
                           wordStyleAsync.maybeWhen(data: (s) => s, orElse: () => style);

    final Color? customColor = effectiveStyle?.color;
    final FontWeight? customWeight = effectiveStyle?.fontWeight;

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;

    final effectiveBaseStyle = (baseStyle ?? TextStyle(fontSize: 17.5, color: isFullscreen ? Colors.white : const Color(0xFF0F172A), fontFamily: 'Noto Serif JP')).copyWith(
      color: customColor ?? (baseStyle?.color),
      fontSize: (baseStyle?.fontSize ?? 17.5) * modeSettings.originalScale,
      fontWeight: (baseStyle?.shadows != null) ? FontWeight.w900 : (isSelected ? FontWeight.w900 : (customWeight ?? baseStyle?.fontWeight)),
      letterSpacing: modeSettings.letterSpacing,
    );

    final effectiveAnnotationStyle = (annotationStyle ?? 
        TextStyle(fontSize: 9.5, color: isFullscreen ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF94A3B8), fontWeight: FontWeight.normal, fontFamily: 'Plus Jakarta Sans')).copyWith(
          color: customColor?.withValues(alpha: 0.6) ?? (annotationStyle?.color),
          fontSize: (annotationStyle?.fontSize ?? 9.5) * modeSettings.additionalScale,
          letterSpacing: modeSettings.letterSpacing,
        );

    final bool isPunctuation = RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(baseText.trim());

    final Widget baseTextWidget = Container(
      key: ValueKey('ruby_base_${word.id}_${isSelected}_${effectiveBaseStyle.fontSize}'),
      padding: EdgeInsets.symmetric(
        horizontal: (isSelected && word.isClickable && !isPunctuation) ? 3 : 0, 
        vertical: 1
      ),
      decoration: BoxDecoration(
        color: (isSelected && word.isClickable && !isPunctuation) 
            ? (isFullscreen 
                ? const Color(0xFF3B66F5).withValues(alpha: 0.4)
                : (hasNoTranslation 
                    ? const Color(0xFFE2E8F0).withValues(alpha: 0.8) 
                    : AppColors.brandBlue.withValues(alpha: 0.35)))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: (isSelected && word.isClickable && !isPunctuation)
            ? Border.all(
                color: isFullscreen 
                    ? const Color(0xFF3B66F5).withValues(alpha: 0.6)
                    : (hasNoTranslation 
                        ? Colors.black12 
                        : AppColors.brandBlue.withValues(alpha: 0.5)),
                width: 1.2,
              )
            : null,
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
    // Rule: Tap allowed in windowed mode OR if locked in fullscreen
    final bool canTap = word.isClickable && (!playerState.isFullscreen || playerState.isLocked);

    Widget gestureContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: mainContent,
    );

    if (canTap) {
      gestureContent = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          final playerState = ref.read(playerProvider);
          final playerNotifier = ref.read(playerProvider.notifier);
          
          if (playerState.highlightedWordIds.contains(word.id) && playerState.selectionAnchorType == SelectionAnchor.word) {
            // Deselect
            playerNotifier.clearSelection();
          } else {
            // Select instantly using synchronous/cached read where possible
            final indexAsync = ref.read(phraseLinkIndexProvider(word.phraseId ?? 0));
            indexAsync.whenData((index) {
              final linked = index.getLinkedIdsForWord(word.id);
              int? tId;
              if (linked['translations']!.isNotEmpty) {
                tId = linked['translations']!.first;
              }

              playerNotifier.selectWord(
                word.id, 
                linked['words']!, 
                linked['translations']!, 
                tId,
                shouldPause: true,
              );
            });

            // Fallback if future isn't cached yet
            if (!indexAsync.hasValue) {
              ref.read(phraseLinkIndexProvider(word.phraseId ?? 0).future).then((index) {
                final linked = index.getLinkedIdsForWord(word.id);
                int? tId;
                if (linked['translations']!.isNotEmpty) {
                  tId = linked['translations']!.first;
                }

                playerNotifier.selectWord(
                  word.id, 
                  linked['words']!, 
                  linked['translations']!, 
                  tId,
                  shouldPause: true,
                );
              });
            }
          }
        },
        child: gestureContent,
      );
    }

    if (isAnchor) {
      return CompositedTransformTarget(
        link: ref.watch(blockLayerLinkProvider),
        child: gestureContent,
      );
    }
    
    return gestureContent;
  }
}
