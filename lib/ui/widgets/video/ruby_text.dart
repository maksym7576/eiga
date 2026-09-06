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

    final selectedBlockId = ref.watch(selectedBlockIdProvider);
    final isSelected = blockId != null && selectedBlockId == blockId;
    final clickedWordId = ref.watch(clickedWordIdProvider);

    useEffect(() {
      if (clickedWordId == word.id) {
        // Use post frame callback to ensure RenderBox is ready and laid out
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize) {
            final position = box.localToGlobal(Offset(box.size.width / 2, 0));
            ref.read(clickedWordPositionProvider.notifier).state = position;
            print('RUBY: Reactive position update for word ${word.id} at $position');
          }
        });
      }
      return null;
    }, [clickedWordId]);

    if (isSelected) {
      print('RUBY: Building selected word ${word.id} in block $blockId. Style: ${style?.name}');
    }

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

    final Color? customColor = style?.color;
    final FontWeight? customWeight = style?.fontWeight;

    final effectiveBaseStyle = (baseStyle ?? const TextStyle(fontSize: 17.5, color: Color(0xFF0F172A), fontFamily: 'Noto Serif JP')).copyWith(
      color: customColor ?? (baseStyle?.color),
      fontWeight: isSelected ? FontWeight.bold : (customWeight ?? baseStyle?.fontWeight),
    );

    final effectiveAnnotationStyle = (annotationStyle ?? 
        const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.normal, fontFamily: 'Plus Jakarta Sans')).copyWith(
          color: customColor?.withValues(alpha: 0.6) ?? (annotationStyle?.color),
        );

    final Widget mainContent = annotationText == null || annotationText.isEmpty
        ? Text(baseText, style: effectiveBaseStyle)
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
              Text(
                baseText,
                style: effectiveBaseStyle,
              ),
            ],
          );

    return GestureDetector(
      onTap: () {
        if (blockId != null) {
          final currentBlock = ref.read(selectedBlockIdProvider);
          final currentWord = ref.read(clickedWordIdProvider);
          
          if (currentBlock == blockId && currentWord == word.id) {
            ref.read(selectedBlockIdProvider.notifier).state = null;
            ref.read(clickedWordIdProvider.notifier).state = null;
            ref.read(clickedWordPositionProvider.notifier).state = null;
            // Resume playback when deselecting
            ref.read(playerProvider.notifier).setPlaying(true);
          } else {
            // Auto-pause video when selecting
            ref.read(playerProvider.notifier).setPlaying(false);
            
            ref.read(selectedBlockIdProvider.notifier).state = blockId;
            ref.read(clickedWordIdProvider.notifier).state = word.id;
          }
        }
      },
      child: _buildBody(isSelected, mainContent),
    );
  }

  Widget _buildBody(bool isSelected, Widget content) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF3B66F5).withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(isFirstInBlock && isSelected ? 12 : 0),
          right: Radius.circular(isLastInBlock && isSelected ? 12 : 0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2), 
        child: content,
      ),
    );
  }
}
