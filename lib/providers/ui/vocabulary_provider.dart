import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../../backend/database/schemas/phrase.dart';
import '../../backend/database/schemas/word_index.dart';
import '../../backend/database/schemas/user_word_status.dart';
import '../../config/ui/word_styles.dart';
import '../services/isar_services_providers.dart';
import 'video_data_providers.dart';

class StyledVocabularyItem {
  final EmbeddedBlock block;
  final List<TokenEntry> words;
  final List<TranslationTokenEntry> translationWords;
  final WordStatus? status;
  final String? seriesName;
  final String? contextOriginal;
  final String? contextTranslated;
  final int phraseId;
  final bool isIdiom;

  StyledVocabularyItem({
    required this.block,
    required this.words,
    required this.translationWords,
    required this.phraseId,
    this.status,
    this.seriesName,
    this.contextOriginal,
    this.contextTranslated,
    this.isIdiom = false,
  });
}

final styledVocabularyProvider = StreamProvider<List<StyledVocabularyItem>>((ref) async* {
  final statusService = ref.watch(knownWordStatusServiceProvider);
  final indexService = ref.watch(wordIndexServiceProvider);
  final phraseService = ref.watch(phraseServiceProvider);

  await for (final statuses in statusService.watchUserStatuses()) {
    if (statuses.isEmpty) {
      yield [];
      continue;
    }

    final List<UserWordStatus> sortedStatuses = List<UserWordStatus>.from(statuses)
      ..sort((a, b) => b.id.compareTo(a.id));
    
    final lemmas = sortedStatuses.map((s) => s.lemma).toList();
    if (lemmas.isEmpty) {
      yield [];
      continue;
    }

    final allIndexMatches = await indexService.findByLemmas(lemmas);
    
    final List<StyledVocabularyItem> result = [];
    final Set<int> processedBlockPhrasePairs = {};

    for (final s in sortedStatuses) {
      final matches = allIndexMatches.where((m) => m.lemma == s.lemma).toList();
      if (matches.isEmpty) continue;

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

        final bool isIdiom = phrase.linkGroups?.any((lg) => lg.isIdiom && lg.sourcePositions.any((sp) => blockWords.any((bw) => bw.wordPosition == sp))) ?? false;

        result.add(StyledVocabularyItem(
          block: EmbeddedBlock(blockId),
          words: blockWords,
          translationWords: blockTrWords,
          phraseId: m.phraseId,
          status: s.status,
          seriesName: m.seriesName,
          contextOriginal: m.contextOriginal,
          contextTranslated: m.contextTranslated,
          isIdiom: isIdiom,
        ));
      }
    }
    
    yield result;
  }
});

class SelectedVocabularyStatusNotifier extends Notifier<WordStatus?> {
  @override
  WordStatus? build() => null;
  set state(WordStatus? value) => super.state = value;
}

final selectedVocabularyStatusProvider = NotifierProvider<SelectedVocabularyStatusNotifier, WordStatus?>(
  SelectedVocabularyStatusNotifier.new,
);

final filteredVocabularyProvider = Provider<AsyncValue<List<StyledVocabularyItem>>>((ref) {
  final allItemsAsync = ref.watch(styledVocabularyProvider);
  final selectedStatus = ref.watch(selectedVocabularyStatusProvider);

  return allItemsAsync.whenData((items) {
    if (selectedStatus == null) return items;
    return items.where((item) => item.status == selectedStatus).toList();
  });
});
