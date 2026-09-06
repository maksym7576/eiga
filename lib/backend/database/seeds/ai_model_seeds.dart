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
      ..defaultLimit = 15
      ..currentMaxLimit = 15
      ..defaultDailyMaxLimit = 1500
      ..currentDailyMaxLimit = 1500
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
      ..defaultLimit = 15
      ..currentMaxLimit = 15
      ..defaultDailyMaxLimit = 1500
      ..currentDailyMaxLimit = 1500
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
      ..defaultLimit = 15
      ..currentMaxLimit = 15
      ..defaultDailyMaxLimit = 1500
      ..currentDailyMaxLimit = 1500
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
      ..defaultLimit = 15
      ..currentMaxLimit = 15
      ..defaultDailyMaxLimit = 1500
      ..currentDailyMaxLimit = 1500
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
      ..defaultLimit = 20
      ..currentMaxLimit = 20
      ..defaultDailyMaxLimit = 2000
      ..currentDailyMaxLimit = 2000
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
      ..defaultLimit = 20
      ..currentMaxLimit = 20
      ..defaultDailyMaxLimit = 1500
      ..currentDailyMaxLimit = 1500
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
      ..name = 'gemini-3.1-pro-preview'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview'
      ..defaultLimit = 2
      ..currentMaxLimit = 2
      ..defaultDailyMaxLimit = 50
      ..currentDailyMaxLimit = 50
      ..defaultPhrasesPerRequest = 10
      ..currentPhrasesPerRequest = 10
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = true
      ..quality = ModelQuality.frontier
      ..speed = ModelSpeed.medium
      ..estimatedTokensPerSec = 60
      ..contextWindow = 1048576
      ..maxOutputTokens = 65536
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 1.00
      ..outputPricePerMToken = 4.0,

    // --- Gemini 2.5 Series ---
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-2.5-pro'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro'
      ..defaultLimit = 2
      ..currentMaxLimit = 2
      ..defaultDailyMaxLimit = 50
      ..currentDailyMaxLimit = 50
      ..defaultPhrasesPerRequest = 10
      ..currentPhrasesPerRequest = 10
      ..supportsWebSearch = true
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..supportsLiveApi = true
      ..quality = ModelQuality.high
      ..speed = ModelSpeed.slow
      ..estimatedTokensPerSec = 40
      ..contextWindow = 128000
      ..maxOutputTokens = 8192
      ..supportsThinking = true
      ..supportedInputs = multimodalInputs
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 1.25
      ..outputPricePerMToken = 5.0,
    AiModel()
      ..provider = AiProvider.google
      ..name = 'gemini-2.5-flash'
      ..url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash'
      ..defaultLimit = 15
      ..currentMaxLimit = 15
      ..defaultDailyMaxLimit = 1500
      ..currentDailyMaxLimit = 1500
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
      ..defaultLimit = 15
      ..currentMaxLimit = 15
      ..defaultDailyMaxLimit = 1500
      ..currentDailyMaxLimit = 1500
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

    // --- Third Party Models ---
    AiModel()
      ..provider = AiProvider.openai
      ..name = 'gpt-4o-mini'
      ..url = 'https://api.openai.com/v1/chat/completions'
      ..defaultLimit = 3
      ..currentMaxLimit = 3
      ..defaultDailyMaxLimit = 10000
      ..currentDailyMaxLimit = 10000
      ..defaultPhrasesPerRequest = 15
      ..currentPhrasesPerRequest = 15
      ..supportsWebSearch = false
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..quality = ModelQuality.standard
      ..speed = ModelSpeed.fast
      ..estimatedTokensPerSec = 100
      ..contextWindow = 128000
      ..maxOutputTokens = 16384
      ..supportedInputs = [InputType.text, InputType.image]
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 0.15
      ..outputPricePerMToken = 0.60,
    AiModel()
      ..provider = AiProvider.anthropic
      ..name = 'claude-3-5-sonnet-latest'
      ..url = 'https://api.anthropic.com/v1/messages'
      ..defaultLimit = 5
      ..currentMaxLimit = 5
      ..defaultDailyMaxLimit = 10000
      ..currentDailyMaxLimit = 10000
      ..defaultPhrasesPerRequest = 15
      ..currentPhrasesPerRequest = 15
      ..supportsWebSearch = false
      ..supportsStreaming = true
      ..currentStreamingEnabled = true
      ..quality = ModelQuality.frontier
      ..speed = ModelSpeed.medium
      ..estimatedTokensPerSec = 80
      ..contextWindow = 2000000
      ..maxOutputTokens = 8192
      ..supportedInputs = [InputType.text, InputType.image]
      ..supportedSteps = allSteps
      ..inputPricePerMToken = 3.0
      ..outputPricePerMToken = 15.0,
  ];
}
