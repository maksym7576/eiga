import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/database/schemas/translation_pipeline_step.dart';

Future<List<AiModel>> standardAiModels() async {
  final allSteps = TranslationPipelineStep.values.toList();
  final multimodalInputs = [
    InputType.text,
    InputType.image,
    InputType.audio,
    InputType.video,
    InputType.pdf
  ];

  return [
    // --- Gemini 3 Series ---
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-3.8-flash'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash'
      ..defaultLimit = 5
      ..currentMaxLimit = 5
      ..defaultDailyMaxLimit = 20
      ..currentDailyMaxLimit = 20
      ..defaultPhrasesPerRequest = 20
      ..currentPhrasesPerRequest = 20
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = true
      ..quality = ModelQuality.frontier
      ..speed = ModelSpeed.ultraFast
      ..estimatedTokensPerSec = 200
      ..contextWindow = 1048576
      ..maxOutputTokens = 65536
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.05
      ..outputPricePerMToken = 0.20,
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-3.7-flash'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.7-flash'
      ..defaultLimit = 5
      ..currentMaxLimit = 5
      ..defaultDailyMaxLimit = 20
      ..currentDailyMaxLimit = 20
      ..defaultPhrasesPerRequest = 20
      ..currentPhrasesPerRequest = 20
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = true
      ..quality = ModelQuality.frontier
      ..speed = ModelSpeed.ultraFast
      ..estimatedTokensPerSec = 180
      ..contextWindow = 1048576
      ..maxOutputTokens = 65536
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.06
      ..outputPricePerMToken = 0.25,
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-3.6-flash'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash'
      ..defaultLimit = 5
      ..currentMaxLimit = 5
      ..defaultDailyMaxLimit = 20
      ..currentDailyMaxLimit = 20
      ..defaultPhrasesPerRequest = 20
      ..currentPhrasesPerRequest = 20
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = true
      ..quality = ModelQuality.high
      ..speed = ModelSpeed.ultraFast
      ..estimatedTokensPerSec = 170
      ..contextWindow = 1048576
      ..maxOutputTokens = 65536
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.07
      ..outputPricePerMToken = 0.30,
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-3.5-flash'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash'
      ..defaultLimit = 5
      ..currentMaxLimit = 5
      ..defaultDailyMaxLimit = 20
      ..currentDailyMaxLimit = 20
      ..defaultPhrasesPerRequest = 15
      ..currentPhrasesPerRequest = 15
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = true
      ..quality = ModelQuality.standard
      ..speed = ModelSpeed.fast
      ..estimatedTokensPerSec = 150
      ..contextWindow = 1048576
      ..maxOutputTokens = 65536
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.075
      ..outputPricePerMToken = 0.30,
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-3.5-flash-lite'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite'
      ..defaultLimit = 15
      ..currentMaxLimit = 15
      ..defaultDailyMaxLimit = 500
      ..currentDailyMaxLimit = 500
      ..defaultPhrasesPerRequest = 20
      ..currentPhrasesPerRequest = 20
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = false
      ..quality = ModelQuality.basic
      ..speed = ModelSpeed.ultraFast
      ..estimatedTokensPerSec = 220
      ..contextWindow = 1048576
      ..maxOutputTokens = 65536
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.03
      ..outputPricePerMToken = 0.15,
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-3.1-flash-lite'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite'
      ..defaultLimit = 15
      ..currentMaxLimit = 15
      ..defaultDailyMaxLimit = 500
      ..currentDailyMaxLimit = 500
      ..defaultPhrasesPerRequest = 20
      ..currentPhrasesPerRequest = 20
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = false
      ..quality = ModelQuality.basic
      ..speed = ModelSpeed.ultraFast
      ..estimatedTokensPerSec = 200
      ..contextWindow = 1048576
      ..maxOutputTokens = 65536
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.04
      ..outputPricePerMToken = 0.20,
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-3-flash'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash'
      ..defaultLimit = 5
      ..currentMaxLimit = 5
      ..defaultDailyMaxLimit = 20
      ..currentDailyMaxLimit = 20
      ..defaultPhrasesPerRequest = 20
      ..currentPhrasesPerRequest = 20
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = true
      ..quality = ModelQuality.standard
      ..speed = ModelSpeed.fast
      ..estimatedTokensPerSec = 140
      ..contextWindow = 1048576
      ..maxOutputTokens = 65536
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.08
      ..outputPricePerMToken = 0.35,

    // --- Gemini 2.5 Series ---
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-2.5-flash'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash'
      ..defaultLimit = 5
      ..currentMaxLimit = 5
      ..defaultDailyMaxLimit = 20
      ..currentDailyMaxLimit = 20
      ..defaultPhrasesPerRequest = 15
      ..currentPhrasesPerRequest = 15
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = true
      ..quality = ModelQuality.standard
      ..speed = ModelSpeed.fast
      ..estimatedTokensPerSec = 100
      ..contextWindow = 128000
      ..maxOutputTokens = 8192
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.15
      ..outputPricePerMToken = 0.60,
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-2.5-flash-lite'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite'
      ..defaultLimit = 10
      ..currentMaxLimit = 10
      ..defaultDailyMaxLimit = 20
      ..currentDailyMaxLimit = 20
      ..defaultPhrasesPerRequest = 20
      ..currentPhrasesPerRequest = 20
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = false
      ..quality = ModelQuality.basic
      ..speed = ModelSpeed.ultraFast
      ..estimatedTokensPerSec = 150
      ..contextWindow = 128000
      ..maxOutputTokens = 8192
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.075
      ..outputPricePerMToken = 0.30,
  ];
}
