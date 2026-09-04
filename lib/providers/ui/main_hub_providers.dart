import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/providers/database/database_providers.dart';

final allVideosProvider = StreamProvider<List<Video>>((ref) {
  final service = ref.watch(videoServiceProvider);
  return service.watchAllVideos();
});
