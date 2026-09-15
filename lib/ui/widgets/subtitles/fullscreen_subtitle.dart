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
    final isLocked = playerState.isLocked;
    
    // Subtitles are ONLY visible in fullscreen mode as requested
    if (!isFullscreen) return const SizedBox.shrink();

    final activePhraseId = ref.watch(activePhraseIdProvider);
    if (activePhraseId == null) return const SizedBox.shrink();

    final phrasesAsync = ref.watch(phrasesStreamProvider);
    final phrases = phrasesAsync.value ?? [];
    
    final Phrase? phrase = phrases.cast<Phrase?>().firstWhere(
      (p) => p?.id == activePhraseId, 
      orElse: () => null
    );
    
    if (phrase == null) return const SizedBox.shrink();

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
          
          return Align(
            alignment: Alignment(0.0, 1.0 - (settings.verticalOffset * 2.0)),
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
                  child: SubtitleTextContent(
                    phrase: phrase,
                    mainOption: mainOpt,
                    additionalOption: addOpt,
                    showTranslation: showTranslation,
                    baseFontSize: fontSize,
                    textAlign: TextAlign.center,
                    textColor: Colors.white,
                    useShadows: settings.outlineWidth > 0,
                    isFullscreen: true,
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
