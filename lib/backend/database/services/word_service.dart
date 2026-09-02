import 'package:isar_community/isar.dart';
import '../schemas/word.dart';

class WordService {
  final Isar db;

  WordService(this.db);

  Future<void> createWord({required Word word}) async {
    await db.writeTxn(() async {
      await db.words.put(word);
    });
  }

  Future<List<Word>> getWordsByBlockIds(List<int> blockIds) async {
    return await db.words
        .filter()
        .anyOf(blockIds, (q, int id) => q.blockIdEqualTo(id))
        .findAll();
  }
}
