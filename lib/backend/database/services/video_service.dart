import 'package:isar_community/isar.dart';
import '../schemas/video.dart';

class VideoService {
  final Isar isar;

  VideoService(this.isar);

  Future<Video?> getVideoById(Id id) async {
    return await isar.videos.get(id);
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

  Future<void> deleteVideo(Id id) async {
    await isar.writeTxn(() async {
      await isar.videos.delete(id);
    });
  }
}
