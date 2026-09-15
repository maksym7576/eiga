import 'package:isar_community/isar.dart';
import '../schemas/word_index.dart';

class WordIndexService {
  final Isar db;

  WordIndexService(this.db);

  Future<void> putAll(List<WordIndex> indices) async {
    await db.writeTxn(() async {
      await db.wordIndexs.putAll(indices);
    });
  }

  Future<List<WordIndex>> findByLemma(String lemma) async {
    return await db.wordIndexs.filter().lemmaEqualTo(lemma).findAll();
  }

  Future<List<WordIndex>> findByLemmas(List<String> lemmas) async {
    return await db.wordIndexs.filter().anyOf(lemmas, (q, String lemma) => q.lemmaEqualTo(lemma)).findAll();
  }

  Future<void> deleteByPhraseId(int phraseId) async {
    await db.writeTxn(() async {
      final existing = await db.wordIndexs.filter().phraseIdEqualTo(phraseId).findAll();
      if (existing.isNotEmpty) {
        await db.wordIndexs.deleteAll(existing.map((e) => e.id).toList());
      }
    });
  }

  Future<void> deleteByVideoId(int videoId) async {
    await db.writeTxn(() async {
      final existing = await db.wordIndexs.filter().videoIdEqualTo(videoId).findAll();
      if (existing.isNotEmpty) {
        await db.wordIndexs.deleteAll(existing.map((e) => e.id).toList());
      }
    });
  }
}
