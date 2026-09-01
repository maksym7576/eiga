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

  Future<void> saveVideo(Video video) async {
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
