import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../providers/services/ai_request_state.dart';
import '../../../../providers/services/database_services_providers.dart';
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
      logger.d('[AiHttp] Received data (${jsonResponse.length} chars)');

      final result = await phraseResponseHandler.processResponse(jsonResponse, expectedIds: expectedIds, language: language);
      
      if (result.phase == AiRequestPhase.success) {
        onProgress?.call(expectedIds.length);
      }
      
      return result;
    } catch (error) {
      if (error is GeminiException) {
        return AiRequestResult.failure(error.type);
      }
      rethrow;
    }
  }

  Future<String> sendRequest(String url, String prompt, {required AiModel model}) async {
    logger.d('[AiHttp] Sending request (Provider: ${model.provider.name})');
    
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    
    // Add provider-specific headers
    switch (model.provider) {
      case AiProvider.google:
        // Key is already in the URL
        break;
      case AiProvider.openai:
        final token = await SecureTokenStorage.getToken(ApiTokenType.openai);
        headers['Authorization'] = 'Bearer $token';
        break;
      case AiProvider.anthropic:
        final token = await SecureTokenStorage.getToken(ApiTokenType.anthropic);
        headers['x-api-key'] = token;
        headers['anthropic-version'] = '2023-06-01'; // Required for Anthropic
        break;
      case AiProvider.custom:
        break;
    }

    final Map<String, dynamic> requestBody;
    
    // Format body based on provider
    if (model.provider == AiProvider.openai) {
      requestBody = {
        "model": model.name,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.1,
      };
    } else if (model.provider == AiProvider.anthropic) {
      requestBody = {
        "model": model.name,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 4096,
      };
    } else {
      // Default (Google)
      requestBody = {
        "contents": [
          {
            "parts": [{"text": prompt}],
          },
        ],
      };
    }

    final response = await http
        .post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody),
    )
    .timeout(
      const Duration(seconds: 160),
      onTimeout: () => throw GeminiGeneralException("AI request time out"),
    );

    // Increment usage for each request
    await ref.read(aiModelServiceProvider).incrementUsage(model.name, 1);

    if (response.statusCode == 200) {
      final bodyText = response.body;
      if (bodyText.trim().isEmpty) {
        throw GeminiGeneralException("Empty response body from AI");
      }

      final data = jsonDecode(bodyText);
      
      // Extract text based on provider
      if (model.provider == AiProvider.openai) {
        return data['choices'][0]['message']['content'].toString();
      } else if (model.provider == AiProvider.anthropic) {
        return data['content'][0]['text'].toString();
      } else {
        // Google
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
      }
      throw GeminiGeneralException("Unexpected response shape from AI");
    } else {
      _handleHttpError(response);
      throw Exception("Unreachable code");
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
