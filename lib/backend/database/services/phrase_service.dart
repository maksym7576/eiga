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

  Future<void> putPhrases(List<Phrase> phraseList) async {
    await db.writeTxn(() async {
      await db.phrases.putAll(phraseList);
    });
  }

  Future<void> setStage(int phraseId, String stageKey, StageState state) async {
    final phrase = await db.phrases.get(phraseId);
    if (phrase == null) return;
    await db.writeTxn(() async {
      final statuses = Map<String, String>.from(phrase.stageStatuses);
      statuses[stageKey] = state.name;
      phrase.stageStatuses = statuses;
      await db.phrases.put(phrase);
    });
  }

  Future<void> setStages(List<int> phraseIds, String stageKey, StageState state) async {
    await db.writeTxn(() async {
      final phrases = await db.phrases.getAll(phraseIds);
      for (var phrase in phrases) {
        if (phrase != null) {
          final statuses = Map<String, String>.from(phrase.stageStatuses);
          statuses[stageKey] = state.name;
          phrase.stageStatuses = statuses;
          await db.phrases.put(phrase);
        }
      }
    });
  }

  Future<void> resetStagesFrom(List<int> phraseIds, String fromStageKey) async {
    final idx = StageKey.order.indexOf(fromStageKey);
    if (idx == -1) return;
    final toReset = StageKey.order.sublist(idx);
    await db.writeTxn(() async {
      for (var id in phraseIds) {
        final p = await db.phrases.get(id);
        if (p == null) continue;
        final updated = Map<String, String>.from(p.stageStatuses);
        for (var key in toReset) {
          updated[key] = StageState.pending.name;
        }
        p.stageStatuses = updated;
        await db.phrases.put(p);
      }
    });
  }

  Future<void> resetAllProcessingStatuses() async {
    await db.writeTxn(() async {
      final allPhrases = await db.phrases.where().findAll();
      for (var phrase in allPhrases) {
        bool changed = false;
        final updated = Map<String, String>.from(phrase.stageStatuses);
        for (var entry in updated.entries) {
          if (entry.value == StageState.processing.name) {
            updated[entry.key] = StageState.pending.name;
            changed = true;
          }
        }
        if (changed) {
          phrase.stageStatuses = updated;
          await db.phrases.put(phrase);
        }
      }
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
        final statuses = Map<String, String>.from(phrase.stageStatuses);
        statuses[StageKey.translation] = StageState.completed.name;
        phrase.stageStatuses = statuses;
        await db.phrases.put(phrase);
      }
    });
  }

  /// Updates translation text without clearing the translating flag or marking as fully done.
  /// Used between stages of multi-step pipelines.
  Future<void> updateTranslatedPhraseTextRaw(int phraseId, String translatedText) async {
    await db.writeTxn(() async {
      final phrase = await db.phrases.get(phraseId);
      if (phrase != null) {
        phrase.translatedPhrase = translatedText;
        await db.phrases.put(phrase);
      }
    });
  }

  Future<void> updatePhraseTexts(int phraseId, String original, String translation) async {
    await db.writeTxn(() async {
      final phrase = await db.phrases.get(phraseId);
      if (phrase != null) {
        phrase.originalPhrase = original;
        phrase.translatedPhrase = translation;
        final statuses = Map<String, String>.from(phrase.stageStatuses);
        statuses[StageKey.translation] = StageState.completed.name;
        phrase.stageStatuses = statuses;
        await db.phrases.put(phrase);
      }
    });
  }

  /// Updates original and translation texts without clearing the translating flag.
  Future<void> updatePhraseTextsRaw(int phraseId, String original, String translation) async {
    await db.writeTxn(() async {
      final phrase = await db.phrases.get(phraseId);
      if (phrase != null) {
        phrase.originalPhrase = original;
        phrase.translatedPhrase = translation;
        await db.phrases.put(phrase);
      }
    });
  }

  Future<void> updateTokens(int phraseId, {List<TokenEntry>? original, List<TranslationTokenEntry>? translated}) async {
    await db.writeTxn(() async {
      final phrase = await db.phrases.get(phraseId);
      if (phrase != null) {
        if (original != null) phrase.originalTokens = original;
        if (translated != null) phrase.translatedWords = translated;
        await db.phrases.put(phrase);
      }
    });
  }

  Future<void> resetPhrasesTranslationStatus(List<Phrase> phrases) async {
    await db.writeTxn(() async {
      for (var phrase in phrases) {
        phrase.translatedPhrase = null;
        phrase.stageStatuses = {};
      }
      await db.phrases.putAll(phrases);
    });
  }

  Future<void> resetPhrasesTranslationStatusByIds(List<int> phraseIds) async {
    await db.writeTxn(() async {
      for (var id in phraseIds) {
        final phrase = await db.phrases.get(id);
        if (phrase != null) {
          phrase.translatedPhrase = null;
          phrase.stageStatuses = {};
          await db.phrases.put(phrase);
        }
      }
    });
  }

  Future<List<Phrase>> searchPhrases(String queryText) async {
    if (queryText.isEmpty) return [];
    
    // Search in both original and translated phrases using indexes
    final originalMatches = await db.phrases
        .filter()
        .originalPhraseContains(queryText, caseSensitive: false)
        .findAll();
        
    final translatedMatches = await db.phrases
        .filter()
        .translatedPhraseContains(queryText, caseSensitive: false)
        .findAll();

    final results = [...originalMatches, ...translatedMatches];
    // De-duplicate by ID
    final seen = <int>{};
    return results.where((p) => seen.add(p.id)).toList();
  }

  Future<void> resetTranslatingState(List<int> phraseIds) async {
    await db.writeTxn(() async {
      for (var id in phraseIds) {
        final phrase = await db.phrases.get(id);
        if (phrase != null) {
          final statuses = Map<String, String>.from(phrase.stageStatuses);
          for (var key in statuses.keys) {
            if (statuses[key] == StageState.processing.name) {
              statuses[key] = StageState.pending.name;
            }
          }
          phrase.stageStatuses = statuses;
          await db.phrases.put(phrase);
        }
      }
    });
  }
}
