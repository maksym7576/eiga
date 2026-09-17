import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/services/reading_type_provider.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'shimmer_text.dart';
import 'subtitle_text_content.dart';
import '../../utils/scaling_utils.dart';

class WindowedSubtitle extends ConsumerWidget {
  final Phrase phrase;
  final bool isPast;

  const WindowedSubtitle({
    super.key,
    required this.phrase,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiStatus = phrase.uiStatus;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Priority 1: If we have a translation text, show it using the rich content widget
        if (phrase.translatedPhrase != null && phrase.translatedPhrase!.isNotEmpty) {
          final isMorphologyRunning = uiStatus.activeStageKey == StageKey.morphology;
          
          final content = _buildTranslatedContent(context, ref, constraints.maxWidth);
          if (isMorphologyRunning) {
            return ShimmerText(child: content);
          }
          return content;
        } 
        
        // Priority 2: If no text yet, but the pipeline is active
        if (uiStatus.isProcessing) {
          return _buildTranslatingContent(context, ref, constraints.maxWidth, uiStatus.activeStageKey);
        } 
        
        // Priority 3: Fully completed (redundant but safe)
        if (uiStatus.isDone) {
          return _buildTranslatedContent(context, ref, constraints.maxWidth);
        } 
        
        // Fallback: Queued or Untranslated
        return _buildQueuedContent(context, ref, constraints.maxWidth);
      },
    );
  }

  Widget _buildTranslatingContent(BuildContext context, WidgetRef ref, double width, String? activeStageKey) {
    final hasTranslation = phrase.translatedPhrase != null && phrase.translatedPhrase!.isNotEmpty;
    final scaleFactor = ref.watch(sidebarSubtitleFontSizeProvider);
    final fontSize = SubtitleScaling.calculateFontSize(width, scaleFactor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerText(
          child: Text(
            phrase.originalPhrase ?? '',
            style: TextStyle(
              fontFamily: 'Noto Serif JP',
              fontSize: fontSize,
              height: 1.8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (hasTranslation)
          ShimmerText(
            child: Text(
              phrase.translatedPhrase!,
              style: TextStyle(
                fontSize: fontSize * 0.75,
                color: const Color(0xFF64748B),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Container(
            height: fontSize * 0.6,
            width: width * 0.6,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
      ],
    );
  }

  Widget _buildQueuedContent(BuildContext context, WidgetRef ref, double width) {
    final scaleFactor = ref.watch(sidebarSubtitleFontSizeProvider);
    final fontSize = SubtitleScaling.calculateFontSize(width, scaleFactor);
    final settings = ref.watch(subtitleSettingsProvider);
    
    return Text(
      phrase.originalPhrase ?? '',
      style: TextStyle(
        fontFamily: 'Noto Serif JP',
        fontSize: fontSize * settings.windowed.originalScale,
        color: const Color(0xFF0F172A),
        height: 1.8,
        fontWeight: FontWeight.w700,
        letterSpacing: settings.windowed.originalLetterSpacing,
      ),
    );
  }

  Widget _buildTranslatedContent(BuildContext context, WidgetRef ref, double width) {
    final readingState = ref.watch(readingTypeNotifierProvider).value;
    final mainOpt = readingState?.mainOption ?? 'original';
    final addOpt = readingState?.additionalOption;
    final showTranslation = readingState?.showTranslation ?? true;
    
    final scaleFactor = ref.watch(sidebarSubtitleFontSizeProvider);
    final fontSize = SubtitleScaling.calculateFontSize(width, scaleFactor);

    return SubtitleTextContent(
      phrase: phrase,
      mainOption: mainOpt,
      additionalOption: addOpt,
      showTranslation: showTranslation,
      baseFontSize: fontSize,
      textColor: const Color(0xFF0F172A),
      useShadows: false,
      isFullscreen: false,
    );
  }
}
