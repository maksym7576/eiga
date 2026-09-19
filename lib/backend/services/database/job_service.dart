import 'package:isar_community/isar.dart';
import '../../database/schemas/job.dart';

class JobService {
  final Isar isar;

  JobService(this.isar);

  Future<int> saveJob(Job job) async {
    return await isar.writeTxn(() async {
      return await isar.jobs.put(job);
    });
  }

  Future<Job?> getJobById(Id id) async {
    return await isar.jobs.get(id);
  }

  Stream<List<Job>> watchJobsForVideo(int videoId) {
    return isar.jobs
        .where()
        .videoIdEqualTo(videoId)
        .watch(fireImmediately: true);
  }

  Stream<List<Job>> watchAllActiveJobs() {
    return isar.jobs
        .filter()
        .statusEqualTo('active')
        .watch(fireImmediately: true);
  }

  Future<void> updateJob(Job job) async {
    await isar.writeTxn(() async {
      await isar.jobs.put(job);
    });
  }

  Future<void> markActiveJobsAsInterrupted() async {
    await isar.writeTxn(() async {
      final activeJobs = await isar.jobs
          .filter()
          .statusEqualTo('active')
          .findAll();

      for (var job in activeJobs) {
        job.status = 'interrupted';
        job.endTime = DateTime.now();
        job.errorMessage = 'Process interrupted by app close or restart';
      }
      if (activeJobs.isNotEmpty) {
        await isar.jobs.putAll(activeJobs);
      }
    });
  }

  Future<void> deleteJob(Id id) async {
    await isar.writeTxn(() async {
      await isar.jobs.delete(id);
    });
  }

  Future<void> cancelJobsForVideo(int videoId) async {
    await isar.writeTxn(() async {
      final activeJobs = await isar.jobs
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
        await isar.jobs.putAll(activeJobs);
      }
    });
  }
}
