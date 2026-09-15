import 'package:isar_community/isar.dart';
export 'translation_pipeline_step.dart';
import 'translation_pipeline_step.dart';

part 'translation_job.g.dart';

@embedded
class AiStageHistory {
  String? stageName;
  int? durationMs;
  String? status; // 'success', 'error'
  String? modelName;

  AiStageHistory({
    this.stageName,
    this.durationMs,
    this.status,
    this.modelName,
  });
}

@collection
class TranslationJob {
  Id id = Isar.autoIncrement;

  @Index()
  int videoId;

  String? modelName;
  String? pipelineId;
  String? status; // 'active', 'success', 'error'
  String? phase;

  DateTime? startTime;
  DateTime? endTime;
  DateTime? translatedAt;
  String? errorMessage;
  String? errorStage;
  int? processedPhrases;
  int? totalPhrases;
  List<int>? phraseOrders;
  bool? isAuto;

  String? executionPlan; // JSON list of steps
  int? completedSteps;

  List<AiStageHistory>? stageHistory;

  TranslationJob({
    required this.videoId,
    this.modelName,
    this.pipelineId,
    this.status,
    this.phase,
    this.startTime,
    this.endTime,
    this.translatedAt,
    this.errorMessage,
    this.errorStage,
    this.processedPhrases,
    this.totalPhrases,
    this.phraseOrders,
    this.isAuto,
    this.executionPlan,
    this.completedSteps,
    this.stageHistory,
  });
}
