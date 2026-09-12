import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final openJimakuDialogProvider = StateProvider<bool>((ref) => false);
final openGeminiDialogProvider = StateProvider<bool>((ref) => false);
final useAlternativeLogoProvider = StateProvider<bool>((ref) => false);
