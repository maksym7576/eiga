import 'package:eiga/config/prompts/prompt_manager.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'pipeline_abstract.dart';
import 'pipeline_step_type.dart';

class TotalPipeline extends PipelineAbstract {
  @override
  String get id => 'total_v1';

  @override
  List<PipelineStepType> get stepTypes => const [
    PipelineStepType.translation,
  ];

  @override
  String promptFor(PipelineStepType type, Video video) {
    return PromptManager.getPrompt(
      type: PromptType.total,
      sourceLanguage: video.originalLanguage ?? '',
      targetLanguage: video.translatedLanguage ?? '',
      title: video.videoName ?? video.nameJumaku ?? '',
      season: video.season ?? '',
      episodeNumber: video.episode ?? '',
      contextBlock: video.researchInformation ?? '',
    );
  }
}
