import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/services/utils/ai_exceptions.dart';

/// Global provider for AI-related errors that should be shown to the user as a dialog.
class AiErrorStateNotifier extends Notifier<AiUserFacingError?> {
  @override
  AiUserFacingError? build() => null;
  set state(AiUserFacingError? value) => super.state = value;
}

final aiErrorStateProvider = NotifierProvider<AiErrorStateNotifier, AiUserFacingError?>(
  AiErrorStateNotifier.new,
);
