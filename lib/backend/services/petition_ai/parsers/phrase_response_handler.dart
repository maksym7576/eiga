import 'dart:convert';
import '../../../database/schemas/block.dart';
import '../../../database/schemas/word.dart';
import '../../../database/schemas/phrase.dart';
import '../../../database/schemas/translation_word.dart';
import '../../../database/schemas/language.dart';
import '../../../database/services/phrase_service.dart';
import '../../../database/services/block_service.dart';
import '../../../database/services/word_service.dart';
import '../../../database/services/translation_word_service.dart';
import '../../utils/ai_exceptions.dart';
import '../../../../providers/services/ai_request_state.dart';
import 'response_parser_utils.dart';
import '../../../../utils/logger.dart';

class PhraseResponseHandler {
  final PhraseService phraseService;
  final BlockService blockService;
  final WordService wordService;
  final TranslationWordService translationWordService;

  PhraseResponseHandler({
    required this.phraseService,
    required this.blockService,
    required this.wordService,
    required this.translationWordService,
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

    final bool isJapanese = language?.toLowerCase() == 'japanese';
    bool phraseHadErrors = false;

    try {
      await _clearPhraseData(phraseId);
      for (final blockJson in rawBlocks) {
        if (blockJson is! Map) continue;
        final newBlock = Block(phraseId: phraseId, blockPositionIndex: blockJson['p'] as int?);
        final blockId = await blockService.createBlock(block: newBlock);

        final List<dynamic> tData = blockJson['t'] ?? [];
        final List<TranslationWord> translationWords = [];
        for (final tItem in tData) {
          if (tItem is! List || tItem.length < 3) continue;
          final List<int> sourceWordPositions = [];
          if (tItem.length >= 4 && tItem[3] is List) {
            for (final pos in tItem[3]) {
              if (pos is num) sourceWordPositions.add(pos.toInt());
            }
          }
          translationWords.add(TranslationWord(
            phraseId: phraseId,
            blockId: blockId,
            translatedWordPosition: tItem[0] as int?,
            text: tItem[1]?.toString(),
            isInferred: tItem[2] == true,
            sourceWordPositions: sourceWordPositions,
          ));
        }
        if (translationWords.isNotEmpty) await translationWordService.createTranslationWords(translationWords);

        final List<dynamic> wData = blockJson['w'] ?? [];
        for (final wItem in wData) {
          if (wItem is! List || wItem.length < 7) continue;
          final wPos = wItem[0] as int?;
          final original = wItem[1]?.toString() ?? '';
          String? posStr = wItem[2]?.toString();
          final lemma = wItem[3]?.toString();
          final kanaRaw = wItem[4]?.toString();
          final romaji = wItem[5]?.toString();
          final functionStr = wItem[6]?.toString();

          final punctuationPattern = RegExp(r'^[\p{P}\p{S}]+$', unicode: true);
          bool isLikelyPunctuation = punctuationPattern.hasMatch(original.trim());
          if (!isLikelyPunctuation && original.trim().length == 1) {
            const commonPunct = '()[]{}<>!?,.:;…-—"\'（）「」『』【】〈〉《〉〔〕［］｛｝！？，．：；。・';
            if (commonPunct.contains(original.trim())) isLikelyPunctuation = true;
          }
          if (isLikelyPunctuation) posStr = 's';

          final pos = _parsePos(posStr);
          final grammarFunction = _parseGrammarFunction(functionStr);
          bool isClickable = pos != WordPos.s && !isLikelyPunctuation;

          final Word newWord = Word(
            phraseId: phraseId,
            blockId: blockId,
            wordPosition: wPos,
            pos: pos,
            lemma: lemma,
            grammarFunction: grammarFunction,
            isClickable: isClickable,
          );

          String? kana = kanaRaw;
          if (isJapanese && (kana == null || kana.isEmpty)) kana = original;
          newWord.versions = [
            ReadingItem(key: 'original', text: original),
            if (kana != null && kana.isNotEmpty) ReadingItem(key: 'kana', text: kana),
            if (romaji != null && romaji.isNotEmpty) ReadingItem(key: 'romaji', text: romaji),
          ];
          await wordService.createWord(word: newWord);
        }
      }
    } catch (e) {
      phraseHadErrors = true;
      logger.e('Error processing phrase $phraseId', error: e);
    }

    if (!phraseHadErrors) {
      await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId);
    } else {
      await phraseService.resetTranslatingState([phraseId]);
    }
    return PhraseOutcome(phraseId: phraseId, ok: !phraseHadErrors);
  }

  Future<void> processTokenizationResult(Phrase phrase, Map<String, dynamic> result, {bool isOriginal = true, required Language language}) async {
    final List<TokenEntry> tokens = [];
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

    for (var item in rawList) {
      if (item is! Map<String, dynamic>) continue;
      final int pos = ResponseParserUtils.parseId(item['pos'] ?? item['wordPosition'] ?? item['translationPosition']);
      
      final List<ReadingItem> versions = [];
      for (var opt in language.readingOptions) {
        // Look for exact key or 'text' if it's 'original'
        final String keyToLook = opt == 'original' ? 'text' : opt;
        final val = item[keyToLook] ?? item[opt];
        if (val != null) {
          versions.add(ReadingItem(key: opt, text: val.toString()));
        }
      }

      tokens.add(TokenEntry(
        wordPosition: pos,
        pos: item['partOfSpeech']?.toString(),
        lemma: item['lemma']?.toString(),
        blockId: posToBlock[pos],
        versions: versions,
      ));
    }
    
    await phraseService.updateTokens(phrase.id, original: isOriginal ? tokens : null, translated: isOriginal ? null : tokens);
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
    for (var line in lines) {
      final id = ResponseParserUtils.parseId(line['id']);
      final phrase = phrases.where((p) => p.id == id).firstOrNull;
      if (phrase != null) {
        await processMorphologyResult(phrase, line);
      }
    }
  }

  Future<void> _clearPhraseData(int phraseId) async {
    await blockService.deleteByPhraseId(phraseId);
    await wordService.deleteByPhraseId(phraseId);
    await translationWordService.deleteByPhraseId(phraseId);
  }

  Future<void> processMorphologyResult(Phrase phrase, Map<String, dynamic> result) async {
    final int phraseId = phrase.id;
    await _clearPhraseData(phraseId);

    final Map<int, String> particleFunctions = {};
    if (result['particleFunctions'] is List) {
      for (var pf in result['particleFunctions']) {
        final pos = ResponseParserUtils.parseId(pf['wordPosition']);
        final fn = pf['grammarFunction']?.toString();
        if (pos > 0 && fn != null) particleFunctions[pos] = fn;
      }
    }

    final tokens = phrase.originalTokens ?? [];
    final Map<int, int> blockIdToDbId = {};
    final Map<int, List<TokenEntry>> blockGroups = {};
    for (var t in tokens) {
      final bId = t.blockId ?? (t.wordPosition ?? 0); 
      blockGroups.putIfAbsent(bId, () => []).add(t);
    }

    for (var entry in blockGroups.entries) {
      final bId = entry.key;
      final bTokens = entry.value;
      final block = Block(phraseId: phraseId, blockPositionIndex: bId);
      final dbBlockId = await blockService.createBlock(block: block);
      blockIdToDbId[bId] = dbBlockId;

      for (var t in bTokens) {
        final original = t.text ?? '';
        final pos = _parsePos(t.pos);
        final grammarFunction = _parseGrammarFunction(particleFunctions[t.wordPosition] ?? 'none');
        final punctuationPattern = RegExp(r'^[\p{P}\p{S}]+$', unicode: true);
        bool isClickable = pos != WordPos.s && !punctuationPattern.hasMatch(original.trim());

        final word = Word(
          phraseId: phraseId,
          blockId: dbBlockId,
          wordPosition: t.wordPosition,
          pos: pos,
          lemma: t.lemma,
          grammarFunction: grammarFunction,
          isClickable: isClickable,
          versions: List.from(t.versions),
        );
        await wordService.createWord(word: word);
      }
    }

    if (result['alignment'] is List) {
      final trTokens = phrase.translatedTokens ?? [];
      final Map<int, TokenEntry> trMap = {for (var t in trTokens) t.wordPosition ?? 0: t};
      
      // Map wordPosition -> dbBlockId
      final Map<int, int> posToBlockId = {};
      for (var t in tokens) {
        if (t.wordPosition == null) continue;
        final bId = t.blockId ?? t.wordPosition!;
        final dbId = blockIdToDbId[bId];
        if (dbId != null) posToBlockId[t.wordPosition!] = dbId;
      }

      for (var align in result['alignment']) {
        final trPos = ResponseParserUtils.parseId(align['translationPosition']);
        final token = trMap[trPos];
        if (token == null) continue;
        
        final sourceWordPositions = ResponseParserUtils.parseIntList(align['sourceWordPositions']);
        final isInferred = align['inferred'] == true;

        // Assign blockId from the first source word if available
        int? dbBlockId;
        if (sourceWordPositions.isNotEmpty) {
          dbBlockId = posToBlockId[sourceWordPositions.first];
        }

        await translationWordService.createTranslationWords([
          TranslationWord(
            phraseId: phraseId,
            blockId: dbBlockId,
            translatedWordPosition: trPos,
            text: token.text,
            isInferred: isInferred,
            sourceWordPositions: sourceWordPositions,
          )
        ]);
      }
    }
    await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId);
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

  Future<AiRequestResult> saveTranslationsResponse(Map<String, dynamic> parsedJson, {List<int> expectedIds = const []}) async {
    final lines = parsedJson['lines'];
    if (lines is! List) {
      await phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }
    final failedPhraseIds = <int>[];
    final processedIds = <int>{};
    for (var lineData in lines) {
      if (lineData is! Map<String, dynamic>) continue;
      final int phraseId = ResponseParserUtils.parseId(lineData['id']);
      final String translation = lineData['translation']?.toString() ?? '';
      final String? cleanedOriginal = lineData['cleanedOriginal']?.toString();
      if (phraseId <= 0 || translation.isEmpty) {
        if (phraseId > 0) {
          failedPhraseIds.add(phraseId);
          await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
        }
        continue;
      }
      processedIds.add(phraseId);
      try {
        if (cleanedOriginal != null && cleanedOriginal.isNotEmpty) {
          await phraseService.updatePhraseTextsRaw(phraseId, cleanedOriginal, translation);
        } else {
          await phraseService.updateTranslatedPhraseTextRaw(phraseId, translation);
        }
      } catch (e) {
        failedPhraseIds.add(phraseId);
        await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
      }
    }
    final missingIds = expectedIds.where((id) => !processedIds.contains(id)).toList();
    if (missingIds.isNotEmpty) {
      logger.w('[Handler] Missing IDs in translation response: $missingIds');
      await phraseService.resetPhrasesTranslationStatusByIds(missingIds);
    }
    if (failedPhraseIds.isEmpty) return AiRequestResult.success();
    return AiRequestResult.partialSuccess(failedPhraseIds.toList());
  }
}

class PhraseOutcome {
  final int phraseId;
  final bool ok;
  const PhraseOutcome({required this.phraseId, required this.ok});
}
