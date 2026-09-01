import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/config/prompts/prompt_manager.dart';
import 'pipeline_abstract.dart';
import 'pipeline_step_type.dart';

class ContextTranslationPipeline extends PipelineAbstract {
  @override
  String get id => 'context_translation_v1';

  @override
  List<PipelineStepType> get stepTypes => const [
    PipelineStepType.contextResearch,
    PipelineStepType.translation,
    PipelineStepType.morphemes,
  ];

  @override
  String promptFor(PipelineStepType type, Video video) {
    final sourceLanguage = video.originalLanguage ?? '';
    final targetLanguage = video.translatedLanguage ?? '';
    final title = video.videoName ?? video.nameJumaku ?? '';

    switch (type) {
      case PipelineStepType.contextResearch:
        return PromptManager.getPrompt(
          type: PromptType.contextResearch,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          title: title,
          season: video.season ?? '',
          episodeNumber: video.episode ?? '',
        );

      case PipelineStepType.translation:
        return PromptManager.getPrompt(
          type: PromptType.translation,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          title: title,
          season: video.season ?? '',
          episodeNumber: video.episode ?? '',
          contextBlock: video.researchInformation ?? '',
        );

      case PipelineStepType.morphemes:
        return PromptManager.getPrompt(
          type: PromptType.parser,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          title: title,
        );
    }
  }
}
