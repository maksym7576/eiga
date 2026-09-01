import 'package:isar_community/isar.dart';
import 'package:eiga/backend/database/schemas/ai_model.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/backend/database/schemas/translation_pipeline_step.dart';
import 'package:eiga/backend/database/services/ai_model_service.dart';
import 'pipeline_step_type.dart';

class PipelineStepResult {
  final PipelineStepType type;
  final AiModel model;
  final String prompt;

  const PipelineStepResult({
    required this.type,
    required this.model,
    required this.prompt,
  });
}

class PipelineBuildResult {
  final String pipelineId;
  final List<PipelineStepResult> steps;

  const PipelineBuildResult({
    required this.pipelineId,
    required this.steps,
  });

  PipelineStepResult stepOf(PipelineStepType type) =>
      steps.firstWhere((s) => s.type == type);
}

abstract class PipelineAbstract {
  String get id;

  List<PipelineStepType> get stepTypes;

  String promptFor(PipelineStepType type, Video video);

  Future<PipelineBuildResult> build(
    Video video,
    AiModelService aiModelService,
    Map<TranslationPipelineStep, String> aiState,
  ) async {
    final steps = <PipelineStepResult>[];
    
    for (final type in stepTypes) {
      final translationStep = type.asTranslationStep;
      final activeModelName = aiState[translationStep];
      
      if (activeModelName == null) {
        throw Exception('No active model for step: $translationStep');
      }

      final model = await aiModelService.getModelByName(activeModelName);
      if (model == null) {
        throw Exception('Model $activeModelName not found in database');
      }

      steps.add(PipelineStepResult(
        type: type,
        model: model,
        prompt: promptFor(type, video),
      ));
    }

    return PipelineBuildResult(pipelineId: id, steps: steps);
  }
}
