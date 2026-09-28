import 'dart:convert';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/services/utils/ai_exceptions.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import 'package:eiga/utils/logger.dart';

class AiHelpers {
  /// Safely decodes a JSON response string, handling empty, null, or HTML error pages.
  static dynamic safeJsonDecode(String response, {String tag = 'AI'}) {
    final trimmed = response.trim();
    if (trimmed.isEmpty || trimmed == 'null') {
      return null;
    }
    if (trimmed.startsWith('<') || trimmed.contains('<!DOCTYPE html>')) {
      throw GeminiServerException("Server returned HTML error page instead of JSON");
    }
    try {
      return jsonDecode(trimmed);
    } catch (e) {
      logger.e('[$tag] Response is NOT valid JSON: $response');
      throw GeminiGeneralException("Invalid JSON response from AI: $e");
    }
  }

  /// Maps exceptions (especially GeminiException) to standard AiRequestResult failures.
  static AiRequestResult handleException(dynamic e, {String? stepType, AiModel? model}) {
    if (e is GeminiException) {
      return AiRequestResult.failure(e.type, message: e.message, stepType: stepType, model: model);
    }
    return AiRequestResult.failure(AiErrorType.unknown, message: e.toString(), stepType: stepType, model: model);
  }
}
