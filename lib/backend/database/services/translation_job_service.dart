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

  Stream<List<TranslationJob>> watchAllActiveJobs() {
    return isar.translationJobs
        .filter()
        .statusEqualTo('active')
        .watch(fireImmediately: true);
  }

  Future<void> updateJob(TranslationJob job) async {
    await isar.writeTxn(() async {
      await isar.translationJobs.put(job);
    });
  }

  Future<void> markActiveJobsAsInterrupted() async {
    await isar.writeTxn(() async {
      final activeJobs = await isar.translationJobs
          .filter()
          .statusEqualTo('active')
          .findAll();

      for (var job in activeJobs) {
        job.status = 'interrupted';
        job.endTime = DateTime.now();
        job.errorMessage = 'Process interrupted by app close or restart';
      }
      if (activeJobs.isNotEmpty) {
        await isar.translationJobs.putAll(activeJobs);
      }
    });
  }

  Future<void> deleteJob(Id id) async {
    await isar.writeTxn(() async {
      await isar.translationJobs.delete(id);
    });
  }

  Future<void> cancelJobsForVideo(int videoId) async {
    await isar.writeTxn(() async {
      final activeJobs = await isar.translationJobs
          .filter()
          .videoIdEqualTo(videoId)
          .statusEqualTo('active')
          .findAll();

      for (var job in activeJobs) {
        job.status = 'stopped';
        job.endTime = DateTime.now();
        job.errorMessage = 'Stopped by user';
      }
      if (activeJobs.isNotEmpty) {
        await isar.translationJobs.putAll(activeJobs);
      }
    });
  }
}
