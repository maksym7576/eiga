import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../database/schemas/ai_model.dart';
import '../../../../config/secure_storage.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import '../../utils/ai_exceptions.dart';
import '../parsers/phrase_response_handler.dart';
import '../parsers/response_parser_utils.dart';
import '../../../../utils/logger.dart';

class GeminiStreamingService {
  final PhraseResponseHandler phraseResponseHandler;
  final Ref ref;

  final Set<int> _processedPhraseIds = {};
  final Set<int> _failedPhraseIds = {};
  String? _currentLanguage;

  GeminiStreamingService({
    required this.phraseResponseHandler,
    required this.ref,
  });

  void _log(String message) {
    logger.d('[GeminiStreamingService] $message');
  }

  Future<AiRequestResult> fetchParseAndSaveData(
    String url, 
    String prompt, {
    required AiModel model,
    List<int> expectedIds = const [],
    void Function(int processed)? onProgress,
    String? language,
    bool useSoftReset = false,
  }) async {
    logger.i('[GeminiStream] Starting for ${expectedIds.length} phrases. Soft reset: $useSoftReset');
    _processedPhraseIds.clear();
    _failedPhraseIds.clear();
    _currentLanguage = language;

    final Map<String, String> headers = {'Content-Type': 'application/json'};
    
    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [{"text": prompt}],
        },
      ],
    };

    final request = http.Request('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..body = jsonEncode(requestBody);

    await ref.read(aiModelServiceProvider).incrementUsage(model.name, 1);

    http.Client? client;
    try {
      client = http.Client();
      final streamedResponse = await client.send(request).timeout(
        const Duration(seconds: 160),
        onTimeout: () => throw GeminiGeneralException("Gemini stream request time out"),
      );

      if (streamedResponse.statusCode != 200) {
        final errorString = await streamedResponse.stream.bytesToString();
        if (useSoftReset) {
          await phraseResponseHandler.phraseService.resetTranslatingState(expectedIds);
        } else {
          await phraseResponseHandler.phraseService.resetPhrasesTranslationStatusByIds(expectedIds);
        }
        _handleHttpError(streamedResponse.statusCode, errorString);
      }

      final StringBuffer fullTextBuffer = StringBuffer();
      final stream = streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (var line in stream) {
        if (!line.startsWith('data: ')) continue;
        final dataStr = line.substring(6).trim();
        if (dataStr.isEmpty) continue;

        try {
          final jsonData = jsonDecode(dataStr);
          final candidates = jsonData['candidates'];
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            if (content != null && content['parts'] != null && content['parts'].isNotEmpty) {
              final String? chunk = content['parts'][0]['text']?.toString();
              if (chunk != null) {
                fullTextBuffer.write(chunk);
                await _extractAndSaveReadyObjects(fullTextBuffer);
                onProgress?.call(_processedPhraseIds.length);
              }
            }
          }
        } catch (e) {
          _log('[PartialParseErr] ${e.toString()}');
        }
      }

      await _extractAndSaveReadyObjects(fullTextBuffer);
      onProgress?.call(_processedPhraseIds.length);

      logger.i('[GeminiStream] Finished. Processed: ${_processedPhraseIds.length}, Failed: ${_failedPhraseIds.length}');

      final missingIds = expectedIds.where((id) => !_processedPhraseIds.contains(id)).toList();
      if (missingIds.isNotEmpty) {
        if (useSoftReset) {
          await phraseResponseHandler.phraseService.resetTranslatingState(missingIds);
        } else {
          await phraseResponseHandler.phraseService.resetPhrasesTranslationStatusByIds(missingIds);
        }
        _failedPhraseIds.addAll(missingIds);
      }

      if (_failedPhraseIds.isEmpty) {
        return AiRequestResult.success();
      }
      return AiRequestResult.partialSuccess(_failedPhraseIds.toList());
    } catch (error) {
      final idsToReset = expectedIds.where((id) => !_processedPhraseIds.contains(id)).toList();
      if (idsToReset.isNotEmpty) {
        if (useSoftReset) {
          await phraseResponseHandler.phraseService.resetTranslatingState(idsToReset);
        } else {
          await phraseResponseHandler.phraseService.resetPhrasesTranslationStatusByIds(idsToReset);
        }
      }
      logger.e('Gemini Stream: fatal error', error: error);
      return AiRequestResult.failure(_resolveErrorType(error));
    } finally {
      client?.close();
    }
  }

  Future<void> _extractAndSaveReadyObjects(StringBuffer buffer) async {
    final raw = buffer.toString();
    int depth = 0;
    int startIndex = -1;
    bool insideString = false;
    bool isEscape = false;
    final List<_ExtractedPiece> readyPieces = [];

    for (int i = 0; i < raw.length; i++) {
      final ch = raw[i];
      if (insideString) {
        if (isEscape) {
          isEscape = false;
        } else if (ch == '\\') {
          isEscape = true;
        } else if (ch == '"') {
          insideString = false;
        }
        continue;
      }
      if (ch == '"') {
        insideString = true;
      } else if (ch == '{') {
        if (depth == 0) startIndex = i;
        depth++;
      } else if (ch == '}') {
        depth--;
        if (depth == 0 && startIndex != -1) {
          final piece = raw.substring(startIndex, i + 1);
          readyPieces.add(_ExtractedPiece(piece, startIndex, i + 1));
          startIndex = -1;
        }
      }
    }

    if (readyPieces.isEmpty) return;

    int removedUntil = 0;
    for (var p in readyPieces) {
      try {
        final decoded = jsonDecode(p.text);
        if (decoded is Map<String, dynamic> && ((decoded.containsKey('phraseId') && decoded.containsKey('blocks')) || (decoded.containsKey('id') && decoded.containsKey('b')))) {
          await _processOnePhrase(decoded);
        } else if (decoded is List) {
          for (var item in decoded) {
            if (item is Map<String, dynamic> && ((item.containsKey('phraseId') && item.containsKey('blocks')) || (item.containsKey('id') && item.containsKey('b')))) {
              await _processOnePhrase(item);
            }
          }
        }
      } catch (_) {
        continue;
      }
      removedUntil = p.end;
    }

    final remaining = raw.substring(removedUntil);
    buffer.clear();
    buffer.write(remaining);
  }

  Future<void> _processOnePhrase(Map<String, dynamic> entry) async {
    final idStr = (entry['id'] ?? entry['phraseId'])?.toString() ?? '0';
    final id = int.tryParse(idStr) ?? 0;
    
    if (id > 0) {
      if (_processedPhraseIds.contains(id)) return;
      _processedPhraseIds.add(id);
    }

    try {
      final outcome = await phraseResponseHandler.processPhraseEntryData(entry, language: _currentLanguage);
      if (outcome != null && !outcome.ok) {
        _failedPhraseIds.add(id);
      }
    } catch (e) {
      if (id > 0) _failedPhraseIds.add(id);
    }
  }

  void _handleHttpError(int code, String body) {
    logger.e('Gemini Stream Error: $code. Body: $body');
    
    final retryAfter = ResponseParserUtils.parseRetryAfter(body);

    if (code == 403 || code == 400) {
      throw GeminiIncorrectTokenException("Gemini Token is incorrect or request malformed");
    } else if (code == 429) {
      throw GeminiModelExpiredException('Gemini Rate limit exceeded', retryAfter: retryAfter);
    } else if (code == 500 || code == 503 || code == 504) {
      throw GeminiServerException('Gemini Server error', retryAfter: retryAfter ?? const Duration(seconds: 4));
    } else {
      throw GeminiGeneralException('Gemini Stream request failed with status $code', retryAfter: retryAfter);
    }
  }

  AiErrorType _resolveErrorType(Object error) {
    if (error is GeminiException) return error.type;
    if (error is http.ClientException) return AiErrorType.server;
    if (error.toString().contains('time out')) return AiErrorType.server;
    return AiErrorType.unknown;
  }
}

class _ExtractedPiece {
  final String text;
  final int start;
  final int end;
  _ExtractedPiece(this.text, this.start, this.end);
}
