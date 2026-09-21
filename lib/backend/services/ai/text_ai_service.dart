import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/services/petition_ai/gemini/gemini_service.dart';
import 'package:eiga/backend/services/petition_ai/groq/groq_service.dart';
import 'package:eiga/backend/services/petition_ai/gemini/gemini_streaming_service.dart';
import 'package:eiga/backend/services/petition_ai/groq/groq_streaming_service.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import 'package:eiga/backend/services/utils/ai_exceptions.dart';
import 'package:eiga/utils/logger.dart';

class TextAiService {
  final Ref ref;
  final GeminiService geminiService;
  final GroqService groqService;
  final GeminiStreamingService geminiStreamingService;
  final GroqStreamingService groqStreamingService;

  TextAiService({
    required this.ref,
    required this.geminiService,
    required this.groqService,
    required this.geminiStreamingService,
    required this.groqStreamingService,
  });

  Future<String> sendRequest(String url, String prompt, {required AiModel model}) async {
    switch (model.provider) {
      case AiProvider.google:
        return await geminiService.sendRequest(url, prompt, model: model);
      case AiProvider.groq:
        return await groqService.sendRequest(url, prompt, model: model);
      case AiProvider.openai:
      case AiProvider.anthropic:
      case AiProvider.custom:
        // These can be added as separate services later if needed
        return await geminiService.sendRequest(url, prompt, model: model);
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
    final bool useStreaming = model.supportsStreaming && model.currentStreamingEnabled;

    if (useStreaming) {
      switch (model.provider) {
        case AiProvider.google:
          return await geminiStreamingService.fetchParseAndSaveData(
            url, prompt, model: model, expectedIds: expectedIds, onProgress: onProgress, language: language, useSoftReset: useSoftReset
          );
        case AiProvider.groq:
          return await groqStreamingService.fetchParseAndSaveData(
            url, prompt, model: model, expectedIds: expectedIds, onProgress: onProgress, language: language, useSoftReset: useSoftReset
          );
        default:
          return await geminiStreamingService.fetchParseAndSaveData(
            url, prompt, model: model, expectedIds: expectedIds, onProgress: onProgress, language: language, useSoftReset: useSoftReset
          );
      }
    } else {
      switch (model.provider) {
        case AiProvider.google:
          return await geminiService.fetchParseAndSaveData(
            url, prompt, model: model, expectedIds: expectedIds, onProgress: onProgress, language: language, useSoftReset: useSoftReset
          );
        // Add Groq non-streaming parsing if needed
        case AiProvider.groq:
          return await groqService.fetchParseAndSaveData(
            url, prompt, model: model, expectedIds: expectedIds, onProgress: onProgress, language: language, useSoftReset: useSoftReset
          );
        default:
          return await geminiService.fetchParseAndSaveData(
            url, prompt, model: model, expectedIds: expectedIds, onProgress: onProgress, language: language, useSoftReset: useSoftReset
          );
      }
    }
  }

  // Common high-level methods that use sendRequest
  Future<AiRequestResult> processJsonRequest({
    required String url,
    required String prompt,
    required AiModel model,
    required Future<AiRequestResult> Function(dynamic decoded) onResponse,
    String? stepType,
  }) async {
    try {
      final response = await sendRequest(url, prompt, model: model);
      
      dynamic decoded;
      try {
        decoded = jsonDecode(response);
      } catch (e) {
        logger.e('[TextAiService] Response is NOT valid JSON: $response');
        return AiRequestResult.failure(AiErrorType.parse, message: 'Invalid JSON response from AI', stepType: stepType, model: model);
      }

      return await onResponse(decoded);
    } catch (e) {
      if (e is GeminiException) {
        return AiRequestResult.failure(e.type, message: e.message, stepType: stepType, model: model);
      }
      return AiRequestResult.failure(AiErrorType.unknown, message: e.toString(), stepType: stepType, model: model);
    }
  }
}
