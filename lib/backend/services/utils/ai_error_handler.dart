import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/providers/services/ai_request_state.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import 'package:eiga/providers/ui/ai_error_state_provider.dart';
import 'ai_exceptions.dart';
import '../../database/schemas/ai_model.dart';

class AiErrorHandler {
  final Ref ref;

  AiErrorHandler(this.ref);

  Future<void> recordResult({
    required String modelName,
    required AiRequestPhase result,
    String? message,
    String? step,
    bool showDialog = false,
  }) async {
    // 1. Log to DB (Permanent storage)
    await ref.read(aiModelServiceProvider).logEvent(
      modelName: modelName,
      result: result,
      message: message,
      step: step,
    );

    // 2. Update Global Error State if needed (UI Dialogs)
    if (result == AiRequestPhase.error && showDialog) {
      if (message != null && message.contains('429')) {
        ref.read(aiErrorStateProvider.notifier).state = AiErrorType.rateLimit.toUserFacing();
      } else if (message != null && (message.contains('500') || message.contains('503'))) {
        ref.read(aiErrorStateProvider.notifier).state = AiErrorType.server.toUserFacing();
      } else if (message != null) {
        ref.read(aiErrorStateProvider.notifier).state = AiUserFacingError(
          title: 'AI Error',
          message: message,
          instruction: 'Check model settings or logs.',
        );
      }
    }
  }

  Future<void> recordException(dynamic e, {required String modelName, String? step, bool showDialog = false}) async {
    final result = (e is GeminiException) ? AiRequestPhase.error : AiRequestPhase.error;
    await recordResult(
      modelName: modelName,
      result: result,
      message: e.toString(),
      step: step,
      showDialog: showDialog,
    );
  }
}

final aiErrorHandlerProvider = Provider<AiErrorHandler>((ref) => AiErrorHandler(ref));
