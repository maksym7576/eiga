import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/services/petition_ai/gemini/gemini_service.dart';
import 'package:eiga/backend/services/utils/ai_exceptions.dart';
import 'package:eiga/utils/logger.dart';

class AudioAiService {
  final Ref ref;
  final GeminiService geminiService;

  AudioAiService({
    required this.ref,
    required this.geminiService,
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
      case AiProvider.openai:
      case AiProvider.anthropic:
      case AiProvider.custom:
        throw GeminiGeneralException("Audio input only supported for Google provider currently");
    }
  }
}
