import 'package:eiga/ui/widgets/subtitles/components/shimmer_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/services/reading_type_provider.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'subtitle_text_content.dart';
import '../../../utils/ui/scaling_utils.dart';

class FullscreenSubtitle extends ConsumerWidget {
  const FullscreenSubtitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fine-grained selectors to prevent whole-widget rebuild on every millisecond/position change
    final isFullscreen = ref.watch(playerProvider.select((s) => s.isFullscreen));
    
    // Subtitles are ONLY visible in fullscreen mode when over the player.
    if (!isFullscreen) return const SizedBox.shrink();
    
    final activePhrase = ref.watch(activePhraseProvider);
    if (activePhrase == null) return const SizedBox.shrink();

    final readingState = ref.watch(readingTypeNotifierProvider).value;
    final mainOpt = readingState?.mainOption ?? 'original';
    final addOpt = readingState?.additionalOption;
    final showTranslation = readingState?.showTranslation ?? true;

    final settings = ref.watch(subtitleSettingsProvider);
    final scaleFactor = ref.watch(fullscreenSubtitleFontSizeProvider);
    
    final isBlockSelected = ref.watch(playerProvider.select((s) => s.highlightedWordIds.isNotEmpty || s.highlightedTranslationIds.isNotEmpty));

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = SubtitleScaling.calculateFontSize(constraints.maxWidth, scaleFactor);
          
          final double effectiveY = 1.0 - (settings.verticalOffset * 2.0);

          return Align(
            alignment: Alignment(0.0, effectiveY),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                        : Colors.transparent,
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
