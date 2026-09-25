import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import '../../database/schemas/video.dart';
import '../../database/schemas/phrase.dart';
import '../../database/schemas/user_word_status.dart';
import '../../../config/ui/word_styles.dart';
import '../../../utils/logger.dart';

class SyncService {
  final Isar isar;

  SyncService(this.isar);

  /// Serializes all necessary data to a JSON string
  Future<String> exportData() async {
    final videos = await isar.videos.where().findAll();
    final phrases = await isar.phrases.where().findAll();
    final wordStatuses = await isar.userWordStatus.where().findAll();

    final payload = {
      'videos': videos.map((v) => _videoToMap(v)).toList(),
      'phrases': phrases.map((p) => _phraseToMap(p)).toList(),
      'wordStatuses': wordStatuses.map((w) => _wordStatusToMap(w)).toList(),
    };

    return jsonEncode(payload);
  }

  /// Merges incoming data into the local database without conflicts
  Future<void> importAndMergeData(String jsonString) async {
    final payload = jsonDecode(jsonString) as Map<String, dynamic>;
    
    final incomingVideos = payload['videos'] as List<dynamic>;
    final incomingPhrases = payload['phrases'] as List<dynamic>;
    final incomingWordStatuses = payload['wordStatuses'] as List<dynamic>;

    // 1. Merge Word Statuses (lemma unique)
    await isar.writeTxn(() async {
      for (var rawW in incomingWordStatuses) {
        final wMap = rawW as Map<String, dynamic>;
        final lemma = wMap['lemma'] as String;
        final statusName = wMap['status'] as String;
        final status = WordStatus.values.byName(statusName);
        final updatedAtStr = wMap['updatedAt'] as String?;
        final updatedAt = updatedAtStr != null ? DateTime.parse(updatedAtStr) : null;

        final existing = await isar.userWordStatus.filter().lemmaEqualTo(lemma).findFirst();
        if (existing == null) {
          await isar.userWordStatus.put(UserWordStatus(
            lemma: lemma,
            status: status,
            updatedAt: updatedAt ?? DateTime.now(),
          ));
        } else {
          // Keep the newer status or advanced status
          bool shouldUpdate = false;
          if (existing.updatedAt == null || (updatedAt != null && updatedAt.isAfter(existing.updatedAt!))) {
            shouldUpdate = true;
          } else if (existing.status == WordStatus.unknown && status != WordStatus.unknown) {
            shouldUpdate = true;
          }

          if (shouldUpdate) {
            existing.status = status;
            existing.updatedAt = updatedAt ?? DateTime.now();
            await isar.userWordStatus.put(existing);
          }
        }
      }
    });

    // 2. Merge Videos and map old IDs to new IDs
    final videoIdMap = <int, int>{}; // Map from incoming video ID to local video ID
    final existingVideos = await isar.videos.where().findAll();

    await isar.writeTxn(() async {
      for (var rawV in incomingVideos) {
        final vMap = rawV as Map<String, dynamic>;
        final incomingId = vMap['id'] as int;
        final fileName = vMap['fileName'] as String?;
        final anilistId = vMap['anilistId'] as int?;
        final tmdbId = vMap['tmdbId'] as String?;

        // Find match by identifier
        Video? existing;
        if (fileName != null && fileName.isNotEmpty) {
          existing = existingVideos.where((v) => v.fileName == fileName).firstOrNull;
        }
        if (existing == null && anilistId != null) {
          existing = existingVideos.where((v) => v.anilistId == anilistId).firstOrNull;
        }
        if (existing == null && tmdbId != null) {
          existing = existingVideos.where((v) => v.tmdbId == tmdbId).firstOrNull;
        }

        if (existing != null) {
          videoIdMap[incomingId] = existing.id;
          // Merge video metadata if incoming is more complete
          bool updated = false;
          if (existing.lastPositionMs == null || 
              ((vMap['lastPositionMs'] as int?) != null && (vMap['lastPositionMs'] as int) > existing.lastPositionMs!)) {
            existing.lastPositionMs = vMap['lastPositionMs'] as int?;
            updated = true;
          }
          if (existing.isSubtitleReady != true && vMap['isSubtitleReady'] == true) {
            existing.isSubtitleReady = true;
            existing.subtitleSource = vMap['subtitleSource'] as String?;
            updated = true;
          }
          if (updated) {
            await isar.videos.put(existing);
          }
        } else {
          // Create new Video
          final newVideo = _mapToVideo(vMap);
          final newId = await isar.videos.put(newVideo);
          videoIdMap[incomingId] = newId;
        }
      }
    });

    // 3. Merge Phrases
    await isar.writeTxn(() async {
      for (var rawP in incomingPhrases) {
        final pMap = rawP as Map<String, dynamic>;
        final incomingVideoId = pMap['videoId'] as int?;
        if (incomingVideoId == null) continue;

        final localVideoId = videoIdMap[incomingVideoId];
        if (localVideoId == null) continue;

        final phraseOrder = pMap['phraseOrder'] as int?;
        final originalPhrase = pMap['originalPhrase'] as String?;

        // Check if phrase exists for this video
        List<Phrase> existingPhrases = [];
        if (phraseOrder != null) {
          existingPhrases = await isar.phrases
              .filter()
              .videoIdEqualTo(localVideoId)
              .phraseOrderEqualTo(phraseOrder)
              .findAll();
        }

        if (existingPhrases.isNotEmpty) {
          final existingPhrase = existingPhrases.first;
          // If existing is not done, but incoming is done, overwrite tokens & details
          final incomingHasTranslation = pMap['translatedPhrase'] != null;
          if (existingPhrase.translatedPhrase == null && incomingHasTranslation) {
            existingPhrase.translatedPhrase = pMap['translatedPhrase'] as String?;
            existingPhrase.originalTokens = _parseOriginalTokens(pMap['originalTokens']);
            existingPhrase.translatedWords = _parseTranslatedWords(pMap['translatedWords']);
            existingPhrase.linkGroups = _parseLinkGroups(pMap['linkGroups']);
            
            if (pMap['stageKeys'] != null && pMap['stageValues'] != null) {
              existingPhrase.stageKeys = List<String>.from(pMap['stageKeys']);
              existingPhrase.stageValues = List<String>.from(pMap['stageValues']);
            }
            await isar.phrases.put(existingPhrase);
          }
        } else {
          // Create new Phrase
          final newPhrase = _mapToPhrase(pMap, localVideoId);
          await isar.phrases.put(newPhrase);
        }
      }
    });
  }

  // --- Helpers for Video ---
  Map<String, dynamic> _videoToMap(Video v) {
    return {
      'id': v.id,
      'originalLanguage': v.originalLanguage,
      'translatedLanguage': v.translatedLanguage,
      'textFormat': v.textFormat,
      'pathSubtitle': v.pathSubtitle,
      'videoPath': v.videoPath,
      'createdAt': v.createdAt?.toIso8601String(),
      'fileName': v.fileName,
      'episode': v.episode,
      'season': v.season,
      'nameJumaku': v.nameJumaku,
      'seriesName': v.seriesName,
      'originalName': v.originalName,
      'subtitleFileName': v.subtitleFileName,
      'anilistId': v.anilistId,
      'tvmazeId': v.tvmazeId,
      'shikimoriId': v.shikimoriId,
      'malId': v.malId,
      'tmdbId': v.tmdbId,
      'imdbId': v.imdbId,
      'thetvdbId': v.thetvdbId,
      'isAnime': v.isAnime,
      'isMovie': v.isMovie,
      'isAdult': v.isAdult,
      'isUnverified': v.isUnverified,
      'coverImagePath': v.coverImagePath,
      'description': v.description,
      'bannerImage': v.bannerImage,
      'genres': v.genres,
      'status': v.status,
      'score': v.score,
      'totalEpisodes': v.totalEpisodes,
      'colorThemeValue': v.colorThemeValue,
      'pipelineIndetificator': v.pipelineIndetificator,
      'isResearchDone': v.isResearchDone,
      'researchInformation': v.researchInformation,
      'isSubtitleReady': v.isSubtitleReady,
      'subtitleSource': v.subtitleSource,
      'appliedPaddingMs': v.appliedPaddingMs,
      'appliedFillGaps': v.appliedFillGaps,
      'audioStatus': v.audioStatus,
      'transcriptionStatus': v.transcriptionStatus,
      'processingProgress': v.processingProgress,
      'transcriptionResumeSeconds': v.transcriptionResumeSeconds,
      'metadataProvider': v.metadataProvider,
      'subtitleMethodUsed': v.subtitleMethodUsed,
      'isCached': v.isCached,
      'lastPositionMs': v.lastPositionMs,
      'selectedAudioTrackIndex': v.selectedAudioTrackIndex,
    };
  }

  Video _mapToVideo(Map<String, dynamic> map) {
    final v = Video();
    v.originalLanguage = map['originalLanguage'] as String?;
    v.translatedLanguage = map['translatedLanguage'] as String?;
    v.textFormat = map['textFormat'] as String?;
    v.pathSubtitle = map['pathSubtitle'] as String?;
    v.videoPath = map['videoPath'] as String?;
    v.createdAt = map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null;
    v.fileName = map['fileName'] as String?;
    v.episode = map['episode'] as String?;
    v.season = map['season'] as String?;
    v.nameJumaku = map['nameJumaku'] as String?;
    v.seriesName = map['seriesName'] as String?;
    v.originalName = map['originalName'] as String?;
    v.subtitleFileName = map['subtitleFileName'] as String?;
    v.anilistId = map['anilistId'] as int?;
    v.tvmazeId = map['tvmazeId'] as int?;
    v.shikimoriId = map['shikimoriId'] as int?;
    v.malId = map['malId'] as int?;
    v.tmdbId = map['tmdbId'] as String?;
    v.imdbId = map['imdbId'] as String?;
    v.thetvdbId = map['thetvdbId'] as String?;
    v.isAnime = map['isAnime'] as bool?;
    v.isMovie = map['isMovie'] as bool?;
    v.isAdult = map['isAdult'] as bool?;
    v.isUnverified = map['isUnverified'] as bool?;
    v.coverImagePath = map['coverImagePath'] as String?;
    v.description = map['description'] as String?;
    v.bannerImage = map['bannerImage'] as String?;
    v.genres = map['genres'] != null ? List<String>.from(map['genres']) : null;
    v.status = map['status'] as String?;
    v.score = map['score'] as double?;
    v.totalEpisodes = map['totalEpisodes'] as int?;
    v.colorThemeValue = map['colorThemeValue'] as int?;
    v.pipelineIndetificator = map['pipelineIndetificator'] as String?;
    v.isResearchDone = map['isResearchDone'] as bool?;
    v.researchInformation = map['researchInformation'] as String?;
    v.isSubtitleReady = map['isSubtitleReady'] as bool?;
    v.subtitleSource = map['subtitleSource'] as String?;
    v.appliedPaddingMs = map['appliedPaddingMs'] as int?;
    v.appliedFillGaps = map['appliedFillGaps'] as bool?;
    v.audioStatus = map['audioStatus'] as String?;
    v.transcriptionStatus = map['transcriptionStatus'] as String?;
    v.processingProgress = map['processingProgress'] as double?;
    v.transcriptionResumeSeconds = map['transcriptionResumeSeconds'] as int?;
    v.metadataProvider = map['metadataProvider'] as String?;
    v.subtitleMethodUsed = map['subtitleMethodUsed'] as String?;
    v.isCached = map['isCached'] as bool? ?? false;
    v.lastPositionMs = map['lastPositionMs'] as int?;
    v.selectedAudioTrackIndex = map['selectedAudioTrackIndex'] as int?;
    return v;
  }

  // --- Helpers for Phrase ---
  Map<String, dynamic> _phraseToMap(Phrase p) {
    return {
      'videoId': p.videoId,
      'phraseOrder': p.phraseOrder,
      'originalPhrase': p.originalPhrase,
      'translatedPhrase': p.translatedPhrase,
      'startTime': p.startTime?.toIso8601String(),
      'endTime': p.endTime?.toIso8601String(),
      'isActive': p.isActive,
      'stageKeys': p.stageKeys,
      'stageValues': p.stageValues,
      'originalTokens': p.originalTokens?.map((t) => {
        'wordPosition': t.wordPosition,
        'pos': t.pos.name,
        'grammarFunction': t.grammarFunction.name,
        'groupRole': t.groupRole.name,
        'attachMode': t.attachMode.name,
        'headPosition': t.headPosition,
        'linkGroupId': t.linkGroupId,
        'lemma': t.lemma,
        'surface': t.surface,
        'grammarCode': t.grammarCode,
        'relationLabel': t.relationLabel,
        'tense': t.tense.name,
        'aspect': t.aspect.name,
        'polarity': t.polarity.name,
        'politeness': t.politeness.name,
        'modality': t.modality.name,
        'blockId': t.blockId,
        'isClickable': t.isClickable,
        'versions': t.versions.map((v) => {'key': v.key, 'text': v.text}).toList(),
      }).toList(),
      'translatedWords': p.translatedWords?.map((tw) => {
        'blockId': tw.blockId,
        'translatedWordPosition': tw.translatedWordPosition,
        'text': tw.text,
        'isInferred': tw.isInferred,
        'sourceWordPositions': tw.sourceWordPositions,
        'linkGroupId': tw.linkGroupId,
      }).toList(),
      'linkGroups': p.linkGroups?.map((lg) => {
        'groupId': lg.groupId,
        'sourcePositions': lg.sourcePositions,
        'targetPositions': lg.targetPositions,
        'headSourcePosition': lg.headSourcePosition,
        'relatedGroupIds': lg.relatedGroupIds,
        'isIdiom': lg.isIdiom,
      }).toList(),
    };
  }

  Phrase _mapToPhrase(Map<String, dynamic> map, int localVideoId) {
    final p = Phrase();
    p.videoId = localVideoId;
    p.phraseOrder = map['phraseOrder'] as int?;
    p.originalPhrase = map['originalPhrase'] as String?;
    p.translatedPhrase = map['translatedPhrase'] as String?;
    p.startTime = map['startTime'] != null ? DateTime.tryParse(map['startTime']) : null;
    p.endTime = map['endTime'] != null ? DateTime.tryParse(map['endTime']) : null;
    p.isActive = map['isActive'] as bool? ?? false;
    
    if (map['stageKeys'] != null && map['stageValues'] != null) {
      p.stageKeys = List<String>.from(map['stageKeys']);
      p.stageValues = List<String>.from(map['stageValues']);
    }

    p.originalTokens = _parseOriginalTokens(map['originalTokens']);
    p.translatedWords = _parseTranslatedWords(map['translatedWords']);
    p.linkGroups = _parseLinkGroups(map['linkGroups']);
    return p;
  }

  List<TokenEntry>? _parseOriginalTokens(dynamic tokensRaw) {
    if (tokensRaw == null) return null;
    final list = tokensRaw as List<dynamic>;
    return list.map((tRaw) {
      final t = tRaw as Map<String, dynamic>;
      final entry = TokenEntry();
      entry.wordPosition = t['wordPosition'] as int?;
      entry.pos = WordPos.values.byName(t['pos'] as String? ?? 'unknown');
      entry.grammarFunction = GrammarFunction.values.byName(t['grammarFunction'] as String? ?? 'none');
      entry.groupRole = GroupRole.values.byName(t['groupRole'] as String? ?? 'head');
      entry.attachMode = AttachMode.values.byName(t['attachMode'] as String? ?? 'none');
      entry.headPosition = t['headPosition'] as int?;
      entry.linkGroupId = t['linkGroupId'] as int?;
      entry.lemma = t['lemma'] as String?;
      entry.surface = t['surface'] as String?;
      entry.grammarCode = t['grammarCode'] as String?;
      entry.relationLabel = t['relationLabel'] as String?;
      entry.tense = Tense.values.byName(t['tense'] as String? ?? 'none');
      entry.aspect = Aspect.values.byName(t['aspect'] as String? ?? 'none');
      entry.polarity = Polarity.values.byName(t['polarity'] as String? ?? 'affirmative');
      entry.politeness = Politeness.values.byName(t['politeness'] as String? ?? 'plain');
      entry.modality = Modality.values.byName(t['modality'] as String? ?? 'none');
      entry.blockId = t['blockId'] as int?;
      entry.isClickable = t['isClickable'] as bool? ?? true;
      
      if (t['versions'] != null) {
        entry.versions = (t['versions'] as List<dynamic>).map((vRaw) {
          final v = vRaw as Map<String, dynamic>;
          return ReadingItem(key: v['key'] as String?, text: v['text'] as String?);
        }).toList();
      }
      return entry;
    }).toList();
  }

  List<TranslationTokenEntry>? _parseTranslatedWords(dynamic wordsRaw) {
    if (wordsRaw == null) return null;
    final list = wordsRaw as List<dynamic>;
    return list.map((wRaw) {
      final w = wRaw as Map<String, dynamic>;
      final entry = TranslationTokenEntry();
      entry.blockId = w['blockId'] as int?;
      entry.translatedWordPosition = w['translatedWordPosition'] as int?;
      entry.text = w['text'] as String?;
      entry.isInferred = w['isInferred'] as bool? ?? false;
      entry.sourceWordPositions = List<int>.from(w['sourceWordPositions'] ?? []);
      entry.linkGroupId = w['linkGroupId'] as int?;
      return entry;
    }).toList();
  }

  List<LinkGroup>? _parseLinkGroups(dynamic groupsRaw) {
    if (groupsRaw == null) return null;
    final list = groupsRaw as List<dynamic>;
    return list.map((gRaw) {
      final g = gRaw as Map<String, dynamic>;
      final entry = LinkGroup();
      entry.groupId = g['groupId'] as int?;
      entry.sourcePositions = List<int>.from(g['sourcePositions'] ?? []);
      entry.targetPositions = List<int>.from(g['targetPositions'] ?? []);
      entry.headSourcePosition = g['headSourcePosition'] as int?;
      entry.relatedGroupIds = List<int>.from(g['relatedGroupIds'] ?? []);
      entry.isIdiom = g['isIdiom'] as bool? ?? false;
      return entry;
    }).toList();
  }

  // --- Helpers for WordStatus ---
  Map<String, dynamic> _wordStatusToMap(UserWordStatus w) {
    return {
      'lemma': w.lemma,
      'status': w.status.name,
      'updatedAt': w.updatedAt?.toIso8601String(),
    };
  }

  // --- Networking & P2P protocol logic ---
  
  /// Gets local IPv4 addresses
  static Future<List<String>> getLocalIpAddresses() async {
    final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    return interfaces.expand((i) => i.addresses.map((a) => a.address)).toList();
  }

  /// Starts a sync server on the host device
  static Future<ServerSocket> startServer({
    required int port,
    required String localData,
    required Function(String clientData) onDataReceived,
    required Function(String status) onStatusChanged,
  }) async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    onStatusChanged("Listening on port $port...");

    server.listen((Socket client) {
      onStatusChanged("Device connected: ${client.remoteAddress.address}");
      
      List<int> buffer = [];
      client.listen(
        (data) {
          buffer.addAll(data);
        },
        onDone: () async {
          try {
            final receivedStr = utf8.decode(buffer);
            onStatusChanged("Data received, merging databases...");
            
            int? returnPort;
            String actualData = receivedStr;
            try {
              final decoded = jsonDecode(receivedStr);
              if (decoded is Map && decoded.containsKey('returnPort')) {
                returnPort = decoded['returnPort'] as int?;
                actualData = decoded['data'] as String;
              }
            } catch (_) {}

            await onDataReceived(actualData);
            
            if (returnPort != null) {
              onStatusChanged("Syncing back to client...");
              try {
                final returnSocket = await Socket.connect(client.remoteAddress, returnPort, timeout: const Duration(seconds: 5));
                final returnWrapper = jsonEncode({'data': localData});
                returnSocket.write(returnWrapper);
                await returnSocket.flush();
                returnSocket.destroy();
              } catch (e) {
                logger.e("Failed to connect back to client port $returnPort", error: e);
              }
            } else {
              client.write(localData);
              await client.flush();
            }

            onStatusChanged("Sync complete!");
          } catch (e, st) {
            logger.e("Error during sync server processing", error: e, stackTrace: st);
            onStatusChanged("Error during sync: $e");
            try { client.close(); } catch (_) {}
          }
        },
        onError: (e, st) {
          logger.e("Connection error in sync server", error: e, stackTrace: st);
          onStatusChanged("Connection error: $e");
          try { client.close(); } catch (_) {}
        },
      );
    });

    return server;
  }

  /// Connects as a client to the host device
  static Future<void> connectAndSync({
    required String hostIp,
    required int port,
    required String localData,
    required Function(String serverData) onDataReceived,
    required Function(String status) onStatusChanged,
  }) async {
    ServerSocket? clientListener;
    try {
      // 1. Start a temporary local listener on client so host can push back data
      clientListener = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
      final clientPort = clientListener.port;

      onStatusChanged("Connecting to host $hostIp:$port...");
      final socket = await Socket.connect(hostIp, port, timeout: const Duration(seconds: 10));
      
      // Send JSON payload wrapped with return port info
      final payloadWrapper = jsonEncode({
        'returnPort': clientPort,
        'data': localData,
      });

      socket.write(payloadWrapper);
      await socket.flush();
      socket.destroy();
      onStatusChanged("Data sent, waiting for host sync...");

      // 2. Wait for host to connect back with its data
      final completer = Completer<void>();
      clientListener.listen((Socket incoming) {
        List<int> buffer = [];
        incoming.listen(
          (data) => buffer.addAll(data),
          onDone: () async {
            try {
              final serverJson = utf8.decode(buffer);
              // Parse wrapper or direct json
              final parsed = jsonDecode(serverJson);
              final actualData = parsed is Map && parsed.containsKey('data') ? parsed['data'] as String : serverJson;
              
              onStatusChanged("Merging data...");
              await onDataReceived(actualData);
              onStatusChanged("Sync complete!");
              completer.complete();
            } catch (e, st) {
              logger.e("Error processing return sync data", error: e, stackTrace: st);
              completer.completeError(e);
            } finally {
              incoming.close();
            }
          },
        );
      });

      await completer.future.timeout(const Duration(seconds: 15));
    } catch (e, st) {
      logger.e("Sync failed for client to $hostIp:$port", error: e, stackTrace: st);
      onStatusChanged("Sync failed: $e");
      rethrow;
    } finally {
      try {
        await clientListener?.close();
      } catch (_) {}
    }
  }
}
