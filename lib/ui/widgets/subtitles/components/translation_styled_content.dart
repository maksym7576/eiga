import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../backend/database/schemas/phrase.dart';
import '../../../../backend/database/schemas/user_word_status.dart';
import '../../../../config/ui/word_styles.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'outlined_text.dart';
import 'shimmer_text.dart';

class TranslationStyledContent extends HookConsumerWidget {
  final Phrase phrase;
  final PhraseLinkIndex index;
  final Map<String, UserWordStatus> statusMap;
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
  final Set<int> hiddenTranslationIds;
  final String playerScope;

  const TranslationStyledContent({
    super.key,
    required this.phrase,
    required this.index,
    required this.statusMap,
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
    this.hiddenTranslationIds = const {},
    this.playerScope = 'main',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hideBrackets = ref.watch(appConfigsServiceProvider.select((c) => c.getHideParenthesesContent));

    List<TranslationTokenEntry> tokens = phrase.translatedWords ?? [];

    final settings = ref.watch(subtitleSettingsProvider);
    final modeSettings = isFullscreen ? settings.fullscreen : settings.windowed;
    
    final double computedOutlineWidth = useShadows 
        ? (baseFontSize * 0.05) * modeSettings.translationOutlineWidth 
        : 0.0;

    if (hideBrackets) {
      tokens = tokens.where((t) => !hiddenTranslationIds.contains(t.translatedWordPosition)).toList();
    }

    if (tokens.isEmpty) {
      String text = phrase.translatedPhrase ?? '';
      if (hideBrackets) {
        final bracketRegExp = RegExp(r'[([{（［｛].*?[)]}）］｝]');
        text = text.replaceAll(bracketRegExp, '').trim();
      }
      
      if (text.isEmpty) {
        // If we are in the middle of active processing, show the current stage label
        if (phrase.uiStatus.isProcessing) {

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
              margin: EdgeInsets.only(top: baseFontSize * 0.25, bottom: baseFontSize * 0.1),
              padding: EdgeInsets.symmetric(horizontal: baseFontSize * 0.4, vertical: baseFontSize * 0.1),
              decoration: BoxDecoration(
                color: isFullscreen ? Colors.black26 : Colors.black.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isFullscreen 
                ? OutlinedText(
                    text: 'Translating...',
                    useOutline: true,
                    outlineWidth: baseFontSize * 0.05,
                    outlineColor: Colors.black.withValues(alpha: 0.8),
                    style: TextStyle(
                      fontSize: baseFontSize * 0.8,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const SizedBox.shrink(),
            ),
          );
        }
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: baseFontSize * 0.15, vertical: baseFontSize * 0.05),
        child: OutlinedText(
          text: text,
          textAlign: textAlign,
          useOutline: useShadows,
          outlineWidth: computedOutlineWidth,
          outlineColor: isFullscreen ? Colors.black.withValues(alpha: 0.8) : Colors.black,
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

        WordStatus? wordStatus;
        if (lemma != null) {
          wordStatus = statusMap[lemma]?.status;
        }

        return _TranslationTokenWidget(
          key: ValueKey('token_${phrase.id}_${token.translatedWordPosition}'),
          token: token,
          index: index,
          lemma: lemma,
          status: wordStatus,
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
          playerScope: playerScope,
        );
      }).toList(),
    );
  }
}

class _TranslationTokenWidget extends HookConsumerWidget {
  final TranslationTokenEntry token;
  final PhraseLinkIndex index;
  final String? lemma;
  final WordStatus? status;
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
  final String playerScope;

  const _TranslationTokenWidget({
    super.key,
    required this.token,
    required this.index,
    this.lemma,
    this.status,
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
    required this.playerScope,
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
        outlineColor: isFullscreen ? Colors.black.withValues(alpha: 0.8) : Colors.black,
        style: TextStyle(
          fontSize: baseFontSize * modeSettings.translationScale,
          color: status?.color ?? (isFullscreen ? Colors.white : textColor.withValues(alpha: isPunctuation ? 0.95 : ((isHighlighted && !isPunctuation) ? 1.0 : 0.85))),
          fontWeight: useOutline ? FontWeight.w800 : ((isHighlighted && !isPunctuation) ? FontWeight.w800 : (status != null ? WordStatusUI(status!).fontWeight : FontWeight.w700)),
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
          final playerNotifier = ref.read(playerProvider(playerScope).notifier);
          
          if (isAnchor) {
            playerNotifier.clearSelection();
          } else {
            final RenderBox? box = context.findRenderObject() as RenderBox?;
            final position = box != null && box.hasSize 
                ? box.localToGlobal(Offset(box.size.width / 2, 0))
                : null;

            final linked = index.getLinkedIdsForWord(token.translatedWordPosition ?? 0);
            int? tId;
            if (linked['translations']!.isNotEmpty) {
              tId = linked['translations']!.first;
            }

            playerNotifier.selectWord(
              phraseId,
              token.translatedWordPosition ?? 0, 
              linked['words']!, 
              linked['translations']!, 
              tId,
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
