import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../backend/services/utils/ai_exceptions.dart';

import '../../backend/database/schemas/ai_model.dart';

enum AiRequestPhase { success, partialSuccess, error }

class AiRequestResult {
  final AiRequestPhase phase;
  final AiUserFacingError? error;
  final List<int> failedPhraseIds;
  final String? failedStepType; // e.g. 'translation'
  final AiModel? failedModel;

  const AiRequestResult({
    required this.phase,
    this.error,
    this.failedPhraseIds = const [],
    this.failedStepType,
    this.failedModel,
  });

  bool get isOk => phase == AiRequestPhase.success;

  factory AiRequestResult.success() =>
      const AiRequestResult(phase: AiRequestPhase.success);

  factory AiRequestResult.partialSuccess(List<int> failedIds) => AiRequestResult(
    phase: AiRequestPhase.partialSuccess,
    failedPhraseIds: failedIds,
    error: PartialFailureInfo(failedIds.map((e) => e.toString()).toList()).toUserFacing(),
  );

  factory AiRequestResult.failure(AiErrorType type, {String? message, String? stepType, AiModel? model}) =>
      AiRequestResult(
        phase: AiRequestPhase.error, 
        error: message != null 
          ? AiUserFacingError(title: 'Error', message: message, instruction: 'Check logs or settings')
          : type.toUserFacing(),
        failedStepType: stepType,
        failedModel: model,
      );
}

final aiRequestResultProvider = StateProvider<AiRequestResult?>((ref) => null);
