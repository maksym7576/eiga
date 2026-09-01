import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backend/services/app_configs.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final appConfigsServiceProvider = Provider<AppConfigs>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppConfigs(prefs);
});
