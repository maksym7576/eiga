import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../backend/services/ai_service.dart';
import '../../backend/services/petition_ai/gemini/gemini_service.dart';
import '../../backend/services/petition_ai/gemini/gemini_streaming_service.dart';
import '../../backend/services/petition_ai/parsers/phrase_response_handler.dart';
import 'database_services_providers.dart';

final phraseResponseHandlerProvider = Provider<PhraseResponseHandler>((ref) {
  return PhraseResponseHandler(
    phraseService: ref.watch(phraseServiceProvider),
    blockService: ref.watch(blockServiceProvider),
    wordService: ref.watch(wordServiceProvider),
  );
});

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(
    phraseResponseHandler: ref.watch(phraseResponseHandlerProvider),
    ref: ref,
  );
});

final geminiStreamingServiceProvider = Provider<GeminiStreamingService>((ref) {
  return GeminiStreamingService(
    phraseResponseHandler: ref.watch(phraseResponseHandlerProvider),
  );
});

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService(
    ref: ref,
    geminiService: ref.watch(geminiServiceProvider),
    geminiStreamingService: ref.watch(geminiStreamingServiceProvider),
  );
});
