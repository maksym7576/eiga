import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eiga/config/app_config.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final appConfigsServiceProvider = Provider<AppConfig>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppConfig(prefs);
});
