import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/database/schemas/phrase.dart';
import '../../backend/database/schemas/block.dart';
import '../../backend/database/schemas/word.dart';
import '../../backend/database/schemas/language.dart';
import '../../backend/services/depacker_subtitles/season_episode_info.dart';
import '../services/database_services_providers.dart';

final playerIdProvider = StateProvider<int?>((ref) {
  return null;
});

final playerTimeProvider = StateProvider<Duration>((ref) {
  return Duration.zero;
});

final isPlayingProvider = StateProvider<bool>((ref) {
  return false;
});

final isAutoScrollEnabledProvider = StateProvider<bool>((ref) {
  return true;
});

final seasonEpisodeProvider = StateProvider<SeasonEpisodeInfo?>((ref) {
  return null;
});

final currentVideoProvider = FutureProvider<Video?>((ref) async {
  final videoId = ref.watch(playerIdProvider);

  if (videoId == null) {
    return null;
  }

  final videoService = ref.read(videoServiceProvider);
  return await videoService.getVideoById(videoId);
});

final videoLanguageProvider = FutureProvider<Language?>((ref) async {
  final video = await ref.watch(currentVideoProvider.future);
  if (video == null || video.originalLanguage == null) return null;

  final languageService = ref.read(languageServiceProvider);
  return await languageService.getLanguageByName(video.originalLanguage!);
});

final phrasesStreamProvider = StreamProvider<List<Phrase>>((ref) {
  final videoId = ref.watch(playerIdProvider);
  if (videoId == null) return Stream.value([]);

  final phraseService = ref.read(phraseServiceProvider);
  return phraseService.watchPhrasesByVideoId(videoId);
});

final activePhraseIdProvider = Provider<int?>((ref) {
  final phrases = ref.watch(phrasesStreamProvider).value ?? [];
  final currentTime = ref.watch(playerTimeProvider);

  if (phrases.isEmpty) return null;

  try {
    final startBase = DateTime(1970, 1, 1);
    return phrases.firstWhere((p) {
      if (p.startTime == null || p.endTime == null) return false;
      final start = p.startTime!.difference(startBase);
      final end = p.endTime!.difference(startBase);
      return currentTime >= start && currentTime <= end;
    }).id;
  } catch (_) {
    return null;
  }
});

final phraseBlocksProvider = FutureProvider.family<List<Block>, int>((ref, phraseId) async {
  final blockService = ref.read(blockServiceProvider);
  return await blockService.getBlocksForPhrase(phraseId);
});

final blockWordsProvider = FutureProvider.family<List<Word>, int>((ref, blockId) async {
  final wordService = ref.read(wordServiceProvider);
  return await wordService.getWordsByBlockIds([blockId]);
});

class TranslationBatch {
  final int startOrder;
  final int endOrder;
  final int translatedCount;
  final int totalCount;
  final bool isDone;

  TranslationBatch({
    required this.startOrder,
    required this.endOrder,
    required this.translatedCount,
    required this.totalCount,
    required this.isDone,
  });

  double get progress => totalCount > 0 ? translatedCount / totalCount : 0.0;
}

final translationBatchesProvider = Provider<List<TranslationBatch>>((ref) {
  final phrases = ref.watch(phrasesStreamProvider).value ?? [];
  if (phrases.isEmpty) return [];

  const batchSize = 120;
  final List<TranslationBatch> batches = [];

  for (int i = 0; i < phrases.length; i += batchSize) {
    final batchPhrases = phrases.sublist(
      i,
      (i + batchSize) > phrases.length ? phrases.length : (i + batchSize),
    );

    final translatedCount = batchPhrases.where((p) => p.isTranslated).length;
    final totalCount = batchPhrases.length;

    batches.add(TranslationBatch(
      startOrder: i + 1,
      endOrder: i + totalCount,
      translatedCount: translatedCount,
      totalCount: totalCount,
      isDone: translatedCount == totalCount,
    ));
  }

  return batches;
});
