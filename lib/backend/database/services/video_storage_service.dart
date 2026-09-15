import 'dart:io';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../schemas/video.dart';
import '../schemas/phrase.dart';
import '../schemas/word_index.dart';
import 'video_service.dart';

class VideoStorageService {
  final Isar isar;
  final VideoService videoService;

  VideoStorageService(this.isar, this.videoService);

  Future<String> _getVideosDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final videosDir = Directory(p.join(appDir.path, 'videos'));
    if (!videosDir.existsSync()) {
      await videosDir.create(recursive: true);
    }
    return videosDir.path;
  }

  Future<bool> cacheVideo(Video video) async {
    if (video.videoPath == null || video.isCached) return false;

    try {
      final sourceFile = File(video.videoPath!);
      if (!sourceFile.existsSync()) return false;

      final videosDir = await _getVideosDir();
      final extension = p.extension(video.videoPath!);
      final targetPath = p.join(videosDir, 'video_${video.id}$extension');

      await sourceFile.copy(targetPath);

      video.videoPath = targetPath;
      video.isCached = true;
      await videoService.updateVideo(video);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeVideoCache(Video video) async {
    if (!video.isCached || video.videoPath == null) return;

    try {
      final file = File(video.videoPath!);
      if (file.existsSync()) {
        await file.delete();
      }
      video.isCached = false;
      await videoService.updateVideo(video);
    } catch (_) {}
  }

  Future<void> deleteEverything(Video video) async {
    // 1. Remove cached file if exists
    if (video.isCached && video.videoPath != null) {
      try {
        final file = File(video.videoPath!);
        if (file.existsSync()) await file.delete();
      } catch (_) {}
    }

    // 2. Cascade delete from DB
    await isar.writeTxn(() async {
      // Delete associated WordIndex entries
      await isar.wordIndexs.filter().videoIdEqualTo(video.id).deleteAll();

      // Delete associated Phrases
      await isar.phrases.filter().videoIdEqualTo(video.id).deleteAll();

      // Finally delete the video
      await isar.videos.delete(video.id);
    });
  }
}
