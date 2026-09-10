import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../database/schemas/ai_model.dart';
import '../../../../config/secure_storage.dart';
import '../../../../providers/services/ai_request_state.dart';
import '../../../../providers/services/database_services_providers.dart';
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
    logger.i('[AiStream] Starting for ${expectedIds.length} phrases (Provider: ${model.provider.name}). Soft reset: $useSoftReset');
    _processedPhraseIds.clear();
    _failedPhraseIds.clear();
    _currentLanguage = language;

    // Headers
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    
    switch (model.provider) {
      case AiProvider.google:
        // Key is already in URL
        break;
      case AiProvider.openai:
        final token = await SecureTokenStorage.getToken(ApiTokenType.openai);
        headers['Authorization'] = 'Bearer $token';
        break;
      case AiProvider.anthropic:
        final token = await SecureTokenStorage.getToken(ApiTokenType.anthropic);
        headers['x-api-key'] = token;
        headers['anthropic-version'] = '2023-06-01';
        break;
      case AiProvider.custom:
        break;
    }

    // Body
    final Map<String, dynamic> requestBody;
    if (model.provider == AiProvider.openai) {
      requestBody = {
        "model": model.name,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.1,
        "stream": true,
      };
    } else if (model.provider == AiProvider.anthropic) {
      requestBody = {
        "model": model.name,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 4096,
        "stream": true,
      };
    } else {
      // Google
      requestBody = {
        "contents": [
          {
            "parts": [{"text": prompt}],
          },
        ],
      };
    }

    final request = http.Request('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..body = jsonEncode(requestBody);

    // Increment usage for each request
    await ref.read(aiModelServiceProvider).incrementUsage(model.name, 1);

    http.Client? client;
    try {
      client = http.Client();
      final streamedResponse = await client.send(request).timeout(
        const Duration(seconds: 160),
        onTimeout: () => throw GeminiGeneralException("AI stream request time out"),
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
        String dataStr = '';
        
        if (model.provider == AiProvider.google) {
          if (!line.startsWith('data: ')) continue;
          dataStr = line.substring(6).trim();
        } else if (model.provider == AiProvider.openai) {
          if (!line.startsWith('data: ')) continue;
          dataStr = line.substring(6).trim();
          if (dataStr == '[DONE]') break;
        } else if (model.provider == AiProvider.anthropic) {
          if (!line.startsWith('data: ')) continue;
          dataStr = line.substring(6).trim();
        }

        if (dataStr.isEmpty) continue;

        try {
          final jsonData = jsonDecode(dataStr);
          final String? newTextChunk = _extractTextChunk(jsonData, model: model);
          if (newTextChunk != null) {
            fullTextBuffer.write(newTextChunk);
            await _extractAndSaveReadyObjects(fullTextBuffer);
            onProgress?.call(_processedPhraseIds.length);
          }
        } catch (e) {
          _log('[PartialParseErr] ${e.toString()}');
        }
      }

      // Final check for remaining buffer
      await _extractAndSaveReadyObjects(fullTextBuffer);
      onProgress?.call(_processedPhraseIds.length);

      logger.i('[AiStream] Finished. Processed: ${_processedPhraseIds.length}, Failed: ${_failedPhraseIds.length}');

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

  String? _extractTextChunk(dynamic jsonData, {required AiModel model}) {
    if (jsonData is! Map) return null;

    switch (model.provider) {
      case AiProvider.google:
        final candidates = jsonData['candidates'];
        if (candidates == null || candidates.isEmpty) return null;
        final content = candidates[0]['content'];
        if (content == null || content['parts'] == null || content['parts'].isEmpty) return null;
        return content['parts'][0]['text']?.toString();
        
      case AiProvider.openai:
        final choices = jsonData['choices'];
        if (choices == null || choices.isEmpty) return null;
        final delta = choices[0]['delta'];
        return delta?['content']?.toString();
        
      case AiProvider.anthropic:
        final type = jsonData['type'];
        if (type == 'content_block_delta') {
          return jsonData['delta']?['text']?.toString();
        }
        return null;
        
      case AiProvider.custom:
        return null;
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
        // Incomplete JSON, skip and leave in buffer
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
    
    // Log received phrase entry in stream - Simplified
    if (id % 10 == 0) { // Log every 10th phrase to avoid flooding
      logger.d('[AiStream] Received phrase $id');
    }

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
    logger.e('AI Stream Error: $code. Body: $body');
    
    final retryAfter = ResponseParserUtils.parseRetryAfter(body);

    if (code == 403 || code == 400) {
      throw GeminiIncorrectTokenException("Token is incorrect or request malformed");
    } else if (code == 429) {
      throw GeminiModelExpiredException('Rate limit exceeded', retryAfter: retryAfter);
    } else if (code == 500 || code == 503 || code == 504) {
      throw GeminiServerException('Server error', retryAfter: retryAfter ?? const Duration(seconds: 4));
    } else {
      throw GeminiGeneralException('Stream request failed with status $code', retryAfter: retryAfter);
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
