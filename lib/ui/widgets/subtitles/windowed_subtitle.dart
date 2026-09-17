import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/services/reading_type_provider.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'components/shimmer_text.dart';
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

        // Priority 2: Standard stages workflow with raw text items
        final activeStageKey = uiStatus.activeStageKey;
        final hasFailed = uiStatus.isError;

        String labelText = '';
        bool isPulse = false;

        if (hasFailed) {
          labelText = 'Failed processing text';
        } else {
          switch (activeStageKey) {
            case StageKey.translation:
              labelText = 'Translating sentence...';
              isPulse = true;
              break;
            case StageKey.morphology:
              labelText = 'Analyzing grammar structures...';
              isPulse = true;
              break;
            case StageKey.tokenizeSource:
              labelText = 'Tokenizing source...';
              isPulse = true;
              break;
            case StageKey.tokenizeTranslation:
              labelText = 'Tokenizing translation...';
              isPulse = true;
              break;
            default:
              labelText = phrase.originalPhrase ?? 'Processing audio timeline...';
              break;
          }
        }

        final Widget textWidget = Text(
          labelText,
          style: TextStyle(
            fontSize: SubtitleScaling.calculateFontSize(constraints.maxWidth, 15),
            color: hasFailed 
                ? Colors.redAccent 
                : (isPast ? Colors.black38 : const Color(0xFF334155)),
            fontWeight: isPast ? FontWeight.normal : FontWeight.w500,
          ),
        );

        if (isPulse) {
          return ShimmerText(
            shimmerColors: const [
              Color(0xFF64748B),
              Color(0xFF64748B),
              Color(0xFF3B66F5),
              Color(0xFF64748B),
              Color(0xFF64748B),
            ],
            child: textWidget,
          );
        }

        return textWidget;
      },
    );
  }

  Widget _buildTranslatedContent(BuildContext context, WidgetRef ref, double maxWidth) {
    final readingState = ref.watch(readingTypeNotifierProvider).value;
    final mainOpt = readingState?.mainOption ?? 'original';
    final addOpt = readingState?.additionalOption;
    final showTranslation = readingState?.showTranslation ?? true;
    
    final settings = ref.watch(subtitleSettingsProvider);

    return SubtitleTextContent(
      phrase: phrase,
      mainOption: mainOpt,
      additionalOption: addOpt,
      showTranslation: showTranslation,
      baseFontSize: SubtitleScaling.calculateFontSize(maxWidth, settings.windowed.fontSize),
      textColor: isPast ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
      useShadows: false,
      isFullscreen: false,
    );
  }
}
