import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:isar_community/isar.dart';
import '../../backend/database/schemas/translation_word.dart';
import '../../backend/database/schemas/block.dart';
import '../../backend/database/schemas/word.dart';
import '../../backend/database/schemas/known_word_status.dart';
import '../../backend/database/schemas/specific_word_style.dart';
import '../services/isar_services_providers.dart';

class StyledVocabularyItem {
  final Block block;
  final List<Word> words;
  final List<TranslationWord> translationWords;
  final List<Word> variations;
  final List<TranslationWord> translationVariations;
  final SpecificWordStyle? style;

  StyledVocabularyItem({
    required this.block,
    required this.words,
    required this.translationWords,
    required this.variations,
    required this.translationVariations,
    this.style,
  });
}

final styledVocabularyProvider = StreamProvider<List<StyledVocabularyItem>>((ref) async* {
  final wordService = ref.watch(wordServiceProvider);
  final statusService = ref.watch(knownWordStatusServiceProvider);
  final styleService = ref.watch(specificWordStyleServiceProvider);
  final translationWordService = ref.watch(translationWordServiceProvider);
  final isar = ref.watch(isarProvider);

  await for (final statuses in statusService.watchKnownWithStyles()) {
    if (statuses.isEmpty) {
      yield [];
      continue;
    }

    final List<KnownWordStatus> sortedStatuses = List<KnownWordStatus>.from(statuses)
      ..sort((a, b) => b.id.compareTo(a.id));

    final Map<int, StyledVocabularyItem> blockItems = {};
    
    for (final s in sortedStatuses) {
      if (s.base == null) continue;
      
      final baseWords = await wordService.getWordsByLemma(s.base!);
      if (baseWords.isEmpty) continue;
      
      final repWord = baseWords.last;
      if (repWord.blockId == null) continue;

      if (blockItems.containsKey(repWord.blockId)) continue;

      final block = await isar.collection<Block>().get(repWord.blockId!);
      if (block == null) continue;

      final style = s.styleId != null ? await styleService.getStyleById(s.styleId!) : null;
      
      final blockWords = await wordService.getWordsByBlockIds([block.id]);
      blockWords.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));

      final trWords = await translationWordService.getTranslationWordsByBlockId(block.id);
      trWords.sort((a, b) => (a.translatedWordPosition ?? 0).compareTo(b.translatedWordPosition ?? 0));

      final Set<String> blockLemmas = blockWords.map((w) => w.lemma).whereType<String>().toSet();
      final List<Word> variations = [];
      for (final lemma in blockLemmas) {
        final occurrences = await wordService.getWordsByLemma(lemma);
        for (final occ in occurrences) {
          if (occ.blockId != block.id) {
            final isDuplicate = variations.any((v) => v.mainText == occ.mainText);
            if (!isDuplicate) variations.add(occ);
          }
        }
      }

      final List<TranslationWord> trVariations = [];
      for (final tr in trWords) {
        if (tr.text == null || tr.text!.isEmpty) continue;
        final occurrences = await translationWordService.getTranslationWordsByText(tr.text!);
        for (final occ in occurrences) {
          if (occ.blockId != block.id) {
            final isDuplicate = trVariations.any((v) => v.text == occ.text);
            if (!isDuplicate) trVariations.add(occ);
          }
        }
      }

      blockItems[block.id!] = StyledVocabularyItem(
        block: block,
        words: blockWords,
        translationWords: trWords,
        variations: variations,
        translationVariations: trVariations,
        style: style,
      );
    }
    yield blockItems.values.toList();
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
