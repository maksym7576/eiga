import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/backend/database/schemas/translation_job.dart';
import 'package:eiga/backend/database/schemas/block.dart';
import 'package:eiga/backend/database/schemas/word.dart';
import 'package:eiga/backend/database/schemas/specific_word_style.dart';
import 'package:eiga/providers/services/database_services_providers.dart';

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
  final Word word;
  final SpecificWordStyle? style;

  StyledVocabularyItem({
    required this.block,
    required this.word,
    this.style,
  });
}

final styledVocabularyProvider = StreamProvider<List<StyledVocabularyItem>>((ref) async* {
  final blockService = ref.watch(blockServiceProvider);
  final wordService = ref.watch(wordServiceProvider);
  final styleService = ref.watch(specificWordStyleServiceProvider);

  await for (final blocks in blockService.watchBlocksWithStyles()) {
    if (blocks.isEmpty) {
      yield [];
      continue;
    }

    final blockIds = blocks.map((b) => b.id).toList();
    final words = await wordService.getWordsByBlockIds(blockIds);
    final styles = await styleService.getAllStyles();
    
    final items = blocks.map((block) {
      final word = words.firstWhere((w) => w.blockId == block.id, orElse: () => Word(blockId: block.id));
      final style = styles.firstWhere((s) => s.id == block.specificWordStyleId, orElse: () => SpecificWordStyle());
      return StyledVocabularyItem(block: block, word: word, style: style);
    }).toList();

    yield items;
  }
});
