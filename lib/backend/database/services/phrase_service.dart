import 'package:isar_community/isar.dart';
import '../schemas/phrase.dart';

class PhraseService {
  final Isar db;

  PhraseService(this.db);

  Stream<List<Phrase>> watchPhrasesByVideoId(int videoId) {
    return db.phrases
        .filter()
        .videoIdEqualTo(videoId)
        .sortByPhraseOrder()
        .watch(fireImmediately: true);
  }

  Future<List<Phrase>> getPhrasesByVideoId(int videoId) async {
    return await db.phrases
        .where()
        .filter()
        .videoIdEqualTo(videoId)
        .findAll();
  }

  Future<Phrase?> getPhraseById(int id) async {
    return await db.phrases.get(id);
  }

  Future<void> addPhrase(Phrase phrase) async {
    await db.writeTxn(() async {
      await db.phrases.put(phrase);
    });
  }

  Future<void> addPhrasesList(List<Phrase> phraseList) async {
    await db.writeTxn(() async {
      await db.phrases.putAll(phraseList);
    });
  }

  Future<void> markAsTranslatedAndMarkNotTranslating(int phraseId) async {
    await db.writeTxn(() async {
      final phrase = await db.phrases.get(phraseId);
      if (phrase != null) {
        phrase.isTranslated = true;
        phrase.isTranslating = false;
        await db.phrases.put(phrase);
      }
    });
  }

  Future<void> resetAllTranslatingStatuses() async {
    await db.writeTxn(() async {
      final stuckPhrases = await db.phrases
          .filter()
          .isTranslatingEqualTo(true)
          .findAll();
      for (var phrase in stuckPhrases) {
        phrase.isTranslating = false;
        await db.phrases.put(phrase);
      }
    });
  }

  Future<void> markPhrasesAsTranslatingByPhraseList(List<Phrase> phrases) async {
    await db.writeTxn(() async {
      for (var phrase in phrases) {
        phrase.isTranslating = true;
      }
      await db.phrases.putAll(phrases);
    });
  }

  Future<void> shiftPhrasesTimeByVideoId(int videoId, Duration millisecondsOffset) async {
    await db.writeTxn(() async {
      final phrases = await db.phrases
          .filter()
          .videoIdEqualTo(videoId)
          .findAll();

      if (phrases.isNotEmpty) {
        for (var phrase in phrases) {
          if (phrase.startTime != null) {
            phrase.startTime = phrase.startTime!.add(millisecondsOffset);
          }
          if (phrase.endTime != null) {
            phrase.endTime = phrase.endTime!.add(millisecondsOffset);
          }
        }
        await db.phrases.putAll(phrases);
      }
    });
  }

  Future<void> shiftPhraseTimeById(int phraseId, Duration millisecondsOffset) async {
    await db.writeTxn(() async {
      final phrase = await db.phrases.get(phraseId);
      if (phrase != null) {
        if (phrase.startTime != null) {
          phrase.startTime = phrase.startTime!.add(millisecondsOffset);
        }
        if (phrase.endTime != null) {
          phrase.endTime = phrase.endTime!.add(millisecondsOffset);
        }
        await db.phrases.put(phrase);
      }
    });
  }

  Future<void> updateTranslatedPhraseText(int phraseId, String translatedText) async {
    await db.writeTxn(() async {
      final phrase = await db.phrases.get(phraseId);
      if (phrase != null) {
        phrase.translatedPhrase = translatedText;
        phrase.isTranslated = false;
        phrase.isTranslating = true;
        await db.phrases.put(phrase);
      }
    });
  }

  Future<void> resetPhrasesTranslationStatus(List<Phrase> phrases) async {
    await db.writeTxn(() async {
      for (var phrase in phrases) {
        phrase.isTranslating = false;
        phrase.translatedPhrase = null;
        phrase.isTranslated = false;
      }
      await db.phrases.putAll(phrases);
    });
  }

  Future<void> resetPhrasesTranslationStatusByIds(List<int> phraseIds) async {
    await db.writeTxn(() async {
      for (var id in phraseIds) {
        final phrase = await db.phrases.get(id);
        if (phrase != null) {
          phrase.isTranslating = false;
          phrase.translatedPhrase = null;
          phrase.isTranslated = false;
          await db.phrases.put(phrase);
        }
      }
    });
  }
}
