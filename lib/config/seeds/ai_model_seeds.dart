import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/config/pipelines/pipeline_steps.dart';

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
    // --- Gemini 3.x Flash ---
    _createModel(
      name: 'gemini-3.8-flash',
      quality: ModelQuality.frontier,
      speed: ModelSpeed.ultraFast,
      rpm: 5,
      rpd: 20,
      tpm: 250000,
      isTranscription: true,
      supportedInputs: multimodalInputs,
      supportedSteps: allSteps,
    ),
    _createModel(
      name: 'gemini-3.7-flash',
      quality: ModelQuality.frontier,
      speed: ModelSpeed.ultraFast,
      rpm: 5,
      rpd: 20,
      tpm: 250000,
      isTranscription: true,
      supportedInputs: multimodalInputs,
      supportedSteps: allSteps,
    ),
    _createModel(
      name: 'gemini-3.6-flash',
      quality: ModelQuality.high,
      speed: ModelSpeed.ultraFast,
      rpm: 5,
      rpd: 20,
      tpm: 250000,
      isTranscription: true,
      supportedInputs: multimodalInputs,
      supportedSteps: allSteps,
    ),
    _createModel(
      name: 'gemini-3.5-flash',
      quality: ModelQuality.standard,
      speed: ModelSpeed.fast,
      rpm: 5,
      rpd: 20,
      tpm: 250000,
      isTranscription: true,
      supportedInputs: multimodalInputs,
      supportedSteps: allSteps,
    ),

    // --- Transcription Specialized ---
    _createModel(
      name: 'gemini-3.5-transcribe',
      quality: ModelQuality.high,
      speed: ModelSpeed.fast,
      rpm: 3,
      rpd: 25,
      tpm: 10000, // From report: 10K TPM
      isTranscription: true,
      supportedInputs: [InputType.audio],
      supportedSteps: [TranslationPipelineStep.transcribe],
      supportsLiveApi: true,
    ),

    // --- Flash Lite ---
    _createModel(
      name: 'gemini-3.5-flash-lite',
      quality: ModelQuality.basic,
      speed: ModelSpeed.ultraFast,
      rpm: 15,
      rpd: 500,
      tpm: 250000,
      supportedInputs: multimodalInputs,
      supportedSteps: [TranslationPipelineStep.translate, TranslationPipelineStep.tokenize],
    ),
    _createModel(
      name: 'gemini-3.1-flash-lite',
      quality: ModelQuality.basic,
      speed: ModelSpeed.ultraFast,
      rpm: 15,
      rpd: 500,
      tpm: 250000,
      supportedInputs: multimodalInputs,
      supportedSteps: [TranslationPipelineStep.translate, TranslationPipelineStep.tokenize],
    ),

    // --- Agents ---
    _createModel(
      name: 'antigravity',
      quality: ModelQuality.standard,
      speed: ModelSpeed.medium,
      rpm: 60,
      rpd: 100,
      tpm: 100000,
      supportedInputs: [InputType.text],
      supportedSteps: [TranslationPipelineStep.research],
    ),

    // --- Gemma 4 ---
    _createModel(
      name: 'gemma-4-26b',
      quality: ModelQuality.basic,
      speed: ModelSpeed.fast,
      rpm: 30,
      rpd: 14400,
      tpm: 16000,
      supportedInputs: [InputType.text],
      supportedSteps: [TranslationPipelineStep.translate],
    ),

    // --- Embeddings ---
    _createModel(
      name: 'gemini-embedding-1',
      quality: ModelQuality.basic,
      speed: ModelSpeed.ultraFast,
      rpm: 100,
      rpd: 1000,
      tpm: 30000,
      supportedInputs: [InputType.text],
      supportedSteps: [TranslationPipelineStep.tokenize],
    ),

    // --- Groq Llama 3.3 ---
    _createGroqModel(
      name: 'llama-3.3-70b-versatile',
      quality: ModelQuality.frontier,
      speed: ModelSpeed.ultraFast,
      rpm: 30,
      rpd: 1000,
      tpm: 8000,
      supportedSteps: allSteps,
    ),

    // --- Groq Mixtral / OSS ---
    _createGroqModel(
      name: 'gpt-oss-120b',
      quality: ModelQuality.frontier,
      speed: ModelSpeed.fast,
      rpm: 30,
      rpd: 1000,
      tpm: 8000,
      supportedSteps: allSteps,
    ),
    _createGroqModel(
      name: 'gpt-oss-20b',
      quality: ModelQuality.standard,
      speed: ModelSpeed.ultraFast,
      rpm: 30,
      rpd: 1000,
      tpm: 8000,
      supportedSteps: allSteps,
    ),

    // --- Groq Qwen ---
    _createGroqModel(
      name: 'qwen3.8-27b',
      quality: ModelQuality.high,
      speed: ModelSpeed.ultraFast,
      rpm: 30,
      rpd: 1000,
      tpm: 8000,
      supportedSteps: allSteps,
    ),

    // --- Groq Whisper ---
    _createGroqModel(
      name: 'whisper-large-v3',
      quality: ModelQuality.high,
      speed: ModelSpeed.ultraFast,
      rpm: 20,
      rpd: 2000,
      tpm: 0, 
      isTranscription: true,
      supportedInputs: [InputType.audio],
      supportedSteps: [TranslationPipelineStep.transcribe],
    ),
    _createGroqModel(
      name: 'whisper-large-v3-turbo',
      quality: ModelQuality.high,
      speed: ModelSpeed.ultraFast,
      rpm: 20,
      rpd: 2000,
      tpm: 0,
      isTranscription: true,
      supportedInputs: [InputType.audio],
      supportedSteps: [TranslationPipelineStep.transcribe],
    ),
  ];
}

AiModel _createModel({
  required String name,
  required ModelQuality quality,
  required ModelSpeed speed,
  required int rpm,
  required int rpd,
  required int tpm,
  bool isTranscription = false,
  bool supportsLiveApi = false,
  List<InputType> supportedInputs = const [InputType.text],
  List<TranslationPipelineStep> supportedSteps = const [TranslationPipelineStep.translate],
}) {
  return AiModel()
    ..provider = AiProvider.google
    ..name = name
    ..url = 'https://generativelanguage.googleapis.com/v1beta/models/$name'
    ..defaultLimit = rpm
    ..currentMaxLimit = rpm
    ..defaultDailyMaxLimit = rpd
    ..currentDailyMaxLimit = rpd
    ..tpmLimit = tpm
    ..quality = quality
    ..speed = speed
    ..isTranscriptionModel = isTranscription
    ..supportsLiveApi = supportsLiveApi
    ..supportedInputs = supportedInputs
    ..supportedSteps = supportedSteps
    ..contextWindow = 1048576
    ..maxOutputTokens = 8192;
}

AiModel _createGroqModel({
  required String name,
  required ModelQuality quality,
  required ModelSpeed speed,
  required int rpm,
  required int rpd,
  required int tpm,
  bool isTranscription = false,
  List<InputType> supportedInputs = const [InputType.text],
  List<TranslationPipelineStep> supportedSteps = const [TranslationPipelineStep.translate],
}) {
  return AiModel()
    ..provider = AiProvider.groq
    ..name = name
    ..url = 'https://api.groq.com/openai/v1/chat/completions'
    ..defaultLimit = rpm
    ..currentMaxLimit = rpm
    ..defaultDailyMaxLimit = rpd
    ..currentDailyMaxLimit = rpd
    ..tpmLimit = tpm
    ..quality = quality
    ..speed = speed
    ..isTranscriptionModel = isTranscription
    ..supportedInputs = supportedInputs
    ..supportedSteps = supportedSteps
    ..contextWindow = 32768
    ..maxOutputTokens = 8192;
}
