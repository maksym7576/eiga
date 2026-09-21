import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../backend/services/ai/ai_service.dart';
import '../../backend/services/ai/transcription_service.dart';
import '../../backend/services/petition_ai/gemini/gemini_service.dart';
import '../../backend/services/petition_ai/gemini/gemini_streaming_service.dart';
import '../../backend/services/petition_ai/parsers/phrase_response_handler.dart';
import 'isar_services_providers.dart';
import '../../backend/services/ai/text_ai_service.dart';
import '../../backend/services/ai/audio_ai_service.dart';
import '../../backend/services/audio/ffmpeg_service.dart';
import '../../backend/services/audio/audio_sync_service.dart';
import '../../backend/services/petition_ai/groq/groq_service.dart';
import '../../backend/services/petition_ai/groq/groq_streaming_service.dart';

final ffmpegServiceProvider = Provider<FFmpegService>((ref) {
  return FFmpegService();
});

final audioSyncServiceProvider = Provider<AudioSyncService>((ref) {
  return AudioSyncService(ffmpegService: ref.watch(ffmpegServiceProvider));
});

final groqServiceProvider = Provider<GroqService>((ref) {
  return GroqService(
    ref: ref,
    phraseResponseHandler: ref.watch(phraseResponseHandlerProvider),
  );
});

final groqStreamingServiceProvider = Provider<GroqStreamingService>((ref) {
  return GroqStreamingService(
    phraseResponseHandler: ref.watch(phraseResponseHandlerProvider),
    ref: ref,
  );
});

final textAiServiceProvider = Provider<TextAiService>((ref) {
  return TextAiService(
    ref: ref,
    geminiService: ref.watch(geminiServiceProvider),
    groqService: ref.watch(groqServiceProvider),
    geminiStreamingService: ref.watch(geminiStreamingServiceProvider),
    groqStreamingService: ref.watch(groqStreamingServiceProvider),
  );
});

final audioAiServiceProvider = Provider<AudioAiService>((ref) {
  return AudioAiService(
    ref: ref,
    geminiService: ref.watch(geminiServiceProvider),
    groqService: ref.watch(groqServiceProvider),
  );
});

final phraseResponseHandlerProvider = Provider<PhraseResponseHandler>((ref) {
  return PhraseResponseHandler(
    phraseService: ref.watch(phraseServiceProvider),
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
    ref: ref,
  );
});

final transcriptionServiceProvider = Provider<TranscriptionService>((ref) {
  return TranscriptionService(
    ref: ref,
    audioAiService: ref.watch(audioAiServiceProvider),
    ffmpegService: ref.watch(ffmpegServiceProvider),
  );
});

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService(
    ref: ref,
    textAiService: ref.watch(textAiServiceProvider),
    audioAiService: ref.watch(audioAiServiceProvider),
    transcriptionService: ref.watch(transcriptionServiceProvider),
  );
});
