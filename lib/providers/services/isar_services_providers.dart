import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../backend/database/services/isar_service.dart';
import '../../backend/database/services/ai_model_service.dart';
import '../../backend/database/services/video_service.dart';
import '../../backend/database/services/video_storage_service.dart';
import '../../backend/database/services/phrase_service.dart';
import '../../backend/database/services/word_index_service.dart';
import '../../backend/database/services/language_service.dart';
import '../../backend/database/services/specific_word_style_service.dart';
import '../../backend/database/services/translation_job_service.dart';
import '../../backend/database/services/known_word_status_service.dart';
import '../../backend/services/sync/audio_sync_service.dart';
import '../database/isar_providers.dart';
export '../database/isar_providers.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarService(isar);
});

final aiModelServiceProvider = Provider<AiModelService>((ref) {
  final isar = ref.watch(isarProvider);
  return AiModelService(isar);
});

final specificWordStyleServiceProvider = Provider<SpecificWordStyleService>((ref) {
  final isar = ref.watch(isarProvider);
  return SpecificWordStyleService(isar);
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
  return VideoService(isar);
});

final videoStorageServiceProvider = Provider<VideoStorageService>((ref) {
  final isar = ref.watch(isarProvider);
  final videoService = ref.watch(videoServiceProvider);
  return VideoStorageService(isar, videoService);
});

final languageServiceProvider = Provider<LanguageService>((ref) {
  final isar = ref.watch(isarProvider);
  return LanguageService(isar);
});

final translationJobServiceProvider = Provider<TranslationJobService>((ref) {
  final isar = ref.watch(isarProvider);
  return TranslationJobService(isar);
});

final knownWordStatusServiceProvider = Provider<KnownWordStatusService>((ref) {
  final isar = ref.watch(isarProvider);
  return KnownWordStatusService(isar);
});

final audioSyncServiceProvider = Provider<AudioSyncService>((ref) {
  return AudioSyncService();
});
