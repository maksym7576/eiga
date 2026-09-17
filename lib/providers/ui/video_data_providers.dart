import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:isar_community/isar.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/database/schemas/translation_job.dart';
import '../../backend/database/schemas/phrase.dart';
import '../../backend/database/schemas/language.dart';
import '../../backend/database/schemas/specific_word_style.dart';
import '../../backend/database/schemas/known_word_status.dart';
import '../../backend/services/depacker_subtitles/season_episode_info.dart';
import '../services/isar_services_providers.dart';
import '../../utils/logger.dart';

import 'player_provider.dart';

// Providers for video-related data
final playerIdProvider = StateProvider<int?>((ref) {
  return null;
});

final phraseDataPrefetcherProvider = NotifierProvider<PhrasePrefetchNotifier, void>(PhrasePrefetchNotifier.new);

class PhrasePrefetchNotifier extends Notifier<void> {
  @override
  void build() {
    ref.listen<int?>(stickyActivePhraseIdProvider, (prev, nextId) {
      if (nextId != null) {
        _runPrefetch(nextId);
      }
    });
  }

  Future<void> _runPrefetch(int activeId) async {
    final List<Phrase> phrases = ref.read(phrasesStreamProvider).value ?? [];
    if (phrases.isEmpty) return;

    final int activeIndex = phrases.indexWhere((p) => p.id == activeId);
    if (activeIndex == -1) return;

    final Iterable<Phrase> nextPhrases = phrases.skip(activeIndex + 1).take(3);

    for (final _ in nextPhrases) {
      await Future.delayed(const Duration(milliseconds: 60));
      if (ref.read(stickyActivePhraseIdProvider) != activeId) return;
    }
  }
}

final selectedBlockIdProvider = Provider<int?>((ref) => ref.watch(playerProvider.select((s) => s.selectedBlockId)));
final clickedWordIdProvider = Provider<int?>((ref) => ref.watch(playerProvider.select((s) => s.clickedWordId)));
final clickedTranslationWordIdProvider = Provider<int?>((ref) => ref.watch(playerProvider.select((s) => s.clickedTranslationWordId)));
final selectionAnchorTypeProvider = Provider<SelectionAnchor?>((ref) => ref.watch(playerProvider.select((s) => s.selectionAnchorType)));
final highlightedWordIdsProvider = Provider<Set<int>>((ref) => ref.watch(playerProvider.select((s) => s.highlightedWordIds)));
final highlightedTranslationIdsProvider = Provider<Set<int>>((ref) => ref.watch(playerProvider.select((s) => s.highlightedTranslationIds)));
final infoPanelTextProvider = StateProvider<String?>((ref) => null);
final clickedWordPositionProvider = Provider<Offset?>((ref) => ref.watch(playerProvider.select((s) => s.clickedWordPosition)));
final selectionLayerLinkProvider = Provider<LayerLink?>((ref) => ref.watch(playerProvider.select((s) => s.selectionLayerLink)));
final selectedPhraseIdProvider = Provider<int?>((ref) => ref.watch(playerProvider.select((s) => s.selectedPhraseId)));

final dimmedWordIdsProvider = Provider<Set<int>>((ref) {
  final phraseId = ref.watch(selectedPhraseIdProvider);
  if (phraseId == null) return const {};
  
  final phrases = ref.watch(phrasesStreamProvider).value;
  if (phrases == null || phrases.isEmpty) return const {};
  
  // Efficient lookup
  final phrase = phrases.firstWhere((p) => p.id == phraseId, orElse: () => Phrase());
  if (phrase.id == 0 || phrase.linkGroups == null || phrase.linkGroups!.isEmpty) return const {};

  final clickedWordId = ref.watch(clickedWordIdProvider);
  final clickedTranslationId = ref.watch(clickedTranslationWordIdProvider);

  int? activeGid;
  if (clickedWordId != null) {
    final tok = phrase.originalTokens?.where((t) => t.wordPosition == clickedWordId).firstOrNull;
    activeGid = tok?.linkGroupId;
  } else if (clickedTranslationId != null) {
    final tw = phrase.translatedWords?.where((t) => t.translatedWordPosition == clickedTranslationId).firstOrNull;
    activeGid = tw?.linkGroupId;
  }

  if (activeGid == null) return const {};
  final g = phrase.linkGroups!.where((lg) => lg.groupId == activeGid).firstOrNull;
  if (g == null) return const {};

  final Set<int> result = {};
  for (final rid in g.relatedGroupIds) {
    final relatedG = phrase.linkGroups!.where((lg) => lg.groupId == rid).firstOrNull;
    if (relatedG != null) {
      result.addAll(relatedG.sourcePositions);
    }
  }
  return result;
});

final dimmedTranslationIdsProvider = Provider<Set<int>>((ref) {
  final phraseId = ref.watch(selectedPhraseIdProvider);
  if (phraseId == null) return const {};
  
  final phrases = ref.watch(phrasesStreamProvider).value;
  if (phrases == null || phrases.isEmpty) return const {};

  final phrase = phrases.firstWhere((p) => p.id == phraseId, orElse: () => Phrase());
  if (phrase.id == 0 || phrase.linkGroups == null || phrase.linkGroups!.isEmpty) return const {};

  final clickedWordId = ref.watch(clickedWordIdProvider);
  final clickedTranslationId = ref.watch(clickedTranslationWordIdProvider);

  int? activeGid;
  if (clickedWordId != null) {
    final tok = phrase.originalTokens?.where((t) => t.wordPosition == clickedWordId).firstOrNull;
    activeGid = tok?.linkGroupId;
  } else if (clickedTranslationId != null) {
    final tw = phrase.translatedWords?.where((t) => t.translatedWordPosition == clickedTranslationId).firstOrNull;
    activeGid = tw?.linkGroupId;
  }

  if (activeGid == null) return const {};
  final g = phrase.linkGroups!.where((lg) => lg.groupId == activeGid).firstOrNull;
  if (g == null) return const {};

  final Set<int> result = {};
  for (final rid in g.relatedGroupIds) {
    final relatedG = phrase.linkGroups!.where((lg) => lg.groupId == rid).firstOrNull;
    if (relatedG != null) {
      result.addAll(relatedG.targetPositions);
    }
  }
  return result;
});

class PhraseLinkIndex {
  final List<TokenEntry> words;
  final List<TranslationTokenEntry> tWords;
  final List<LinkGroup> linkGroups;

  PhraseLinkIndex(this.words, this.tWords, [List<LinkGroup>? groups]) : linkGroups = groups ?? const [];

  Map<String, Set<int>> getLinkedIdsForWord(int wordId) {
    final tok = words.firstWhere((w) => w.wordPosition == wordId, orElse: () => TokenEntry());
    if (tok.linkGroupId != null && linkGroups.isNotEmpty) {
      final g = linkGroups.firstWhere((lg) => lg.groupId == tok.linkGroupId, orElse: () => LinkGroup());
      if (g.groupId != null) {
        return {
          'words': g.sourcePositions.toSet(),
          'translations': g.targetPositions.toSet(),
        };
      }
    }

    final Set<int> wordIds = {wordId};
    final Set<int> translationIds = <int>{};
    for (final t in tWords) {
      if (t.sourceWordPositions.contains(wordId)) {
        if (t.translatedWordPosition != null) translationIds.add(t.translatedWordPosition!);
      }
    }
    for (final tId in translationIds) {
      final t = tWords.firstWhere((tw) => tw.translatedWordPosition == tId, orElse: () => TranslationTokenEntry());
      wordIds.addAll(t.sourceWordPositions);
    }
    return {
      'words': wordIds,
      'translations': translationIds,
    };
  }

  Map<String, Set<int>> getLinkedIdsForTranslation(int translationId) {
    final tw = tWords.firstWhere((t) => t.translatedWordPosition == translationId, orElse: () => TranslationTokenEntry());
    if (tw.linkGroupId != null && linkGroups.isNotEmpty) {
      final g = linkGroups.firstWhere((lg) => lg.groupId == tw.linkGroupId, orElse: () => LinkGroup());
      if (g.groupId != null) {
        return {
          'words': g.sourcePositions.toSet(),
          'translations': g.targetPositions.toSet(),
        };
      }
    }

    return {
      'words': tw.sourceWordPositions.toSet(),
      'translations': {translationId},
    };
  }

  Map<int, List<TokenEntry>> get translationToWords {
    final Map<int, List<TokenEntry>> map = {};
    for (final t in tWords) {
      if (t.translatedWordPosition != null) {
        map[t.translatedWordPosition!] = words.where((w) => t.sourceWordPositions.contains(w.wordPosition)).toList();
      }
    }
    return map;
  }

  Map<int, List<TranslationTokenEntry>> get wordToTranslations {
    final Map<int, List<TranslationTokenEntry>> map = {};
    for (final w in words) {
      if (w.wordPosition != null) {
        map[w.wordPosition!] = tWords.where((t) => t.sourceWordPositions.contains(w.wordPosition)).toList();
      }
    }
    return map;
  }
}

final blockLayerLinkProvider = Provider<LayerLink>((ref) => LayerLink());

final specificWordStylesStreamProvider = StreamProvider<List<SpecificWordStyle>>((ref) {
  final service = ref.read(specificWordStyleServiceProvider);
  return service.watchAllStyles();
});

final allStylesMapProvider = Provider<Map<int, SpecificWordStyle>>((ref) {
  final styles = ref.watch(specificWordStylesStreamProvider).value ?? [];
  return {for (final s in styles) s.id: s};
});

final lemmaToStatusMapProvider = StreamProvider<Map<String, KnownWordStatus>>((ref) {
  final service = ref.read(knownWordStatusServiceProvider);
  return service.db.collection<KnownWordStatus>().where().watch(fireImmediately: true).map((list) {
    return {for (final s in list) if (s.base != null) s.base!: s};
  });
});

final seasonEpisodeProvider = StateProvider<SeasonEpisodeInfo?>((ref) {
  return null;
});

final currentVideoProvider = FutureProvider<Video?>((ref) async {
  final videoId = ref.watch(playerIdProvider);
  if (videoId == null) return null;

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

  final startBase = DateTime(1970, 1, 1);
  
  int low = 0;
  int high = phrases.length - 1;

  while (low <= high) {
    int mid = (low + high) >> 1;
    final p = phrases[mid];
    
    if (p.startTime == null || p.endTime == null) {
      low++;
      continue;
    }

    final start = p.startTime!.difference(startBase);
    final end = p.endTime!.difference(startBase);

    if (currentTime >= start && currentTime <= end) {
      return p.id;
    } else if (currentTime < start) {
      high = mid - 1;
    } else {
      low = mid + 1;
    }
  }

  return null;
});

final stickyActivePhraseIdProvider = Provider<int?>((ref) {
  final phrases = ref.watch(phrasesStreamProvider).value ?? [];
  final currentTime = ref.watch(playerTimeProvider);

  if (phrases.isEmpty) return null;

  final activeId = ref.watch(activePhraseIdProvider);
  if (activeId != null) return activeId;

  final startBase = DateTime(1970, 1, 1);
  int low = 0;
  int high = phrases.length - 1;
  int lastFinishedIdx = -1;

  while (low <= high) {
    int mid = (low + high) >> 1;
    final p = phrases[mid];
    if (p.startTime == null) {
      low++;
      continue;
    }

    final start = p.startTime!.difference(startBase);
    if (start <= currentTime) {
      lastFinishedIdx = mid;
      low = mid + 1;
    } else {
      high = mid - 1;
    }
  }

  if (lastFinishedIdx != -1) {
    return phrases[lastFinishedIdx].id;
  }

  return null;
});

final clickedWordProvider = FutureProvider<TokenEntry?>((ref) async {
  final wordId = ref.watch(clickedWordIdProvider);
  if (wordId == null) return null;
  
  final phraseId = ref.watch(selectedPhraseIdProvider);
  if (phraseId == null) return null;
  
  final phraseService = ref.read(phraseServiceProvider);
  final phrase = await phraseService.getPhraseById(phraseId);
  return phrase?.originalTokens?.where((t) => (t.wordPosition ?? 0) == wordId).firstOrNull;
});

final clickedTranslationWordProvider = FutureProvider<TranslationTokenEntry?>((ref) async {
  final twId = ref.watch(clickedTranslationWordIdProvider);
  if (twId == null) return null;
  
  final phraseId = ref.watch(selectedPhraseIdProvider);
  if (phraseId == null) return null;
  
  final phraseService = ref.read(phraseServiceProvider);
  final phrase = await phraseService.getPhraseById(phraseId);
  return phrase?.translatedWords?.where((t) => (t.translatedWordPosition ?? 0) == twId).firstOrNull;
});

class EmbeddedBlock {
  final int id;
  EmbeddedBlock(this.id);
}

class WordWithStyle {
  final TokenEntry word;
  final EmbeddedBlock block;
  final SpecificWordStyle? style;

  WordWithStyle({required this.word, required this.block, this.style});
}

class TranslationTokenWithStyle {
  final TranslationTokenEntry token;
  final EmbeddedBlock? block;
  final SpecificWordStyle? style;
  final String? lemma;

  TranslationTokenWithStyle({
    required this.token,
    this.block,
    this.style,
    this.lemma,
  });
}

final wordStyleProvider = StreamProvider.family<SpecificWordStyle?, String>((ref, lemma) {
  if (lemma.isEmpty) return Stream.value(null);
  
  final statusService = ref.read(knownWordStatusServiceProvider);
  final stylesMap = ref.watch(allStylesMapProvider);
  
  return statusService.db.collection<KnownWordStatus>()
      .filter()
      .baseEqualTo(lemma)
      .watch(fireImmediately: true)
      .map((statuses) {
    if (statuses.isEmpty || statuses.first.styleId == null) return null;
    return stylesMap[statuses.first.styleId!];
  });
});

final blockStyleProvider = StreamProvider.family<SpecificWordStyle?, int>((ref, blockId) async* {
  final phraseId = ref.watch(stickyActivePhraseIdProvider);
  if (phraseId == null) {
    yield null;
    return;
  }
  
  final phraseService = ref.read(phraseServiceProvider);
  final phrase = await phraseService.getPhraseById(phraseId);
  if (phrase == null || phrase.originalTokens == null) {
    yield null;
    return;
  }

  final blockTokens = phrase.originalTokens!.where((t) => t.blockId == blockId).toList();
  blockTokens.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));
  final expressionBase = blockTokens.map((w) => w.lemma ?? '').join(' ').trim();
  
  if (expressionBase.isEmpty) {
    yield null;
    return;
  }

  final statusService = ref.read(knownWordStatusServiceProvider);
  final stylesMap = ref.watch(allStylesMapProvider);

  await for (final statuses in statusService.db.collection<KnownWordStatus>().filter().baseEqualTo(expressionBase).watch(fireImmediately: true)) {
    if (statuses.isEmpty || statuses.first.styleId == null) {
      yield null;
    } else {
      yield stylesMap[statuses.first.styleId!];
    }
  }
});
