import 'package:isar_community/isar.dart';
import '../schemas/word.dart';

// Service for Word operations
class WordService {
  final Isar db;

  WordService(this.db);

  Future<void> createWord({required Word word}) async {
    await db.writeTxn(() async {
      await db.collection<Word>().put(word);
    });
  }

  Future<Word?> getWordById(int id) async {
    return await db.collection<Word>().get(id);
  }

  Future<List<Word>> getWordsByBlockIds(List<int> blockIds) async {
    return await db.collection<Word>()
        .filter()
        .anyOf(blockIds, (q, int id) => q.blockIdEqualTo(id))
        .findAll();
  }

  Future<List<Word>> getWordsByPhraseId(int phraseId) async {
    return await db.collection<Word>()
        .filter()
        .phraseIdEqualTo(phraseId)
        .sortByWordPosition()
        .findAll();
  }

  Stream<List<Word>> watchWordsByBlockIds(List<int> blockIds) {
    return db.collection<Word>()
        .filter()
        .anyOf(blockIds, (q, int id) => q.blockIdEqualTo(id))
        .watch(fireImmediately: true);
  }

  Future<List<Word>> getWordsByLemma(String lemma) async {
    return await db.collection<Word>().filter().lemmaEqualTo(lemma).findAll();
  }

  Future<void> deleteByPhraseId(int phraseId) async {
    await db.writeTxn(() async {
      await db.collection<Word>().filter().phraseIdEqualTo(phraseId).deleteAll();
    });
  }
}
