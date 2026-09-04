import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import '../../backend/database/schemas/phrase.dart';
import '../../backend/database/schemas/video.dart';
import '../../backend/services/depacker_subtitles/season_episode_info.dart';
import '../services/database_services_providers.dart';
import '../services/subtitle_depacker_providers.dart';
import '../videoComponentsProvider.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'dto_providers.dart';
import 'search_provider.dart';

import '../services/token_provider.dart';
import '../../config/secure_storage.dart';

final videoPathProvider = StateProvider<String?>((ref) => null);

enum VideoSource { url, youtube, file }
enum SubtitleSource { local, jimaku }

class UploadState {
  final VideoSource videoSource;
  final SubtitleSource subtitleSource;
  final String? videoPath;
  final String? subtitlePath;
  final String? videoName;
  final String? episode;
  final String? season;
  final List<Phrase> previewPhrases;
  final bool isParsing;
  final bool isSaving;

  UploadState({
    this.videoSource = VideoSource.file,
    this.subtitleSource = SubtitleSource.local,
    this.videoPath,
    this.subtitlePath,
    this.videoName,
    this.episode,
    this.season,
    this.previewPhrases = const [],
    this.isParsing = false,
    this.isSaving = false,
  });

  UploadState copyWith({
    VideoSource? videoSource,
    SubtitleSource? subtitleSource,
    String? videoPath,
    String? subtitlePath,
    String? videoName,
    String? episode,
    String? season,
    List<Phrase>? previewPhrases,
    bool? isParsing,
    bool? isSaving,
  }) {
    return UploadState(
      videoSource: videoSource ?? this.videoSource,
      subtitleSource: subtitleSource ?? this.subtitleSource,
      videoPath: videoPath ?? this.videoPath,
      subtitlePath: subtitlePath ?? this.subtitlePath,
      videoName: videoName ?? this.videoName,
      episode: episode ?? this.episode,
      season: season ?? this.season,
      previewPhrases: previewPhrases ?? this.previewPhrases,
      isParsing: isParsing ?? this.isParsing,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class UploadNotifier extends Notifier<UploadState> {
  @override
  UploadState build() {
    final jimakuToken = ref.watch(tokenProvider(ApiTokenType.jimaku)).value ?? '';
    final defaultSource = jimakuToken.isNotEmpty ? SubtitleSource.jimaku : SubtitleSource.local;
    
    return UploadState(subtitleSource: defaultSource);
  }

  void setVideoSource(VideoSource source) {
    state = state.copyWith(videoSource: source);
  }

  void setSubtitleSource(SubtitleSource source) {
    state = state.copyWith(subtitleSource: source);
  }

  void setEpisode(String? episode) {
    state = state.copyWith(episode: episode);
  }

  void setSeason(String? season) {
    state = state.copyWith(season: season);
  }

  void reset() {
    // Reset local state
    state = UploadState(
      subtitleSource: (ref.read(tokenProvider(ApiTokenType.jimaku)).value ?? '').isNotEmpty 
          ? SubtitleSource.jimaku 
          : SubtitleSource.local
    );
    
    // Clear global providers
    ref.invalidate(videoPathProvider);
    ref.read(selectedEntryProvider(SearchSourceKeys.jimaku).notifier).state = null;
    ref.read(selectedEntryProvider(SearchSourceKeys.anilist).notifier).state = null;
    ref.read(selectedResultProvider(SearchSourceKeys.jimaku).notifier).state = null;
    ref.read(selectedResultProvider(SearchSourceKeys.anilist).notifier).state = null;
    ref.read(searchResultsProvider(SearchSourceKeys.jimaku).notifier).state = [];
    ref.read(searchResultsProvider(SearchSourceKeys.anilist).notifier).state = [];
    ref.read(jimakuSearchFullResultsProvider.notifier).state = [];
    ref.read(aniListProvider.notifier).clear();
    
    // Explicitly reset languages
    ref.invalidate(languageProvider);
  }

  Future<void> pickVideo() async {
    // Використовуємо FileType.any, щоб Android відкривав провідник файлів, а не Google Photos
    final result = await FilePicker.pickFiles(type: FileType.any, allowMultiple: false);
    if (result.isNotEmpty) {
      final path = result.first.path;
      if (path != null) {
        // Оновлюємо окремий провайдер для зручності
        ref.read(videoPathProvider.notifier).state = path;

        final info = parseSeasonEpisode(p.basename(path));
        state = state.copyWith(
          videoPath: path,
          videoName: p.basenameWithoutExtension(path),
          season: info.season,
          episode: info.episode,
        );
      }
    }
  }

  Future<void> pickSubtitle() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['srt', 'ass'],
      allowMultiple: false,
    );
    if (result.isNotEmpty) {
      final path = result.first.path;
      if (path != null) {
        handleSubtitleSelected(path);
      }
    }
  }

  Future<void> handleSubtitleSelected(String path, {String? episode, String? season}) async {
    final info = parseSeasonEpisode(p.basename(path));
    
    state = state.copyWith(
      subtitlePath: path,
      isParsing: true,
      previewPhrases: [],
      episode: episode ?? state.episode ?? info.episode,
      season: season ?? state.season ?? info.season,
    );

    final depacker = ref.read(subtitleDepackerServiceProvider);
    try {
      final phrases = await depacker.parseSrtPreview(
        filePath: path,
        language: 'Japanese', 
      );
      state = state.copyWith(previewPhrases: phrases, isParsing: false);
    } catch (e) {
      state = state.copyWith(isParsing: false);
    }
  }

  Future<bool> saveVideo() async {
    final languages = ref.read(languageProvider);
    if (state.videoPath == null || 
        state.subtitlePath == null || 
        languages.original == null || 
        languages.target == null) return false;

    state = state.copyWith(isSaving: true);
    
    // 1. Identify the Anilist ID from any source
    int? targetAnilistId;
    
    // From direct selection
    final anilistData = ref.read(aniListProvider).value;
    if (anilistData != null) {
      targetAnilistId = anilistData.id;
    }
    
    // Or from selected Jimaku entry
    if (targetAnilistId == null) {
      final dynamic jimakuEntry = ref.read(selectedEntryProvider(SearchSourceKeys.jimaku));
      if (jimakuEntry != null && jimakuEntry is JimakuDataDTO) {
        targetAnilistId = jimakuEntry.anilistId;
      }
    }

    // 2. Ensure AniList images are downloaded locally
    String? finalCoverPath;
    if (targetAnilistId != null) {
       // Force reload with image download
       await ref.read(aniListProvider.notifier).load(targetAnilistId, downloadImages: true);
       final updatedData = ref.read(aniListProvider).value;
       // Prefer local path, fallback to URL
       finalCoverPath = updatedData?.coverImagePath ?? updatedData?.coverImageUrl;
    }
    
    final latestAnilistData = ref.read(aniListProvider).value;

    final video = Video()
      ..videoPath = state.videoPath
      ..pathSubtitle = state.subtitlePath
      ..videoName = state.videoName
      ..episode = state.episode
      ..season = state.season
      ..originalLanguage = languages.original ?? 'Japanese'
      ..translatedLanguage = languages.target ?? 'Ukrainian'
      ..createdAt = DateTime.now();

    if (latestAnilistData != null && latestAnilistData.id == targetAnilistId) {
      video.anilistId = latestAnilistData.id;
      video.coverImagePath = finalCoverPath;
      video.description = latestAnilistData.description;
      video.genres = latestAnilistData.genres;
      video.englishName = latestAnilistData.englishTitle;
      video.colorThemeValue = latestAnilistData.colorThemeValue;
    }

    try {
      final videoId = await ref.read(videoServiceProvider).addVideo(video);
      
      final depacker = ref.read(subtitleDepackerServiceProvider);
      await depacker.depack(video..id = videoId);
      
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }
}

final uploadProvider = NotifierProvider.autoDispose<UploadNotifier, UploadState>(
  UploadNotifier.new,
);
