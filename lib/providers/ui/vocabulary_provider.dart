import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:isar_community/isar.dart';
import '../../backend/database/schemas/phrase.dart';
import '../../backend/database/schemas/word_index.dart';
import '../../backend/database/schemas/known_word_status.dart';
import '../../backend/database/schemas/specific_word_style.dart';
import '../services/isar_services_providers.dart';
import 'video_data_providers.dart';

class StyledVocabularyItem {
  final EmbeddedBlock block;
  final List<TokenEntry> words;
  final List<TranslationTokenEntry> translationWords;
  final SpecificWordStyle? style;
  final String? seriesName;
  final String? contextOriginal;
  final String? contextTranslated;
  final int phraseId;

  StyledVocabularyItem({
    required this.block,
    required this.words,
    required this.translationWords,
    required this.phraseId,
    this.style,
    this.seriesName,
    this.contextOriginal,
    this.contextTranslated,
  });
}

final styledVocabularyProvider = StreamProvider<List<StyledVocabularyItem>>((ref) async* {
  final statusService = ref.watch(knownWordStatusServiceProvider);
  final indexService = ref.watch(wordIndexServiceProvider);
  final stylesMap = ref.watch(allStylesMapProvider);
  final phraseService = ref.watch(phraseServiceProvider);

  await for (final statuses in statusService.watchKnownWithStyles()) {
    if (statuses.isEmpty) {
      yield [];
      continue;
    }

    final List<KnownWordStatus> sortedStatuses = List<KnownWordStatus>.from(statuses)
      ..sort((a, b) => b.id.compareTo(a.id));
    
    final lemmas = sortedStatuses.map((s) => s.base).whereType<String>().toList();
    if (lemmas.isEmpty) {
      yield [];
      continue;
    }

    final allIndexMatches = await indexService.findByLemmas(lemmas);
    
    final List<StyledVocabularyItem> result = [];
    final Set<int> processedBlockPhrasePairs = {};

    for (final s in sortedStatuses) {
      if (s.base == null) continue;
      final matches = allIndexMatches.where((m) => m.lemma == s.base).toList();
      if (matches.isEmpty) continue;

      final style = s.styleId != null ? stylesMap[s.styleId!] : null;

      for (final m in matches) {
        final pairKey = (m.phraseId << 32) | (m.blockId ?? 0);
        if (processedBlockPhrasePairs.contains(pairKey)) continue;
        processedBlockPhrasePairs.add(pairKey);

        final phrase = await phraseService.getPhraseById(m.phraseId);
        if (phrase == null) continue;

        final blockId = m.blockId ?? 0;
        final blockWords = phrase.originalTokens?.where((t) => t.blockId == blockId).toList() ?? [];
        blockWords.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));

        final blockTrWords = phrase.translatedWords?.where((tw) => tw.blockId == blockId).toList() ?? [];
        blockTrWords.sort((a, b) => (a.translatedWordPosition ?? 0).compareTo(b.translatedWordPosition ?? 0));

        result.add(StyledVocabularyItem(
          block: EmbeddedBlock(blockId),
          words: blockWords,
          translationWords: blockTrWords,
          phraseId: m.phraseId,
          style: style,
          seriesName: m.seriesName,
          contextOriginal: m.contextOriginal,
          contextTranslated: m.contextTranslated,
        ));
      }
    }
    
    yield result;
  }
});

final allVocabularyStylesProvider = StreamProvider<List<SpecificWordStyle>>((ref) {
  final service = ref.watch(specificWordStyleServiceProvider);
  return service.watchAllStyles();
});

final selectedVocabularyStyleIdProvider = StateProvider<int?>((ref) => null);

final filteredVocabularyProvider = Provider<AsyncValue<List<StyledVocabularyItem>>>((ref) {
  final allItemsAsync = ref.watch(styledVocabularyProvider);
  final selectedStyleId = ref.watch(selectedVocabularyStyleIdProvider);

  return allItemsAsync.whenData((items) {
    if (selectedStyleId == null) return items;
    return items.where((item) => item.style?.id == selectedStyleId).toList();
  });
});
