import 'package:eiga/ui/widgets/subtitles/components/shimmer_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/ui/upload_provider.dart';
import 'package:eiga/providers/services/reading_type_provider.dart';
import 'package:eiga/providers/ui/subtitle_settings_provider.dart';
import 'subtitle_text_content.dart';
import '../../../utils/ui/scaling_utils.dart';

/// Субтитри поверх відео. Тільки відображення, без жестів:
/// усі тапи проходять крізь них до _PlayerInteractionLayer.
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
    final playerState = ref.watch(playerProvider(playerScope));
    if (!playerState.isInitialized && !forceShow) return const SizedBox.shrink();

    final position = ref.watch(playerTimeProvider(playerScope));
    final List<Phrase> activePhrases = [];
    final allPhrases = customPhrases ?? ref.watch(phrasesStreamProvider).value ?? [];

    if (allPhrases.isNotEmpty) {
      final ms = position.inMilliseconds;
      for (final phrase in allPhrases) {
        if (phrase.startTime != null && phrase.endTime != null) {
          final start = phrase.startTime!.difference(DateTime(1970, 1, 1)).inMilliseconds;
          if (start > ms + 1000) break;
          final end = phrase.endTime!.difference(DateTime(1970, 1, 1)).inMilliseconds;
          if (ms >= start && ms <= end) activePhrases.add(phrase);
        }
      }
    }

    if (activePhrases.isEmpty) return const SizedBox.shrink();

    // Сортуємо активні фрази за часом старту, щоб вони не "стрибали"
    activePhrases
        .sort((a, b) => (a.startTime ?? DateTime(0)).compareTo(b.startTime ?? DateTime(0)));

    final readingState = ref.watch(readingTypeNotifierProvider).value;
    final mainOpt = readingState?.mainOption ?? 'original';
    final addOpt = readingState?.additionalOption;
    final showTranslation = readingState?.showTranslation ?? true;
    final settings = ref.watch(subtitleSettingsProvider);
    final scaleFactor = ref.watch(fullscreenSubtitleFontSizeProvider);

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double baseFontSize = playerScope == 'preview'
              ? (constraints.maxWidth / 32).clamp(10.0, 18.0)
              : SubtitleScaling.calculateFontSize(constraints.maxWidth, scaleFactor);

          final double effectiveY = 1.0 - (settings.verticalOffset * 2.0);

          // Унікальний переклад з активних фраз
          final Set<String> translations = activePhrases
              .where((p) => p.translatedPhrase != null && p.translatedPhrase!.isNotEmpty)
              .map((p) => p.translatedPhrase!)
              .toSet();

          return Align(
            alignment: Alignment(0.0, effectiveY),
            child: IgnorePointer(
              ignoring: !playerState.isLocked,
              child: Container(
                decoration: settings.showBackdrop
                    ? BoxDecoration(
                        color: Colors.black.withValues(alpha: settings.backdropOpacity),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: settings.backdropOpacity * 0.8),
                            blurRadius: 24,
                            spreadRadius: 8,
                          ),
                        ],
                      )
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: settings.showBackdrop
                      ? EdgeInsets.symmetric(
                          horizontal: SubtitleScaling.calculateFontSize(constraints.maxWidth, settings.backdropPadding * 1.5),
                          vertical: SubtitleScaling.calculateFontSize(constraints.maxWidth, settings.backdropPadding),
                        )
                      : EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...activePhrases.map((phrase) => _buildBody(
                        phrase,
                        mainOpt,
                        addOpt,
                        showTranslation,
                        baseFontSize,
                        playerState.isFullscreen,
                      )),

                      // Переклад знизу тільки для прев'ю
                      if (translations.isNotEmpty && playerScope == 'preview')
                        ...translations.map((text) => Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: baseFontSize * 0.85,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            shadows: const [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        )),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
      Phrase phrase,
      String mainOpt,
      String? addOpt,
      bool showTranslation,
      double fontSize,
      bool isFullscreen,
      ) {
    final isProcessing = phrase.uiStatus.isProcessing;

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