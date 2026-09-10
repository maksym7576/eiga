import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:eiga/backend/services/utils/ai_exceptions.dart';

/// Global provider for AI-related errors that should be shown to the user as a dialog.
final aiErrorStateProvider = StateProvider<AiUserFacingError?>((ref) => null);
