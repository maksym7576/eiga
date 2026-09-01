import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/backend/database/services/ai_model_service.dart';
import 'package:eiga/backend/database/services/video_service.dart';
import 'package:eiga/providers/database/database_providers.dart';
import 'package:eiga/providers/ui/ai_models_state_provider.dart';
import 'pipeline_abstract.dart';
import 'total_pipeline.dart';
import 'context_translation_pipeline.dart';

class PipelineManager {
  static final Map<String, PipelineAbstract> _registry = {
    'total_v1': TotalPipeline(),
    'context_translation_v1': ContextTranslationPipeline(),
  };

  static PipelineAbstract? byId(String id) => _registry[id];

  /// Builds a pipeline for a specific video.
  static Future<PipelineBuildResult?> build(
    Ref ref, {
    required int videoId,
    String? pipelineId,
  }) async {
    final videoService = ref.read(videoServiceProvider);
    final aiModelService = ref.read(aiModelServiceProvider);
    final aiState = ref.read(aiModelsProvider);

    final video = await videoService.getVideoById(videoId);
    if (video == null) return null;

    final resolvedId = pipelineId ?? video.pipelineIndetificator;
    if (resolvedId == null) return null;

    final pipeline = byId(resolvedId);
    if (pipeline == null) return null;

    return await pipeline.build(video, aiModelService, aiState);
  }
}
