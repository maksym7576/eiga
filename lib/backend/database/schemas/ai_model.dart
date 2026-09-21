import 'package:isar_community/isar.dart';
import '../../../config/pipelines/pipeline_steps.dart';
import 'job.dart';

part 'ai_model.g.dart';

enum AiProvider { google, openai, anthropic, groq, custom }

enum ModelQuality { basic, standard, high, frontier }

enum ModelSpeed { ultraFast, fast, medium, slow }

enum InputType { text, image, audio, video, pdf }

@collection
class AiModel {
  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  late AiProvider provider;

  @Index(unique: true)
  late String name;

  late String url;

  int defaultLimit = 20;
  int currentMaxLimit = 20;
  bool isMaxLimitCustom = false;
  int used = 0;

  int defaultDailyMaxLimit = 100;
  int currentDailyMaxLimit = 100;
  bool isDailyMaxLimitCustom = false;
  int dailyUsed = 0;

  int tpmLimit = 100000; // Tokens Per Minute limit
  int tokensPerAudioSecond = 1; // Average tokens per second of audio

  int defaultPhrasesPerRequest = 10;
  int currentPhrasesPerRequest = 10;
  bool isPhrasesPerRequestCustom = false;

  bool supportsWebSearch = false;

  bool supportsStreaming = true;
  bool currentStreamingEnabled = true;
  bool isStreamingCustom = false;

  bool supportsLiveApi = false;

  @Enumerated(EnumType.name)
  late ModelQuality quality;

  bool supportsThinking = false;

  bool isTranscriptionModel = false;

  @Enumerated(EnumType.name)
  late ModelSpeed speed;

  int estimatedTokensPerSec = 50;

  int errorCount = 0;
  String? lastErrorMessage;
  DateTime? lastErrorAt;
  int successCount = 0;
  int partialSuccessCount = 0;


  double reliabilityScore = 0.0;

  int contextWindow = 128000;
  int maxOutputTokens = 8192;

  @Enumerated(EnumType.name)
  List<InputType> supportedInputs = [InputType.text];

  @Enumerated(EnumType.name)
  List<TranslationPipelineStep> supportedSteps = [
    TranslationPipelineStep.translate
  ];

  double inputPricePerMToken = 0.0;
  double outputPricePerMToken = 0.0;

  AiModel();
}
