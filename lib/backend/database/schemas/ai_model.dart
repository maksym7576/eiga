import 'package:isar_community/isar.dart';
import 'translation_pipeline_step.dart';

part 'ai_model.g.dart';

enum AiProvider { google, openai, anthropic, custom }

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

  @Enumerated(EnumType.name)
  late ModelSpeed speed;
  
  int estimatedTokensPerSec = 50;

  int contextWindow = 128000;
  int maxOutputTokens = 8192;

  @Enumerated(EnumType.name)
  List<InputType> supportedInputs = [InputType.text];

  @Enumerated(EnumType.name)
  List<TranslationPipelineStep> supportedSteps = [
    TranslationPipelineStep.fullTranslate
  ];

  double inputPricePerMToken = 0.0;
  double outputPricePerMToken = 0.0;

  AiModel();
}
