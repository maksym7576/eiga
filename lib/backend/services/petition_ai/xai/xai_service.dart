import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import '../../../../providers/services/isar_services_providers.dart';
import '../../../database/schemas/ai_model.dart';
import '../../utils/ai_exceptions.dart';
import '../parsers/response_parser_utils.dart';
import '../../../../utils/logger.dart';
import '../../../../config/secure_storage.dart';

class XAiService {
  final Ref ref;

  XAiService({required this.ref});

  Future<String> sendRequest(String url, String prompt, {required AiModel model}) async {
    try {
      logger.d('[XAiHttp] Sending request to ${model.name}');
      
      final token = await SecureTokenStorage.getToken(ApiTokenType.xai);
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
        onTimeout: () => throw GeminiGeneralException("X.AI request time out"),
      );

      await ref.read(aiModelServiceProvider).incrementUsage(model.name, 1);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].toString().trim();
        }
        throw GeminiGeneralException("Unexpected response shape from X.AI");
      } else {
        _handleHttpError(response);
        throw Exception("Unreachable code");
      }
    } catch (e) {
      if (e is GeminiException) rethrow;
      throw GeminiGeneralException("Connection error to X.AI: ${e.toString()}");
    }
  }

  void _handleHttpError(http.Response response) {
    final int code = response.statusCode;
    final body = response.body;
    logger.e('X.AI HTTP Error: $code. Body: $body');
    
    final retryAfter = ResponseParserUtils.parseRetryAfter(body);

    if (code == 401 || code == 403) {
      throw GeminiIncorrectTokenException("X.AI Token is incorrect");
    } else if (code == 429) {
      throw GeminiModelExpiredException('X.AI Rate limit exceeded', retryAfter: retryAfter);
    } else if (code == 500 || code == 503) {
      throw GeminiServerException('X.AI Server error', retryAfter: retryAfter ?? const Duration(seconds: 5));
    } else {
      throw GeminiGeneralException('X.AI Request failed with status $code', retryAfter: retryAfter);
    }
  }
}
