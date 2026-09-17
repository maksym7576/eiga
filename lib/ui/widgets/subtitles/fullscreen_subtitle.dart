import 'package:eiga/ui/widgets/subtitles/components/shimmer_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/services/reading_type_provider.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'subtitle_text_content.dart';
import '../../utils/scaling_utils.dart';

class FullscreenSubtitle extends ConsumerWidget {
  const FullscreenSubtitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final isFullscreen = playerState.isFullscreen;
    
    // Subtitles are ONLY visible in fullscreen mode when over the player.
    // In windowed mode, they are shown in the phrase list below.
    if (!isFullscreen) return const SizedBox.shrink();
    
    final activePhraseId = ref.watch(activePhraseIdProvider);
    if (activePhraseId == null) return const SizedBox.shrink();

    final activePhrase = ref.watch(activePhraseProvider);
    if (activePhrase == null) return const SizedBox.shrink();

    final readingState = ref.watch(readingTypeNotifierProvider).value;
    final mainOpt = readingState?.mainOption ?? 'original';
    final addOpt = readingState?.additionalOption;
    final showTranslation = readingState?.showTranslation ?? true;

    final settings = ref.watch(subtitleSettingsProvider);
    final scaleFactor = ref.watch(fullscreenSubtitleFontSizeProvider);
    
    final highlightedWords = ref.watch(highlightedWordIdsProvider);
    final highlightedTranslations = ref.watch(highlightedTranslationIdsProvider);
    final bool isBlockSelected = highlightedWords.isNotEmpty || highlightedTranslations.isNotEmpty;

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = SubtitleScaling.calculateFontSize(constraints.maxWidth, scaleFactor);
          
          // Adjust alignment: in windowed mode, move it higher up to avoid overlapping player controls
          final double effectiveY = isFullscreen 
              ? (1.0 - (settings.verticalOffset * 2.0))
              : (0.75 - (settings.verticalOffset * 1.5));

          return Align(
            alignment: Alignment(0.0, effectiveY),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isFullscreen ? 24.0 : 16.0,
                vertical: isFullscreen ? 0 : 8.0,
              ),
              child: GestureDetector(
                onTap: () {
                  if (isBlockSelected) {
                    ref.read(playerProvider.notifier).clearSelection();
                  } else {
                    ref.read(playerProvider.notifier).togglePlaying();
                    ref.read(playerProvider.notifier).resetHideTimer();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(SubtitleScaling.calculateFontSize(constraints.maxWidth, settings.backdropPadding)),
                  decoration: BoxDecoration(
                    color: settings.showBackdrop
                        ? Colors.black.withValues(alpha: settings.backdropOpacity)
                        : (isFullscreen ? Colors.transparent : Colors.black54),
                    borderRadius: BorderRadius.circular(SubtitleScaling.calculateFontSize(constraints.maxWidth, 12) / 2.3),
                  ),
                  child: _buildBody(activePhrase, mainOpt, addOpt, showTranslation, fontSize, isFullscreen),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildBody(Phrase phrase, String mainOpt, String? addOpt, bool showTranslation, double fontSize, bool isFullscreen) {
    final uiStatus = phrase.uiStatus;
    final isMorphologyRunning = uiStatus.activeStageKey == StageKey.morphology;
    
    final content = SubtitleTextContent(
      phrase: phrase,
      mainOption: mainOpt,
      additionalOption: addOpt,
      showTranslation: showTranslation,
      baseFontSize: fontSize,
      textAlign: TextAlign.center,
      textColor: Colors.white,
      useShadows: true,
      isFullscreen: isFullscreen,
    );

    if (isMorphologyRunning) {
      return ShimmerText(
        shimmerColors: const [
          Colors.white,
          Colors.white,
          Color(0xFF3B66F5),
          Colors.white,
          Colors.white,
        ],
        child: content,
      );
    }
    return content;
  }
}
