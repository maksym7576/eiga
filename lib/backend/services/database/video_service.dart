import 'dart:io';
import 'package:isar_community/isar.dart';
import '../../database/schemas/video.dart';
import '../../database/schemas/phrase.dart';
import '../../database/schemas/word_index.dart';
import '../cache_service.dart';

class VideoService {
  final Isar isar;
  final CacheService cacheService;

  VideoService(this.isar, this.cacheService);

  Future<Video?> getVideoById(Id id) async {
    return await isar.videos.get(id);
  }

  Stream<Video?> watchVideoById(Id id) {
    return isar.videos.watchObject(id, fireImmediately: true);
  }

  Future<List<Video>> getAllVideos() async {
    return await isar.videos.where().findAll();
  }

  Stream<List<Video>> watchAllVideos() {
    return isar.videos.where().watch(fireImmediately: true);
  }

  Future<void> saveVideo(Video video) async {
    await isar.writeTxn(() async {
      await isar.videos.put(video);
    });
  }

  Future<Id> addVideo(Video video) async {
    video.createdAt = DateTime.now();
    return await isar.writeTxn(() async {
      return await isar.videos.put(video);
    });
  }

  Future<Video?> addVideoAndGet(Video video) async {
    final id = await addVideo(video);
    return await getVideoById(id);
  }

  Future<void> updateVideo(Video video) async {
    await isar.writeTxn(() async {
      await isar.videos.put(video);
    });
  }

  Future<void> updateVideoPosition(Id id, int positionMs) async {
    await isar.writeTxn(() async {
      final video = await isar.videos.get(id);
      if (video != null) {
        video.lastPositionMs = positionMs;
        await isar.videos.put(video);
      }
    });
  }

  Future<void> deleteVideo(Id id) async {
    final video = await isar.videos.get(id);
    if (video == null) return;

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
      await isar.wordIndexs.filter().videoIdEqualTo(id).deleteAll();

      // Delete associated Phrases
      await isar.phrases.filter().videoIdEqualTo(id).deleteAll();

      // Finally delete the video
      await isar.videos.delete(id);
    });
  }

  Future<bool> cacheVideo(Video video) async {
    if (video.videoPath == null || video.isCached) return false;

    try {
      final sourceFile = File(video.videoPath!);
      if (!sourceFile.existsSync()) return false;

      final targetPath = await cacheService.cacheFile(
        sourceFile, 
        CacheType.video,
        preferredName: 'video_${video.id}${sourceFile.path.substring(sourceFile.path.lastIndexOf('.'))}'
      );

      video.videoPath = targetPath;
      video.isCached = true;
      await updateVideo(video);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeVideoCache(Video video) async {
    if (!video.isCached || video.videoPath == null) return;
    try {
      final file = File(video.videoPath!);
      if (file.existsSync()) await file.delete();
      video.isCached = false;
      await updateVideo(video);
    } catch (_) {}
  }
}
