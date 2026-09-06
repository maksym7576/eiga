import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/database/schemas/translation_job.dart';
import '../../backend/database/schemas/phrase.dart';
import '../../backend/database/schemas/block.dart';
import '../../backend/database/schemas/word.dart';
import '../../backend/database/schemas/language.dart';
import '../../backend/database/schemas/specific_word_style.dart';
import '../../backend/services/depacker_subtitles/season_episode_info.dart';
import '../services/database_services_providers.dart';

final playerIdProvider = StateProvider<int?>((ref) {
  return null;
});

final selectedBlockIdProvider = StateProvider<int?>((ref) => null);

final clickedWordIdProvider = StateProvider<int?>((ref) => null);

final clickedWordPositionProvider = StateProvider<Offset?>((ref) => null);

final blockLayerLinkProvider = Provider<LayerLink>((ref) => LayerLink());

final specificWordStylesStreamProvider = StreamProvider<List<SpecificWordStyle>>((ref) {
  final service = ref.read(specificWordStyleServiceProvider);
  return service.watchAllStyles();
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

final currentVideoStreamProvider = StreamProvider<Video?>((ref) {
  final videoId = ref.watch(playerIdProvider);
  if (videoId == null) return Stream.value(null);

  final videoService = ref.read(videoServiceProvider);
  return videoService.watchVideoById(videoId);
});

final translationJobsStreamProvider = StreamProvider.family<List<TranslationJob>, int>((ref, videoId) {
  final service = ref.read(translationJobServiceProvider);
  return service.watchJobsForVideo(videoId);
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

final stickyActivePhraseIdProvider = Provider<int?>((ref) {
  final phrases = ref.watch(phrasesStreamProvider).value ?? [];
  final currentTime = ref.watch(playerTimeProvider);

  if (phrases.isEmpty) return null;

  // 1. Try standard active phrase first
  final activeId = ref.watch(activePhraseIdProvider);
  if (activeId != null) return activeId;

  // 2. If no active phrase (gap), find the last one that finished
  try {
    final startBase = DateTime(1970, 1, 1);
    
    // Find phrases that started before or at current time
    final pastAndCurrentPhrases = phrases.where((p) {
      if (p.startTime == null) return false;
      final start = p.startTime!.difference(startBase);
      return currentTime >= start;
    }).toList();

    if (pastAndCurrentPhrases.isEmpty) return null;

    // The "last" one is the one with the highest phraseOrder
    pastAndCurrentPhrases.sort((a, b) => (b.phraseOrder ?? 0).compareTo(a.phraseOrder ?? 0));
    
    return pastAndCurrentPhrases.first.id;
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

class WordWithStyle {
  final Word word;
  final Block block;
  final SpecificWordStyle? style;

  WordWithStyle({required this.word, required this.block, this.style});
}

final phraseBlocksWithStylesProvider = StreamProvider.family<List<Map<String, dynamic>>, int>((ref, phraseId) {
  final blockService = ref.read(blockServiceProvider);
  final styleService = ref.read(specificWordStyleServiceProvider);


  return blockService.watchBlocksForPhrase(phraseId).asyncMap((blocks) async {
    if (blocks.isEmpty) return [];

    final List<Map<String, dynamic>> results = [];
    for (final block in blocks) {
      SpecificWordStyle? style;
      if (block.specificWordStyleId != null) {
        style = await styleService.getStyleById(block.specificWordStyleId!);
      }
      results.add({'block': block, 'style': style});
    }

    // Sort by position index
    results.sort((a, b) => ((a['block'] as Block).blockPositionIndex ?? 0)
        .compareTo((b['block'] as Block).blockPositionIndex ?? 0));

    return results;
  });
});

final phraseWordsProvider = StreamProvider.family<List<WordWithStyle>, int>((ref, phraseId) async* {
  final blocksWithStylesAsync = ref.watch(phraseBlocksWithStylesProvider(phraseId));
  final wordService = ref.read(wordServiceProvider);


  if (blocksWithStylesAsync.hasValue) {
    final entries = blocksWithStylesAsync.value!;
    if (entries.isEmpty) {
      yield [];
    } else {
      final List<WordWithStyle> allWords = [];
      for (final entry in entries) {
        final block = entry['block'] as Block;
        final style = entry['style'] as SpecificWordStyle?;

        final words = await wordService.getWordsByBlockIds([block.id]);
        final sortedWords = List<Word>.from(words)
          ..sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));

        for (final word in sortedWords) {
          allWords.add(WordWithStyle(word: word, block: block, style: style));
        }
      }
      yield allWords;
    }
  }
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
