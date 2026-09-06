import 'package:isar_community/isar.dart';
import '../schemas/translation_job.dart';

class TranslationJobService {
  final Isar isar;

  TranslationJobService(this.isar);

  Future<int> saveJob(TranslationJob job) async {
    return await isar.writeTxn(() async {
      return await isar.translationJobs.put(job);
    });
  }

  Future<TranslationJob?> getJobById(Id id) async {
    return await isar.translationJobs.get(id);
  }

  Stream<List<TranslationJob>> watchJobsForVideo(int videoId) {
    return isar.translationJobs
        .where()
        .videoIdEqualTo(videoId)
        .watch(fireImmediately: true);
  }

  Future<void> updateJob(TranslationJob job) async {
    await isar.writeTxn(() async {
      await isar.translationJobs.put(job);
    });
  }

  Future<void> deleteJob(Id id) async {
    await isar.writeTxn(() async {
      await isar.translationJobs.delete(id);
    });
  }
}
