import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum ApiTokenType {
  gemini('gemini_api_key'),
  jimaku('jimaku_api_key');

  final String key;
  const ApiTokenType(this.key);
}

class SecureTokenStorage {
  static const _storage = FlutterSecureStorage();

  static Future<String> getToken(ApiTokenType type) async {
    final token = await _storage.read(key: type.key);
    return token ?? '';
  }

  static Future<void> setToken(ApiTokenType type, String apiKey) async {
    await _storage.write(key: type.key, value: apiKey);
  }

  static Future<void> deleteToken(ApiTokenType type) async {
    await _storage.delete(key: type.key);
  }
}
