import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import '../../../database/schemas/ai_model.dart';
import '../../utils/ai_exceptions.dart';
import '../parsers/phrase_response_handler.dart';
import '../parsers/response_parser_utils.dart';
import '../../../../utils/logger.dart';
import '../../../../config/secure_storage.dart';

class GeminiService {
  final PhraseResponseHandler phraseResponseHandler;
  final Ref ref;

  GeminiService({
    required this.phraseResponseHandler,
    required this.ref,
  });

  Future<AiRequestResult> fetchEpisodeContext(String url, String prompt, int videoId, {required AiModel model}) async {
    logger.d('[AiHttp] Fetching episode context for video $videoId');
    try {
      final String jsonString = await sendRequest(url, prompt, model: model);

      final videoService = ref.read(videoServiceProvider);
      final video = await videoService.getVideoById(videoId);

      if (video != null) {
        video.isResearchDone = true;
        video.researchInformation = jsonString; // Store the cleaned JSON or raw text
        await videoService.updateVideo(video);
      }
      return AiRequestResult.success();
    } catch (error) {
      if (error is GeminiException) {
        return AiRequestResult.failure(error.type);
      }
      rethrow;
    }
  }

  Future<AiRequestResult> fetchTranslations(String url, String prompt, {required AiModel model, List<int> expectedIds = const []}) async {
    logger.d('[AiHttp] Fetching translations for ${expectedIds.length} phrases');
    try {
      final String jsonString = await sendRequest(url, prompt, model: model);
      final Map<String, dynamic> jsonResponse = jsonDecode(jsonString);

      return await phraseResponseHandler.saveTranslationsResponse(jsonResponse, expectedIds: expectedIds);
    } catch (error) {
      if (error is GeminiException) {
        return AiRequestResult.failure(error.type);
      }
      rethrow;
    }
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
    logger.d('[AiHttp] Fetching parse and save for ${expectedIds.length} phrases. Soft reset: $useSoftReset');
    try {
      final String jsonResponse = await sendRequest(url, prompt, model: model);
      
      // Log received data - Simplified
      logger.v('[AiHttp] Received data (${jsonResponse.length} chars)');

      final result = await phraseResponseHandler.processResponse(jsonResponse, expectedIds: expectedIds, language: language);
      
      if (result.phase == AiRequestPhase.success) {
        onProgress?.call(expectedIds.length);
      }
      
      return result;
    } catch (error) {
      if (error is GeminiException) {
        return AiRequestResult.failure(error.type, message: error.message);
      }
      return AiRequestResult.failure(AiErrorType.unknown, message: error.toString());
    }
  }

  Future<String> sendRequest(String url, String prompt, {required AiModel model}) async {
    try {
      logger.d('[GeminiHttp] Sending request to ${model.name}');
      
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      
      final Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [{"text": prompt}],
          },
        ],
      };

      final response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      )
      .timeout(
        const Duration(seconds: 160),
        onTimeout: () => throw GeminiGeneralException("Gemini request time out"),
      );

      await ref.read(aiModelServiceProvider).incrementUsage(model.name, 1);

      if (response.statusCode == 200) {
        final bodyText = response.body;
        if (bodyText.trim().isEmpty) {
          throw GeminiGeneralException("Empty response body from Gemini");
        }

        final data = jsonDecode(bodyText);
        
        if (data is Map && data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            String rawText = candidate['content']['parts'][0]['text'].toString();
            String cleanedResponse = rawText.replaceAll('```json', '').replaceAll('```', '').trim();
            return cleanedResponse;
          }
        }
        throw GeminiGeneralException("Unexpected response shape from Gemini");
      } else {
        _handleHttpError(response);
        throw Exception("Unreachable code");
      }
    } catch (e) {
      if (e is GeminiException) rethrow;
      throw GeminiGeneralException("Connection error to Gemini: ${e.toString()}");
    }
  }

  Future<String> sendRequestWithAudio(String url, String prompt, String base64Audio, {required AiModel model, String mimeType = 'audio/mp3'}) async {
    try {
      logger.d('[GeminiAudio] Sending request to ${model.name}');
      
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      
      final Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
              {
                "inline_data": {
                  "mime_type": mimeType,
                  "data": base64Audio
                }
              }
            ],
          },
        ],
        "generationConfig": {
          "responseMimeType": "application/json",
        }
      };

      final response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      )
      .timeout(
        const Duration(seconds: 300),
        onTimeout: () => throw GeminiGeneralException("AI audio request time out"),
      );

      await ref.read(aiModelServiceProvider).incrementUsage(model.name, 1);

      if (response.statusCode == 200) {
        final bodyText = response.body;
        final data = jsonDecode(bodyText);
        
        if (data is Map && data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            String rawText = candidate['content']['parts'][0]['text'].toString();
            logger.v('[AiHttp] Valid audio response received from ${model.name}');
            // If model doesn't support JSON mode but we asked for it, we might get markdown
            return rawText.replaceAll('```json', '').replaceAll('```', '').trim();
          }
        }
        logger.e('[AiHttp] Audio response 200 but unexpected shape: $bodyText');
        throw GeminiGeneralException("Unexpected audio response shape from AI");
      } else if (response.statusCode == 400 && response.body.contains('JSON mode')) {
        // FALLBACK: If model doesn't support JSON mode, retry without it
        logger.w('[AiHttp] Model ${model.name} does not support JSON mode. Retrying without it...');
        final Map<String, dynamic> fallbackBody = {
          "contents": [
            {
              "parts": [
                {"text": "$prompt\nIMPORTANT: Return ONLY valid JSON array as requested."},
                {"inline_data": {"mime_type": mimeType, "data": base64Audio}}
              ],
            },
          ],
        };
        final fallbackResponse = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(fallbackBody),
        ).timeout(const Duration(seconds: 300));

        if (fallbackResponse.statusCode == 200) {
          final data = jsonDecode(fallbackResponse.body);
          String rawText = data['candidates'][0]['content']['parts'][0]['text'].toString();
          return rawText.replaceAll('```json', '').replaceAll('```', '').trim();
        } else {
          _handleHttpError(fallbackResponse);
        }
        throw Exception("Unreachable");
      } else {
        logger.e('[AiHttp] Audio request failed. Status: ${response.statusCode}, Body: ${response.body}');
        _handleHttpError(response);
        throw Exception("Unreachable code");
      }
    } catch (e) {
      if (e is GeminiException) rethrow;
      throw GeminiGeneralException("Audio connection error: ${e.toString()}");
    }
  }

  void _handleHttpError(http.Response response) {
    final int code = response.statusCode;
    final body = response.body;
    logger.e('AI HTTP Error: $code. Body: $body');
    
    final retryAfter = ResponseParserUtils.parseRetryAfter(body);

    if (code == 403 || code == 400) {
      throw GeminiIncorrectTokenException("Token is incorrect or request malformed");
    } else if (code == 429) {
      throw GeminiModelExpiredException('Rate limit exceeded', retryAfter: retryAfter);
    } else if (code == 500 || code == 503 || code == 504) {
      throw GeminiServerException('Server error', retryAfter: retryAfter ?? const Duration(seconds: 4));
    } else {
      throw GeminiGeneralException('Request failed with status $code', retryAfter: retryAfter);
    }
  }
}
