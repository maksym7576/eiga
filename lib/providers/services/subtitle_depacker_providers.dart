import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../backend/services/depacker_subtitles/subtitle_depacker_service.dart';
import 'database_services_providers.dart';

final subtitleDepackerServiceProvider = Provider<SubtitleDepackerService>((ref) {
  final videoService = ref.watch(videoServiceProvider);
  final phraseService = ref.watch(phraseServiceProvider);
  final languageService = ref.watch(languageServiceProvider);
  
  return SubtitleDepackerService(
    videoService: videoService,
    phraseService: phraseService,
    languageService: languageService,
  );
});
