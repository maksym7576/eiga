import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/services/reading_type_provider.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'components/shimmer_text.dart';
import 'subtitle_text_content.dart';
import '../../../utils/ui/scaling_utils.dart';

class WindowedSubtitle extends ConsumerWidget {
  final Phrase phrase;
  final bool isPast;
  final String playerScope;

  const WindowedSubtitle({
    super.key,
    required this.phrase,
    this.isPast = false,
    this.playerScope = 'main',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiStatus = phrase.uiStatus;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Priority 1: If we have ANY content (original or translation), show it via rich content
        if ((phrase.originalPhrase != null && phrase.originalPhrase!.isNotEmpty) || 
            (phrase.translatedPhrase != null && phrase.translatedPhrase!.isNotEmpty)) {
          
          final Color textColor = isPast ? const Color(0xFF94A3B8) : const Color(0xFF0F172A);
          final isProcessing = uiStatus.isProcessing;
          final content = _buildTranslatedContent(context, ref, constraints.maxWidth);

          if (isProcessing) {
            return ShimmerText(
              // Using srcATop to keep the original text colors (word statuses)
              // but overlay the shimmer highlight
              blendMode: BlendMode.srcATop,
              shimmerColors: [
                Colors.transparent,
                Colors.transparent,
                const Color(0xFF3B66F5).withValues(alpha: 0.6),
                const Color(0xFF3B66F5).withValues(alpha: 0.8),
                const Color(0xFF3B66F5).withValues(alpha: 0.6),
                Colors.transparent,
                Colors.transparent,
              ],
              child: content,
            );
          }
          return content;
        }

        // Priority 2: Standard stages workflow with raw text items
        final activeStageKey = uiStatus.activeStageKey;
        final hasFailed = uiStatus.isError;

        if (hasFailed) {
          return Text(
            'Failed processing text',
            style: TextStyle(
              fontSize: SubtitleScaling.calculateFontSize(constraints.maxWidth, 15),
              color: Colors.redAccent,
              fontWeight: FontWeight.w500,
            ),
          );
        }

        // When it is processing/translating and there is no text yet, just display the shimmering loading line
        return _buildShimmerLine(constraints.maxWidth);
      },
    );
  }

  Widget _buildShimmerLine(double maxWidth) {
    return ShimmerText(
      shimmerColors: const [
        Color(0xFFE2E8F0),
        Color(0xFFE2E8F0),
        Color(0xFF3B66F5),
        Color(0xFFE2E8F0),
        Color(0xFFE2E8F0),
      ],
      child: Container(
        width: maxWidth * 0.7,
        height: 6,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildTranslatedContent(BuildContext context, WidgetRef ref, double maxWidth) {
    final readingState = ref.watch(readingTypeNotifierProvider).value;
    final mainOpt = readingState?.mainOption ?? 'original';
    final addOpt = readingState?.additionalOption;
    final showTranslation = readingState?.showTranslation ?? true;
    
    final settings = ref.watch(subtitleSettingsProvider);

    final Color textColor = isPast ? const Color(0xFF94A3B8) : const Color(0xFF0F172A);

    return SubtitleTextContent(
      phrase: phrase,
      mainOption: mainOpt,
      additionalOption: addOpt,
      showTranslation: showTranslation,
      baseFontSize: SubtitleScaling.calculateFontSize(maxWidth, settings.windowed.fontSize),
      textColor: textColor,
      useShadows: false,
      isFullscreen: false,
      playerScope: playerScope,
    );
  }
}
