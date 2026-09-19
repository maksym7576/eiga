import 'package:isar_community/isar.dart';
import '../../../providers/services/ai_request_state.dart';

part 'ai_model_event.g.dart';

@collection
class AiModelEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late String modelName;

  late DateTime timestamp;

  @Enumerated(EnumType.name)
  late AiRequestPhase result;

  String? message;
  String? step;

  AiModelEvent();
}
