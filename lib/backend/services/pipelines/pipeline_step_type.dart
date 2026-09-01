import 'package:eiga/backend/database/schemas/translation_pipeline_step.dart';

enum PipelineStepType { contextResearch, translation, morphemes }

extension PipelineStepTypeMapping on PipelineStepType {
  TranslationPipelineStep get asTranslationStep {
    switch (this) {
      case PipelineStepType.contextResearch:
        return TranslationPipelineStep.research;
      case PipelineStepType.translation:
        return TranslationPipelineStep.translate;
      case PipelineStepType.morphemes:
        return TranslationPipelineStep.morphemes;
    }
  }
}
