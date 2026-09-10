import 'package:isar_community/isar.dart';
import '../schemas/translation_word.dart';

class TranslationWordService {
  final Isar db;

  TranslationWordService(this.db);

  Future<void> createTranslationWords(List<TranslationWord> words) async {
    await db.writeTxn(() async {
      await db.collection<TranslationWord>().putAll(words);
    });
  }

  Future<List<TranslationWord>> getTranslationWordsByPhraseId(int phraseId) async {
    return await db.collection<TranslationWord>()
        .filter()
        .phraseIdEqualTo(phraseId)
        .findAll();
  }

  Future<List<TranslationWord>> getTranslationWordsByBlockId(int blockId) async {
    return await db.collection<TranslationWord>()
        .filter()
        .blockIdEqualTo(blockId)
        .findAll();
  }

  Future<void> deleteByPhraseId(int phraseId) async {
    await db.writeTxn(() async {
      await db.collection<TranslationWord>().filter().phraseIdEqualTo(phraseId).deleteAll();
    });
  }

  Future<List<TranslationWord>> getTranslationWordsByText(String text) async {
    return await db.collection<TranslationWord>()
        .filter()
        .textEqualTo(text)
        .findAll();
  }
}
