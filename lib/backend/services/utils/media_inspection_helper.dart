import 'dart:async';
import 'dart:developer' as developer;
import 'package:media_kit/media_kit.dart';
import 'package:eiga/providers/ui/upload/upload_models.dart';

class MediaInspectionResult {
  final List<MediaTrackInfo> audioTracks;
  final List<MediaTrackInfo> subtitleTracks;
  final MediaTrackInfo? selectedAudioTrack;
  final String? resolution;
  final int? videoDuration;
  final String codec;

  MediaInspectionResult({
    required this.audioTracks,
    required this.subtitleTracks,
    this.selectedAudioTrack,
    this.resolution,
    this.videoDuration,
    this.codec = 'H.264',
  });

  @override
  String toString() => 'MediaInspectionResult(audioTracks: ${audioTracks.length}, subtitleTracks: ${subtitleTracks.length}, resolution: $resolution, videoDuration: ${videoDuration}s, codec: $codec)';
}

class MediaInspectionHelper {
  static bool _isInspecting = false;
  static DateTime? _inspectionStartTime;
  static bool get isInspecting => _isInspecting;

  static Future<MediaInspectionResult?> inspectVideo(String path) async {
    developer.log('MediaInspectionHelper [PARAM TRACE]: inspectVideo called with path: "$path", _isInspecting before wait: $_isInspecting', name: 'MediaInspectionHelper');

    // Safety check: if lock is stuck for more than 20 seconds, force release it
    if (_isInspecting && _inspectionStartTime != null) {
      if (DateTime.now().difference(_inspectionStartTime!) > const Duration(seconds: 20)) {
        developer.log('MediaInspectionHelper: inspection lock stuck, forcing release', name: 'MediaInspectionHelper');
        _isInspecting = false;
      }
    }

    int waitAttempts = 0;
    while (_isInspecting && waitAttempts < 100) {
      developer.log('MediaInspectionHelper [PARAM TRACE]: waiting for active inspection to finish, attempt: $waitAttempts', name: 'MediaInspectionHelper');
      await Future.delayed(const Duration(milliseconds: 100));
      waitAttempts++;
    }

    _isInspecting = true;
    _inspectionStartTime = DateTime.now();
    developer.log('MediaInspectionHelper [PARAM TRACE]: lock acquired. _isInspecting: $_isInspecting, startTime: $_inspectionStartTime', name: 'MediaInspectionHelper');

    Player? tempPlayer;
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      tempPlayer = Player();
      developer.log('MediaInspectionHelper [PARAM TRACE]: opening tempPlayer with path: "$path"', name: 'MediaInspectionHelper');
      
      try {
        await tempPlayer.open(Media(path), play: false).timeout(
          const Duration(seconds: 15),
        );
        developer.log('MediaInspectionHelper [PARAM TRACE]: tempPlayer.open finished successfully', name: 'MediaInspectionHelper');
      } catch (e) {
        developer.log('MediaInspectionHelper [PARAM TRACE ERROR]: tempPlayer.open failed or timed out: $e', name: 'MediaInspectionHelper');
      }

      int retry = 0;
      while (retry < 30 && tempPlayer != null) {
        final tracks = tempPlayer.state.tracks;
        final duration = tempPlayer.state.duration;
        developer.log('MediaInspectionHelper [PARAM TRACE]: scanning retry $retry - audio: ${tracks.audio.length}, subtitle: ${tracks.subtitle.length}, duration: $duration', name: 'MediaInspectionHelper');
        
        if ((tracks.audio.isNotEmpty || tracks.subtitle.isNotEmpty) && duration > Duration.zero) {
          break;
        }
        await Future.delayed(const Duration(milliseconds: 150));
        retry++;
      }

      final tracks = tempPlayer.state.tracks;
      final audioTracks = tracks.audio
          .where((t) => t.id != 'auto' && t.id != 'no' && t.id != '')
          .indexed
          .map((e) => MediaTrackInfo(
                id: e.$2.id.toString(),
                title: e.$2.title ?? 'Audio Track ${e.$1 + 1}',
                language: e.$2.language,
                index: e.$1 + 1,
              ))
          .toList();

      final subtitleTracks = tracks.subtitle
          .where((t) => t.id != 'auto' && t.id != 'no' && t.id != '')
          .indexed
          .map((e) => MediaTrackInfo(
                id: e.$2.id.toString(),
                title: e.$2.title ?? 'Subtitle Track ${e.$1 + 1}',
                language: e.$2.language,
                index: e.$1 + 1,
              ))
          .toList();

      for (int i = 0; i < audioTracks.length; i++) {
        developer.log('MediaInspectionHelper [PARAM TRACE]: AudioTrack[$i] -> id: ${audioTracks[i].id}, title: ${audioTracks[i].title}, lang: ${audioTracks[i].language}', name: 'MediaInspectionHelper');
      }
      for (int i = 0; i < subtitleTracks.length; i++) {
        developer.log('MediaInspectionHelper [PARAM TRACE]: SubtitleTrack[$i] -> id: ${subtitleTracks[i].id}, title: ${subtitleTracks[i].title}, lang: ${subtitleTracks[i].language}', name: 'MediaInspectionHelper');
      }

      final height = tempPlayer.state.height;
      final durationS = tempPlayer.state.duration.inSeconds;
      String? resolution = height != null ? (height >= 1080 ? '1080p' : (height >= 720 ? '720p' : '${height}p')) : null;

      developer.log('MediaInspectionHelper [PARAM TRACE]: raw height: $height -> resolved resolution: $resolution, raw duration: ${tempPlayer.state.duration} -> durationS: $durationS', name: 'MediaInspectionHelper');

      final result = MediaInspectionResult(
        audioTracks: audioTracks,
        subtitleTracks: subtitleTracks,
        selectedAudioTrack: audioTracks.isNotEmpty ? audioTracks.first : null,
        resolution: resolution,
        videoDuration: durationS > 0 ? durationS : null,
      );

      developer.log('MediaInspectionHelper [PARAM TRACE]: created $result', name: 'MediaInspectionHelper');
      return result;
    } catch (e, st) {
      developer.log('MediaInspectionHelper [PARAM TRACE ERROR]: exception during inspection: $e\n$st', name: 'MediaInspectionHelper');
      return null;
    } finally {
      if (tempPlayer != null) {
        try {
          await tempPlayer.dispose();
          await Future.delayed(const Duration(milliseconds: 400));
          developer.log('MediaInspectionHelper [PARAM TRACE]: tempPlayer disposed, locks released', name: 'MediaInspectionHelper');
        } catch (_) {}
      }
      _isInspecting = false;
      _inspectionStartTime = null;
      developer.log('MediaInspectionHelper [PARAM TRACE]: lock released. _isInspecting: $_isInspecting', name: 'MediaInspectionHelper');
    }
  }
}
