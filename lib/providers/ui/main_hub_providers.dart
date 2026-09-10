import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../backend/database/schemas/translation_word.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/database/schemas/translation_job.dart';
import '../../backend/database/schemas/block.dart';
import '../../backend/database/schemas/word.dart';
import '../../backend/database/schemas/known_word_status.dart';
import '../../backend/database/schemas/specific_word_style.dart';
import '../services/database_services_providers.dart';

final allVideosProvider = StreamProvider<List<Video>>((ref) {
  final service = ref.watch(videoServiceProvider);
  return service.watchAllVideos();
});

final activeJobsProvider = StreamProvider<List<TranslationJob>>((ref) {
  final service = ref.watch(translationJobServiceProvider);
  return service.watchAllActiveJobs();
});

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

    // Sort by ID descending to get most recent first
    final List<KnownWordStatus> sortedStatuses = List<KnownWordStatus>.from(statuses)
      ..sort((a, b) => b.id.compareTo(a.id));

    final Map<int, StyledVocabularyItem> blockItems = {};
    
    for (final s in sortedStatuses) {
      if (s.base == null) continue;
      
      // Find representative word for this status
      final baseWords = await wordService.getWordsByLemma(s.base!);
      if (baseWords.isEmpty) continue;
      
      // Use the most recent occurrence as representative
      final repWord = baseWords.last;
      if (repWord.blockId == null) continue;

      // Skip if this block is already processed
      if (blockItems.containsKey(repWord.blockId)) continue;

      final block = await isar.collection<Block>().get(repWord.blockId!);
      if (block == null) continue;

      final style = s.styleId != null ? await styleService.getStyleById(s.styleId!) : null;
      
      // Get all words in this block
      final blockWords = await wordService.getWordsByBlockIds([block.id]);
      blockWords.sort((a, b) => (a.wordPosition ?? 0).compareTo(b.wordPosition ?? 0));

      // Get translation for this block
      final trWords = await translationWordService.getTranslationWordsByBlockId(block.id);
      trWords.sort((a, b) => (a.translatedWordPosition ?? 0).compareTo(b.translatedWordPosition ?? 0));

      // Find variations for all unique lemmas in this block across the entire library
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

      // Find variations for translation tokens
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
