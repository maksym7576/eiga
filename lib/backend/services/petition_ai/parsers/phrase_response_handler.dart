import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../../database/schemas/phrase.dart';
import '../../../database/schemas/block.dart';
import '../../../database/schemas/word.dart';
import '../../../database/services/phrase_service.dart';
import '../../../database/services/block_service.dart';
import '../../../database/services/word_service.dart';
import '../../utils/ai_exceptions.dart';
import '../../../../providers/services/ai_request_state.dart';
import 'response_parser_utils.dart';
import 'word_reading_normalizer.dart';
import '../../../../utils/logger.dart';

class PhraseResponseHandler {
  final PhraseService phraseService;
  final BlockService blockService;
  final WordService wordService;

  final WordReadingNormalizer _normalizer = WordReadingNormalizer();

  PhraseResponseHandler({
    required this.phraseService,
    required this.blockService,
    required this.wordService,
  });

  void _log(String message) {
    logger.d('[PhraseResponseHandler] $message');
  }

  Future<AiRequestResult> processResponse(String jsonResponse, {List<int> expectedIds = const []}) async {
    dynamic parsed;
    try {
      parsed = jsonDecode(jsonResponse);
    } catch (e) {
      await phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final List<dynamic> entries;
    if (parsed is List) {
      entries = parsed;
    } else if (parsed is Map) {
      entries = [parsed];
    } else {
      await phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
      return AiRequestResult.failure(AiErrorType.parse);
    }

    final failedPhraseIds = <int>[];
    final processedIds = <int>{};
    final Set<String> dedupSignatures = {};

    for (final entry in entries) {
      final outcome = await processPhraseEntryData(entry, dedupSignatures: dedupSignatures);
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
      await phraseService.resetPhrasesTranslationStatusByIds(missingIds);
    }

    if (failedPhraseIds.isEmpty) {
      return AiRequestResult.success();
    }
    return AiRequestResult.partialSuccess(failedPhraseIds.toList());
  }

  Future<_PhraseOutcome?> processPhraseEntryData(
    dynamic phrasesData, {
    Set<String>? dedupSignatures,
  }) async {
    if (phrasesData == null || phrasesData is! Map) return null;

    final int phraseId = ResponseParserUtils.parseId(phrasesData['phraseId']);
    if (phraseId <= 0) return null;

    final rawBlocks = phrasesData['blocks'];
    if (rawBlocks is! List || rawBlocks.isEmpty) {
      await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
      return _PhraseOutcome(phraseId: phraseId, ok: false);
    }

    final phrase = await phraseService.getPhraseById(phraseId);
    if (phrase == null) return _PhraseOutcome(phraseId: phraseId, ok: false);

    // Save translation if present in this entry
    final String? entryTranslation = phrasesData['translation']?.toString();

    final Set<String> referenceVersionKeys = _normalizer.collectReferenceVersionKeys(rawBlocks);
    final firstWordPos = _normalizer.findFirstWordPosition(rawBlocks);

    bool phraseHadErrors = false;

    for (var blockJson in rawBlocks) {
      try {
        if (blockJson is! Map || !blockJson.containsKey('b_pos') || !blockJson.containsKey('tr')) {
          phraseHadErrors = true;
          continue;
        }

        final int? blockPos = blockJson['b_pos'] is int
            ? blockJson['b_pos'] as int
            : int.tryParse(blockJson['b_pos'].toString());
        
        if (blockPos == null) {
          phraseHadErrors = true;
          continue;
        }

        final contentSignature = "${phraseId}_$blockPos";

        if (dedupSignatures != null && dedupSignatures.contains(contentSignature)) {
          continue;
        }
        dedupSignatures?.add(contentSignature);

        final existingBlock = await blockService.getBlockByContentSignature(contentSignature);
        if (existingBlock != null) continue;

        final newBlock = Block(
          phraseId: phraseId,
          blockTranslation: blockJson['tr']?.toString() ?? '',
          translatedPositionIndex: ResponseParserUtils.parseIntList(blockJson['tr_pos']),
          blockPositionIndex: blockPos,
          contentSignature: contentSignature,
          colorHex: ResponseParserUtils.parseColorHex(blockJson['colorHex']),
        );

        final blockId = await blockService.createBlock(block: newBlock);

        final List<dynamic> wordDataJson = blockJson['word'] is List ? blockJson['word'] as List : [];

        for (var wordData in wordDataJson) {
          try {
            if (wordData is! Map) {
              phraseHadErrors = true;
              continue;
            }
            final Map<String, dynamic> map = Map<String, dynamic>.from(wordData);

            final int? currentWordPos = map['w_pos'] is int
                ? map['w_pos'] as int
                : int.tryParse(map['w_pos']?.toString() ?? '');

            final bool isFirstWordInPhrase = firstWordPos != null &&
                blockPos == firstWordPos.blockPos &&
                currentWordPos == firstWordPos.wordPos;

            final newWord = Word(
              blockId: blockId,
              wordPosition: currentWordPos,
            )..versions = _normalizer.normalizeWordVersions(
                map,
                referenceVersionKeys,
                isFirstWordInPhrase: isFirstWordInPhrase,
              );

            await wordService.createWord(word: newWord);
          } catch (e) {
            phraseHadErrors = true;
          }
        }
      } catch (e) {
        phraseHadErrors = true;
      }
    }

    if (!phraseHadErrors) {
      await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId, translation: entryTranslation);
    } else {
      await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
    }

    return _PhraseOutcome(phraseId: phraseId, ok: !phraseHadErrors);
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

      if (phraseId <= 0 || translation.isEmpty) {
        if (phraseId > 0) {
          failedPhraseIds.add(phraseId);
          await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
        }
        continue;
      }

      processedIds.add(phraseId);
      try {
        await phraseService.updateTranslatedPhraseText(phraseId, translation);
      } catch (e) {
        failedPhraseIds.add(phraseId);
        await phraseService.resetPhrasesTranslationStatusByIds([phraseId]);
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
      await phraseService.resetPhrasesTranslationStatusByIds(missingIds);
    }

    if (failedPhraseIds.isEmpty) {
      return AiRequestResult.success();
    }
    return AiRequestResult.partialSuccess(failedPhraseIds.toList());
  }
}

class _PhraseOutcome {
  final int phraseId;
  final bool ok;
  const _PhraseOutcome({required this.phraseId, required this.ok});
}
