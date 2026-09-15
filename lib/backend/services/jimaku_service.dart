import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:eiga/config/app_config.dart';
import 'package:eiga/config/secure_storage.dart';
import 'package:eiga/backend/services/cache_service.dart';

class JimakuService {
  static const String baseUrl = AppConfig.jimakuBaseUrl;

  final String apiKey;
  final CacheService _cacheService = CacheService();

  JimakuService._(this.apiKey);

  static Future<JimakuService> create() async {
    final token = await SecureTokenStorage.getToken(ApiTokenType.jimaku);

    if (token.isEmpty) {
      throw Exception('Jimaku API token not found');
    }
    return JimakuService._(token);
  }

  Map<String, String> get headers => {
    'Authorization': apiKey,
    'Content-Type': 'application/json',
  };

  Future<List<UnifiedMetadataDTO>> searchJumakuObjects({
    String? query,
    bool anime = true,
    int? anilistId,
    String? tmdbId,
    int? after,
    int? before,
  }) async {
    final Map<String, String> params = {'anime': anime.toString()};

    if (query != null && query.isNotEmpty) {
      params['query'] = query;
    }
    if (anilistId != null) {
      params['anilist_id'] = anilistId.toString();
    }
    if (tmdbId != null && tmdbId.isNotEmpty) {
      params['tmdb_id'] = tmdbId;
    }
    if (after != null) {
      params['after'] = after.toString();
    }
    if (before != null) {
      params['before'] = before.toString();
    }

    final uri = Uri.parse(
      '$baseUrl/entries/search',
    ).replace(queryParameters: params);

    final response = await http.get(uri, headers: headers).timeout(AppConfig.defaultTimeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => _mapJimakuToUnified(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception(
        'Searching error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  UnifiedMetadataDTO _mapJimakuToUnified(Map<String, dynamic> json) {
    final flags = json['flags'] as Map<String, dynamic>? ?? {};
    final id = json['id'] as int;

    return UnifiedMetadataDTO(
      sourceId: id.toString(),
      title: json['english_name'] as String? ?? json['name'] as String? ?? 'Unknown',
      subtitle: json['name'] as String?,
      originalTitle: json['japanese_name'] as String?,
      anilistId: json['anilist_id'] as int?,
      tmdbId: json['tmdb_id'] as String?,
      imdbId: json['imdb_id'] as String?,
      thetvdbId: json['thetvdb_id'] as String?,
      type: flags['movie'] == true ? 'MOVIE' : (flags['anime'] == true ? 'ANIME' : 'TV'),
      linkUrl: 'https://jimaku.cc/entry/$id',
      extras: {
        'last_modified': json['last_modified'],
        'is_adult': flags['adult'],
        'is_unverified': flags['unverified'],
      },
    );
  }

  Future<List<FileJimakuDTO>> getFiles(int id, {int? episode}) async {
    final Map<String, String> queryParams = {};
    if (episode != null) {
      queryParams['episode'] = episode.toString();
    }
    final uri = Uri.parse(
      '$baseUrl/entries/$id/files',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: headers).timeout(AppConfig.defaultTimeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => FileJimakuDTO.fromJson(item)).toList();
    } else if (response.statusCode == 429) {
      throw Exception('Jimaku API rate limit exceeded. Please wait a moment and try again.');
    } else {
      throw Exception(
        'Error to get files: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<String> downloadAndCacheFile(
    String url, {
    String? preferredName,
    Duration? maxAge,
  }) async {
    final fileName = preferredName ?? '${DateTime.now().microsecondsSinceEpoch}_${p.basename(url)}';

    final cachedPath = await _cacheService.getCachedFilePath(CacheType.jimaku, fileName);
    if (cachedPath != null) {
      return cachedPath;
    }

    await _cacheService.cleanExpiredCache();

    final response = await http.get(Uri.parse(url), headers: headers).timeout(AppConfig.defaultTimeout);

    if (response.statusCode == 429) {
      throw Exception('Jimaku download rate limit exceeded.');
    }
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }

    return await _cacheService.cacheBytes(response.bodyBytes, CacheType.jimaku, fileName);
  }

  Future<void> clearCache() async {
    await _cacheService.clearCache(CacheType.jimaku);
  }
}
