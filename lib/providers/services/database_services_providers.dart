import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../backend/database/services/video_service.dart';
import '../../backend/database/services/phrase_service.dart';
import '../../backend/database/services/word_service.dart';
import '../../backend/database/services/block_service.dart';
import '../../backend/database/services/language_service.dart';
import '../../backend/database/services/specific_word_style_service.dart';
import '../../backend/database/services/translation_job_service.dart';
import '../database/database_providers.dart';
import '../database/database_providers.dart';

final videoServiceProvider = Provider<VideoService>((ref) {
  final isar = ref.watch(isarProvider);
  return VideoService(isar);
});

final specificWordStyleServiceProvider = Provider<SpecificWordStyleService>((ref) {
  final isar = ref.watch(isarProvider);
  return SpecificWordStyleService(isar);
});

final phraseServiceProvider = Provider<PhraseService>((ref) {
  final isar = ref.watch(isarProvider);
  return PhraseService(isar);
});

final wordServiceProvider = Provider<WordService>((ref) {
  final isar = ref.watch(isarProvider);
  return WordService(isar);
});

final blockServiceProvider = Provider<BlockService>((ref) {
  final isar = ref.watch(isarProvider);
  return BlockService(isar);
});

final languageServiceProvider = Provider<LanguageService>((ref) {
  final isar = ref.watch(isarProvider);
  return LanguageService(isar);
});

final translationJobServiceProvider = Provider<TranslationJobService>((ref) {
  final isar = ref.watch(isarProvider);
  return TranslationJobService(isar);
});
