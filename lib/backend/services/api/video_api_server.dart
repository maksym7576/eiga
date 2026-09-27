import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../../database/schemas/video.dart';
import '../../database/schemas/phrase.dart';
import '../background/translation_background_manager.dart';
import '../../../providers/database/isar_providers.dart';
import '../../../utils/logger.dart';

class VideoApiServer {
  final Ref ref;
  final Isar isar;
  HttpServer? _server;
  int _port = 8767;

  VideoApiServer(this.ref, this.isar);

  int get port => _port;
  bool get isRunning => _server != null;

  Future<void> start([int port = 8767]) async {
    if (_server != null) return;
    _port = port;
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, _port);
      logger.i('[VideoApiServer] Started successfully on port $_port');

      _server!.listen(_handleRequest, onError: (e, st) {
        logger.e('[VideoApiServer] Error in server stream', error: e, stackTrace: st);
      });
    } catch (e, st) {
      logger.e('[VideoApiServer] Failed to start server on port $_port', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> stop() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      logger.i('[VideoApiServer] Stopped');
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    // Enable CORS for all requests
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      return;
    }

    try {
      final path = request.uri.path;
      final queryParams = request.uri.queryParameters;

      logger.d('[VideoApiServer] ${request.method} $path');

      // 1. GET /api/ping
      if (request.method == 'GET' && path == '/api/ping') {
        _sendJson(request.response, {'status': 'connected'});
        return;
      }

      // 2. POST /api/videos
      if (request.method == 'POST' && path == '/api/videos') {
        final body = await _readJsonBody(request);
        final url = body['url'] as String?;
        if (url == null || url.isEmpty) {
          _sendError(request.response, HttpStatus.badRequest, 'Missing required field: url');
          return;
        }

        // Check if video with this url already exists
        Video? video = await isar.videos.filter().urlEqualTo(url).findFirst();

        await isar.writeTxn(() async {
          if (video == null) {
            video = Video()
              ..url = url
              ..source = body['source'] as String?
              ..title = body['title'] as String?
              ..fileName = body['title'] as String?
              ..originalLanguage = body['originalLanguage'] as String?
              ..translatedLanguage = body['translatedLanguage'] as String?
              ..creationSource = body['creationSource'] as String? ?? 'extension'
              ..createdAt = DateTime.now();
            final id = await isar.videos.put(video!);
            video = await isar.videos.get(id);
          } else {
            // Update fields if provided
            bool changed = false;
            if (body['source'] != null) {
              video!.source = body['source'] as String;
              changed = true;
            }
            if (body['title'] != null) {
              video!.title = body['title'] as String;
              video!.fileName = body['title'] as String;
              changed = true;
            }
            if (body['originalLanguage'] != null) {
              video!.originalLanguage = body['originalLanguage'] as String;
              changed = true;
            }
            if (body['translatedLanguage'] != null) {
              video!.translatedLanguage = body['translatedLanguage'] as String;
              changed = true;
            }
            if (body['creationSource'] != null) {
              video!.creationSource = body['creationSource'] as String;
              changed = true;
            }
            if (changed) {
              await isar.videos.put(video!);
            }
          }
        });

        _sendJson(request.response, _videoToMap(video!));
        return;
      }

      // 3. POST /api/videos/{url}/phrases (or /api/videos/phrases with url)
      final phrasesRegex = RegExp(r'^/api/videos/(.+)/phrases$');
      final phrasesMatch = phrasesRegex.firstMatch(path);
      if (request.method == 'POST' && phrasesMatch != null) {
        final encodedUrl = phrasesMatch.group(1)!;
        final url = Uri.decodeComponent(encodedUrl);

        final video = await isar.videos.filter().urlEqualTo(url).findFirst();
        if (video == null) {
          _sendError(request.response, HttpStatus.notFound, 'Video not found for url: $url');
          return;
        }

        final body = await _readBodyDynamic(request);
        List<dynamic> rawPhrases = [];
        final append = body is Map && body['append'] == true;
        if (body is Map && body.containsKey('phrases')) {
          rawPhrases = body['phrases'] as List<dynamic>? ?? [];
        } else if (body is List) {
          rawPhrases = body;
        }

        final existingPhrases = append
            ? await isar.phrases.filter().videoIdEqualTo(video.id).findAll()
            : <Phrase>[];
        final lastPhraseOrder = existingPhrases.fold<int>(0, (last, phrase) {
          final order = phrase.phraseOrder ?? 0;
          return order > last ? order : last;
        });

        await isar.writeTxn(() async {
          if (!append) {
            await isar.phrases.filter().videoIdEqualTo(video.id).deleteAll();
          }

          final newPhrases = <Phrase>[];
          for (int i = 0; i < rawPhrases.length; i++) {
            final pMap = rawPhrases[i] as Map<String, dynamic>;
            final startMs = pMap['startTime'] as int? ?? (pMap['start'] as int? ?? 0);
            final endMs = pMap['endTime'] as int? ?? (pMap['end'] as int? ?? 0);
            final text = pMap['text'] as String? ?? (pMap['originalPhrase'] as String? ?? '');

            final startTime = DateTime(1970, 1, 1).add(Duration(milliseconds: startMs));
            final endTime = DateTime(1970, 1, 1).add(Duration(milliseconds: endMs));

            final existing = append
                ? existingPhrases.where((phrase) =>
                    phrase.startTime?.isAtSameMomentAs(startTime) == true &&
                    phrase.originalPhrase == text).firstOrNull
                : null;

            if (existing != null) {
              existing
                ..startTime = startTime
                ..endTime = endTime
                ..originalPhrase = text;
              newPhrases.add(existing);
              continue;
            }

            newPhrases.add(Phrase(
              videoId: video.id,
              phraseOrder: append ? lastPhraseOrder + i + 1 : i + 1,
              originalPhrase: text,
              startTime: startTime,
              endTime: endTime,
            ));
          }

          if (newPhrases.isNotEmpty) {
            await isar.phrases.putAll(newPhrases);
          }
        });

        final updatedPhrases = await isar.phrases.filter().videoIdEqualTo(video.id).sortByPhraseOrder().findAll();

        _sendJson(request.response, {
          'video': _videoToMap(video),
          'phrases': updatedPhrases.map((p) => _phraseToMap(p)).toList(),
        });
        return;
      }

      // 4. GET /api/videos/phrases?url={url}
      if (request.method == 'GET' && path == '/api/videos/phrases') {
        final url = queryParams['url'];
        if (url == null || url.isEmpty) {
          _sendError(request.response, HttpStatus.badRequest, 'Missing query parameter: url');
          return;
        }

        final video = await isar.videos.filter().urlEqualTo(url).findFirst();
        if (video == null) {
          _sendJson(request.response, {'phrases': []});
          return;
        }

        final phrases = await isar.phrases.filter().videoIdEqualTo(video.id).sortByPhraseOrder().findAll();
        _sendJson(request.response, {
          'phrases': phrases.map((p) => _phraseToMap(p)).toList(),
        });
        return;
      }

      // 5. POST /api/videos/sync
      if (request.method == 'POST' && path == '/api/videos/sync') {
        final body = await _readJsonBody(request);
        final url = body['url'] as String?;
        final currentTimeMs = body['currentTimeMs'] as int? ?? 0;

        if (url == null || url.isEmpty) {
          _sendError(request.response, HttpStatus.badRequest, 'Missing required field: url');
          return;
        }

        final video = await isar.videos.filter().urlEqualTo(url).findFirst();
        if (video == null) {
          _sendError(request.response, HttpStatus.notFound, 'Video not found for url: $url');
          return;
        }

        final phrases = await isar.phrases.filter().videoIdEqualTo(video.id).sortByPhraseOrder().findAll();
        if (phrases.isEmpty) {
          _sendJson(request.response, {'phrase': null});
          return;
        }

        final baseDate = DateTime(1970, 1, 1);
        
        // Find phrase corresponding to currentTimeMs
        Phrase? activePhrase;
        for (final p in phrases) {
          if (p.startTime != null && p.endTime != null) {
            final start = p.startTime!.difference(baseDate).inMilliseconds;
            final end = p.endTime!.difference(baseDate).inMilliseconds;
            if (currentTimeMs >= start && currentTimeMs <= end) {
              activePhrase = p;
              break;
            }
          }
        }

        // If no exact match, find closest upcoming or past phrase
        if (activePhrase == null) {
          for (final p in phrases) {
            if (p.startTime != null) {
              final start = p.startTime!.difference(baseDate).inMilliseconds;
              if (start >= currentTimeMs) {
                activePhrase = p;
                break;
              }
            }
          }
          activePhrase ??= phrases.last;
        }

        // Check if translated; if not, trigger translation task via background manager
        if (!activePhrase.isTranslated) {
          try {
            final manager = ref.read(translationBackgroundManagerProvider);
            final untranslatedIds = <int>[];
            final activeIndex = phrases.indexWhere((p) => p.id == activePhrase!.id);
            for (int i = activeIndex; i < phrases.length && i < activeIndex + 4; i++) {
              if (!phrases[i].isTranslated && !phrases[i].isTranslating) {
                untranslatedIds.add(phrases[i].id);
              }
            }

            if (untranslatedIds.isNotEmpty) {
              manager.addTask(TranslationTask(
                videoId: video.id,
                phraseIds: untranslatedIds,
                priority: TaskPriority.high,
              ));
            }
          } catch (e, st) {
            logger.e('[VideoApiServer] Failed to trigger translation task', error: e, stackTrace: st);
          }
        }

        // Re-fetch phrase to get latest status/translation
        final currentPhrase = await isar.phrases.get(activePhrase.id) ?? activePhrase;

        _sendJson(request.response, {
          'phrase': _phraseToMap(currentPhrase),
        });
        return;
      }

      _sendError(request.response, HttpStatus.notFound, 'Endpoint not found: ${request.method} $path');
    } catch (e, st) {
      logger.e('[VideoApiServer] Request handling error', error: e, stackTrace: st);
      _sendError(request.response, HttpStatus.internalServerError, e.toString());
    }
  }

  Map<String, dynamic> _videoToMap(Video v) {
    return {
      'id': v.id.toString(),
      'url': v.url ?? '',
      'title': v.title ?? v.fileName ?? v.seriesName ?? '',
      'originalLanguage': v.originalLanguage ?? '',
      'translatedLanguage': v.translatedLanguage ?? '',
      'creationSource': v.creationSource ?? 'extension',
      'createdAt': v.createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _phraseToMap(Phrase p) {
    final baseDate = DateTime(1970, 1, 1);
    final startMs = p.startTime != null ? p.startTime!.difference(baseDate).inMilliseconds : 0;
    final endMs = p.endTime != null ? p.endTime!.difference(baseDate).inMilliseconds : 0;

    String status = 'pending';
    if (p.isTranslated) {
      status = 'translated';
    } else if (p.isTranslating) {
      status = 'processing';
    }

    return {
      'id': p.id.toString(),
      'startTime': startMs,
      'endTime': endMs,
      'text': p.originalPhrase ?? '',
      'translatedText': p.translatedPhrase,
      'isTranslated': p.isTranslated,
      'status': status,
    };
  }

  Future<Map<String, dynamic>> _readJsonBody(HttpRequest request) async {
    final content = await utf8.decoder.bind(request).join();
    if (content.isEmpty) return {};
    final decoded = jsonDecode(content);
    if (decoded is Map<String, dynamic>) return decoded;
    return {};
  }

  Future<dynamic> _readBodyDynamic(HttpRequest request) async {
    final content = await utf8.decoder.bind(request).join();
    if (content.isEmpty) return {};
    return jsonDecode(content);
  }

  void _sendJson(HttpResponse response, Map<String, dynamic> data) {
    response.statusCode = HttpStatus.ok;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(data));
    response.close();
  }

  void _sendError(HttpResponse response, int statusCode, String message) {
    response.statusCode = statusCode;
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode({'error': message}));
    response.close();
  }
}

final videoApiServerProvider = Provider<VideoApiServer>((ref) {
  final isar = ref.watch(isarProvider);
  final server = VideoApiServer(ref, isar);
  server.start().catchError((e) {
    logger.e('[VideoApiServer] Auto-start failed', error: e);
  });
  ref.onDispose(() {
    server.stop();
  });
  return server;
});
