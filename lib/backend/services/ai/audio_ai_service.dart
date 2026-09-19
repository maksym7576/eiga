import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/services/petition_ai/gemini/gemini_service.dart';
import 'package:eiga/backend/services/petition_ai/xai/xai_service.dart';
import 'package:eiga/backend/services/utils/ai_exceptions.dart';
import 'package:eiga/utils/logger.dart';

class AudioAiService {
  final Ref ref;
  final GeminiService geminiService;
  final XAiService xAiService;

  AudioAiService({
    required this.ref,
    required this.geminiService,
    required this.xAiService,
  });

  Future<String> sendAudioRequest(
    String url, 
    String prompt, 
    String base64Audio, {
    required AiModel model, 
    String mimeType = 'audio/mp3'
  }) async {
    switch (model.provider) {
      case AiProvider.google:
        return await geminiService.sendRequestWithAudio(url, prompt, base64Audio, model: model, mimeType: mimeType);
      case AiProvider.xai:
        // Grok doesn't support native audio yet in the same way, 
        // but we could implement it if they add it.
        throw GeminiGeneralException("Audio input not yet supported for Grok provider");
      case AiProvider.openai:
      case AiProvider.anthropic:
      case AiProvider.custom:
        throw GeminiGeneralException("Audio input only supported for Google provider currently");
    }
  }
}
