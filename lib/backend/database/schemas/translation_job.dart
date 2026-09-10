import 'package:isar_community/isar.dart';
import 'video.dart'; // For AiStageHistory if kept there, but better to move it or re-declare

part 'translation_job.g.dart';

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
    this.isAuto,
    this.executionPlan,
    this.completedSteps,
    this.stageHistory,
  });
}
