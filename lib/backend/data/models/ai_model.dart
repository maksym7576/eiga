import 'package:isar_community/isar.dart';

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
  int defaultPhrasesPerRequest = 10;

  bool supportsWebSearch = false;
  bool supportsStreaming = true;
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

  double inputPricePerMToken = 0.0;
  double outputPricePerMToken = 0.0;

  AiModel();
}
