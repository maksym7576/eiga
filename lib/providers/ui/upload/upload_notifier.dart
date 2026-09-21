import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:ffmpeg_kit_flutter_new_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_audio/return_code.dart';
import 'package:path/path.dart' as p;
import 'package:eiga/config/secure_storage.dart';
import 'package:eiga/backend/database/schemas/phrase.dart';
import 'package:eiga/backend/database/schemas/video.dart';
import 'package:eiga/backend/services/depacker_subtitles/season_episode_info.dart';
import 'package:eiga/backend/database/dto/media_dto.dart';
import 'package:eiga/backend/database/dto/jimaku_file_dto.dart';
import 'package:eiga/backend/services/audio/audio_sync_service.dart';
import 'package:eiga/backend/services/background/translation_background_manager.dart';
import 'package:eiga/providers/ui/player_provider.dart';
import 'package:eiga/providers/services/isar_services_providers.dart';
import 'package:eiga/providers/services/subtitle_depacker_providers.dart';
import 'package:eiga/providers/services/external_api_providers.dart';
import 'package:eiga/providers/services/app_configs_provider.dart';
import 'package:eiga/providers/services/token_provider.dart';
import 'package:eiga/providers/ui/upload/upload_models.dart';
import 'package:eiga/providers/ui/upload/video_path_provider.dart';
import 'package:eiga/providers/ui/language_provider.dart';
import 'package:eiga/providers/ui/metadata_state_provider.dart';
import 'package:eiga/providers/ui/search_provider.dart';
import 'package:eiga/providers/ui/video_data_providers.dart';
import 'package:eiga/ui/widgets/search/cloud/cloud_subtitle_source.dart';

import '../../../config/languages/language_hub.dart';

class UploadNotifier extends Notifier<UploadState> {
  @override
  UploadState build() {
    final jimakuTokenAsync = ref.watch(tokenProvider(ApiTokenType.jimaku));
    if (jimakuTokenAsync.isLoading) return UploadState(isInitialized: false);
    final jimakuToken = jimakuTokenAsync.value ?? '';
    SubtitleSource defaultSource = jimakuToken.isNotEmpty ? SubtitleSource.jimaku : SubtitleSource.local;
    return UploadState(subtitleSource: defaultSource, subtitleMethod: SubtitleMethod.quick, isInitialized: true);
  }

  void setVideoSource(VideoSource source) => state = state.copyWith(videoSource: source);
  void setSubtitleSource(SubtitleSource source) {
    state = state.copyWith(subtitleSource: source);
    if (source == SubtitleSource.none) {
      clearActiveSelection();
      state = state.copyWith(subtitleMethod: SubtitleMethod.manual);
    }
  }
  void setSubtitleMethod(SubtitleMethod method) {
    state = state.copyWith(subtitleMethod: method);
    // Якщо вже вибрано епізод і ми перейшли на AI scan або Quick match, автоматично запускаємо підбір
    if (state.episode != null && state.videoPath != null) {
      if (method == SubtitleMethod.quick) {
        runQuickMatch(state.episode!);
      } else if (method == SubtitleMethod.ai_scan) {
        runAiBatchMatch(state.episode!);
      }
    }
  }
  void setFileName(String? name) {
    state = state.copyWith(fileName: name);
    clearAllSubtitleSelections();
  }
  void setAiTranscriptionLanguage(String? lang) => state = state.copyWith(aiTranscriptionLanguage: lang);
  void setEpisode(String? episode) {
    state = state.copyWith(episode: episode);
    // Автоматично запускаємо підбір / швидкий пошук при зміні епізоду
    if (episode != null) {
      if (state.subtitleMethod == SubtitleMethod.quick) {
        runQuickMatch(episode);
      } else if (state.subtitleMethod == SubtitleMethod.ai_scan) {
        runAiBatchMatch(episode);
      }
    }
  }
  void clearAllSubtitleSelections() {
    state = state.copyWith(
      manualSelection: null,
      quickSelection: null,
      aiSelection: null,
      videoSelection: null,
      selectedOriginalSubtitle: null,
      syncStatus: SyncMatchStatus.idle,
      syncConfidence: 0.0,
      suggestedOffset: null,
    );
  }
  void setStepIndex(int index) {
    state = state.copyWith(currentStepIndex: index);
    
    // Зупиняємо відео в preview плеєрі, коли переходимо з першого кроку далі
    if (index > 0) {
      try {
        ref.read(playerProvider('preview')).player?.pause();
      } catch (_) {}
    }
    
    // Auto-match on Step 3 (index 2) if possible
    if (index == 2 && state.episode != null && state.activeSelection == null) {
      if (state.subtitleMethod == SubtitleMethod.quick) {
        runQuickMatch(state.episode!);
      } else if (state.subtitleMethod == SubtitleMethod.ai_scan) {
        runAiBatchMatch(state.episode!);
      }
    }
  }

  void clearActiveSelection() {
    switch (state.subtitleMethod) {
      case SubtitleMethod.manual: state = state.copyWith(manualSelection: null); break;
      case SubtitleMethod.quick: state = state.copyWith(quickSelection: null); break;
      case SubtitleMethod.ai_scan: state = state.copyWith(aiSelection: null); break;
      case SubtitleMethod.video: state = state.copyWith(videoSelection: null, selectedOriginalSubtitle: null); break;
    }
  }

  void setCoverSourceMode(CoverSourceMode mode) {
    state = state.copyWith(coverSourceMode: mode);
    if (mode == CoverSourceMode.video && state.videoPath != null) {
      _extractCoverFromVideo();
    }
  }

  Future<void> pickManualCover() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file != null && file.path != null) {
      state = state.copyWith(manualCoverPath: file.path, coverSourceMode: CoverSourceMode.device);
    }
  }

  Future<void> _extractCoverFromVideo() async {
    if (state.videoPath == null) return;
    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = p.join(tempDir.path, 'cover_${DateTime.now().millisecondsSinceEpoch}.jpg');
      final session = await FFmpegKit.execute('-ss 00:00:02 -i "${state.videoPath}" -vframes 1 "$outputPath" -y');
      if (ReturnCode.isSuccess(await session.getReturnCode())) {
        state = state.copyWith(manualCoverPath: outputPath);
      }
    } catch (_) {}
  }

  void reset() {
    final jimakuToken = ref.read(tokenProvider(ApiTokenType.jimaku)).value ?? '';
    SubtitleSource defaultSource = jimakuToken.isNotEmpty ? SubtitleSource.jimaku : SubtitleSource.local;
    state = UploadState(subtitleSource: defaultSource, subtitleMethod: SubtitleMethod.quick, isInitialized: true);
    ref.invalidate(playerIdProvider);
    ref.read(audioSyncServiceProvider).clearCache();
    ref.read(selectedEntryProvider(SearchSourceKeys.jimaku).notifier).state = null;
    ref.read(selectedEntryProvider(SearchSourceKeys.anilist).notifier).state = null;
    ref.read(jimakuSearchFullResultsProvider.notifier).state = [];
    ref.read(aniListProvider.notifier).clear();
    ref.read(languageProvider.notifier).reset();
  }

  Future<void> pickVideo() async {
    final file = await FilePicker.pickFile(type: FileType.any);
    if (file != null && file.path != null) {
      final path = file.path!;
      final fileStat = File(path).statSync();
      final sizeMb = (fileStat.size / (1024 * 1024)).toStringAsFixed(1);
      ref.read(videoPathProvider.notifier).state = path;
      
      final baseName = p.basename(path);
      final info = parseSeasonEpisode(baseName);
      
      // Clean title for search: remove [Group], (Resolution), .ext, and episode markers
      String cleanTitle = p.basenameWithoutExtension(baseName);
      cleanTitle = cleanTitle.replaceAll(RegExp(r'\[.*?\]|\(.*?\)', caseSensitive: false), ' ');
      cleanTitle = cleanTitle.replaceAll(RegExp(r'[\s\-_.]+(episode|ep|e|part)[\s\-_.]*\d+([\s\-_.]|$)', caseSensitive: false), ' ');
      cleanTitle = cleanTitle.replaceAll(RegExp(r'\s-\s\d+([\s\-_.]|$)', caseSensitive: false), ' ');
      cleanTitle = cleanTitle.replaceAll(RegExp(r'\s[sS]\d+[eE]\d+', caseSensitive: false), ' ');
      cleanTitle = cleanTitle.replaceAll(RegExp(r'(1080p|720p|480p|2160p|4k|x264|x265|hevc|h264|h265|bluray|bdrip|webrip|web-dl|dual-audio|multi-sub|subbed|dubbed|uncensored|eng sub|ua sub)', caseSensitive: false), ' ');
      cleanTitle = cleanTitle.replaceAll(RegExp(r'[_.\-]'), ' ');
      cleanTitle = cleanTitle.trim().replaceAll(RegExp(r'\s+'), ' ');
      
      state = state.copyWith(
        videoPath: path, 
        fileName: cleanTitle.isNotEmpty ? cleanTitle : p.basenameWithoutExtension(path), 
        season: info.season, 
        episode: info.episode, 
        fileSize: '$sizeMb MB', 
        isParsing: true
      );

      final tempPlayer = Player();
      try {
        await tempPlayer.open(Media(path), play: false);
        int retry = 0;
        while (retry < 25) {
          final tracks = tempPlayer.state.tracks;
          if (tracks.audio.isNotEmpty || tracks.subtitle.isNotEmpty) {
            await Future.delayed(const Duration(milliseconds: 500));
            break;
          }
          await Future.delayed(const Duration(milliseconds: 200));
          retry++;
        }
        final tracks = tempPlayer.state.tracks;
        final audioTracks = tracks.audio.where((t) => t.id != 'auto' && t.id != 'no').indexed.map((e) => MediaTrackInfo(id: e.$2.id, title: e.$2.title, language: e.$2.language, index: e.$1)).toList();
        final subtitleTracks = tracks.subtitle.where((t) => t.id != 'auto' && t.id != 'no').indexed.map((e) => MediaTrackInfo(id: e.$2.id, title: e.$2.title, language: e.$2.language, index: e.$1)).toList();
        
        // Автовизначення мови за назвою аудіо або субтитрів відео
        for (var sub in subtitleTracks) {
          final langCode = (sub.language ?? '').toLowerCase();
          final title = (sub.title ?? '').toLowerCase();
          for (var lang in LanguageHub.all) {
            if (langCode == lang.code.toLowerCase() || title.contains(lang.name.toLowerCase()) || title.contains(lang.code.toLowerCase())) {
              ref.read(languageProvider.notifier).setOriginal(lang.name);
              break;
            }
          }
          if (ref.read(languageProvider).original != null) break;
        }
        final height = tempPlayer.state.height;
        String? resolution = height != null ? (height >= 1080 ? '1080p' : (height >= 720 ? '720p' : '${height}p')) : null;
        state = state.copyWith(audioTracks: audioTracks, subtitleTracks: subtitleTracks, selectedAudioTrack: audioTracks.isNotEmpty ? audioTracks.first : null, resolution: resolution, codec: 'H.264', isParsing: false);
      } finally {
        await tempPlayer.dispose();
      }
    }
  }

  void selectAudioTrack(MediaTrackInfo track) {
    state = state.copyWith(selectedAudioTrack: track);
    // Миттєво застосовуємо вибір аудіодоріжки до плеєра прев'ю, якщо він вже ініціалізований
    try {
      final previewPlayer = ref.read(playerProvider('preview').notifier);
      previewPlayer.setAudioTrack(track.id);
    } catch (_) {}
  }

  Future<void> selectOriginalSubtitle(MediaTrackInfo? track, {String? language}) async {
    if (track == null) {
      state = state.copyWith(selectedOriginalSubtitle: null, videoSelection: null);
      return;
    }
    state = state.copyWith(selectedOriginalSubtitle: track, isParsing: true, subtitleMethod: SubtitleMethod.video);
    try {
      final extractedPath = await _extractSubtitle(track);
      if (extractedPath != null) {
        final phrases = await _parsePhrases(extractedPath);
        final analyzed = AnalyzedSubtitle(fileName: track.title ?? 'Video Track ${track.index}', path: extractedPath, confidence: 0.0, phrases: phrases);
        state = state.copyWith(videoSelection: analyzed);
        if (language != null) ref.read(languageProvider.notifier).setOriginal(language);
      }
    } finally {
      state = state.copyWith(isParsing: false);
    }
  }

  Future<void> selectTranslationSubtitle(MediaTrackInfo? track, {String? language}) async {
    if (track == null) {
      state = state.copyWith(selectedTranslationSubtitle: null, translationSubtitlePath: null);
      return;
    }
    state = state.copyWith(selectedTranslationSubtitle: track, isParsing: true);
    try {
      final extractedPath = await _extractSubtitle(track);
      if (extractedPath != null) {
        state = state.copyWith(translationSubtitlePath: extractedPath);
        if (language != null) ref.read(languageProvider.notifier).setTarget(language);
      }
    } finally {
      state = state.copyWith(isParsing: false);
    }
  }

  Future<List<Phrase>> _parsePhrases(String path) async {
    final languages = ref.read(languageProvider);
    final depacker = ref.read(subtitleDepackerServiceProvider);
    return await depacker.parseSrtPreview(filePath: path, language: languages.original ?? 'Japanese');
  }

  Future<void> pickSubtitle() async {
    final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: ['srt', 'ass']);
    if (file != null && file.path != null) {
      await handleSubtitleSelected(file.path!, source: SubtitleSource.local);
    }
  }

  Future<void> selectManual(FileJimakuDTO file) async {
    state = state.copyWith(isParsing: true);
    try {
      final service = await ref.read(jimakuServiceProvider.future);
      final path = await service.downloadAndCacheFile(file.url, preferredName: file.name);
      await handleSubtitleSelected(path, source: SubtitleSource.jimaku);
    } catch (e) { 
      state = state.copyWith(isParsing: false); 
    }
  }

  Future<void> runQuickMatch(String episode) async {
    final entry = _getActiveEntry();
    if (entry == null || state.videoPath == null) return;
    state = state.copyWith(isParsing: true, episode: episode);
    try {
      final source = CloudSubtitleSource(SearchSourceKeys.jimaku);
      final bestFile = await source.findBestFile(entry, ref, targetEpisode: episode);
      
      if (bestFile != null) {
        final path = await source.resolve(JimakuFileOrGroupDTO(file: bestFile), ref);
        final phrases = await _parsePhrases(path);
        state = state.copyWith(
          quickSelection: AnalyzedSubtitle(fileName: bestFile.name, path: path, confidence: 0.0, phrases: phrases),
          isParsing: false,
        );
      } else {
        state = state.copyWith(isParsing: false, quickSelection: null);
      }
    } catch (e) {
      state = state.copyWith(isParsing: false);
    }
  }

  Future<void> runAiBatchMatch(String episode) async {
    final entry = _getActiveEntry();
    if (entry == null || state.videoPath == null) return;
    state = state.copyWith(episode: episode);
    await evaluateAllEpisodeSubtitles();
  }

  UnifiedMetadataDTO? _getActiveEntry() {
    return (ref.read(selectedEntryProvider(SearchSourceKeys.jimaku)) ?? ref.read(selectedEntryProvider(SearchSourceKeys.anilist)) ?? ref.read(selectedEntryProvider(SearchSourceKeys.tvmaze)) ?? ref.read(selectedEntryProvider(SearchSourceKeys.shikimori))) as UnifiedMetadataDTO?;
  }

  Future<void> checkCurrentSync() async {
    if (state.videoPath == null || state.previewPhrases.isEmpty || state.isCheckingSync) return;
    state = state.copyWith(isCheckingSync: true, syncStatus: SyncMatchStatus.analyzing);
    try {
      final result = await ref.read(audioSyncServiceProvider).analyzeSync(
          videoPath: state.videoPath!,
          phrases: state.previewPhrases,
          skipMinutes: ref.read(appConfigsServiceProvider).getSyncSkipMinutes,
          pointDurationMinutes: ref.read(appConfigsServiceProvider).getSyncPointDurationMinutes);
      final updatedSelection = _updateCurrentSelectionWithResult(result);
      state = state.copyWith(
          isCheckingSync: false,
          syncStatus: _mapResultType(result.type),
          suggestedOffset: result.offset,
          syncConfidence: result.confidence,
          syncExplanation: result.explanation,
          syncCheckpoints: result.checkpoints,
          syncPnr: result.pnr,
          syncUniqueness: result.uniqueness,
          syncConsensus: result.consensusCount,
          syncTotalSegments: result.totalSegments,
          manualSelection: state.subtitleMethod == SubtitleMethod.manual ? updatedSelection : state.manualSelection,
          quickSelection: state.subtitleMethod == SubtitleMethod.quick ? updatedSelection : state.quickSelection,
          aiSelection: state.subtitleMethod == SubtitleMethod.ai_scan ? updatedSelection : state.aiSelection,
          videoSelection: state.subtitleMethod == SubtitleMethod.video ? updatedSelection : state.videoSelection);
    } catch (e) {
      state = state.copyWith(isCheckingSync: false, syncStatus: SyncMatchStatus.error);
    }
  }

  AnalyzedSubtitle _updateCurrentSelectionWithResult(SyncResult result) {
    return AnalyzedSubtitle(
      fileName: state.subtitleFileName!,
      path: state.subtitlePath!,
      confidence: result.confidence,
      offset: result.offset,
      phrases: state.previewPhrases,
      explanation: result.explanation,
      pnr: result.pnr,
      uniqueness: result.uniqueness,
      consensusCount: result.consensusCount,
      totalSegments: result.totalSegments,
      checkpoints: result.checkpoints,
    );
  }

  SyncMatchStatus _mapResultType(SyncMatchResultType type) {
    if (type == SyncMatchResultType.perfect) return SyncMatchStatus.perfect;
    if (type == SyncMatchResultType.offset) return SyncMatchStatus.offset;
    return SyncMatchStatus.mismatch;
  }

  Future<String?> _extractSubtitle(MediaTrackInfo track) async {
    if (state.videoPath == null) return null;
    final tempDir = await getTemporaryDirectory();
    final outputPath = p.join(tempDir.path, 'extracted_sub_${DateTime.now().millisecondsSinceEpoch}.srt');
    final session = await FFmpegKit.execute('-i "${state.videoPath}" -map 0:s:${track.index} "$outputPath" -y');
    return ReturnCode.isSuccess(await session.getReturnCode()) ? outputPath : null;
  }

  Future<void> handleSubtitleSelected(String path, {String? episode, String? season, SubtitleSource? source}) async {
    state = state.copyWith(isParsing: true);
    try {
      final depacker = ref.read(subtitleDepackerServiceProvider);
      final streams = await depacker.parseMultiStreamPreview(
        filePath: path, 
        language: ref.read(languageProvider).original ?? 'Japanese'
      );
      
      if (streams.isEmpty) {
        state = state.copyWith(isParsing: false);
        return;
      }

      final fileName = p.basename(path);
      final List<AnalyzedSubtitle> versions = [];
      
      streams.forEach((style, phrases) {
        versions.add(AnalyzedSubtitle(
          fileName: streams.length > 1 ? '$fileName ($style)' : fileName,
          path: path,
          confidence: 0.0,
          phrases: phrases,
        ));
      });

      final defaultSelection = versions.first;
      
      state = state.copyWith(
        manualSelection: defaultSelection,
        analyzedVersions: versions,
        availableStreams: streams,
        selectedStreamKey: streams.keys.first,
        subtitleSource: source ?? state.subtitleSource,
        episode: episode ?? state.episode,
        isParsing: false,
      );
    } catch (e) {
      state = state.copyWith(isParsing: false);
    }
  }

  void selectSubtitleStream(String streamKey) {
    final phrases = state.availableStreams[streamKey] ?? [];
    final updatedSelection = AnalyzedSubtitle(fileName: state.subtitleFileName!, path: state.subtitlePath!, confidence: 0.0, phrases: phrases);
    state = state.copyWith(selectedStreamKey: streamKey, manualSelection: state.subtitleMethod == SubtitleMethod.manual ? updatedSelection : state.manualSelection, quickSelection: state.subtitleMethod == SubtitleMethod.quick ? updatedSelection : state.quickSelection, aiSelection: state.subtitleMethod == SubtitleMethod.ai_scan ? updatedSelection : state.aiSelection, videoSelection: state.subtitleMethod == SubtitleMethod.video ? updatedSelection : state.videoSelection);
  }

  void optimizeTimings(int paddingMs, {bool fillGaps = false}) {
    if (state.previewPhrases.isEmpty) return;
    final baseDate = DateTime(1970, 1, 1);
    final List<Phrase> optimized = [];
    final original = state.previewPhrases;
    for (int i = 0; i < original.length; i++) {
      final p = original[i];
      if (p.startTime == null || p.endTime == null) { optimized.add(p); continue; }
      Duration newStart = p.startTime!.difference(baseDate) - Duration(milliseconds: paddingMs);
      Duration newEnd = p.endTime!.difference(baseDate) + Duration(milliseconds: paddingMs);
      if (newStart.isNegative) newStart = Duration.zero;
      if (i > 0) {
        final prev = optimized[i - 1];
        if (prev.endTime != null) {
          final prevEndOffset = prev.endTime!.difference(baseDate);
          final gapMs = newStart.inMilliseconds - prevEndOffset.inMilliseconds;
          if (gapMs < 20 || (fillGaps && gapMs < 1000)) {
            newStart = prevEndOffset + const Duration(milliseconds: 20);
            if (newStart.inMilliseconds > newEnd.inMilliseconds) newEnd = newStart + const Duration(milliseconds: 100);
          }
        }
      }
      optimized.add(Phrase(videoId: p.videoId, phraseOrder: p.phraseOrder, originalPhrase: p.originalPhrase, translatedPhrase: p.translatedPhrase, startTime: baseDate.add(newStart), endTime: baseDate.add(newEnd), isActive: p.isActive, originalTokens: p.originalTokens, translatedWords: p.translatedWords, stageStatuses: p.stageStatuses));
    }
    final updatedSelection = AnalyzedSubtitle(fileName: state.subtitleFileName!, path: state.subtitlePath!, confidence: state.syncConfidence, offset: state.suggestedOffset, phrases: optimized, explanation: state.syncExplanation);
    state = state.copyWith(appliedPaddingMs: paddingMs, appliedFillGaps: fillGaps, manualSelection: state.subtitleMethod == SubtitleMethod.manual ? updatedSelection : state.manualSelection, quickSelection: state.subtitleMethod == SubtitleMethod.quick ? updatedSelection : state.quickSelection, aiSelection: state.subtitleMethod == SubtitleMethod.ai_scan ? updatedSelection : state.aiSelection, videoSelection: state.subtitleMethod == SubtitleMethod.video ? updatedSelection : state.videoSelection);
  }

  void selectVersion(AnalyzedSubtitle version) {
    state = state.copyWith(
      manualSelection: state.subtitleMethod == SubtitleMethod.manual ? version : state.manualSelection,
      quickSelection: state.subtitleMethod == SubtitleMethod.quick ? version : state.quickSelection,
      aiSelection: state.subtitleMethod == SubtitleMethod.ai_scan ? version : state.aiSelection,
      videoSelection: state.subtitleMethod == SubtitleMethod.video ? version : state.videoSelection,
      syncConfidence: version.confidence,
      suggestedOffset: version.offset,
      syncCheckpoints: version.checkpoints,
      syncPnr: version.pnr,
      syncUniqueness: version.uniqueness,
      syncConsensus: version.consensusCount,
      syncTotalSegments: version.totalSegments,
    );
  }

  Future<void> evaluateAllEpisodeSubtitles() async {
    final entry = _getActiveEntry();
    if (entry == null || state.episode == null || state.videoPath == null) return;
    state = state.copyWith(isEvaluatingBatch: true, analyzedVersions: [], syncStatus: SyncMatchStatus.analyzing);
    try {
      final syncService = ref.read(audioSyncServiceProvider);
      await syncService.preheatVoiceMaps(state.videoPath!);
      final service = await ref.read(jimakuServiceProvider.future);
      List<FileJimakuDTO> rawFiles = [];
      try { rawFiles = await service.getFiles(int.parse(entry.sourceId), episode: int.tryParse(state.episode!)); } catch (_) { rawFiles = await service.getFiles(int.parse(entry.sourceId)); }
      final targetEp = int.tryParse(state.episode!);
      final episodeFiles = rawFiles.where((f) { final ep = int.tryParse(parseSeasonEpisode(f.name).episode ?? ''); return ep != null && ep == targetEp; }).toList();
      if (episodeFiles.isEmpty) { state = state.copyWith(isEvaluatingBatch: false, syncStatus: SyncMatchStatus.mismatch); return; }
      state = state.copyWith(totalEvaluationCount: episodeFiles.length);
      final List<AnalyzedSubtitle> analyzed = [];
      for (int i = 0; i < episodeFiles.length; i++) {
        state = state.copyWith(currentEvaluationIndex: i + 1);
        final file = episodeFiles[i];
        try {
          final path = await service.downloadAndCacheFile(file.url, preferredName: file.name);
          final depacker = ref.read(subtitleDepackerServiceProvider);
          final streams = await depacker.parseMultiStreamPreview(
            filePath: path, 
            language: ref.read(languageProvider).original ?? 'Japanese'
          );

          // Штраф за мульти-стрім файл (зменшуємо впевненість на 5%)
          final multiStreamPenalty = streams.length > 1 ? 0.05 : 0.0;

          for (var entry in streams.entries) {
            final phrases = entry.value;
            final result = await syncService.analyzeSync(videoPath: state.videoPath!, phrases: phrases);
            
            analyzed.add(AnalyzedSubtitle(
              fileName: streams.length > 1 ? "${file.name} (${entry.key})" : file.name,
              path: path,
              confidence: (result.confidence - multiStreamPenalty).clamp(0.0, 1.0),
              offset: result.offset,
              phrases: phrases,
              explanation: result.explanation,
              checkpoints: result.checkpoints,
              pnr: result.pnr,
              uniqueness: result.uniqueness,
              consensusCount: result.consensusCount,
              totalSegments: result.totalSegments,
            ));
          }
          state = state.copyWith(analyzedVersions: List.from(analyzed));
        } catch (_) {}
      }
      analyzed.sort((a, b) => b.confidence.compareTo(a.confidence));
      if (analyzed.isNotEmpty) {
        selectVersion(analyzed.first);
      }
      state = state.copyWith(isEvaluatingBatch: false);
    } catch (e) { state = state.copyWith(isEvaluatingBatch: false, syncStatus: SyncMatchStatus.error); }
  }

  void applySyncFix({Duration? manualOffset}) {
    final offset = manualOffset ?? state.suggestedOffset ?? state.activeSelection?.offset;
    if (offset == null || offset == Duration.zero) return;

    final phrases = state.previewPhrases;
    final updatedPhrases = phrases.map((p) => Phrase(
      videoId: p.videoId,
      phraseOrder: p.phraseOrder,
      originalPhrase: p.originalPhrase,
      translatedPhrase: p.translatedPhrase,
      startTime: p.startTime?.add(offset),
      endTime: p.endTime?.add(offset),
      isActive: p.isActive,
      originalTokens: p.originalTokens,
      translatedWords: p.translatedWords,
      linkGroups: p.linkGroups,
      idiomSpans: p.idiomSpans,
      stageStatuses: p.stageStatuses,
    )).toList();

    final currentSelection = state.activeSelection!;
    final updatedSelection = AnalyzedSubtitle(
      fileName: currentSelection.fileName,
      path: currentSelection.path,
      confidence: currentSelection.confidence,
      offset: Duration.zero,
      phrases: updatedPhrases,
      explanation: 'Fixed ${offset.inMilliseconds}ms offset',
      checkpoints: currentSelection.checkpoints,
      pnr: currentSelection.pnr,
      uniqueness: currentSelection.uniqueness,
      consensusCount: currentSelection.consensusCount,
    );

    state = state.copyWith(
      manualSelection: state.subtitleMethod == SubtitleMethod.manual ? updatedSelection : state.manualSelection,
      quickSelection: state.subtitleMethod == SubtitleMethod.quick ? updatedSelection : state.quickSelection,
      aiSelection: state.subtitleMethod == SubtitleMethod.ai_scan ? updatedSelection : state.aiSelection,
      videoSelection: state.subtitleMethod == SubtitleMethod.video ? updatedSelection : state.videoSelection,
      suggestedOffset: null,
    );
  }

  Future<bool> saveVideo() async {
    if (state.videoPath == null || state.fileName == null || state.fileName!.isEmpty) {
      developer.log('Save failed: videoPath or fileName is missing', name: 'UploadNotifier');
      return false;
    }

    state = state.copyWith(isSaving: true);
    try {
      final entry = _getActiveEntry();
      final videoService = ref.read(videoServiceProvider);
      final phraseService = ref.read(phraseServiceProvider);
      final languages = ref.read(languageProvider);

      developer.log('Saving video: ${state.fileName}', name: 'UploadNotifier');

      final selectedAudioIndex = state.selectedAudioTrack != null ? state.audioTracks.indexOf(state.selectedAudioTrack!) : null;
      developer.log('Saving video: ${state.fileName}, selectedAudioTrack: ${state.selectedAudioTrack?.title}, resolved index: $selectedAudioIndex, total audio tracks: ${state.audioTracks.length}', name: 'UploadNotifier');

      final video = Video()
        ..videoPath = state.videoPath
        ..fileName = state.fileName
        ..episode = state.episode
        ..season = state.season
        ..originalLanguage = languages.original
        ..translatedLanguage = languages.target
        ..subtitleSource = state.subtitleSource.name
        ..appliedPaddingMs = state.appliedPaddingMs
        ..appliedFillGaps = state.appliedFillGaps
        ..pathSubtitle = (state.subtitleSource == SubtitleSource.none || state.subtitleSource == SubtitleSource.ai) ? null : state.subtitlePath
        ..isSubtitleReady = state.subtitleSource != SubtitleSource.ai
        ..audioStatus = state.subtitleSource == SubtitleSource.ai ? 'pending' : 'none'
        ..transcriptionStatus = state.subtitleSource == SubtitleSource.ai ? 'pending' : 'completed'
        ..selectedAudioTrackIndex = selectedAudioIndex != null && selectedAudioIndex >= 0 ? selectedAudioIndex : null
        ..createdAt = DateTime.now();

      if (entry != null) {
        final entryType = (entry.type ?? '').toUpperCase();
        video
          ..seriesName = entry.title
          ..originalName = entry.originalTitle
          ..description = entry.description
          ..coverImagePath = entry.imagePath ?? entry.imageUrl
          ..bannerImage = entry.bannerPath ?? entry.bannerUrl
          ..genres = entry.genres
          ..status = entry.status
          ..score = entry.score
          ..totalEpisodes = entry.episodes
          ..anilistId = entry.anilistId
          ..tvmazeId = entry.tvmazeId
          ..shikimoriId = entry.shikimoriId
          ..malId = entry.malId
          ..tmdbId = entry.tmdbId
          ..imdbId = entry.imdbId
          ..thetvdbId = entry.thetvdbId
          ..colorThemeValue = entry.colorThemeValue
          ..isAnime = entryType == 'ANIME' || entryType == 'TV' || entryType == 'OVA' || entryType == 'ONA' || entryType == 'SPECIAL'
          ..isMovie = entryType == 'MOVIE';
      }

      final videoId = await videoService.addVideo(video);
      developer.log('Video saved with ID: $videoId', name: 'UploadNotifier');
      
      // Map to NEW objects to ensure Isar treats them as new entries
      final phrases = state.previewPhrases.map((p) => Phrase(
        videoId: videoId,
        phraseOrder: p.phraseOrder,
        originalPhrase: p.originalPhrase,
        translatedPhrase: p.translatedPhrase,
        startTime: p.startTime,
        endTime: p.endTime,
        isActive: p.isActive,
        originalTokens: p.originalTokens,
        translatedWords: p.translatedWords,
        linkGroups: p.linkGroups,
        idiomSpans: p.idiomSpans,
        stageStatuses: p.stageStatuses,
      )).toList();

      if (phrases.isNotEmpty) {
        developer.log('Saving ${phrases.length} phrases', name: 'UploadNotifier');
        await phraseService.addPhrasesList(phrases);
      }

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e, st) {
      developer.log('Error saving video', name: 'UploadNotifier', error: e, stackTrace: st);
      state = state.copyWith(isSaving: false);
      return false;
    }
  }
}
