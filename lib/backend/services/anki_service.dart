import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eiga/config/app_config.dart';

class AnkiService {
  final AppConfig _appConfig;

  AnkiService(this._appConfig);

  String get _baseUrl => _appConfig.getAnkiConnectUrl;

  Future<bool> checkConnection() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: json.encode({
          'action': 'version',
          'version': 6,
        }),
      ).timeout(const Duration(seconds: 3));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['error'] == null;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<List<String>> getDeckNames() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: json.encode({
          'action': 'deckNames',
          'version': 6,
        }),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == null && data['result'] != null) {
          return List<String>.from(data['result']);
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<String>> getModelNames() async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: json.encode({
          'action': 'modelNames',
          'version': 6,
        }),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == null && data['result'] != null) {
          return List<String>.from(data['result']);
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<bool> addNote({
    required String front,
    required String back,
    List<String> tags = const [],
  }) async {
    try {
      final deckName = _appConfig.getAnkiDeckName;
      final modelName = _appConfig.getAnkiNoteType;

      // NoteTypes might have different field names, but standard Basic/Cloze usually has Front/Back or Text.
      // We'll dynamically check the model fields or just try standard Front/Back and fallback if needed.
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: json.encode({
          'action': 'addNote',
          'version': 6,
          'params': {
            'note': {
              'deckName': deckName,
              'modelName': modelName,
              'fields': {
                'Front': front,
                'Back': back,
                // Fallback for some common layouts if needed
                'Text': front,
                'Extra': back,
              },
              'tags': tags,
            }
          },
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['error'] == null;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
