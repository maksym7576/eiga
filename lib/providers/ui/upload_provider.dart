import 'dart:math';
import 'dart:developer' as developer;
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
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'dto_providers.dart';
import 'search_provider.dart';
import 'video_data_providers.dart';
import '../../backend/services/sync/audio_sync_service.dart';
import '../services/app_configs_provider.dart';

import '../services/token_provider.dart';
import '../../config/secure_storage.dart';

final videoPathProvider = StateProvider<String?>((ref) => null);

enum VideoSource { url, youtube, file }
enum SubtitleSource { local, jimaku, wyzie }
enum SyncMatchStatus { idle, analyzing, perfect, offset, mismatch, error }

class AnalyzedSubtitle {
  final String fileName;
  final String path;
  final double confidence;
  final Duration? offset;
  final List<Phrase> phrases;
  final String? explanation;
  
  final double pnr;
  final double uniqueness;
  final int consensusCount;
  final List<SyncCheckpoint> checkpoints;

  AnalyzedSubtitle({
    required this.fileName,
    required this.path,
    required this.confidence,
    this.offset,
    required this.phrases,
    this.explanation,
    this.pnr = 0.0,
    this.uniqueness = 0.0,
    this.consensusCount = 0,
    this.checkpoints = const [],
  });
}

class UploadState {
  final VideoSource videoSource;
  final SubtitleSource subtitleSource;
  final String? videoPath;
  final int? videoDuration;
  final String? subtitlePath;
  final String? fileName;
  final String? subtitleFileName;
  final String? episode;
  final String? season;
  final List<Phrase> previewPhrases;
  final bool isParsing;
  final bool isSaving;
  final bool isInitialized;

  final bool isCheckingSync;
  final SyncMatchStatus syncStatus;
  final Duration? suggestedOffset;
  final double syncConfidence;
  final bool isWrongEpisodePromptVisible;
  final String? syncExplanation;
  final List<SyncCheckpoint> syncCheckpoints;
  
  final double syncPnr;
  final double syncUniqueness;
  final int syncConsensus;
  final int syncTotalSegments;

  final List<AnalyzedSubtitle> analyzedVersions;
  final bool isEvaluatingBatch;
  final int currentEvaluationIndex;
  final int totalEvaluationCount;

  UploadState({
    this.videoSource = VideoSource.file,
    this.subtitleSource = SubtitleSource.local,
    this.videoPath,
    this.videoDuration,
    this.subtitlePath,
    this.fileName,
    this.subtitleFileName,
    this.episode,
    this.season,
    this.previewPhrases = const [],
    this.isParsing = false,
    this.isSaving = false,
    this.isInitialized = false,
    this.isCheckingSync = false,
    this.syncStatus = SyncMatchStatus.idle,
    this.suggestedOffset,
    this.syncConfidence = 0.0,
    this.isWrongEpisodePromptVisible = false,
    this.syncExplanation,
    this.syncCheckpoints = const [],
    this.syncPnr = 0.0,
    this.syncUniqueness = 0.0,
    this.syncConsensus = 0,
    this.syncTotalSegments = 0,
    this.analyzedVersions = const [],
    this.isEvaluatingBatch = false,
    this.currentEvaluationIndex = 0,
    this.totalEvaluationCount = 0,
  });

  UploadState copyWith({
    VideoSource? videoSource,
    SubtitleSource? subtitleSource,
    String? videoPath,
    int? videoDuration,
    String? subtitlePath,
    String? fileName,
    String? subtitleFileName,
    String? episode,
    String? season,
    List<Phrase>? previewPhrases,
    bool? isParsing,
    bool? isSaving,
    bool? isInitialized,
    bool? isCheckingSync,
    SyncMatchStatus? syncStatus,
    Duration? suggestedOffset,
    double? syncConfidence,
    bool? isWrongEpisodePromptVisible,
    String? syncExplanation,
    List<SyncCheckpoint>? syncCheckpoints,
    double? syncPnr,
    double? syncUniqueness,
    int? syncConsensus,
    int? syncTotalSegments,
    List<AnalyzedSubtitle>? analyzedVersions,
    bool? isEvaluatingBatch,
    int? currentEvaluationIndex,
    int? totalEvaluationCount,
  }) {
    return UploadState(
      videoSource: videoSource ?? this.videoSource,
      subtitleSource: subtitleSource ?? this.subtitleSource,
      videoPath: videoPath ?? this.videoPath,
      videoDuration: videoDuration ?? this.videoDuration,
      subtitlePath: subtitlePath ?? this.subtitlePath,
      fileName: fileName ?? this.fileName,
      subtitleFileName: subtitleFileName ?? this.subtitleFileName,
      episode: episode ?? this.episode,
      season: season ?? this.season,
      previewPhrases: previewPhrases ?? this.previewPhrases,
      isParsing: isParsing ?? this.isParsing,
      isSaving: isSaving ?? this.isSaving,
      isInitialized: isInitialized ?? this.isInitialized,
      isCheckingSync: isCheckingSync ?? this.isCheckingSync,
      syncStatus: syncStatus ?? this.syncStatus,
      suggestedOffset: suggestedOffset ?? this.suggestedOffset,
      syncConfidence: syncConfidence ?? this.syncConfidence,
      isWrongEpisodePromptVisible: isWrongEpisodePromptVisible ?? this.isWrongEpisodePromptVisible,
      syncExplanation: syncExplanation ?? this.syncExplanation,
      syncCheckpoints: syncCheckpoints ?? this.syncCheckpoints,
      syncPnr: syncPnr ?? this.syncPnr,
      syncUniqueness: syncUniqueness ?? this.syncUniqueness,
      syncConsensus: syncConsensus ?? this.syncConsensus,
      syncTotalSegments: syncTotalSegments ?? this.syncTotalSegments,
      analyzedVersions: analyzedVersions ?? this.analyzedVersions,
      isEvaluatingBatch: isEvaluatingBatch ?? this.isEvaluatingBatch,
      currentEvaluationIndex: currentEvaluationIndex ?? this.currentEvaluationIndex,
      totalEvaluationCount: totalEvaluationCount ?? this.totalEvaluationCount,
    );
  }
}

class UploadNotifier extends Notifier<UploadState> {
  @override
  UploadState build() {
    final jimakuTokenAsync = ref.watch(tokenProvider(ApiTokenType.jimaku));
    final wyzieTokenAsync = ref.watch(tokenProvider(ApiTokenType.wyzie));
    
    if (jimakuTokenAsync.isLoading || wyzieTokenAsync.isLoading) {
      return UploadState(isInitialized: false);
    }

    final jimakuToken = jimakuTokenAsync.value ?? '';
    final wyzieToken = wyzieTokenAsync.value ?? '';
    
    SubtitleSource defaultSource = SubtitleSource.local;
    if (jimakuToken.isNotEmpty) {
      defaultSource = SubtitleSource.jimaku;
    } else if (wyzieToken.isNotEmpty) {
      defaultSource = SubtitleSource.wyzie;
    }
    
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
    developer.log('UploadProvider: reset() called from:\n${StackTrace.current}', name: 'UploadProvider');
    
    final jimakuToken = ref.read(tokenProvider(ApiTokenType.jimaku)).value ?? '';
    final wyzieToken = ref.read(tokenProvider(ApiTokenType.wyzie)).value ?? '';
    
    SubtitleSource defaultSource = SubtitleSource.local;
    if (jimakuToken.isNotEmpty) {
      defaultSource = SubtitleSource.jimaku;
    } else if (wyzieToken.isNotEmpty) {
      defaultSource = SubtitleSource.wyzie;
    }

    state = UploadState(
      subtitleSource: defaultSource
    );
    
    ref.invalidate(playerIdProvider);
    ref.invalidate(playerTimeProvider);
    ref.invalidate(isPlayingProvider);
    ref.read(audioSyncServiceProvider).clearCache();
    
    ref.read(selectedEntryProvider(SearchSourceKeys.jimaku).notifier).state = null;
    ref.read(selectedEntryProvider(SearchSourceKeys.wyzie).notifier).state = null;
    ref.read(selectedEntryProvider(SearchSourceKeys.anilist).notifier).state = null;
    ref.read(selectedResultProvider(SearchSourceKeys.jimaku).notifier).state = null;
    ref.read(selectedResultProvider(SearchSourceKeys.wyzie).notifier).state = null;
    ref.read(selectedResultProvider(SearchSourceKeys.anilist).notifier).state = null;
    ref.read(searchResultsProvider(SearchSourceKeys.jimaku).notifier).state = [];
    ref.read(searchResultsProvider(SearchSourceKeys.wyzie).notifier).state = [];
    ref.read(searchResultsProvider(SearchSourceKeys.anilist).notifier).state = [];
    ref.read(searchResultsProvider(SearchSourceKeys.tvmaze).notifier).state = [];
    ref.read(jimakuSearchFullResultsProvider.notifier).state = [];
    ref.read(aniListProvider.notifier).clear();
    ref.read(tvMazeProvider.notifier).clear();
    
    ref.invalidate(searchMetadataProvider(SearchSourceKeys.jimaku));
    ref.invalidate(searchMetadataProvider(SearchSourceKeys.wyzie));
    ref.invalidate(searchMetadataProvider(SearchSourceKeys.anilist));
    ref.invalidate(languageProvider);

    state = state.copyWith(
      analyzedVersions: [], 
      isEvaluatingBatch: false,
      syncPnr: 0.0,
      syncUniqueness: 0.0,
      syncConsensus: 0,
      syncTotalSegments: 0,
      syncExplanation: null,
      syncCheckpoints: [],
    );
  }

  Future<void> pickVideo() async {
    final file = await FilePicker.pickFile(type: FileType.any);
    if (file != null) {
      final path = file.path;
      if (path != null) {
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
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['srt', 'ass'],
    );
    if (file != null) {
      final path = file.path;
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
      checkSynchronization();
    } catch (e) {
      state = state.copyWith(isParsing: false);
    }
  }

  Future<void> checkSynchronization() async {
    if (state.videoPath == null || state.previewPhrases.isEmpty) return;

    developer.log('Triggering synchronization check...', name: 'UploadProvider');
    state = state.copyWith(
      isCheckingSync: true,
      syncStatus: SyncMatchStatus.analyzing,
      isWrongEpisodePromptVisible: false,
    );

    final syncService = ref.read(audioSyncServiceProvider);
    final config = ref.read(appConfigsServiceProvider);
    
    final result = await syncService.analyzeSync(
      videoPath: state.videoPath!,
      phrases: state.previewPhrases,
      skipMinutes: config.getSyncSkipMinutes,
      pointDurationMinutes: config.getSyncPointDurationMinutes,
    );

    SyncMatchStatus finalStatus = SyncMatchStatus.error;
    if (result.type == SyncMatchResultType.perfect) finalStatus = SyncMatchStatus.perfect;
    if (result.type == SyncMatchResultType.offset) finalStatus = SyncMatchStatus.offset;
    if (result.type == SyncMatchResultType.mismatch) finalStatus = SyncMatchStatus.mismatch;

    developer.log('Sync check complete. Status: ${finalStatus.name}, Offset: ${result.offset?.inMilliseconds}ms', name: 'UploadProvider');
    
    // Update the version in the list with the fresh results too
    final updatedVersions = state.analyzedVersions.map((v) {
      if (v.fileName == state.subtitleFileName) {
        return AnalyzedSubtitle(
          fileName: v.fileName,
          path: v.path,
          confidence: result.confidence,
          offset: result.offset,
          phrases: state.previewPhrases,
          explanation: result.explanation,
          pnr: result.pnr,
          uniqueness: result.uniqueness,
          consensusCount: result.consensusCount,
          checkpoints: result.checkpoints,
        );
      }
      return v;
    }).toList();

    state = state.copyWith(
      isCheckingSync: false,
      syncStatus: finalStatus,
      suggestedOffset: result.offset,
      syncConfidence: result.confidence,
      syncExplanation: result.explanation,
      syncCheckpoints: result.checkpoints,
      syncPnr: result.pnr,
      syncUniqueness: result.uniqueness,
      syncConsensus: result.consensusCount,
      syncTotalSegments: max(3, result.consensusCount), 
      analyzedVersions: updatedVersions,
      isWrongEpisodePromptVisible: finalStatus == SyncMatchStatus.mismatch && (state.subtitleSource == SubtitleSource.jimaku || state.subtitleSource == SubtitleSource.wyzie),
    );
  }

  void applySyncFix({Duration? manualOffset}) {
    final offset = manualOffset ?? state.suggestedOffset;
    if (offset == null) return;
    
    final updatedPhrases = state.previewPhrases.map((p) {
      return Phrase(
        videoId: p.videoId,
        phraseOrder: p.phraseOrder,
        originalPhrase: p.originalPhrase,
        translatedPhrase: p.translatedPhrase,
        startTime: p.startTime?.add(offset),
        endTime: p.endTime?.add(offset),
        isTranslated: p.isTranslated,
        isTranslating: p.isTranslating,
        isActive: p.isActive,
        originalTokens: p.originalTokens,
        translatedTokens: p.translatedTokens,
      );
    }).toList();

    state = state.copyWith(
      previewPhrases: updatedPhrases,
      syncStatus: SyncMatchStatus.analyzing,
      suggestedOffset: null,
      syncCheckpoints: [], 
      // Reset the current version's offset in the list so the UI reflects the pending re-analysis
      analyzedVersions: state.analyzedVersions.map((v) {
        if (v.fileName == state.subtitleFileName) {
          return AnalyzedSubtitle(
            fileName: v.fileName,
            path: v.path,
            confidence: v.confidence,
            offset: Duration.zero, // Temporary zero to hide button
            phrases: updatedPhrases,
            explanation: v.explanation,
            pnr: v.pnr,
            uniqueness: v.uniqueness,
            consensusCount: v.consensusCount,
            checkpoints: [],
          );
        }
        return v;
      }).toList(),
    );

    // Re-verify synchronization after applying fix
    checkSynchronization();
  }

  void shiftAllPhrases(Duration offset) {
    final updatedPhrases = state.previewPhrases.map((p) {
      return Phrase(
        videoId: p.videoId,
        phraseOrder: p.phraseOrder,
        originalPhrase: p.originalPhrase,
        translatedPhrase: p.translatedPhrase,
        startTime: p.startTime?.add(offset),
        endTime: p.endTime?.add(offset),
        isTranslated: p.isTranslated,
        isTranslating: p.isTranslating,
        isActive: p.isActive,
        originalTokens: p.originalTokens,
        translatedTokens: p.translatedTokens,
      );
    }).toList();

    state = state.copyWith(
      previewPhrases: updatedPhrases,
      syncStatus: SyncMatchStatus.analyzing,
      syncCheckpoints: [],
      analyzedVersions: state.analyzedVersions.map((v) {
        if (v.fileName == state.subtitleFileName) {
          return AnalyzedSubtitle(
            fileName: v.fileName,
            path: v.path,
            confidence: v.confidence,
            offset: Duration.zero,
            phrases: updatedPhrases,
            explanation: v.explanation,
            pnr: v.pnr,
            uniqueness: v.uniqueness,
            consensusCount: v.consensusCount,
            checkpoints: [],
          );
        }
        return v;
      }).toList(),
    );

    checkSynchronization();
  }

  void selectVersion(AnalyzedSubtitle version) {
    state = state.copyWith(
      subtitlePath: version.path,
      subtitleFileName: version.fileName,
      previewPhrases: version.phrases,
      syncStatus: version.confidence > 0.4 
          ? (version.offset!.inMilliseconds.abs() < 250 ? SyncMatchStatus.perfect : SyncMatchStatus.offset)
          : SyncMatchStatus.mismatch,
      suggestedOffset: version.offset,
      syncConfidence: version.confidence,
      syncExplanation: version.explanation,
      syncCheckpoints: version.checkpoints,
      syncPnr: version.pnr,
      syncUniqueness: version.uniqueness,
      syncConsensus: version.consensusCount,
      syncTotalSegments: state.syncTotalSegments,
    );
  }

  Future<void> evaluateAllEpisodeSubtitles() async {
    final isJimaku = state.subtitleSource == SubtitleSource.jimaku;
    final sourceKey = isJimaku ? SearchSourceKeys.jimaku : SearchSourceKeys.wyzie;
    final entry = ref.read(selectedEntryProvider(sourceKey)) as UnifiedMetadataDTO?;
    if (entry == null || state.episode == null || state.videoPath == null) return;

    state = state.copyWith(
      isEvaluatingBatch: true,
      analyzedVersions: [],
      syncStatus: SyncMatchStatus.analyzing,
    );

    try {
      final syncService = ref.read(audioSyncServiceProvider);
      final config = ref.read(appConfigsServiceProvider);
      developer.log('Pre-heating voice maps for video...', name: 'UploadProvider');
      await syncService.preheatVoiceMaps(state.videoPath!);

      final id = entry.sourceId;
      final episodeInt = int.tryParse(state.episode ?? '');
      List<FileJimakuDTO> rawFiles = [];
      
      try {
        if (isJimaku) {
          final service = await ref.read(jimakuServiceProvider.future);
          final idInt = int.tryParse(id);
          if (idInt != null) {
            rawFiles = await service.getFiles(idInt, episode: episodeInt);
          }
        } else {
          final service = await ref.read(wyzieServiceProvider.future);
          rawFiles = await service.getFiles(id, episode: episodeInt);
        }
      } catch (e) {
        developer.log('Episode-specific fetch failed, falling back to all files: $e', name: 'UploadProvider');
        if (isJimaku) {
          final service = await ref.read(jimakuServiceProvider.future);
          final idInt = int.tryParse(id);
          if (idInt != null) {
            rawFiles = await service.getFiles(idInt);
          }
        } else {
          final service = await ref.read(wyzieServiceProvider.future);
          rawFiles = await service.getFiles(id);
        }
      }

      final targetEpInt = int.tryParse(state.episode ?? '');
      final List<FileJimakuDTO> episodeFiles = rawFiles.where((f) {
        final parsedInfo = parseSeasonEpisode(f.name);
        if (parsedInfo.episode == null) return false;
        final parsedEpInt = int.tryParse(parsedInfo.episode!);
        return parsedEpInt != null && parsedEpInt == targetEpInt;
      }).toList();

      if (episodeFiles.isEmpty) {
        state = state.copyWith(isEvaluatingBatch: false, syncStatus: SyncMatchStatus.mismatch);
        return;
      }

      state = state.copyWith(totalEvaluationCount: episodeFiles.length);
      final List<AnalyzedSubtitle> analyzed = [];

      for (int i = 0; i < episodeFiles.length; i++) {
        state = state.copyWith(currentEvaluationIndex: i + 1);
        final file = episodeFiles[i];
        
        try {
          developer.log('Batch sync: Evaluating ${file.name}', name: 'UploadProvider');
          final path = isJimaku
              ? await (await ref.read(jimakuServiceProvider.future)).downloadAndCacheFile(file.url, preferredName: file.name)
              : await (await ref.read(wyzieServiceProvider.future)).downloadAndCacheFile(file.url, preferredName: file.name);
          
          final depacker = ref.read(subtitleDepackerServiceProvider);
          final phrases = await depacker.parseSrtPreview(filePath: path, language: 'Japanese');
          final result = await syncService.analyzeSync(
            videoPath: state.videoPath!, 
            phrases: phrases,
            skipMinutes: config.getSyncSkipMinutes,
            pointDurationMinutes: config.getSyncPointDurationMinutes,
          );

          analyzed.add(AnalyzedSubtitle(
            fileName: file.name,
            path: path,
            confidence: result.confidence,
            offset: result.offset,
            phrases: phrases,
            explanation: result.explanation,
            pnr: result.pnr,
            uniqueness: result.uniqueness,
            consensusCount: result.consensusCount,
            checkpoints: result.checkpoints,
          ));
          
          state = state.copyWith(
            analyzedVersions: List.from(analyzed),
            syncTotalSegments: result.consensusCount > state.syncTotalSegments ? result.consensusCount : state.syncTotalSegments,
          );
        } catch (e) {
          developer.log('Failed to analyze ${file.name}: $e', name: 'UploadProvider');
        }
      }

      analyzed.sort((a, b) => b.confidence.compareTo(a.confidence));
      final best = analyzed.isNotEmpty ? analyzed.first : null;

      final newState = state.copyWith(
        analyzedVersions: List.from(analyzed),
        isEvaluatingBatch: false,
        isWrongEpisodePromptVisible: (analyzed.isEmpty || (best != null && best.confidence < 0.4)) && (state.subtitleSource == SubtitleSource.jimaku || state.subtitleSource == SubtitleSource.wyzie),
        subtitlePath: best?.path ?? state.subtitlePath,
        subtitleFileName: best?.fileName ?? state.subtitleFileName,
        previewPhrases: best?.phrases ?? state.previewPhrases,
        syncStatus: (best != null && best.confidence > 0.4) 
            ? (best.offset!.inMilliseconds.abs() < 250 ? SyncMatchStatus.perfect : SyncMatchStatus.offset)
            : (analyzed.isEmpty ? SyncMatchStatus.error : SyncMatchStatus.mismatch),
        suggestedOffset: best?.offset,
        syncConfidence: best?.confidence ?? 0.0,
        syncExplanation: best?.explanation,
        syncCheckpoints: best?.checkpoints ?? [],
        syncPnr: best?.pnr ?? 0.0,
        syncUniqueness: best?.uniqueness ?? 0.0,
        syncConsensus: best?.consensusCount ?? 0,
        syncTotalSegments: state.syncTotalSegments,
      );
      
      state = newState;
    } catch (e, st) {
      developer.log('Batch evaluation error: $e', name: 'UploadProvider', error: e, stackTrace: st);
      state = state.copyWith(
        isEvaluatingBatch: false, 
        syncStatus: SyncMatchStatus.error,
        analyzedVersions: state.analyzedVersions.isEmpty ? [] : state.analyzedVersions,
      );
    }
  }

  @Deprecated('Use evaluateAllEpisodeSubtitles instead')
  Future<void> autoTryAlternativeJimakuSubtitles() async {
    await evaluateAllEpisodeSubtitles();
  }

  Future<bool> saveVideo() async {
    final languages = ref.read(languageProvider);
    if (state.videoPath == null || 
        state.subtitlePath == null || 
        languages.original == null || 
        languages.target == null) {
      return false;
    }

    state = state.copyWith(isSaving: true);
    final metadataType = ref.read(selectedMetadataProvider);
    UnifiedMetadataDTO? finalMetadata;
    
    if (metadataType == MetadataProviderType.anilist) {
      finalMetadata = ref.read(aniListProvider).value;
    } else if (metadataType == MetadataProviderType.tvmaze) {
      finalMetadata = ref.read(tvMazeProvider).value;
    } else if (metadataType == MetadataProviderType.shikimori) {
      finalMetadata = ref.read(shikimoriProvider).value;
    }

    if (finalMetadata == null) {
      final jimakuEntry = ref.read(selectedEntryProvider(SearchSourceKeys.jimaku));
      final wyzieEntry = ref.read(selectedEntryProvider(SearchSourceKeys.wyzie));
      if (jimakuEntry != null && jimakuEntry is UnifiedMetadataDTO) {
        final jimakuId = int.tryParse(jimakuEntry.sourceId);
        if (jimakuId != null) {
          final cached = ref.read(searchMetadataProvider(SearchSourceKeys.jimaku))[jimakuId];
          if (cached != null && cached is UnifiedMetadataDTO) finalMetadata = cached;
        }
      } else if (wyzieEntry != null && wyzieEntry is UnifiedMetadataDTO) {
        final wyzieId = int.tryParse(wyzieEntry.sourceId);
        if (wyzieId != null) {
          final cached = ref.read(searchMetadataProvider(SearchSourceKeys.wyzie))[wyzieId];
          if (cached != null && cached is UnifiedMetadataDTO) finalMetadata = cached;
        }
      }
    }
    
    if (finalMetadata == null) {
      final key = metadataType == MetadataProviderType.tvmaze 
          ? SearchSourceKeys.tvmaze 
          : (metadataType == MetadataProviderType.shikimori ? SearchSourceKeys.shikimori : SearchSourceKeys.anilist);
      final entry = ref.read(selectedEntryProvider(key));
      if (entry != null && entry is UnifiedMetadataDTO) finalMetadata = entry;
    }

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
      await depacker.depack(video..id = videoId, preParsedPhrases: state.previewPhrases);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }
}

final uploadProvider = NotifierProvider<UploadNotifier, UploadState>(
  UploadNotifier.new,
);
