import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/database/schemas/translation_job.dart';
import '../services/isar_services_providers.dart';

final allVideosProvider = StreamProvider<List<Video>>((ref) {
  final service = ref.watch(videoServiceProvider);
  return service.watchAllVideos();
});

final activeJobsProvider = StreamProvider<List<TranslationJob>>((ref) {
  final service = ref.watch(translationJobServiceProvider);
  return service.watchAllActiveJobs();
});
