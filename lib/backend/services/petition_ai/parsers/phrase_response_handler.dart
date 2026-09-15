import 'dart:convert';
import 'package:isar_community/isar.dart';
import '../../../database/schemas/phrase.dart';
import '../../../database/schemas/word_index.dart';
import '../../../database/schemas/video.dart';
import '../../../database/schemas/language.dart';
import '../../../database/services/phrase_service.dart';
import '../../utils/ai_exceptions.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import 'response_parser_utils.dart';
import '../../../../utils/logger.dart';

class PhraseOutcome {
  final int phraseId;
  final bool ok;

  PhraseOutcome({required this.phraseId, required this.ok});
}

class PhraseResponseHandler {
  final PhraseService phraseService;

  PhraseResponseHandler({
    required this.phraseService,
  });

  Future<AiRequestResult> processResponse(String jsonResponse, {List<int> expectedIds = const [], String? language}) async {
    dynamic parsed;
    try {
      parsed = jsonDecode(jsonResponse);
    } catch (e) {
      await phraseService.resetTranslatingState(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final List<dynamic> entries;
    if (parsed is List) {
      entries = parsed;
    } else if (parsed is Map) {
      entries = [parsed];
    } else {
      await phraseService.resetTranslatingState(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final failedPhraseIds = <int>[];
    final processedIds = <int>{};

    for (final entry in entries) {
      final outcome = await processPhraseEntryData(entry, language: language);
      if (outcome == null) continue;
      
      processedIds.add(outcome.phraseId);
      if (!outcome.ok) {
        failedPhraseIds.add(outcome.phraseId);
      }
    }

    final missingIds = <int>[];
    for (final expectedId in expectedIds) {
      if (!processedIds.contains(expectedId)) {
        missingIds.add(expectedId);
        failedPhraseIds.add(expectedId);
      }
    }

    if (missingIds.isNotEmpty) {
      logger.w('[Handler] Missing IDs in morphology response: $missingIds');
      await phraseService.resetTranslatingState(missingIds);
    }

    if (failedPhraseIds.isEmpty) {
      return AiRequestResult.success();
    }
    return AiRequestResult.partialSuccess(failedPhraseIds.toList());
  }

  Future<PhraseOutcome?> processPhraseEntryData(dynamic phraseData, {String? language}) async {
    if (phraseData == null || phraseData is! Map) return null;

    final int phraseId = ResponseParserUtils.parseId(phraseData['id'] ?? phraseData['phraseId']);
    if (phraseId <= 0) return null;

    final rawBlocks = phraseData['b'] ?? phraseData['blocks'];
    if (rawBlocks is! List || rawBlocks.isEmpty) {
      await phraseService.resetTranslatingState([phraseId]);
      return PhraseOutcome(phraseId: phraseId, ok: false);
    }

    final phrase = await phraseService.getPhraseById(phraseId);
    if (phrase == null) return PhraseOutcome(phraseId: phraseId, ok: false);

    bool phraseHadErrors = false;

    try {
      final List<TokenEntry> originalTokens = [];
      final List<TranslationTokenEntry> translatedWords = [];

      for (final blockJson in rawBlocks) {
        if (blockJson is! Map) continue;
        final int? blockId = blockJson['p'] as int?;

        final List<dynamic> tData = blockJson['t'] ?? [];
        for (final tItem in tData) {
          if (tItem is! List || tItem.length < 3) continue;
          final List<int> sourceWordPositions = [];
          if (tItem.length >= 4 && tItem[3] is List) {
            for (final pos in tItem[3]) {
              if (pos is num) sourceWordPositions.add(pos.toInt());
            }
          }
          translatedWords.add(TranslationTokenEntry(
            blockId: blockId,
            translatedWordPosition: ResponseParserUtils.parseId(tItem[0]),
            text: tItem[1]?.toString() ?? '',
            isInferred: tItem[2] == true,
            sourceWordPositions: sourceWordPositions,
          ));
        }

        final List<dynamic> wData = blockJson['w'] ?? [];
        for (final wItem in wData) {
          if (wItem is! List || wItem.length < 7) continue;
          final wPos = wItem[0] as int?;
          final original = wItem[1]?.toString() ?? '';
          final posStr = wItem[2]?.toString();
          final lemma = wItem[3]?.toString();
          final kanaRaw = wItem[4]?.toString();
          final romaji = wItem[5]?.toString();
          final functionStr = wItem[6]?.toString();

          final List<ReadingItem> versions = [
            ReadingItem(key: 'original', text: original),
            if (kanaRaw != null && kanaRaw.isNotEmpty) ReadingItem(key: 'kana', text: kanaRaw),
            if (romaji != null && romaji.isNotEmpty) ReadingItem(key: 'romaji', text: romaji),
          ];

          originalTokens.add(TokenEntry(
            wordPosition: wPos,
            pos: _parsePos(posStr),
            grammarFunction: _parseGrammarFunction(functionStr),
            lemma: lemma,
            blockId: blockId,
            versions: versions,
          ));
        }
      }

      phrase.originalTokens = originalTokens;
      phrase.translatedWords = translatedWords;
      
      await phraseService.putPhrases([phrase]);
      await _updateWordIndexForPhrases([phrase]);
    } catch (e) {
      phraseHadErrors = true;
      logger.e('Error processing phrase $phraseId', error: e);
    }

    if (!phraseHadErrors) {
      await phraseService.setStage(phraseId, StageKey.translation, StageState.completed);
    } else {
      await phraseService.setStage(phraseId, StageKey.translation, StageState.error);
    }
    return PhraseOutcome(phraseId: phraseId, ok: !phraseHadErrors);
  }

  Future<void> processTokenizationResult(Phrase phrase, Map<String, dynamic> result, {bool isOriginal = true, required Language language}) async {
    final List<dynamic> rawList = result['words'] ?? result['tokens'] ?? [];

    final List<dynamic> blocks = result['blocks'] ?? [];
    final Map<int, int> posToBlock = {};
    for (var b in blocks) {
      final bId = ResponseParserUtils.parseId(b['blockId']);
      final List<int> wPositions = ResponseParserUtils.parseIntList(b['wordPositions']);
      for (var pos in wPositions) {
        posToBlock[pos] = bId;
      }
    }

    if (isOriginal) {
      final List<TokenEntry> tokens = [];
      for (var item in rawList) {
        if (item is! Map<String, dynamic>) continue;
        final int pos = ResponseParserUtils.parseId(item['pos'] ?? item['wordPosition'] ?? item['translationPosition']);
        
        final List<ReadingItem> versions = [];
        for (var opt in language.readingOptions) {
          final String keyToLook = opt == 'original' ? 'text' : opt;
          final val = item[keyToLook] ?? item[opt];
          if (val != null) {
            versions.add(ReadingItem(key: opt, text: val.toString()));
          }
        }

        tokens.add(TokenEntry(
          wordPosition: pos,
          pos: _parsePos(item['partOfSpeech']?.toString()),
          lemma: item['lemma']?.toString(),
          blockId: posToBlock[pos],
          versions: versions,
        ));
      }
      await phraseService.updateTokens(phrase.id, original: tokens, translated: null);
    } else {
      final List<TranslationTokenEntry> tokens = [];
      for (var item in rawList) {
        if (item is! Map<String, dynamic>) continue;
        final int pos = ResponseParserUtils.parseId(item['pos'] ?? item['wordPosition'] ?? item['translationPosition']);
        
        tokens.add(TranslationTokenEntry(
          translatedWordPosition: pos,
          blockId: posToBlock[pos] ?? pos,
          text: item['text']?.toString() ?? item['translation']?.toString() ?? '',
        ));
      }
      await phraseService.updateTokens(phrase.id, original: null, translated: tokens);
    }
  }

  Future<void> processTokenizationBatch(Map<String, dynamic> batchResult, List<Phrase> phrases, {bool isOriginal = true, required Language language}) async {
    final List<dynamic> lines = batchResult['lines'] ?? [];
    for (var line in lines) {
      final id = ResponseParserUtils.parseId(line['id']);
      final phrase = phrases.where((p) => p.id == id).firstOrNull;
      if (phrase != null) {
        await processTokenizationResult(phrase, line, isOriginal: isOriginal, language: language);
      }
    }
  }

  Future<void> processMorphologyBatch(Map<String, dynamic> batchResult, List<Phrase> phrases) async {
    final List<dynamic> lines = batchResult['lines'] ?? [];
    final List<Phrase> toUpdate = [];
    final List<int> completedIds = [];

    for (var line in lines) {
      final id = ResponseParserUtils.parseId(line['id']);
      final phrase = phrases.where((p) => p.id == id).firstOrNull;
      if (phrase != null) {
        _applyMorphologyToPhrase(phrase, line);
        toUpdate.add(phrase);
        completedIds.add(phrase.id);
      }
    }

    if (toUpdate.isNotEmpty) {
      await phraseService.putPhrases(toUpdate);
      await _updateWordIndexForPhrases(toUpdate);
      await phraseService.setStages(completedIds, StageKey.morphology, StageState.completed);
    }
  }

  void _applyMorphologyToPhrase(Phrase phrase, Map<String, dynamic> result) {
    if (result['alignment'] is List) {
      final trTokens = phrase.translatedWords ?? [];
      final Map<int, TranslationTokenEntry> trMap = {for (var t in trTokens) t.translatedWordPosition ?? 0: t};

      for (var align in result['alignment']) {
        final trPos = ResponseParserUtils.parseId(align['translationPosition']);
        final token = trMap[trPos];
        if (token == null) continue;
        
        token.sourceWordPositions = ResponseParserUtils.parseIntList(align['sourceWordPositions']);
        token.isInferred = align['inferred'] == true;
      }
    }

    if (result['particleFunctions'] is List) {
       for (var pf in result['particleFunctions']) {
        final pos = ResponseParserUtils.parseId(pf['wordPosition']);
        final fn = pf['grammarFunction']?.toString();
        if (pos > 0 && fn != null) {
           final token = phrase.originalTokens?.where((t) => t.wordPosition == pos).firstOrNull;
           if (token != null) {
             token.grammarFunction = _parseGrammarFunction(fn);
           }
        }
      }
    }
  }

  Future<AiRequestResult> saveTranslationsResponse(Map<String, dynamic> parsedJson, {List<int> expectedIds = const []}) async {
    final lines = parsedJson['lines'];
    if (lines is! List) {
      await phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final List<Phrase> toUpdate = [];
    final List<int> processedIds = [];
    final List<int> failedIds = [];

    for (var lineData in lines) {
      if (lineData is! Map<String, dynamic>) continue;
      final int phraseId = ResponseParserUtils.parseId(lineData['id']);
      final String translation = lineData['translation']?.toString() ?? '';
      final String? cleanedOriginal = lineData['cleanedOriginal']?.toString();

      if (phraseId <= 0 || translation.isEmpty) {
        if (phraseId > 0) failedIds.add(phraseId);
        continue;
      }

      final phrase = await phraseService.getPhraseById(phraseId);
      if (phrase != null) {
        phrase.translatedPhrase = translation;
        if (cleanedOriginal != null && cleanedOriginal.isNotEmpty) {
          phrase.originalPhrase = cleanedOriginal;
        }
        final statuses = Map<String, String>.from(phrase.stageStatuses);
        statuses[StageKey.translation] = StageState.completed.name;
        phrase.stageStatuses = statuses;
        toUpdate.add(phrase);
        processedIds.add(phraseId);
      }
    }

    if (toUpdate.isNotEmpty) {
      await phraseService.putPhrases(toUpdate);
    }

    final missingIds = expectedIds.where((id) => !processedIds.contains(id) && !failedIds.contains(id)).toList();
    if (missingIds.isNotEmpty) {
      logger.w('[Handler] Missing IDs in translation response: $missingIds');
      await phraseService.resetPhrasesTranslationStatusByIds(missingIds);
    }
    if (failedIds.isNotEmpty) {
      await phraseService.resetPhrasesTranslationStatusByIds(failedIds);
    }

    if (failedIds.isEmpty && missingIds.isEmpty) return AiRequestResult.success();
    return AiRequestResult.partialSuccess([...failedIds, ...missingIds]);
  }

  WordPos _parsePos(String? pos) {
    if (pos == null) return WordPos.unknown;
    final p = pos.toLowerCase();
    switch (p) {
      case 'v': return WordPos.v;
      case 'i': return WordPos.i;
      case 'd': return WordPos.d;
      case 'n': return WordPos.n;
      case 'p': return WordPos.p;
      case 'x': return WordPos.x;
      case 's': return WordPos.s;
      case 'o': return WordPos.o;
      default: return WordPos.unknown;
    }
  }

  GrammarFunction _parseGrammarFunction(String? fn) {
    if (fn == null || fn == 'none') return GrammarFunction.none;
    final val = fn.toLowerCase();
    for (final e in GrammarFunction.values) {
      if (e.name == val) return e;
    }
    return GrammarFunction.none;
  }

  Future<void> _updateWordIndexForPhrases(List<Phrase> phrases) async {
    if (phrases.isEmpty) return;

    try {
      final List<WordIndex> newIndices = [];
      final videoIds = phrases.map((p) => p.videoId).whereType<int>().toSet();
      final Map<int, Video> videoMap = {};
      for (var vid in videoIds) {
        final v = await phraseService.db.videos.get(vid);
        if (v != null) videoMap[vid] = v;
      }

      final phraseIds = phrases.map((p) => p.id).toList();

      await phraseService.db.writeTxn(() async {
        // 1. Batch delete existing indices for all phrases in this batch
        final existing = await phraseService.db.wordIndexs
            .filter()
            .anyOf(phraseIds, (q, int id) => q.phraseIdEqualTo(id))
            .findAll();
        
        if (existing.isNotEmpty) {
          await phraseService.db.wordIndexs.deleteAll(existing.map((e) => e.id).toList());
        }

        // 2. Prepare new indices
        for (var phrase in phrases) {
          if (phrase.originalTokens == null) continue;
          final video = videoMap[phrase.videoId];

          for (var token in phrase.originalTokens!) {
            if (token.lemma == null || token.lemma!.isEmpty) continue;
            
            newIndices.add(WordIndex(
              lemma: token.lemma!,
              pos: token.pos,
              videoId: phrase.videoId ?? 0,
              seriesName: video?.seriesName ?? video?.fileName,
              phraseId: phrase.id,
              contextOriginal: phrase.originalPhrase,
              contextTranslated: phrase.translatedPhrase,
              wordPosition: token.wordPosition,
              blockId: token.blockId,
            ));
          }
        }

        // 3. Batch insert new indices
        if (newIndices.isNotEmpty) {
          await phraseService.db.wordIndexs.putAll(newIndices);
        }
      });
    } catch (e) {
      logger.e('[Handler] Failed to update WordIndex', error: e);
    }
  }
}
