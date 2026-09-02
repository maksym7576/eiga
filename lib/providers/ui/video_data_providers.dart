import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/services/depacker_subtitles/season_episode_info.dart';
import '../services/database_services_providers.dart';

final playerIdProvider = StateProvider<int?>((ref) {
  return null;
});

final playerTimeProvider = StateProvider<Duration>((ref) {
  return Duration.zero;
});

final seasonEpisodeProvider = StateProvider<SeasonEpisodeInfo?>((ref) {
  return null;
});

final currentVideoProvider = FutureProvider<Video?>((ref) async {
  final videoId = ref.watch(playerIdProvider);

  if (videoId == null) {
    return null;
  }

  final videoService = ref.read(videoServiceProvider);
  return await videoService.getVideoById(videoId);
});
