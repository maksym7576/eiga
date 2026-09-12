import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:eiga/config/app_config.dart';
import 'package:eiga/config/secure_storage.dart';

class WyzieService {
  static const String baseUrl = AppConfig.wyzieBaseUrl;

  final String apiKey;

  WyzieService._(this.apiKey);

  static Future<WyzieService> create() async {
    final token = await SecureTokenStorage.getToken(ApiTokenType.wyzie);

    if (token.isEmpty) {
      throw Exception('Wyzie API token not found');
    }
    return WyzieService._(token);
  }

  Map<String, String> get headers => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  Future<List<UnifiedMetadataDTO>> searchWyzieObjects({
    String? query,
    bool anime = true,
  }) async {
    final Map<String, String> params = {'type': anime ? 'anime' : 'movie'};

    if (query != null && query.isNotEmpty) {
      params['q'] = query;
    }

    final uri = Uri.parse('$baseUrl/search').replace(queryParameters: params);

    final response = await http.get(uri, headers: headers).timeout(AppConfig.defaultTimeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => _mapWyzieToUnified(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception(
        'Wyzie search error: ${response.statusCode} - ${response.body}',
      );
    }
  }

  UnifiedMetadataDTO _mapWyzieToUnified(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';

    return UnifiedMetadataDTO(
      sourceId: id,
      title: json['title'] as String? ?? 'Unknown',
      subtitle: json['alternative_title'] as String?,
      originalTitle: json['original_title'] as String?,
      anilistId: json['anilist_id'] as int?,
      type: json['type'] as String?,
      imageUrl: json['poster_url'] as String?,
      linkUrl: 'https://wyzie.xyz/entry/$id',
      extras: {
        'year': json['year'],
      },
    );
  }

  Future<List<FileJimakuDTO>> getFiles(String id, {int? episode}) async {
    final Map<String, String> queryParams = {};
    if (episode != null) {
      queryParams['episode'] = episode.toString();
    }
    final uri = Uri.parse('$baseUrl/entries/$id/subtitles').replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final response = await http.get(uri, headers: headers).timeout(AppConfig.defaultTimeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => FileJimakuDTO.fromJson(item)).toList();
    } else {
      throw Exception(
        'Wyzie error to get files: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<String> downloadAndCacheFile(
    String url, {
    String? preferredName,
    Duration maxAge = const Duration(hours: 1),
  }) async {
    final tempDir = await getTemporaryDirectory();
    final cacheDir = Directory(p.join(tempDir.path, 'wyzie_cache'));

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    final fileName = preferredName ?? '${DateTime.now().microsecondsSinceEpoch}_${p.basename(url)}';
    final localPath = p.join(cacheDir.path, fileName);
    final file = File(localPath);

    if (await file.exists()) {
      final stat = await file.stat();
      if (DateTime.now().difference(stat.modified) < maxAge) {
        return localPath;
      }
    }

    final response = await http.get(Uri.parse(url), headers: headers).timeout(AppConfig.defaultTimeout);

    if (response.statusCode != 200) {
      throw Exception('Wyzie download error: ${response.statusCode}');
    }
    await file.writeAsBytes(response.bodyBytes);

    return localPath;
  }

  Future<void> clearCache() async {
    final tempDir = await getTemporaryDirectory();
    final cacheDir = Directory(p.join(tempDir.path, 'wyzie_cache'));
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }
}
