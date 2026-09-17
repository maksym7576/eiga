import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../backend/database/schemas/specific_word_style.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import '../../styles/app_colors.dart';

class RubyText extends HookConsumerWidget {
  final TokenEntry word;
  final int phraseId;
  final PhraseLinkIndex index;
  final String mainOption;
  final String? additionalOption;
  final TextStyle? baseStyle;
  final TextStyle? annotationStyle;
  final SpecificWordStyle? style;
  final int? blockId;
  final bool isFirstInBlock;
  final bool isLastInBlock;
  final bool isFullscreen;
  final bool isHighlighted;
  final bool isAnchor;
  final bool isLocked;
  final SelectionAnchor? selectionAnchorType;
  final LayerLink? selectionLayerLink;

  const RubyText({
    super.key,
    required this.word,
    required this.phraseId,
    required this.index,
    required this.mainOption,
    this.additionalOption,
    this.baseStyle,
    this.annotationStyle,
    this.style,
    this.blockId,
    this.isFirstInBlock = true,
    this.isLastInBlock = true,
    this.isFullscreen = false,
    required this.isHighlighted,
    required this.isAnchor,
    required this.isLocked,
    this.selectionAnchorType,
    this.selectionLayerLink,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (word.versions.isEmpty) return const SizedBox.shrink();

    String baseText = '';
    String? annotationText;

    String? getTextForOption(String opt) {
      if (opt == 'translation') return null;
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
        final pattern = RegExp(r'[^\p{L}\p{N}\s]', unicode: true);
        annotationText = annotationText.replaceAll(pattern, '');
        if (annotationText.trim() == baseText.trim()) annotationText = null;
      }
    }

    final effectiveBaseStyle = (baseStyle ?? const TextStyle()).copyWith(
      color: style?.color ?? baseStyle?.color,
      fontWeight: (isHighlighted) ? FontWeight.w900 : (style?.fontWeight ?? baseStyle?.fontWeight),
    );

    final bool isPunctuation = RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(baseText.trim());

    final bool showHighlight = isHighlighted && word.isClickable && !isPunctuation;

    final Widget baseTextWidget = Container(
      key: ValueKey('ruby_base_${word.id}_$isHighlighted'),
      padding: EdgeInsets.symmetric(
        horizontal: isPunctuation ? 0 : 3, 
        vertical: 1
      ),
      decoration: BoxDecoration(
        color: showHighlight
            ? (isFullscreen 
                ? const Color(0xFF3B66F5).withValues(alpha: 0.4)
                : AppColors.brandBlue.withValues(alpha: 0.35))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: showHighlight
              ? (isFullscreen 
                  ? const Color(0xFF3B66F5).withValues(alpha: 0.6)
                  : AppColors.brandBlue.withValues(alpha: 0.5))
              : Colors.transparent,
          width: isPunctuation ? 0 : 1.2,
        ),
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
                  style: annotationStyle,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
              baseTextWidget,
            ],
          );

    final bool canTap = word.isClickable && (!isFullscreen || isLocked);

    Widget gestureContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: mainContent,
    );

    if (canTap) {
      gestureContent = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final playerNotifier = ref.read(playerProvider.notifier);
          
          if (isHighlighted && selectionAnchorType == SelectionAnchor.word) {
            playerNotifier.clearSelection();
          } else {
            // Instant position calculation
            final RenderBox? box = context.findRenderObject() as RenderBox?;
            final position = box != null && box.hasSize 
                ? box.localToGlobal(Offset(box.size.width / 2, 0))
                : null;

            final linked = index.getLinkedIdsForWord(word.id);
            int? tId;
            if (linked['translations']!.isNotEmpty) {
              tId = linked['translations']!.first;
            }

            playerNotifier.selectWord(
              phraseId,
              word.id, 
              linked['words']!, 
              linked['translations']!, 
              tId,
              shouldPause: true,
              position: position,
            );
          }
        },
        child: gestureContent,
      );
    }

    if (isAnchor && selectionLayerLink != null) {
      return CompositedTransformTarget(
        link: selectionLayerLink!,
        child: gestureContent,
      );
    }
    
    return gestureContent;
  }
}
