import 'package:eiga/config/pipelines/pipeline_steps.dart';

enum PipelineStepType { contextResearch, translation, tokenize, morphemes, grammarRole }

extension PipelineStepTypeMapping on PipelineStepType {
  TranslationPipelineStep get asTranslationStep {
    switch (this) {
      case PipelineStepType.contextResearch:
        return TranslationPipelineStep.research;
      case PipelineStepType.translation:
        return TranslationPipelineStep.translate;
      case PipelineStepType.tokenize:
        return TranslationPipelineStep.tokenize;
      case PipelineStepType.morphemes:
        return TranslationPipelineStep.morphemes;
      case PipelineStepType.grammarRole:
        return TranslationPipelineStep.grammarRole;
    }
  }
}
