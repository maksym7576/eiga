import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:eiga/config/app_config.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';

class AniListDisabledException implements Exception {
  final String message;
  AniListDisabledException(this.message);
  @override
  String toString() => message;
}

class AniListService {
  static const _endpoint = AppConfig.aniListEndpoint;
  static const _timeout = AppConfig.defaultTimeout;

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'EigaApp/1.0.0 (https://github.com/your-username/eiga)',
  };

  static const _query = r'''
    query ($id: Int) {
      Media(id: $id, type: ANIME) {
        id
        title {
          romaji
          english
          native
        }
        description(asHtml: false)
        bannerImage
        genres
        season
        seasonYear
        episodes
        format
        status
        averageScore
        coverImage {
          extraLarge
          large
          color
        }
      }
    }
  ''';

  static const _searchQuery = r'''
    query ($search: String, $page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        media(search: $search, type: ANIME) {
          id
          title {
            romaji
            english
            native
          }
          description(asHtml: false)
          bannerImage
          genres
          season
          seasonYear
          episodes
          status
          averageScore
          coverImage {
            extraLarge
            large
            color
          }
        }
      }
    }
  ''';

  static const _multipleIdsQuery = r'''
    query ($idIn: [Int], $page: Int, $perPage: Int) {
      Page(page: $page, perPage: $perPage) {
        media(id_in: $idIn, type: ANIME) {
          id
          title {
            romaji
            english
            native
          }
          description(asHtml: false)
          bannerImage
          genres
          season
          seasonYear
          episodes
          status
          averageScore
          coverImage {
            extraLarge
            large
            color
          }
        }
      }
    }
  ''';

  Future<List<UnifiedMetadataDTO>> getByName(
    String name, {
    int page = 1,
    int perPage = 10,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      developer.log('AniList status check & search: "$name" (page: $page)', name: 'AniListService');
      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: _headers,
            body: jsonEncode({
              'query': _searchQuery,
              'variables': {
                'search': name,
                'page': page,
                'perPage': perPage,
              },
            }),
          )
          .timeout(_timeout);

      developer.log('AniList response received in ${stopwatch.elapsedMilliseconds}ms', name: 'AniListService');

      if (response.statusCode == 429) {
        final retryAfter = response.headers['retry-after'];
        developer.log('AniList rate limit exceeded. Retry-After: $retryAfter', name: 'AniListService');
        return [];
      }

      if (response.statusCode != 200) {
        final errorMessage = _tryExtractErrorMessage(response.body);
        developer.log(
          'AniList search failed: ${response.statusCode}\nBody: ${response.body}',
          name: 'AniListService',
        );
        if (response.body.contains('temporarily disabled')) {
          throw AniListDisabledException(errorMessage ?? 'The AniList API has been temporarily disabled.');
        }
        return [];
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (decoded.containsKey('errors')) {
        final errorMessage = _tryExtractErrorMessage(response.body);
        if (errorMessage != null && errorMessage.contains('temporarily disabled')) {
          throw AniListDisabledException(errorMessage);
        }
        developer.log('AniList returned GraphQL errors: ${decoded['errors']}', name: 'AniListService');
      }

      final mediaList = decoded['data']?['Page']?['media'] as List<dynamic>?;

      if (mediaList == null) {
        developer.log('AniList search returned 0 results', name: 'AniListService');
        return [];
      }

      developer.log('AniList search returned ${mediaList.length} results', name: 'AniListService');

      return mediaList
          .where((m) => m != null)
          .map((m) => _mapAniListToUnified(m as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      if (e is AniListDisabledException) rethrow;
      _handleError('getByName', e, st, query: name);
      return [];
    }
  }

  UnifiedMetadataDTO _mapAniListToUnified(Map<String, dynamic> json) {
    final title = json['title'] as Map<String, dynamic>? ?? {};
    final cover = json['coverImage'] as Map<String, dynamic>? ?? {};
    final id = json['id'] as int?;

    int? colorValue;
    final colorStr = cover['color'] as String?;
    if (colorStr != null && colorStr.startsWith('#')) {
      final hex = colorStr.replaceFirst('#', '');
      colorValue = int.tryParse('FF$hex', radix: 16);
    }

    final scoreRaw = json['averageScore'] as num?;
    final normalizedScore = scoreRaw != null ? scoreRaw / 10.0 : null;

    return UnifiedMetadataDTO(
      sourceId: id?.toString() ?? '',
      anilistId: id,
      title: title['romaji'] as String? ?? title['english'] as String? ?? 'Unknown',
      subtitle: title['english'] as String?,
      originalTitle: title['native'] as String?,
      imageUrl: (cover['extraLarge'] ?? cover['large']) as String?,
      bannerUrl: json['bannerImage'] as String?,
      description: json['description'] as String?,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      colorThemeValue: colorValue,
      episodes: json['episodes'] as int?,
      type: json['format'] as String?,
      status: json['status'] as String?,
      score: normalizedScore,
      linkUrl: id != null ? 'https://anilist.co/anime/$id' : null,
      extras: {
        'season': json['season'],
        'seasonYear': json['seasonYear'],
      },
    );
  }

  void _handleError(String methodName, dynamic error, StackTrace stackTrace, {String? query}) {
    final isNetworkError = error is SocketException || 
                           error is HttpException || 
                           error is http.ClientException || 
                           error is TimeoutException;
    
    if (isNetworkError) {
      developer.log(
        'AniList SERVER PROBLEM ($methodName): Connection failed or timed out. '
        'This is likely an issue with AniList servers or your internet connection.',
        name: 'AniListService',
        error: error,
        level: 1000, // Error level
      );
    } else if (error is FormatException || error is TypeError) {
      developer.log(
        'AniList CODE/APP PROBLEM ($methodName): Failed to parse response. '
        'This means the code needs to be updated to match the API changes.',
        name: 'AniListService',
        error: error,
        stackTrace: stackTrace,
        level: 1200, // Fatal/Critical level
      );
    } else {
      developer.log(
        'AniList UNKNOWN PROBLEM ($methodName): ${query != null ? "Query: $query" : ""}',
        name: 'AniListService',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<(bool, String?)> checkHealth() async {
    developer.log('AniList health check started...', name: 'AniListService');
    try {
      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: _headers,
            body: jsonEncode({
              'query': 'query { Page(perPage: 1) { media(type: ANIME) { id } } }',
            }),
          )
          .timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) return (true, null);

      final message = _tryExtractErrorMessage(response.body);
      return (false, message);
    } catch (e) {
      developer.log('AniList health check failed: $e', name: 'AniListService');
      return (false, null);
    }
  }

  String? _tryExtractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      if (decoded.containsKey('errors')) {
        final errors = decoded['errors'] as List<dynamic>;
        if (errors.isNotEmpty) {
          return errors.first['message']?.toString();
        }
      }
    } catch (_) {}
    return null;
  }

  Future<List<UnifiedMetadataDTO>> getByIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    try {
      developer.log('AniList getByIds: $ids', name: 'AniListService');
      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: _headers,
            body: jsonEncode({
              'query': _multipleIdsQuery,
              'variables': {
                'idIn': ids,
                'page': 1,
                'perPage': ids.length,
              },
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 429) {
        final retryAfter = response.headers['retry-after'];
        developer.log('AniList rate limit exceeded. Retry-After: $retryAfter', name: 'AniListService');
        return [];
      }

      if (response.statusCode != 200) {
        final errorMessage = _tryExtractErrorMessage(response.body);
        developer.log(
          'AniList getByIds failed: ${response.statusCode}\nBody: ${response.body}',
          name: 'AniListService',
        );
        if (response.body.contains('temporarily disabled')) {
          throw AniListDisabledException(errorMessage ?? 'The AniList API has been temporarily disabled.');
        }
        return [];
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (decoded.containsKey('errors')) {
        final errorMessage = _tryExtractErrorMessage(response.body);
        if (errorMessage != null && errorMessage.contains('temporarily disabled')) {
          throw AniListDisabledException(errorMessage);
        }
        developer.log('AniList returned GraphQL errors: ${decoded['errors']}', name: 'AniListService');
      }

      final mediaList = decoded['data']?['Page']?['media'] as List<dynamic>?;

      if (mediaList == null) {
        developer.log('AniList search returned 0 results', name: 'AniListService');
        return [];
      }

      developer.log('AniList search returned ${mediaList.length} results', name: 'AniListService');

      return mediaList
          .where((m) => m != null)
          .map((m) => _mapAniListToUnified(m as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      if (e is AniListDisabledException) rethrow;
      _handleError('getByIds', e, st);
      return [];
    }
  }

  Future<UnifiedMetadataDTO?> getById(
      int anilistId, {
        bool downloadImages = true,
      }) async {
    try {
      developer.log('AniList getById: $anilistId', name: 'AniListService');
      final response = await http
          .post(
        Uri.parse(_endpoint),
        headers: _headers,
        body: jsonEncode({
          'query': _query,
          'variables': {'id': anilistId},
        }),
      )
          .timeout(_timeout);

      if (response.statusCode == 429) {
        final retryAfter = response.headers['retry-after'];
        developer.log('AniList rate limit exceeded. Retry-After: $retryAfter', name: 'AniListService');
        return null;
      }

      if (response.statusCode != 200) {
        final errorMessage = _tryExtractErrorMessage(response.body);
        developer.log(
          'AniList request failed: ${response.statusCode}\nBody: ${response.body}',
          name: 'AniListService',
        );
        if (response.body.contains('temporarily disabled')) {
          throw AniListDisabledException(errorMessage ?? 'The AniList API has been temporarily disabled.');
        }
        return null;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (decoded.containsKey('errors')) {
        final errorMessage = _tryExtractErrorMessage(response.body);
        if (errorMessage != null && errorMessage.contains('temporarily disabled')) {
          throw AniListDisabledException(errorMessage);
        }
        developer.log('AniList returned GraphQL errors: ${decoded['errors']}', name: 'AniListService');
      }
      
      final media = decoded['data']?['Media'] as Map<String, dynamic>?;
      if (media == null) return null;

      var dto = _mapAniListToUnified(media);

      if (downloadImages) {
        final results = await Future.wait([
          if (dto.imageUrl != null)
            _downloadAndSave(dto.imageUrl!, anilistId, suffix: 'cover')
          else
            Future.value(null),
          if (dto.bannerUrl != null)
            _downloadAndSave(dto.bannerUrl!, anilistId, suffix: 'banner')
          else
            Future.value(null),
        ]);

        final coverPath = results[0];
        final bannerPath = results[1];

        dto = dto.copyWith(
          imagePath: coverPath ?? dto.imagePath,
          bannerPath: bannerPath ?? dto.bannerPath,
        );
      }

      return dto;
    } catch (e, st) {
      if (e is AniListDisabledException) rethrow;
      _handleError('getById', e, st, query: anilistId.toString());
      return null;
    }
  }

  Future<String?> _downloadAndSave(
      String url,
      int anilistId, {
        required String suffix,
      }) async {
    try {
      final extension = _extractExtension(url);
      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(dir.path, 'anilist_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final file = File(p.join(imagesDir.path, '${anilistId}_$suffix.$extension'));

      if (await file.exists()) {
        final length = await file.length();
        if (length > 0) {
          return file.path;
        }
      }

      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent': _headers['User-Agent']!,
      }).timeout(_timeout);
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        developer.log(
          'Failed to download image: $url (Status: ${response.statusCode})',
          name: 'AniListService',
        );
        return null;
      }

      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e, st) {
      developer.log(
        'Failed to download image: $url',
        name: 'AniListService',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  String _extractExtension(String url) {
    final path = Uri.parse(url).path;
    final segment = path.split('/').last;
    final dotIndex = segment.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == segment.length - 1) {
      return 'jpg';
    }
    return segment.substring(dotIndex + 1);
  }
}
