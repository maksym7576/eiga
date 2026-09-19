import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
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
import '../../backend/services/petition_ai/xai/xai_service.dart';

final ffmpegServiceProvider = Provider<FFmpegService>((ref) {
  return FFmpegService();
});

final audioSyncServiceProvider = Provider<AudioSyncService>((ref) {
  return AudioSyncService(ffmpegService: ref.watch(ffmpegServiceProvider));
});

final xAiServiceProvider = Provider<XAiService>((ref) {
  return XAiService(ref: ref);
});

final textAiServiceProvider = Provider<TextAiService>((ref) {
  return TextAiService(
    ref: ref,
    geminiService: ref.watch(geminiServiceProvider),
    xAiService: ref.watch(xAiServiceProvider),
  );
});

final audioAiServiceProvider = Provider<AudioAiService>((ref) {
  return AudioAiService(
    ref: ref,
    geminiService: ref.watch(geminiServiceProvider),
    xAiService: ref.watch(xAiServiceProvider),
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
    geminiStreamingService: ref.watch(geminiStreamingServiceProvider),
    ffmpegService: ref.watch(ffmpegServiceProvider),
  );
});

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService(
    ref: ref,
    textAiService: ref.watch(textAiServiceProvider),
    audioAiService: ref.watch(audioAiServiceProvider),
    geminiStreamingService: ref.watch(geminiStreamingServiceProvider),
    transcriptionService: ref.watch(transcriptionServiceProvider),
  );
});
