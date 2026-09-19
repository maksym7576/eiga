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
