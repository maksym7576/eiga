import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../backend/services/database/database_service.dart';
import '../../backend/services/database/ai_model_service.dart';
import '../../backend/services/database/video_service.dart';
import '../../backend/services/database/phrase_service.dart';
import '../../backend/services/database/word_index_service.dart';
import '../../backend/services/database/job_service.dart';
import '../../backend/services/database/known_word_status_service.dart';
import '../../backend/services/audio/audio_sync_service.dart';
import '../../backend/services/cache_service.dart';
import '../database/isar_providers.dart';
import 'ai_services_providers.dart';

final isarServiceProvider = Provider<DatabaseService>((ref) {
  final isar = ref.watch(isarProvider);
  return DatabaseService(isar);
});

final aiModelServiceProvider = Provider<AiModelService>((ref) {
  final isar = ref.watch(isarProvider);
  return AiModelService(isar);
});

final phraseServiceProvider = Provider<PhraseService>((ref) {
  final isar = ref.watch(isarProvider);
  return PhraseService(isar);
});

final wordIndexServiceProvider = Provider<WordIndexService>((ref) {
  final isar = ref.watch(isarProvider);
  return WordIndexService(isar);
});

final videoServiceProvider = Provider<VideoService>((ref) {
  final isar = ref.watch(isarProvider);
  final cacheService = CacheService(); // We could make this a provider too
  return VideoService(isar, cacheService);
});

final jobServiceProvider = Provider<JobService>((ref) {
  final isar = ref.watch(isarProvider);
  return JobService(isar);
});

final knownWordStatusServiceProvider = Provider<KnownWordStatusService>((ref) {
  final isar = ref.watch(isarProvider);
  return KnownWordStatusService(isar);
});

final audioSyncServiceProvider = Provider<AudioSyncService>((ref) {
  return AudioSyncService(ffmpegService: ref.watch(ffmpegServiceProvider));
});
