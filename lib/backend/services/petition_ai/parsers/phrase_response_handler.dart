import 'dart:convert';
import 'dart:convert';
import 'package:isar_community/isar.dart';
import '../../../database/schemas/phrase.dart';
import '../../../database/schemas/word_index.dart';
import '../../../database/schemas/video.dart';
import '../../../../config/languages/language_hub.dart';
import '../../../services/database/phrase_service.dart';
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

  Future<void> processTokenizationBatch(Map<String, dynamic> batchResult, List<Phrase> phrases, {bool isOriginal = true, required String languageName}) async {
    final List<dynamic> lines = batchResult['lines'] ?? [];
    for (var line in lines) {
      final id = ResponseParserUtils.parseId(line['id']);
      final phrase = phrases.where((p) => p.id == id).firstOrNull;
      if (phrase != null) {
        await processTokenizationResult(phrase, line, isOriginal: isOriginal, languageName: languageName);
      }
    }
  }

  Future<void> processTokenizationResult(Phrase phrase, Map<String, dynamic> result, {bool isOriginal = true, required String languageName}) async {
    final List<dynamic> rawList = result['words'] ?? result['tokens'] ?? [];
    final config = LanguageHub.getByName(languageName);
    final readingOptions = config?.readingOptions ?? ['original'];

    final List<dynamic> blocks = result['renderBlocks'] ?? result['blocks'] ?? [];
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
        for (var opt in readingOptions) {
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
    final tokens = phrase.originalTokens ?? [];
    final Map<int, TokenEntry> tokenPosMap = {for (final t in tokens) if (t.wordPosition != null) t.wordPosition!: t};

    if (result['alignment'] is List) {
      final trTokens = phrase.translatedWords ?? [];
      final Map<int, TranslationTokenEntry> trMap = {for (var t in trTokens) t.translatedWordPosition ?? 0: t};

      for (var align in result['alignment']) {
        final trPos = ResponseParserUtils.parseId(align['translationPosition']);
        final token = trMap[trPos];
        if (token == null) continue;
        
        final rawPositions = ResponseParserUtils.parseIntList(align['sourceWordPositions']);
        // Filter out p/x/s tokens from alignment as per morphology v2 rule
        final filteredPositions = rawPositions.where((pos) {
          final t = tokenPosMap[pos];
          if (t == null) return true; // keep if unknown locally
          return t.pos != WordPos.p && t.pos != WordPos.x && t.pos != WordPos.s;
        }).toList();

        token.sourceWordPositions = filteredPositions;
        token.isInferred = align['inferred'] == true || filteredPositions.isEmpty;
      }
    }

    if (result['grammarCodes'] is List) {
      for (var gc in result['grammarCodes']) {
        final pos = ResponseParserUtils.parseId(gc['wordPosition']);
        final code = gc['code']?.toString();
        if (pos > 0 && code != null) {
          final token = tokenPosMap[pos];
          if (token != null) {
            token.grammarCode = code;
          }
        }
      }
    }

    if (result['idiomSpans'] is List) {
      phrase.idiomSpans = (result['idiomSpans'] as List).map((s) => ResponseParserUtils.parseIntList(s)).toList();
    }

    if (result['particleFunctions'] is List) {
       for (var pf in result['particleFunctions']) {
        final pos = ResponseParserUtils.parseId(pf['wordPosition']);
        final fn = pf['grammarFunction']?.toString();
        if (pos > 0 && fn != null) {
           final token = tokenPosMap[pos];
           if (token != null) {
             token.grammarFunction = _parseGrammarFunction(fn);
             // Fallback code map
             token.grammarCode ??= 'ptl.${fn.toLowerCase()}';
           }
        }
      }
    }

    // Initialize basic structural fields used for rendering / clustering
    _initializeTokenMetadata(phrase);
  }

  void _initializeTokenMetadata(Phrase phrase) {
    final tokens = phrase.originalTokens ?? [];
    for (int i = 0; i < tokens.length; i++) {
      final t = tokens[i];
      t.surface = t.versions.isNotEmpty ? t.versions.first.text : '';
      
      final isContent = (t.pos == WordPos.v || t.pos == WordPos.i || t.pos == WordPos.d || t.pos == WordPos.n || t.pos == WordPos.o);
      if (isContent) {
        t.groupRole = GroupRole.head;
        t.attachMode = AttachMode.none;
      } else {
        t.groupRole = (t.pos == WordPos.p) ? GroupRole.particle : ((t.pos == WordPos.x) ? GroupRole.auxiliary : GroupRole.punct);
        
        final isModality = (t.grammarCode != null && t.grammarCode!.contains('modality')) || 
                           (t.surface == 'そうだ' || t.surface == 'らしい' || t.surface == 'みたい');
        t.attachMode = isModality ? AttachMode.modify : AttachMode.merge;
      }
    }
  }

  void _buildLinkGroups(Phrase phrase) {
    final tokens = phrase.originalTokens ?? [];
    final translations = phrase.translatedWords ?? [];
    if (tokens.isEmpty && translations.isEmpty) return;

    final Map<String, String> parent = {};
    void addUf(String id) => parent.putIfAbsent(id, () => id);
    String findUf(String id) {
      if (!parent.containsKey(id)) return id;
      if (parent[id] == id) return id;
      parent[id] = findUf(parent[id]!);
      return parent[id]!;
    }
    void unionUf(String id1, String id2) {
      addUf(id1); addUf(id2);
      final r1 = findUf(id1); final r2 = findUf(id2);
      if (r1 != r2) parent[r1] = r2;
    }

    for (final t in tokens) { if (t.wordPosition != null) addUf('s${t.wordPosition}'); }
    for (final w in translations) { if (w.translatedWordPosition != null) addUf('t${w.translatedWordPosition}'); }

    // Union by Idiom Spans first
    final spans = phrase.idiomSpans ?? [];
    for (final span in spans) {
      if (span.length > 1) {
        for (int i = 0; i < span.length - 1; i++) {
          unionUf('s${span[i]}', 's${span[i + 1]}');
        }
      }
    }

    for (final w in translations) {
      if (w.translatedWordPosition != null) {
        for (final sp in w.sourceWordPositions) {
          unionUf('t${w.translatedWordPosition}', 's$sp');
        }
      }
    }

    for (final t in tokens) {
      if (t.wordPosition != null && t.attachMode == AttachMode.merge && t.headPosition != null) {
        unionUf('s${t.wordPosition}', 's${t.headPosition}');
      }
    }

    final Map<String, List<String>> clusters = {};
    for (final key in parent.keys) {
      final root = findUf(key);
      clusters.putIfAbsent(root, () => []).add(key);
    }

    final List<LinkGroup> groups = [];
    int currentGroupId = 0;
    final Map<int, int> sourceToGroupId = {};
    final Map<int, int> targetToGroupId = {};

    for (final cluster in clusters.values) {
      final List<int> srcPos = [];
      final List<int> tgtPos = [];

      for (final item in cluster) {
        if (item.startsWith('s')) {
          final id = int.tryParse(item.substring(1));
          if (id != null) srcPos.add(id);
        } else if (item.startsWith('t')) {
          final id = int.tryParse(item.substring(1));
          if (id != null) tgtPos.add(id);
        }
      }

      srcPos.sort();
      tgtPos.sort();

      int? headSourcePos;
      for (final sp in srcPos) {
        final tok = tokens.firstWhere((t) => t.wordPosition == sp, orElse: () => TokenEntry());
        if (tok.groupRole == GroupRole.head) {
          headSourcePos = sp;
          break;
        }
      }
      headSourcePos ??= srcPos.isNotEmpty ? srcPos.first : null;

      final bool isIdiom = spans.any((span) => srcPos.any((sp) => span.contains(sp)));

      final gid = currentGroupId++;
      final lg = LinkGroup(
        groupId: gid,
        sourcePositions: srcPos,
        targetPositions: tgtPos,
        headSourcePosition: headSourcePos,
        relatedGroupIds: [],
        isIdiom: isIdiom,
      );
      groups.add(lg);

      for (final sp in srcPos) sourceToGroupId[sp] = gid;
      for (final tp in tgtPos) targetToGroupId[tp] = gid;
    }

    for (final t in tokens) {
      if (t.wordPosition != null && t.attachMode == AttachMode.modify && t.headPosition != null) {
        final myGid = sourceToGroupId[t.wordPosition!];
        final targetGid = sourceToGroupId[t.headPosition!];
        if (myGid != null && targetGid != null && myGid != targetGid) {
          final myGroup = groups.firstWhere((g) => g.groupId == myGid);
          final targetGroup = groups.firstWhere((g) => g.groupId == targetGid);
          if (!myGroup.relatedGroupIds.contains(targetGid)) myGroup.relatedGroupIds.add(targetGid);
          if (!targetGroup.relatedGroupIds.contains(myGid)) targetGroup.relatedGroupIds.add(myGid);
        }
      }
    }

    for (final t in tokens) { if (t.wordPosition != null) t.linkGroupId = sourceToGroupId[t.wordPosition!]; }
    for (final w in translations) { if (w.translatedWordPosition != null) w.linkGroupId = targetToGroupId[w.translatedWordPosition!]; }

    phrase.linkGroups = groups;
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

  Future<void> processGrammarRoleBatch(Map<String, dynamic> batchResult, List<Phrase> phrases) async {
    final List<dynamic> lines = batchResult['lines'] ?? [];
    final List<Phrase> toUpdate = [];

    for (var line in lines) {
      if (line is! Map<String, dynamic>) continue;
      final id = ResponseParserUtils.parseId(line['id']);
      final phrase = phrases.where((p) => p.id == id).firstOrNull;
      if (phrase == null) continue;

      final roles = line['roles'];
      if (roles is List) {
        final tokens = phrase.originalTokens ?? [];
        final Map<int, TokenEntry> tokenPosMap = {for (final t in tokens) if (t.wordPosition != null) t.wordPosition!: t};

        for (var roleItem in roles) {
          if (roleItem is! Map<String, dynamic>) continue;
          final pos = ResponseParserUtils.parseId(roleItem['wordPosition']);
          final token = tokenPosMap[pos];
          if (token != null) {
            token.grammarFunction = _parseGrammarFunction(roleItem['grammarFunction']?.toString());
            token.relationLabel = roleItem['relationLabel']?.toString();
            
            final connectsTo = roleItem['connectsTo'];
            if (connectsTo is List && connectsTo.isNotEmpty) {
              token.headPosition = ResponseParserUtils.parseId(connectsTo.first);
            } else {
              token.headPosition = null;
            }
          }
        }
        _buildLinkGroups(phrase);
        toUpdate.add(phrase);
      }
    }

    if (toUpdate.isNotEmpty) {
      await phraseService.putPhrases(toUpdate);
      await _updateWordIndexForPhrases(toUpdate);
    }
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
            if (token.groupRole != GroupRole.head) continue; // Only index head lemmas
            
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
              linkGroupId: token.linkGroupId,
              grammarCode: token.grammarCode,
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
