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
  final String playerScope;
  final List<Phrase>? customPhrases;
  final bool forceShow;

  const FullscreenSubtitle({
    super.key,
    this.playerScope = 'main',
    this.customPhrases,
    this.forceShow = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fine-grained selectors to prevent whole-widget rebuild on every millisecond/position change
    final isFullscreen = ref.watch(playerProvider(playerScope).select((s) => s.isFullscreen));
    
    // Subtitles are visible in fullscreen mode OR when forceShow is enabled (e.g. for previews)
    if (!isFullscreen && !forceShow) return const SizedBox.shrink();
    
    final position = ref.watch(playerTimeProvider(playerScope));
    
    // Logic to find active phrase(s)
    final List<Phrase> activePhrases = [];
    final phrases = customPhrases ?? ref.watch(phrasesStreamProvider).value ?? [];
    
    if (phrases.isNotEmpty) {
      final ms = position.inMilliseconds;
      for (final phrase in phrases) {
        if (phrase.startTime != null && phrase.endTime != null) {
          final start = phrase.startTime!.difference(DateTime(1970, 1, 1)).inMilliseconds;
          if (start > ms + 1000) break;
          final end = phrase.endTime!.difference(DateTime(1970, 1, 1)).inMilliseconds;
          if (ms >= start && ms <= end) activePhrases.add(phrase);
        }
      }
    }

    if (activePhrases.isEmpty) return const SizedBox.shrink();

    final readingState = ref.watch(readingTypeNotifierProvider).value;
    final mainOpt = readingState?.mainOption ?? 'original';
    final addOpt = readingState?.additionalOption;
    final showTranslation = readingState?.showTranslation ?? true;

    final settings = ref.watch(subtitleSettingsProvider);
    final scaleFactor = ref.watch(fullscreenSubtitleFontSizeProvider);
    
    final isBlockSelected = ref.watch(playerProvider(playerScope).select((s) => s.highlightedWordIds.isNotEmpty || s.highlightedTranslationIds.isNotEmpty));

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
                    ref.read(playerProvider(playerScope).notifier).clearSelection();
                  } else {
                    ref.read(playerProvider(playerScope).notifier).togglePlaying();
                    ref.read(playerProvider(playerScope).notifier).resetHideTimer();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: activePhrases.map((phrase) => Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: EdgeInsets.all(SubtitleScaling.calculateFontSize(constraints.maxWidth, settings.backdropPadding)),
                    decoration: BoxDecoration(
                      color: settings.showBackdrop
                          ? Colors.black.withValues(alpha: settings.backdropOpacity)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(SubtitleScaling.calculateFontSize(constraints.maxWidth, 12) / 2.3),
                    ),
                    child: _buildBody(phrase, mainOpt, addOpt, showTranslation, fontSize, isFullscreen),
                  )).toList(),
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
    final isProcessing = uiStatus.isProcessing;
    
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
      playerScope: playerScope,
    );

    if (isProcessing) {
      return ShimmerText(
        blendMode: BlendMode.srcATop,
        shimmerColors: [
          Colors.transparent,
          Colors.transparent,
          const Color(0xFF3B66F5).withValues(alpha: 0.5),
          const Color(0xFF6366F1).withValues(alpha: 0.7),
          const Color(0xFF3B66F5).withValues(alpha: 0.5),
          Colors.transparent,
          Colors.transparent,
        ],
        child: content,
      );
    }
    return content;
  }
}
