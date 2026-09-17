import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../backend/database/schemas/phrase.dart';
import '../../../../backend/database/schemas/specific_word_style.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'outlined_text.dart';

class TranslationStyledContent extends HookConsumerWidget {
  final Phrase phrase;
  final PhraseLinkIndex index;
  final Map<String, dynamic> statusMap;
  final Map<int, SpecificWordStyle> stylesMap;
  final Set<int> highlightedTranslationIds;
  final int? clickedTranslationId;
  final SelectionAnchor? anchorType;
  final LayerLink? selectionLayerLink;
  final double baseFontSize;
  final TextAlign textAlign;
  final Color textColor;
  final bool useShadows;
  final bool isFullscreen;
  final bool isLocked;

  const TranslationStyledContent({
    super.key,
    required this.phrase,
    required this.index,
    required this.statusMap,
    required this.stylesMap,
    required this.highlightedTranslationIds,
    this.clickedTranslationId,
    this.anchorType,
    this.selectionLayerLink,
    required this.baseFontSize,
    required this.textAlign,
    required this.textColor,
    required this.useShadows,
    required this.isFullscreen,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = phrase.translatedWords ?? [];

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;
    
    final double computedOutlineWidth = useShadows 
        ? (baseFontSize * 0.05) * modeSettings.translationOutlineWidth 
        : 0.0;

    if (tokens.isEmpty) {
      final text = phrase.translatedPhrase ?? '';
      if (text.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: baseFontSize * 0.15, vertical: baseFontSize * 0.05),
        child: OutlinedText(
          text: text,
          textAlign: textAlign,
          useOutline: useShadows,
          outlineWidth: computedOutlineWidth,
          outlineColor: Colors.black,
          style: TextStyle(
            fontSize: baseFontSize,
            color: isFullscreen ? Colors.white : textColor.withValues(alpha: 0.85),
            fontWeight: useShadows ? FontWeight.w800 : FontWeight.w600,
            height: 1.5,
          ),
        ),
      );
    }

    final originalTokens = phrase.originalTokens ?? [];
    final wordPosMap = {for (final w in originalTokens) if (w.wordPosition != null) w.wordPosition!: w};

    return Wrap(
      key: ValueKey('tokens_wrap_${phrase.id}'),
      alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
      spacing: baseFontSize * 0.05, 
      runSpacing: baseFontSize * 0.1, 
      children: tokens.map((token) {
        final tokenText = token.text ?? '';
        final isHighlighted = highlightedTranslationIds.contains(token.translatedWordPosition);
        final bool isAnchor = anchorType == SelectionAnchor.translation && token.translatedWordPosition == clickedTranslationId;
        final bool isPunctuation = RegExp(r'^[\p{P}\p{S}]+$', unicode: true).hasMatch(tokenText.trim());

        String? lemma;
        if (token.sourceWordPositions.isNotEmpty) {
          lemma = wordPosMap[token.sourceWordPositions.first]?.lemma;
        } else if (token.blockId != null) {
          lemma = originalTokens.where((w) => w.blockId == token.blockId).firstOrNull?.lemma;
        }

        SpecificWordStyle? wordStyle;
        if (lemma != null) {
          final status = statusMap[lemma];
          if (status?.styleId != null) wordStyle = stylesMap[status!.styleId!];
        }

        return _TranslationTokenWidget(
          key: ValueKey('token_${phrase.id}_${token.translatedWordPosition}'),
          token: token,
          index: index,
          lemma: lemma,
          style: wordStyle,
          phraseId: phrase.id,
          isHighlighted: isHighlighted,
          isAnchor: isAnchor,
          isPunctuation: isPunctuation,
          baseFontSize: baseFontSize,
          textColor: textColor,
          useOutline: useShadows,
          outlineWidth: computedOutlineWidth,
          isFullscreen: isFullscreen,
          isLocked: isLocked,
          selectionAnchorType: anchorType,
          selectionLayerLink: selectionLayerLink,
          modeSettings: modeSettings,
        );
      }).toList(),
    );
  }
}

class _TranslationTokenWidget extends HookConsumerWidget {
  final TranslationTokenEntry token;
  final PhraseLinkIndex index;
  final String? lemma;
  final SpecificWordStyle? style;
  final int phraseId;
  final bool isHighlighted;
  final bool isAnchor;
  final bool isPunctuation;
  final double baseFontSize;
  final Color textColor;
  final bool useOutline;
  final double outlineWidth;
  final bool isFullscreen;
  final bool isLocked;
  final SelectionAnchor? selectionAnchorType;
  final LayerLink? selectionLayerLink;
  final dynamic modeSettings;

  const _TranslationTokenWidget({
    super.key,
    required this.token,
    required this.index,
    this.lemma,
    this.style,
    required this.phraseId,
    required this.isHighlighted,
    required this.isAnchor,
    required this.isPunctuation,
    required this.baseFontSize,
    required this.textColor,
    required this.isFullscreen,
    required this.isLocked,
    this.useOutline = false,
    this.outlineWidth = 0.0,
    this.selectionAnchorType,
    this.selectionLayerLink,
    required this.modeSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool canTap = !isFullscreen || isLocked;
    final bool showHighlight = isHighlighted && !isPunctuation;

    Widget tokenContent = Container(
      key: ValueKey('token_bg_${token.translatedWordPosition}_$isHighlighted'),
      padding: EdgeInsets.symmetric(
        horizontal: isPunctuation ? baseFontSize * 0.06 : baseFontSize * 0.15, 
        vertical: baseFontSize * 0.05
      ),
      decoration: BoxDecoration(
        color: showHighlight
            ? (isFullscreen 
                ? const Color(0xFF3B66F5).withValues(alpha: 0.4)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.8))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(baseFontSize * 0.3),
        border: Border.all(
          color: showHighlight
              ? (isFullscreen ? const Color(0xFF3B66F5).withValues(alpha: 0.6) : Colors.black12)
              : Colors.transparent,
          width: isPunctuation ? 0 : baseFontSize * 0.06,
        ),
      ),
      child: OutlinedText(
        text: token.text ?? '',
        useOutline: useOutline,
        outlineWidth: outlineWidth,
        outlineColor: Colors.black,
        style: TextStyle(
          fontSize: baseFontSize * modeSettings.translationScale,
          color: style?.color ?? (isFullscreen ? Colors.white : textColor.withValues(alpha: isPunctuation ? 0.95 : ((isHighlighted && !isPunctuation) ? 1.0 : 0.85))),
          fontWeight: useOutline ? FontWeight.w800 : ((isHighlighted && !isPunctuation) ? FontWeight.w800 : (style?.fontWeight ?? FontWeight.w700)),
          height: 1.5,
          letterSpacing: modeSettings.translationLetterSpacing,
          decoration: TextDecoration.none,
        ),
      ),
    );

    if (!isPunctuation && canTap) {
      tokenContent = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final playerNotifier = ref.read(playerProvider.notifier);
          
          if (isHighlighted && selectionAnchorType == SelectionAnchor.translation) {
            playerNotifier.clearSelection();
          } else {
            final RenderBox? box = context.findRenderObject() as RenderBox?;
            final position = box != null && box.hasSize 
                ? box.localToGlobal(Offset(box.size.width / 2, 0))
                : null;

            final linked = index.getLinkedIdsForTranslation(token.translatedWordPosition ?? 0);
            int? wordId;
            final sourceWords = index.translationToWords[token.translatedWordPosition ?? 0] ?? [];
            if (sourceWords.isNotEmpty) {
              wordId = sourceWords.first.wordPosition;
            }

            playerNotifier.selectTranslation(
              phraseId,
              token.translatedWordPosition ?? 0,
              linked['words']!,
              linked['translations']!,
              wordId,
              shouldPause: true,
              position: position,
            );
          }
        },
        child: tokenContent,
      );
    }

    if (isAnchor && selectionLayerLink != null) {
      return CompositedTransformTarget(
        link: selectionLayerLink!,
        child: tokenContent,
      );
    }

    return tokenContent;
  }
}
