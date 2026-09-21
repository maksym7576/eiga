import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/services/petition_ai/parsers/phrase_response_handler.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import '../../../../providers/services/isar_services_providers.dart';
import '../../../database/schemas/ai_model.dart';
import '../../utils/ai_exceptions.dart';
import '../parsers/response_parser_utils.dart';
import '../../../../utils/logger.dart';
import '../../../../config/secure_storage.dart';

class GroqService {
  final Ref ref;
  final PhraseResponseHandler phraseResponseHandler;

  GroqService({required this.ref, required this.phraseResponseHandler});

  Future<String> sendRequest(String url, String prompt, {required AiModel model}) async {
    try {
      logger.d('[GroqHttp] Sending request to ${model.name}');
      
      final token = await SecureTokenStorage.getToken(ApiTokenType.groq);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final Map<String, dynamic> requestBody = {
        "model": model.name,
        "messages": [
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.1,
        "stream": false,
      };

      final response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      )
      .timeout(
        const Duration(seconds: 120),
        onTimeout: () => throw GeminiGeneralException("Groq request time out"),
      );

      await ref.read(aiModelServiceProvider).incrementUsage(model.name, 1);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].toString().trim();
        }
        throw GeminiGeneralException("Unexpected response shape from Groq");
      } else {
        _handleHttpError(response);
        throw Exception("Unreachable code");
      }
    } catch (e) {
      if (e is GeminiException) rethrow;
      throw GeminiGeneralException("Connection error to Groq: ${e.toString()}");
    }
  }

  void _handleHttpError(http.Response response) {
    final int code = response.statusCode;
    final body = response.body;
    logger.e('Groq HTTP Error: $code. Body: $body');
    
    final retryAfter = ResponseParserUtils.parseRetryAfter(body);

    if (code == 401 || code == 403) {
      throw GeminiIncorrectTokenException("Groq Token is incorrect");
    } else if (code == 429) {
      throw GeminiModelExpiredException('Groq Rate limit exceeded', retryAfter: retryAfter);
    } else if (code == 500 || code == 503) {
      throw GeminiServerException('Groq Server error', retryAfter: retryAfter ?? const Duration(seconds: 5));
    } else {
      throw GeminiGeneralException('Groq Request failed with status $code', retryAfter: retryAfter);
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
    try {
      final String jsonResponse = await sendRequest(url, prompt, model: model);
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
}
