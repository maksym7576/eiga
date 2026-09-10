import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:isar_community/isar.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/database/schemas/translation_job.dart';
import '../../backend/database/schemas/phrase.dart';
import '../../backend/database/schemas/block.dart';
import '../../backend/database/schemas/word.dart';
import '../../backend/database/schemas/translation_word.dart';
import '../../backend/database/schemas/language.dart';
import '../../backend/database/schemas/specific_word_style.dart';
import '../../backend/database/schemas/known_word_status.dart';
import '../../backend/services/depacker_subtitles/season_episode_info.dart';
import '../services/database_services_providers.dart';

// Providers for video-related data
final playerIdProvider = StateProvider<int?>((ref) {
  return null;
});

final selectedBlockIdProvider = StateProvider<int?>((ref) => null);

final clickedWordIdProvider = StateProvider<int?>((ref) => null);

final clickedTranslationWordIdProvider = StateProvider<int?>((ref) => null);

enum SelectionAnchor { word, translation }
final selectionAnchorTypeProvider = StateProvider<SelectionAnchor?>((ref) => null);

final highlightedWordIdsProvider = StateProvider<Set<int>>((ref) => {});
final highlightedTranslationIdsProvider = StateProvider<Set<int>>((ref) => {});
final infoPanelTextProvider = StateProvider<String?>((ref) => null);

final clickedWordPositionProvider = StateProvider<Offset?>((ref) => null);

class PhraseLinkIndex {
  final Map<int, List<TranslationWord>> wordToTranslations = {};
  final Map<int, List<Word>> translationToWords = {};

  PhraseLinkIndex(List<Word> words, List<TranslationWord> tWords) {
    // 1. Map Japanese words by position (phrase-wide)
    final wordByPos = <int, Word>{
      for (final w in words) 
        if (w.wordPosition != null)
          w.wordPosition!: w
    };

    // 2. Link translations to their source words
    for (final t in tWords) {
      final List<Word> sourceWords = [];
      for (final pos in t.sourceWordPositions) {
        final w = wordByPos[pos];
        if (w != null) {
          sourceWords.add(w);
        } else {
          print('LINK INDEX WARNING: No word found for pos $pos (Translation: "${t.text}")');
        }
      }

      translationToWords[t.id] = sourceWords;
      for (final w in sourceWords) {
        wordToTranslations.putIfAbsent(w.id, () => []).add(t);
      }
    }
  }

  /// Returns all words and translations that form a linked group with the given word.
  /// Bridging logic: If word A is part of translation T, include all source words of T.
  Map<String, Set<int>> getLinkedIdsForWord(int wordId) {
    final translations = wordToTranslations[wordId] ?? [];
    final Set<int> wordIds = {wordId};
    final Set<int> translationIds = translations.map((t) => t.id).toSet();

    // Bridging: find siblings
    for (final tId in translationIds) {
      final siblings = translationToWords[tId] ?? [];
      for (final s in siblings) {
        wordIds.add(s.id);
      }
    }

    return {
      'words': wordIds,
      'translations': translationIds,
    };
  }

  /// Returns all words and translations that form a linked group with the given translation token.
  Map<String, Set<int>> getLinkedIdsForTranslation(int translationId) {
    final words = translationToWords[translationId] ?? [];
    return {
      'words': words.map((w) => w.id).toSet(),
      'translations': {translationId},
    };
  }
}

final phraseLinkIndexProvider = FutureProvider.family<PhraseLinkIndex, int>((ref, phraseId) async {
  final wordService = ref.read(wordServiceProvider);
  final translationWordService = ref.read(translationWordServiceProvider);

  final words = await wordService.getWordsByPhraseId(phraseId);
  final tWords = await translationWordService.getTranslationWordsByPhraseId(phraseId);

  return PhraseLinkIndex(words, tWords);
});

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

final clickedWordProvider = FutureProvider<Word?>((ref) async {
  final wordId = ref.watch(clickedWordIdProvider);
  if (wordId == null) return null;
  
  final wordService = ref.read(wordServiceProvider);
  return await wordService.getWordById(wordId);
});

final clickedTranslationWordProvider = FutureProvider<TranslationWord?>((ref) async {
  final twId = ref.watch(clickedTranslationWordIdProvider);
  if (twId == null) return null;
  
  final twService = ref.read(translationWordServiceProvider);
  return await twService.db.translationWords.get(twId);
});

class WordWithStyle {
  final Word word;
  final Block block;
  final SpecificWordStyle? style;

  WordWithStyle({required this.word, required this.block, this.style});
}

final phraseBlocksWithStylesProvider = StreamProvider.family<List<Map<String, dynamic>>, int>((ref, phraseId) {
  final blockService = ref.read(blockServiceProvider);
  final wordService = ref.read(wordServiceProvider);
  final statusService = ref.read(knownWordStatusServiceProvider);
  final styleService = ref.read(specificWordStyleServiceProvider);
  final translationWordService = ref.read(translationWordServiceProvider);

  return blockService.watchBlocksForPhrase(phraseId).asyncMap((blocks) async {
    if (blocks.isEmpty) return [];

    final List<Map<String, dynamic>> results = [];
    for (final block in blocks) {
      SpecificWordStyle? style;
      
      // Find words for this block to determine style via lemma
      final words = await wordService.getWordsByBlockIds([block.id]);
      final wordWithLemma = words.where((w) => w.lemma != null && w.lemma!.isNotEmpty).firstOrNull;
      
      if (wordWithLemma != null) {
        final status = await statusService.getByBase(wordWithLemma.lemma!);
        if (status != null && status.styleId != null) {
          style = await styleService.getStyleById(status.styleId!);
        }
      }

      // Find translation tokens for this block
      final translationWords = await translationWordService.getTranslationWordsByBlockId(block.id);
      final translationIndices = translationWords.map((tw) => tw.translatedWordPosition ?? 0).toList();
      
      results.add({
        'block': block, 
        'style': style,
        'translationIndices': translationIndices,
      });
    }

    // Sort by position index
    results.sort((a, b) => ((a['block'] as Block).blockPositionIndex ?? 0)
        .compareTo((b['block'] as Block).blockPositionIndex ?? 0));

    return results;
  });
});

class TranslationTokenWithStyle {
  final TranslationWord token;
  final Block? block;
  final SpecificWordStyle? style;
  final String? lemma;

  TranslationTokenWithStyle({
    required this.token,
    this.block,
    this.style,
    this.lemma,
  });
}

final phraseTranslationTokensProvider = StreamProvider.family<List<TranslationTokenWithStyle>, int>((ref, phraseId) {
  final blockService = ref.read(blockServiceProvider);
  final wordService = ref.read(wordServiceProvider);
  final statusService = ref.read(knownWordStatusServiceProvider);
  final styleService = ref.read(specificWordStyleServiceProvider);
  final translationWordService = ref.read(translationWordServiceProvider);

  return translationWordService.db.collection<TranslationWord>()
      .filter()
      .phraseIdEqualTo(phraseId)
      .watch(fireImmediately: true)
      .asyncMap((tokens) async {
    if (tokens.isEmpty) return [];

    final List<TranslationTokenWithStyle> results = [];
    
    // Cache blocks and styles to avoid redundant lookups
    final Map<int, Block> blockCache = {};
    final Map<int, SpecificWordStyle?> styleCache = {};

    // Load all words for this phrase once to link lemmas to translation tokens
    final phraseWords = await wordService.getWordsByPhraseId(phraseId);
    final Map<int, Word> wordPosMap = {
      for (final w in phraseWords) if (w.wordPosition != null) w.wordPosition!: w
    };

    for (final token in tokens) {
      // 1. Get or Load Block (if available)
      Block? block;
      if (token.blockId != null) {
        block = blockCache[token.blockId!];
        if (block == null) {
          block = await blockService.db.blocks.get(token.blockId!);
          if (block != null) blockCache[token.blockId!] = block;
        }
      }

      // 2. Get or Load Style and Lemma from sourceWordPositions
      SpecificWordStyle? style;
      String? lemma;
      
      if (token.sourceWordPositions.isNotEmpty) {
        // Find lemma from the FIRST source word position linked to this token
        final sourceWord = wordPosMap[token.sourceWordPositions.first];
        
        if (sourceWord != null && sourceWord.lemma != null) {
          lemma = sourceWord.lemma;
          final status = await statusService.getByBase(lemma!);
          if (status != null && status.styleId != null) {
            style = await styleService.getStyleById(status.styleId!);
          }
        }
      } else if (token.blockId != null) {
        // Fallback to block-based lookup if positions are empty
        if (styleCache.containsKey(token.blockId!)) {
          style = styleCache[token.blockId!];
          final blockWords = phraseWords.where((w) => w.blockId == token.blockId).toList();
          lemma = blockWords.where((w) => w.lemma != null && w.lemma!.isNotEmpty).firstOrNull?.lemma;
        } else {
          final blockWords = phraseWords.where((w) => w.blockId == token.blockId).toList();
          final wordWithLemma = blockWords.where((w) => w.lemma != null && w.lemma!.isNotEmpty).firstOrNull;
          lemma = wordWithLemma?.lemma;
          
          if (wordWithLemma != null) {
            final status = await statusService.getByBase(wordWithLemma.lemma!);
            if (status != null && status.styleId != null) {
              style = await styleService.getStyleById(status.styleId!);
            }
          }
          styleCache[token.blockId!] = style;
        }
      }

      results.add(TranslationTokenWithStyle(
        token: token,
        block: block,
        style: style,
        lemma: lemma,
      ));
    }

    // Sort by translated word position to reconstruct the sentence
    results.sort((a, b) => (a.token.translatedWordPosition ?? 0)
        .compareTo(b.token.translatedWordPosition ?? 0));

    return results;
  });
});

final phraseWordsProvider = StreamProvider.family<List<WordWithStyle>, int>((ref, phraseId) {
  final blockService = ref.read(blockServiceProvider);
  final wordService = ref.read(wordServiceProvider);
  final statusService = ref.read(knownWordStatusServiceProvider);
  final styleService = ref.read(specificWordStyleServiceProvider);

  return blockService.watchBlocksForPhrase(phraseId).asyncMap((blocks) async {
    final List<WordWithStyle> allWords = [];
    
    // Sort blocks by position index
    final sortedBlocks = List<Block>.from(blocks)
      ..sort((a, b) => (a.blockPositionIndex ?? 0).compareTo(b.blockPositionIndex ?? 0));

    for (final block in sortedBlocks) {
      final words = await wordService.getWordsByBlockIds([block.id]);
      final sortedWords = List<Word>.from(words)
        ..sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));

      for (final word in sortedWords) {
        SpecificWordStyle? wordStyle;
        
        // Resolve style specifically for this word via its lemma
        if (word.lemma != null && word.lemma!.isNotEmpty) {
          final status = await statusService.getByBase(word.lemma!);
          if (status != null && status.styleId != null) {
            wordStyle = await styleService.getStyleById(status.styleId!);
          }
        }
        
        allWords.add(WordWithStyle(word: word, block: block, style: wordStyle));
      }
    }
    return allWords;
  });
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

final wordStyleProvider = StreamProvider.family<SpecificWordStyle?, String>((ref, lemma) {
  if (lemma.isEmpty) return Stream.value(null);
  
  final statusService = ref.read(knownWordStatusServiceProvider);
  final styleService = ref.read(specificWordStyleServiceProvider);
  
  return statusService.db.collection<KnownWordStatus>()
      .filter()
      .baseEqualTo(lemma)
      .watch(fireImmediately: true)
      .asyncMap((statuses) async {
    if (statuses.isEmpty || statuses.first.styleId == null) return null;
    return await styleService.getStyleById(statuses.first.styleId!);
  });
});

final blockStyleProvider = StreamProvider.family<SpecificWordStyle?, int>((ref, blockId) async* {
  final isar = ref.watch(isarProvider);
  final wordService = ref.read(wordServiceProvider);
  final statusService = ref.read(knownWordStatusServiceProvider);
  final styleService = ref.read(specificWordStyleServiceProvider);

  // 1. Get all words in this block to form the expression base
  final words = await wordService.getWordsByBlockIds([blockId]);
  if (words.isEmpty) {
    yield null;
    return;
  }
  
  words.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));
  final expressionBase = words.map((w) => w.lemma ?? '').join(' ').trim();
  
  if (expressionBase.isEmpty) {
    yield null;
    return;
  }

  // 2. Watch the status of this specific expression
  await for (final statuses in statusService.db.collection<KnownWordStatus>().filter().baseEqualTo(expressionBase).watch(fireImmediately: true)) {
    if (statuses.isEmpty || statuses.first.styleId == null) {
      yield null;
    } else {
      yield await styleService.getStyleById(statuses.first.styleId!);
    }
  }
});
