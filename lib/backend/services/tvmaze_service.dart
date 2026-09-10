import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:eiga/config/app_config.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';

/// Кидається, коли TVmaze повертає помилку, яку варто показати окремо
/// (напр. show lookup не знайшов збігу — HTTP 404).
class TVmazeNotFoundException implements Exception {
  final String message;
  TVmazeNotFoundException(this.message);
  @override
  String toString() => message;
}

class TVmazeService {
  static const _baseUrl = AppConfig.tvMazeEndpoint;
  static const _timeout = AppConfig.defaultTimeout;

  static const _headers = {
    'Accept': 'application/json',
    'User-Agent': 'EigaApp/1.0.0 (https://github.com/your-username/eiga)',
  };

  // ---------------------------------------------------------------------
  // Пошук
  // ---------------------------------------------------------------------

  /// /search/shows?q=:query — нечіткий пошук, повертає список збігів
  /// разом з "score" релевантності.
  Future<List<UnifiedMetadataDTO>> searchShows(String query) async {
    final uri = Uri.parse('$_baseUrl/search/shows').replace(
      queryParameters: {'q': query},
    );
    final data = await _getJson(uri);
    if (data == null) return [];

    final list = data as List<dynamic>;
    return list
        .map((entry) => entry['show'] as Map<String, dynamic>?)
        .whereType<Map<String, dynamic>>()
        .map(_mapTVmazeToUnified)
        .toList();
  }

  /// /singlesearch/shows?q=:query — повертає рівно один найкращий збіг
  /// або null. Можна передати embed (напр. 'episodes', 'cast').
  Future<UnifiedMetadataDTO?> singleSearchShow(String query, {String? embed}) async {
    final params = {'q': query, 'embed': embed};
    params.removeWhere((key, value) => value == null);
    final uri = Uri.parse('$_baseUrl/singlesearch/shows').replace(queryParameters: params);
    final data = await _getJson(uri);
    if (data == null) return null;
    return _mapTVmazeToUnified(data as Map<String, dynamic>);
  }

  /// /lookup/shows?imdb=:id або ?thetvdb=:id — знаходить шоу за зовнішнім ID.
  /// TVmaze відповідає HTTP 301 з редіректом на /shows/:id, http-пакет
  /// сам іде за редіректом, тому просто парсимо фінальну відповідь.
  Future<UnifiedMetadataDTO?> lookupShowByImdb(String imdbId) =>
      _lookupShow('imdb', imdbId);

  Future<UnifiedMetadataDTO?> lookupShowByTheTvdb(String theTvdbId) =>
      _lookupShow('thetvdb', theTvdbId);

  Future<UnifiedMetadataDTO?> _lookupShow(String provider, String id) async {
    final uri = Uri.parse('$_baseUrl/lookup/shows').replace(
      queryParameters: {provider: id},
    );
    final data = await _getJson(uri);
    if (data == null) return null;
    return _mapTVmazeToUnified(data as Map<String, dynamic>);
  }

  // ---------------------------------------------------------------------
  // Shows
  // ---------------------------------------------------------------------

  /// /shows/:id — основна інформація. embed напр. 'cast', 'episodes',
  /// або декілька через '&embed[]=...' (тут — простий одинарний embed).
  Future<UnifiedMetadataDTO?> getShowById(int id, {String? embed, bool downloadImage = false}) async {
    // Force embed episodes if not specified, to get episode count
    final effectiveEmbed = embed ?? 'episodes';
    final params = {'embed': effectiveEmbed};
    final uri = Uri.parse('$_baseUrl/shows/$id').replace(queryParameters: params);
    final data = await _getJson(uri);
    if (data == null) return null;

    var dto = _mapTVmazeToUnified(data as Map<String, dynamic>);

    if (downloadImage && dto.imageUrl != null) {
      final path = await _downloadAndSave(dto.imageUrl!, id, suffix: 'poster');
      if (path != null) dto = dto.copyWith(imagePath: path);
    }

    return dto;
  }

  /// /shows/:id/episodes — повний список епізодів (без спешлів за замовч.).
  Future<List<MediaEpisodeDTO>> getShowEpisodes(int id, {bool includeSpecials = false}) async {
    final params = {if (includeSpecials) 'specials': '1'};
    final uri = Uri.parse('$_baseUrl/shows/$id/episodes').replace(queryParameters: params);
    final data = await _getJson(uri);
    if (data == null) return [];
    return (data as List<dynamic>)
        .map((e) => MediaEpisodeDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// /shows/:id/episodebynumber?season=:s&number=:n
  Future<MediaEpisodeDTO?> getEpisodeByNumber(int showId, int season, int number) async {
    final uri = Uri.parse('$_baseUrl/shows/$showId/episodebynumber').replace(
      queryParameters: {'season': '$season', 'number': '$number'},
    );
    final data = await _getJson(uri);
    if (data == null) return null;
    return MediaEpisodeDTO.fromJson(data as Map<String, dynamic>);
  }

  /// /shows/:id/episodesbydate?date=YYYY-MM-DD — для щоденних шоу.
  Future<List<MediaEpisodeDTO>> getEpisodesByDate(int showId, String isoDate) async {
    final uri = Uri.parse('$_baseUrl/shows/$showId/episodesbydate').replace(
      queryParameters: {'date': isoDate},
    );
    final data = await _getJson(uri);
    if (data == null) return [];
    return (data as List<dynamic>)
        .map((e) => MediaEpisodeDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// /shows/:id/cast
  Future<List<MediaCastDTO>> getShowCast(int id) async {
    final uri = Uri.parse('$_baseUrl/shows/$id/cast');
    final data = await _getJson(uri);
    if (data == null) return [];
    return (data as List<dynamic>)
        .map((e) => MediaCastDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// /shows/:id/akas
  Future<List<Map<String, dynamic>>> getShowAkas(int id) async {
    final uri = Uri.parse('$_baseUrl/shows/$id/akas');
    final data = await _getJson(uri);
    if (data == null) return [];
    return (data as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  /// /shows?page=:num — повний індекс шоу, кешується TVmaze на 24 год.
  /// Використовуйте для локальної синхронізації бази (page = lastId ~/ 250).
  Future<List<UnifiedMetadataDTO>> getShowIndex({int page = 0}) async {
    final uri = Uri.parse('$_baseUrl/shows').replace(queryParameters: {'page': '$page'});
    final data = await _getJson(uri);
    if (data == null) return [];
    return (data as List<dynamic>)
        .map((e) => _mapTVmazeToUnified(e as Map<String, dynamic>))
        .toList();
  }

  Future<(bool, String?)> checkHealth() async {
    try {
      // Fetch a highly popular show that should always exist (e.g., ID 1: Under the Dome)
      final uri = Uri.parse('$_baseUrl/shows/1');
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) return (true, null);
      return (false, 'Status code: ${response.statusCode}');
    } catch (e) {
      return (false, e.toString());
    }
  }

  UnifiedMetadataDTO _mapTVmazeToUnified(Map<String, dynamic> json) {
    final ratingMap = json['rating'] as Map<String, dynamic>?;
    final networkMap = json['network'] as Map<String, dynamic>?;
    final webChannelMap = json['webChannel'] as Map<String, dynamic>?;
    final imageMap = json['image'] as Map<String, dynamic>?;
    
    int? epCount;
    List<MediaEpisodeDTO>? episodesList;
    List<MediaCastDTO>? cast;

    final embedded = json['_embedded'] as Map<String, dynamic>?;
    if (embedded != null) {
      if (embedded.containsKey('episodes')) {
        final eps = embedded['episodes'] as List<dynamic>?;
        epCount = eps?.length;
        episodesList = eps?.map((e) => MediaEpisodeDTO.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (embedded.containsKey('cast')) {
        final castList = embedded['cast'] as List<dynamic>?;
        cast = castList?.map((e) => MediaCastDTO.fromJson(e as Map<String, dynamic>)).toList();
      }
    }

    final id = json['id'] as int;

    return UnifiedMetadataDTO(
      sourceId: id.toString(),
      tvmazeId: id,
      title: json['name'] as String? ?? 'Unknown',
      imageUrl: imageMap?['medium'] ?? imageMap?['original'],
      linkUrl: json['url'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((g) => g.toString())
          .toList(),
      score: (ratingMap?['average'] as num?)?.toDouble(),
      description: json['summary'] as String?,
      episodes: epCount,
      episodesList: episodesList,
      cast: cast,
      imdbId: json['externals']?['imdb'] as String?,
      thetvdbId: json['externals']?['thetvdb']?.toString(),
      extras: {
        'language': json['language'],
        'premiered': json['premiered'],
        'ended': json['ended'],
        'network': networkMap?['name'],
        'webChannel': webChannelMap?['name'],
        'officialSite': json['officialSite'],
      },
    );
  }

  // ---------------------------------------------------------------------
  // Розклад
  // ---------------------------------------------------------------------

  /// /schedule?country=:cc&date=:date — ефірний розклад для країни/дня.
  Future<List<MediaEpisodeDTO>> getSchedule({String country = 'US', String? date}) async {
    final params = {'country': country, if (date != null) 'date': date};
    final uri = Uri.parse('$_baseUrl/schedule').replace(queryParameters: params);
    final data = await _getJson(uri);
    if (data == null) return [];
    return (data as List<dynamic>)
        .map((e) => MediaEpisodeDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// /schedule/web?country=:cc&date=:date — стрімінгові прем'єри.
  /// country=null -> усі; country='' -> лише глобальні (Netflix і т.п.).
  Future<List<MediaEpisodeDTO>> getWebSchedule({String? country, String? date}) async {
    final params = {if (country != null) 'country': country, if (date != null) 'date': date};
    final uri = Uri.parse('$_baseUrl/schedule/web').replace(queryParameters: params);
    final data = await _getJson(uri);
    if (data == null) return [];
    return (data as List<dynamic>)
        .map((e) => MediaEpisodeDTO.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---------------------------------------------------------------------
  // Внутрішні хелпери
  // ---------------------------------------------------------------------

  /// Виконує GET, обробляє rate-limit (429), 404 та інші помилки так само,
  /// як AniListService обробляє GraphQL-помилки. Повертає decoded JSON
  /// (Map або List) або null, якщо ресурс не знайдено / стався збій.
  Future<dynamic> _getJson(Uri uri) async {
    try {
      developer.log('TVmaze GET: $uri', name: 'TVmazeService');
      final response = await http.get(uri, headers: _headers).timeout(_timeout);

      if (response.statusCode == 429) {
        final retryAfter = response.headers['retry-after'];
        developer.log('TVmaze rate limit exceeded. Retry-After: $retryAfter', name: 'TVmazeService');
        return null;
      }

      if (response.statusCode == 404) {
        // Очікувана відповідь для lookup/episodebynumber/episodesbydate
        // коли збігів немає — не логуємо як помилку.
        return null;
      }

      if (response.statusCode != 200) {
        developer.log(
          'TVmaze request failed: ${response.statusCode}\nBody: ${response.body}',
          name: 'TVmazeService',
        );
        return null;
      }

      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } catch (e, st) {
      developer.log('TVmaze request failed', name: 'TVmazeService', error: e, stackTrace: st);
      return null;
    }
  }

  /// Кешує зображення локально, як _downloadAndSave в AniListService.
  Future<String?> _downloadAndSave(String url, int id, {required String suffix}) async {
    try {
      final extension = _extractExtension(url);
      final dir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(dir.path, 'tvmaze_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final file = File(p.join(imagesDir.path, '${id}_$suffix.$extension'));
      if (await file.exists() && await file.length() > 0) {
        return file.path;
      }

      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent': _headers['User-Agent']!,
      }).timeout(_timeout);

      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        developer.log(
          'Failed to download image: $url (Status: ${response.statusCode})',
          name: 'TVmazeService',
        );
        return null;
      }

      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e, st) {
      developer.log('Failed to download image: $url', name: 'TVmazeService', error: e, stackTrace: st);
      return null;
    }
  }

  String _extractExtension(String url) {
    final path = Uri.parse(url).path;
    final segment = path.split('/').last;
    final dotIndex = segment.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == segment.length - 1) return 'jpg';
    return segment.substring(dotIndex + 1);
  }
}
