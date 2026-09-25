import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../backend/database/schemas/phrase.dart';
import '../../../../config/ui/word_styles.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import '../../../styles/app_colors.dart';
import 'outlined_text.dart';

class RubyText extends HookConsumerWidget {
  final TokenEntry word;
  final int phraseId;
  final PhraseLinkIndex index;
  final String mainOption;
  final String? additionalOption;
  final TextStyle? baseStyle;
  final TextStyle? annotationStyle;
  final WordStatus? status;
  final int? blockId;
  final bool isFirstInBlock;
  final bool isLastInBlock;
  final bool isFullscreen;
  final bool isHighlighted;
  final bool isAnchor;
  final bool isLocked;
  final bool removeSpaces;
  final bool useShadows;
  final double outlineWidth;
  final SelectionAnchor? selectionAnchorType;
  final LayerLink? selectionLayerLink;
  final String playerScope;

  const RubyText({
    super.key,
    required this.word,
    required this.phraseId,
    required this.index,
    required this.mainOption,
    this.additionalOption,
    this.baseStyle,
    this.annotationStyle,
    this.status,
    this.blockId,
    this.isFirstInBlock = true,
    this.isLastInBlock = true,
    this.isFullscreen = false,
    required this.isHighlighted,
    required this.isAnchor,
    required this.isLocked,
    this.removeSpaces = false,
    this.useShadows = false,
    this.outlineWidth = 0.0,
    this.selectionAnchorType,
    this.selectionLayerLink,
    this.playerScope = 'main',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (word.versions.isEmpty) return const SizedBox.shrink();

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;

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

    // Map 0.0-1.0 to FontWeight 100-900
    FontWeight weightFromSettings = FontWeight.values[((modeSettings.fontWeight * 8).round())];
    
    final effectiveBaseStyle = (baseStyle ?? const TextStyle()).copyWith(
      color: status?.color ?? baseStyle?.color,
      fontWeight: (isHighlighted)
          ? FontWeight.w900
          : (status != null ? WordStatusUI(status!).fontWeight : weightFromSettings),
    );

    final bool isPunctuation =
    RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(baseText.trim());

    final bool showHighlight = isHighlighted && word.isClickable && !isPunctuation;

    final double fs = baseStyle?.fontSize ?? 16.0;

    // Єдиний відступ: пропуск між словами, тільки для мов з пробілами.
    // Для японської (removeSpaces) і для пунктуації він дорівнює 0.
    final double rightPadding = (isPunctuation || removeSpaces) ? 0.0 : fs * 0.25;

    // Рамка винесена у foregroundDecoration, щоб вона не збільшувала розмір віджета.
    final Widget baseTextWidget = Container(
      key: ValueKey('ruby_base_${word.id}_$isHighlighted'),
      padding: EdgeInsets.only(right: rightPadding),
      decoration: BoxDecoration(
        color: showHighlight
            ? (isFullscreen
            ? const Color(0xFF3B66F5).withValues(alpha: 0.4)
            : AppColors.brandBlue.withValues(alpha: 0.35))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      foregroundDecoration: BoxDecoration(
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
      child: OutlinedText(
        text: baseText,
        style: effectiveBaseStyle,
        useOutline: useShadows,
        outlineWidth: outlineWidth,
        outlineColor: isFullscreen ? Colors.black.withValues(alpha: 0.8) : Colors.black,
      ),
    );

    // Відступ між original і additional повністю з налаштувань.
    final double annotationSpacing = fs * 0.2 * modeSettings.originalToAdditionalSpacing;

    final Widget mainContent = annotationText == null || annotationText.isEmpty
        ? baseTextWidget
        : Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OutlinedText(
          text: annotationText,
          style: annotationStyle ?? const TextStyle(),
          maxLines: 1,
          overflow: TextOverflow.clip,
          useOutline: useShadows,
          outlineWidth: outlineWidth * 0.6,
          outlineColor: isFullscreen ? Colors.black.withValues(alpha: 0.8) : Colors.black,
        ),
        if (annotationSpacing > 0) SizedBox(height: annotationSpacing),
        baseTextWidget,
      ],
    );

    final bool canTap = word.isClickable && (!isFullscreen || isLocked);

    Widget gestureContent = mainContent;

    if (canTap) {
      gestureContent = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final playerNotifier = ref.read(playerProvider(playerScope).notifier);

          if (isAnchor) {
            playerNotifier.clearSelection();
          } else {
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