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
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'dto_providers.dart';
import 'search_provider.dart';
import 'video_data_providers.dart';

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
  final String? fileName;
  final String? subtitleFileName;
  final String? episode;
  final String? season;
  final List<Phrase> previewPhrases;
  final bool isParsing;
  final bool isSaving;
  final bool isInitialized;

  UploadState({
    this.videoSource = VideoSource.file,
    this.subtitleSource = SubtitleSource.local,
    this.videoPath,
    this.subtitlePath,
    this.fileName,
    this.subtitleFileName,
    this.episode,
    this.season,
    this.previewPhrases = const [],
    this.isParsing = false,
    this.isSaving = false,
    this.isInitialized = false,
  });

  UploadState copyWith({
    VideoSource? videoSource,
    SubtitleSource? subtitleSource,
    String? videoPath,
    String? subtitlePath,
    String? fileName,
    String? subtitleFileName,
    String? episode,
    String? season,
    List<Phrase>? previewPhrases,
    bool? isParsing,
    bool? isSaving,
    bool? isInitialized,
  }) {
    return UploadState(
      videoSource: videoSource ?? this.videoSource,
      subtitleSource: subtitleSource ?? this.subtitleSource,
      videoPath: videoPath ?? this.videoPath,
      subtitlePath: subtitlePath ?? this.subtitlePath,
      fileName: fileName ?? this.fileName,
      subtitleFileName: subtitleFileName ?? this.subtitleFileName,
      episode: episode ?? this.episode,
      season: season ?? this.season,
      previewPhrases: previewPhrases ?? this.previewPhrases,
      isParsing: isParsing ?? this.isParsing,
      isSaving: isSaving ?? this.isSaving,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class UploadNotifier extends Notifier<UploadState> {
  @override
  UploadState build() {
    final tokenAsync = ref.watch(tokenProvider(ApiTokenType.jimaku));
    
    // We only consider it initialized once the token is loaded or failed
    if (tokenAsync.isLoading) {
      return UploadState(isInitialized: false);
    }

    final jimakuToken = tokenAsync.value ?? '';
    final defaultSource = jimakuToken.isNotEmpty ? SubtitleSource.jimaku : SubtitleSource.local;
    
    return UploadState(
      subtitleSource: defaultSource,
      isInitialized: true,
    );
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
    ref.invalidate(playerIdProvider);
    ref.invalidate(playerTimeProvider);
    ref.invalidate(isPlayingProvider);
    
    ref.read(selectedEntryProvider(SearchSourceKeys.jimaku).notifier).state = null;
    ref.read(selectedEntryProvider(SearchSourceKeys.anilist).notifier).state = null;
    ref.read(selectedResultProvider(SearchSourceKeys.jimaku).notifier).state = null;
    ref.read(selectedResultProvider(SearchSourceKeys.anilist).notifier).state = null;
    ref.read(searchResultsProvider(SearchSourceKeys.jimaku).notifier).state = [];
    ref.read(searchResultsProvider(SearchSourceKeys.anilist).notifier).state = [];
    ref.read(searchResultsProvider(SearchSourceKeys.tvmaze).notifier).state = [];
    ref.read(jimakuSearchFullResultsProvider.notifier).state = [];
    ref.read(aniListProvider.notifier).clear();
    ref.read(tvMazeProvider.notifier).clear();
    
    // Explicitly reset search metadata
    ref.invalidate(searchMetadataProvider(SearchSourceKeys.jimaku));
    ref.invalidate(searchMetadataProvider(SearchSourceKeys.anilist));
    
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
          fileName: p.basenameWithoutExtension(path),
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
      subtitleFileName: p.basename(path),
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
    
    final metadataType = ref.read(selectedMetadataProvider);
    UnifiedMetadataDTO? finalMetadata;
    
    // 1. Try to get metadata from specific provider notifier (most reliable source)
    if (metadataType == MetadataProviderType.anilist) {
      finalMetadata = ref.read(aniListProvider).value;
    } else if (metadataType == MetadataProviderType.tvmaze) {
      finalMetadata = ref.read(tvMazeProvider).value;
    } else if (metadataType == MetadataProviderType.shikimori) {
      finalMetadata = ref.read(shikimoriProvider).value;
    }

    // 2. Fallback: Check search cache if enriched (important for Jimaku search results)
    if (finalMetadata == null) {
      final jimakuEntry = ref.read(selectedEntryProvider(SearchSourceKeys.jimaku));
      if (jimakuEntry != null && jimakuEntry is UnifiedMetadataDTO) {
        final jimakuId = int.tryParse(jimakuEntry.sourceId);
        if (jimakuId != null) {
          final cached = ref.read(searchMetadataProvider(SearchSourceKeys.jimaku))[jimakuId];
          if (cached != null && cached is UnifiedMetadataDTO) {
            finalMetadata = cached;
          }
        }
      }
    }
    
    // 3. Last fallback: Check search source selection directly
    if (finalMetadata == null) {
      final key = metadataType == MetadataProviderType.tvmaze 
          ? SearchSourceKeys.tvmaze 
          : (metadataType == MetadataProviderType.shikimori ? SearchSourceKeys.shikimori : SearchSourceKeys.anilist);
      final entry = ref.read(selectedEntryProvider(key));
      if (entry != null && entry is UnifiedMetadataDTO) {
        finalMetadata = entry;
      }
    }

    // 4. If we found metadata, ensure images are downloaded locally before saving
    if (finalMetadata != null) {
      if (finalMetadata.anilistId != null) {
         await ref.read(aniListProvider.notifier).load(finalMetadata.anilistId!, downloadImages: true);
         finalMetadata = ref.read(aniListProvider).value ?? finalMetadata;
      } else if (finalMetadata.tvmazeId != null) {
         await ref.read(tvMazeProvider.notifier).load(finalMetadata.tvmazeId!, downloadImages: true);
         finalMetadata = ref.read(tvMazeProvider).value ?? finalMetadata;
      } else if (finalMetadata.shikimoriId != null) {
         await ref.read(shikimoriProvider.notifier).load(finalMetadata.shikimoriId!, downloadImages: true);
         finalMetadata = ref.read(shikimoriProvider).value ?? finalMetadata;
      }
    }

    final video = Video()
      ..videoPath = state.videoPath
      ..pathSubtitle = state.subtitlePath
      ..fileName = state.fileName
      ..subtitleFileName = state.subtitleFileName
      ..episode = state.episode
      ..season = state.season
      ..originalLanguage = languages.original ?? 'Japanese'
      ..translatedLanguage = languages.target ?? 'Ukrainian'
      ..createdAt = DateTime.now();

    if (finalMetadata != null) {
      video
        ..anilistId = finalMetadata.anilistId
        ..tvmazeId = finalMetadata.tvmazeId
        ..shikimoriId = finalMetadata.shikimoriId
        ..malId = finalMetadata.malId
        ..tmdbId = finalMetadata.tmdbId
        ..imdbId = finalMetadata.imdbId
        ..thetvdbId = finalMetadata.thetvdbId
        ..coverImagePath = finalMetadata.imagePath ?? finalMetadata.imageUrl
        ..bannerImage = finalMetadata.bannerPath ?? finalMetadata.bannerUrl
        ..description = finalMetadata.description
        ..genres = finalMetadata.genres
        ..seriesName = finalMetadata.title
        ..originalName = finalMetadata.originalTitle
        ..colorThemeValue = finalMetadata.colorThemeValue
        ..status = finalMetadata.status
        ..score = finalMetadata.score
        ..totalEpisodes = finalMetadata.episodes
        ..isAnime = finalMetadata.type?.toLowerCase().contains('anime') == true || 
                   metadataType == MetadataProviderType.anilist || 
                   metadataType == MetadataProviderType.shikimori
        ..isMovie = finalMetadata.type?.toLowerCase().contains('movie') == true;
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
