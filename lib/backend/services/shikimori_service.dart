import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:eiga/config/app_config.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';

class ShikimoriRequestException implements Exception {
  final String message;
  final int? statusCode;
  final String? responseBody;

  const ShikimoriRequestException(this.message, {this.statusCode, this.responseBody});

  @override
  String toString() => 'ShikimoriRequestException: $message'
      '${statusCode != null ? ' (status $statusCode)' : ''}';
}

class ShikimoriService {
  static const _baseUrl = AppConfig.shikimoriBaseUrl;
  static const _timeout = AppConfig.defaultTimeout;

  static const _headers = {
    'Accept': 'application/json',
    'User-Agent': 'EigaApp/1.0 (https://github.com/your-username/eiga)',
  };

  Future<List<UnifiedMetadataDTO>> searchAnime(String query, {int page = 1, int limit = 10}) async {
    final cleanedQuery = query.trim();
    if (cleanedQuery.isEmpty) return [];

    final uri = Uri.parse('$_baseUrl/animes').replace(
      queryParameters: {
        'search': cleanedQuery,
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    final data = await _getJson(uri);
    if (data is! List) return [];

    return data
        .map((item) => _mapShikimoriToUnified(item as Map<String, dynamic>))
        .toList();
  }

  Future<UnifiedMetadataDTO?> getAnimeById(int id, {bool downloadImages = true}) async {
    final uri = Uri.parse('$_baseUrl/animes/$id');
    final data = await _getJson(uri);

    if (data is! Map<String, dynamic>) return null;

    var dto = _mapShikimoriToUnified(data);

    if (downloadImages && dto.imageUrl != null) {
      final path = await _downloadAndSave(dto.imageUrl!, id, suffix: 'poster');
      if (path != null) dto = dto.copyWith(imagePath: path);
    }

    return dto;
  }

  /// Shikimori singlesearch equivalent (takes first match)
  Future<UnifiedMetadataDTO?> singleSearchAnime(String query) async {
    try {
      final results = await searchAnime(query, limit: 1);
      if (results.isEmpty) return null;
      return results.first;
    } catch (e) {
      developer.log('Shikimori single search failed for "$query": $e', name: 'ShikimoriService');
      return null;
    }
  }

  Future<(bool, String?)> checkHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/animes').replace(
        queryParameters: {'limit': '1'},
      );
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) return (true, null);
      return (false, 'Status code: ${response.statusCode}');
    } catch (e) {
      return (false, e.toString());
    }
  }

  UnifiedMetadataDTO _mapShikimoriToUnified(Map<String, dynamic> json) {
    final id = json['id'] as int;
    
    // Extract English title: check english array or fallback to name (original/international name)
    String? englishTitle;
    if (json.containsKey('english') && json['english'] is List && (json['english'] as List).isNotEmpty) {
      englishTitle = (json['english'] as List).first.toString();
    }
    
    final mainTitle = englishTitle ?? json['name'] as String? ?? 'Unknown';
    final name = json['name'] as String?;
    
    // Subtitle: use 'name' if it's different from the title we picked
    final subtitle = (name != null && name != mainTitle) ? name : null;

    String? originalTitle;
    if (json.containsKey('japanese') && json['japanese'] is List && (json['japanese'] as List).isNotEmpty) {
      originalTitle = (json['japanese'] as List).first.toString();
    }

    final image = json['image'] as Map<String, dynamic>? ?? {};
    final originalImage = image['original'] as String?;
    final imageUrl = originalImage != null ? 'https://shikimori.one$originalImage' : null;

    final genres = (json['genres'] as List<dynamic>? ?? [])
        .map((g) => g['name'] as String)
        .toList();

    return UnifiedMetadataDTO(
      sourceId: id.toString(),
      shikimoriId: id, // We might need to add this to UnifiedMetadataDTO or use sourceId
      anilistId: null, // Shikimori doesn't directly provide AniList ID usually
      malId: json['myanimelist_id'] as int?,
      title: mainTitle,
      subtitle: subtitle,
      originalTitle: originalTitle,
      imageUrl: imageUrl,
      episodes: json['episodes'] as int?,
      type: json['kind'] as String?,
      status: json['status'] as String?,
      score: double.tryParse(json['score']?.toString() ?? ''),
      description: json['description'] as String?,
      genres: genres,
      linkUrl: 'https://shikimori.one${json['url']}',
      extras: {
        'ongoing': json['ongoing'],
        'anons': json['anons'],
        'aired_on': json['aired_on'],
        'released_on': json['released_on'],
      },
    );
  }

  Future<dynamic> _getJson(Uri uri) async {
    const int maxAttempts = 2;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        developer.log('Shikimori GET: $uri (attempt $attempt)', name: 'ShikimoriService');
        final response = await http.get(uri, headers: _headers).timeout(_timeout);

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }

        if (response.statusCode == 429) {
          developer.log('Shikimori rate limit exceeded (429).', name: 'ShikimoriService');
          if (attempt == maxAttempts) {
             throw ShikimoriRequestException('Rate limit exceeded', statusCode: 429);
          }
          await Future.delayed(Duration(milliseconds: 1000 * attempt));
          continue;
        }

        if (response.statusCode >= 500) {
          developer.log('Shikimori server error: ${response.statusCode}', name: 'ShikimoriService');
          if (attempt == maxAttempts) {
            throw ShikimoriRequestException('Server error', statusCode: response.statusCode);
          }
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }

        throw ShikimoriRequestException('Request failed', statusCode: response.statusCode, responseBody: response.body);
      } on TimeoutException {
        if (attempt == maxAttempts) throw const ShikimoriRequestException('Request timed out', statusCode: 504);
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        if (attempt == maxAttempts) rethrow;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Future<String?> _downloadAndSave(String url, int id, {required String suffix}) async {
    try {
      final uri = Uri.parse(url);
      final extension = p.extension(uri.path).isEmpty ? '.jpg' : p.extension(uri.path);
      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(dir.path, 'shikimori_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final file = File(p.join(imagesDir.path, '${id}_$suffix$extension'));
      if (await file.exists() && await file.length() > 0) {
        return file.path;
      }

      final response = await http.get(uri, headers: _headers).timeout(_timeout);

      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        developer.log('Failed to download image: $url', name: 'ShikimoriService');
        return null;
      }

      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e, st) {
      developer.log('Failed to download image: $url', name: 'ShikimoriService', error: e, stackTrace: st);
      return null;
    }
  }
}
