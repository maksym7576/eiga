import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../backend/database/schemas/phrase.dart';
import '../../../providers/ui/video_data_providers.dart';
import '../../../providers/ui/player_provider.dart';
import '../../../providers/services/reading_type_provider.dart';
import 'subtitle_text_content.dart';

class SubtitleOverlay extends ConsumerWidget {
  const SubtitleOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullscreen = ref.watch(playerProvider.select((s) => s.isFullscreen));
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      alignment: Alignment.bottomCenter,
      child: SubtitleTextContent(
        phrase: phrase,
        mainOption: mainOpt,
        additionalOption: addOpt,
        showTranslation: showTranslation,
        baseFontSize: 22,
        textAlign: TextAlign.center,
        textColor: Colors.white,
        useShadows: true,
      ),
    );
  }
}
