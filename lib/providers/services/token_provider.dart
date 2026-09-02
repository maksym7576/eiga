import 'package:eiga/config/secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tokenProvider = AsyncNotifierProvider.family<TokenNotifier, String, ApiTokenType>(
  TokenNotifier.new,
);

class TokenNotifier extends AsyncNotifier<String> {
  final ApiTokenType arg;
  TokenNotifier(this.arg);

  @override
  Future<String> build() async {
    return await SecureTokenStorage.getToken(arg);
  }

  Future<void> setToken(String apiKey) async {
    final trimmedKey = apiKey.trim();
    if (trimmedKey.isEmpty) return;

    state = const AsyncLoading();
    try {
      await SecureTokenStorage.setToken(arg, trimmedKey);
      state = AsyncData(trimmedKey);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteToken() async {
    state = const AsyncLoading();
    try {
      await SecureTokenStorage.deleteToken(arg);
      state = const AsyncData('');
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
