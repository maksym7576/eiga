import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:isar_community/isar.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/database/schemas/job.dart';
import '../../backend/database/schemas/phrase.dart';
import '../../backend/database/schemas/user_word_status.dart';
import '../../config/ui/word_styles.dart';
import '../../backend/services/depacker_subtitles/season_episode_info.dart';
import '../services/isar_services_providers.dart';

import 'player_provider.dart';

final wordStyleProvider = StreamProvider.family<WordStatus?, String>((ref, lemma) {
  if (lemma.isEmpty) return Stream.value(null);
  final statusService = ref.read(knownWordStatusServiceProvider);
  return statusService.db.userWordStatus
      .filter()
      .lemmaEqualTo(lemma)
      .watch(fireImmediately: true)
      .map((statuses) {
    if (statuses.isEmpty) return null;
    return statuses.first.status;
  });
});

final blockStyleProvider = StreamProvider.family<WordStatus?, int>((ref, blockId) async* {
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
  await for (final statuses in statusService.db.userWordStatus.filter().lemmaEqualTo(expressionBase).watch(fireImmediately: true)) {
    if (statuses.isEmpty) {
      yield null;
    } else {
      yield statuses.first.status;
    }
  }
});

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

  late final Map<int, List<TokenEntry>> _translationToWords;
  late final Map<int, List<TranslationTokenEntry>> _wordToTranslations;

  PhraseLinkIndex(this.words, this.tWords, [List<LinkGroup>? groups]) : linkGroups = groups ?? const [] {
    _translationToWords = {};
    for (final t in tWords) {
      if (t.translatedWordPosition != null) {
        _translationToWords[t.translatedWordPosition!] = words.where((w) => t.sourceWordPositions.contains(w.wordPosition)).toList();
      }
    }

    _wordToTranslations = {};
    for (final w in words) {
      if (w.wordPosition != null) {
        _wordToTranslations[w.wordPosition!] = tWords.where((t) => t.sourceWordPositions.contains(w.wordPosition)).toList();
      }
    }
  }

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
    
    final linkedTranslations = _wordToTranslations[wordId] ?? [];
    for (final t in linkedTranslations) {
      if (t.translatedWordPosition != null) {
        translationIds.add(t.translatedWordPosition!);
        final linkedBack = _translationToWords[t.translatedWordPosition!] ?? [];
        for (final w in linkedBack) {
          if (w.wordPosition != null) wordIds.add(w.wordPosition!);
        }
      }
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

  Map<int, List<TokenEntry>> get translationToWords => _translationToWords;
  Map<int, List<TranslationTokenEntry>> get wordToTranslations => _wordToTranslations;
}

final blockLayerLinkProvider = Provider<LayerLink>((ref) => LayerLink());

final lemmaToStatusMapProvider = StreamProvider<Map<String, UserWordStatus>>((ref) {
  final service = ref.read(knownWordStatusServiceProvider);
  return service.db.userWordStatus.where().watch(fireImmediately: true).map((list) {
    return {for (final s in list) s.lemma: s};
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

final videoProvider = StreamProvider.family<Video?, int>((ref, videoId) {
  final videoService = ref.read(videoServiceProvider);
  return videoService.watchVideoById(videoId);
});

final translationJobsStreamProvider = StreamProvider.family<List<Job>, int>((ref, videoId) {
  final service = ref.read(jobServiceProvider);
  return service.watchJobsForVideo(videoId);
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
  int mid;
  while (low <= high) {
    mid = (low + high) >> 1;
    final p = phrases[mid];
    if (p.startTime == null || p.endTime == null) { low++; continue; }
    final start = p.startTime!.difference(startBase);
    final end = p.endTime!.difference(startBase);
    if (currentTime >= start && currentTime <= end) { return p.id; } 
    else if (currentTime < start) { high = mid - 1; } 
    else { low = mid + 1; }
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
    if (p.startTime == null) { low++; continue; }
    final start = p.startTime!.difference(startBase);
    if (start <= currentTime) { lastFinishedIdx = mid; low = mid + 1; } 
    else { high = mid - 1; }
  }
  if (lastFinishedIdx != -1) { return phrases[lastFinishedIdx].id; }
  return null;
});

final activePhraseProvider = Provider<Phrase?>((ref) {
  final phrases = ref.watch(phrasesStreamProvider).value ?? [];
  final activeId = ref.watch(activePhraseIdProvider);
  if (activeId == null || phrases.isEmpty) return null;
  for (final p in phrases) { if (p.id == activeId) return p; }
  return null;
});

final clickedWordProvider = FutureProvider<TokenEntry?>((ref) async {
  final wordId = ref.watch(clickedWordIdProvider);
  final phraseId = ref.watch(selectedPhraseIdProvider);
  if (wordId == null || phraseId == null) return null;
  final phraseService = ref.read(phraseServiceProvider);
  final phrase = await phraseService.getPhraseById(phraseId);
  return phrase?.originalTokens?.where((t) => (t.wordPosition ?? 0) == wordId).firstOrNull;
});

final clickedTranslationWordProvider = FutureProvider<TranslationTokenEntry?>((ref) async {
  final twId = ref.watch(clickedTranslationWordIdProvider);
  final phraseId = ref.watch(selectedPhraseIdProvider);
  if (twId == null || phraseId == null) return null;
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
  final WordStatus? status;
  WordWithStyle({required this.word, required this.block, this.status});
}

class TranslationTokenWithStyle {
  final TranslationTokenEntry token;
  final EmbeddedBlock? block;
  final WordStatus? status;
  final String? lemma;
  TranslationTokenWithStyle({required this.token, this.block, this.status, this.lemma});
}
