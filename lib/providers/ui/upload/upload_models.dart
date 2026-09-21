import 'package:eiga/backend/database/schemas/phrase.dart';
import 'package:eiga/backend/services/audio/audio_sync_service.dart';

enum VideoSource { file }
enum CoverSourceMode { automatic, device, video }
enum SubtitleSource { local, jimaku, ai, none }
enum SubtitleMethod { quick, ai_scan, manual, video }
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
  final int totalSegments;
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
    this.totalSegments = 0,
    this.checkpoints = const [],
  });
}

class MediaTrackInfo {
  final String id;
  final String? title;
  final String? language;
  final int index;

  MediaTrackInfo({required this.id, this.title, this.language, required this.index});
}

class UploadState {
  final VideoSource videoSource;
  final SubtitleSource subtitleSource;
  final SubtitleMethod subtitleMethod;
  final String? videoPath;
  final int? videoDuration;

  // Stored selections for each method (to prevent losing state)
  final AnalyzedSubtitle? manualSelection;
  final AnalyzedSubtitle? quickSelection;
  final AnalyzedSubtitle? aiSelection;
  final AnalyzedSubtitle? videoSelection;

  final String? translationSubtitlePath;
  final String? fileName;
  final String? episode;
  final String? season;
  final List<Phrase> originalPreviewPhrases;
  final bool isParsing;
  final bool isSaving;
  final bool isInitialized;

  final int appliedPaddingMs;
  final bool appliedFillGaps;

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

  final Map<String, List<Phrase>> availableStreams;
  final String? selectedStreamKey;

  final String? aiTranscriptionLanguage;

  final String? resolution;
  final String? fileSize;
  final String? codec;

  // Track selection
  final List<MediaTrackInfo> audioTracks;
  final List<MediaTrackInfo> subtitleTracks;
  final MediaTrackInfo? selectedAudioTrack;
  final MediaTrackInfo? selectedOriginalSubtitle;
  final MediaTrackInfo? selectedTranslationSubtitle;

  final CoverSourceMode coverSourceMode;
  final String? manualCoverPath;
  final int currentStepIndex;

  UploadState({
    this.videoSource = VideoSource.file,
    this.subtitleSource = SubtitleSource.local,
    this.subtitleMethod = SubtitleMethod.quick,
    this.videoPath,
    this.videoDuration,
    this.manualSelection,
    this.quickSelection,
    this.aiSelection,
    this.videoSelection,
    this.translationSubtitlePath,
    this.fileName,
    this.episode,
    this.season,
    this.originalPreviewPhrases = const [],
    this.availableStreams = const {},
    this.selectedStreamKey,
    this.aiTranscriptionLanguage,
    this.isParsing = false,
    this.isSaving = false,
    this.isInitialized = false,
    this.appliedPaddingMs = 0,
    this.appliedFillGaps = false,
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
    this.resolution,
    this.fileSize,
    this.codec,
    this.audioTracks = const [],
    this.subtitleTracks = const [],
    this.selectedAudioTrack,
    this.selectedOriginalSubtitle,
    this.selectedTranslationSubtitle,
    this.coverSourceMode = CoverSourceMode.automatic,
    this.manualCoverPath,
    this.currentStepIndex = 0,
  });

  // Getter for the ACTIVE subtitle data based on current method
  String? get subtitlePath {
    switch (subtitleMethod) {
      case SubtitleMethod.manual: return manualSelection?.path;
      case SubtitleMethod.quick: return quickSelection?.path;
      case SubtitleMethod.ai_scan: return aiSelection?.path;
      case SubtitleMethod.video: return videoSelection?.path;
    }
  }

  String? get subtitleFileName {
    switch (subtitleMethod) {
      case SubtitleMethod.manual: return manualSelection?.fileName;
      case SubtitleMethod.quick: return quickSelection?.fileName;
      case SubtitleMethod.ai_scan: return aiSelection?.fileName;
      case SubtitleMethod.video: return videoSelection?.fileName;
    }
  }

  List<Phrase> get previewPhrases {
    return activeSelection?.phrases ?? [];
  }

  AnalyzedSubtitle? get activeSelection {
    if (subtitleSource == SubtitleSource.none) return null;
    
    switch (subtitleMethod) {
      case SubtitleMethod.manual: return manualSelection;
      case SubtitleMethod.quick: return quickSelection;
      case SubtitleMethod.ai_scan: return aiSelection;
      case SubtitleMethod.video: return videoSelection;
    }
  }

  UploadState copyWith({
    VideoSource? videoSource,
    SubtitleSource? subtitleSource,
    SubtitleMethod? subtitleMethod,
    String? videoPath,
    int? videoDuration,
    AnalyzedSubtitle? manualSelection,
    AnalyzedSubtitle? quickSelection,
    AnalyzedSubtitle? aiSelection,
    AnalyzedSubtitle? videoSelection,
    String? translationSubtitlePath,
    String? fileName,
    String? subtitleFileName,
    String? episode,
    String? season,
    List<Phrase>? previewPhrases,
    List<Phrase>? originalPreviewPhrases,
    Map<String, List<Phrase>>? availableStreams,
    String? selectedStreamKey,
    bool? isParsing,
    bool? isSaving,
    bool? isInitialized,
    int? appliedPaddingMs,
    bool? appliedFillGaps,
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
    String? aiTranscriptionLanguage,
    String? resolution,
    String? fileSize,
    String? codec,
    List<MediaTrackInfo>? audioTracks,
    List<MediaTrackInfo>? subtitleTracks,
    MediaTrackInfo? selectedAudioTrack,
    MediaTrackInfo? selectedOriginalSubtitle,
    MediaTrackInfo? selectedTranslationSubtitle,
    CoverSourceMode? coverSourceMode,
    String? manualCoverPath,
    int? currentStepIndex,
  }) {
    return UploadState(
      videoSource: videoSource ?? this.videoSource,
      subtitleSource: subtitleSource ?? this.subtitleSource,
      subtitleMethod: subtitleMethod ?? this.subtitleMethod,
      videoPath: videoPath ?? this.videoPath,
      videoDuration: videoDuration ?? this.videoDuration,
      manualSelection: manualSelection ?? this.manualSelection,
      quickSelection: quickSelection ?? this.quickSelection,
      aiSelection: aiSelection ?? this.aiSelection,
      videoSelection: videoSelection ?? this.videoSelection,
      translationSubtitlePath: translationSubtitlePath ?? this.translationSubtitlePath,
      fileName: fileName ?? this.fileName,
      episode: episode ?? this.episode,
      season: season ?? this.season,
      originalPreviewPhrases: originalPreviewPhrases ?? this.originalPreviewPhrases,
      availableStreams: availableStreams ?? this.availableStreams,
      selectedStreamKey: selectedStreamKey ?? this.selectedStreamKey,
      aiTranscriptionLanguage: aiTranscriptionLanguage ?? this.aiTranscriptionLanguage,
      isParsing: isParsing ?? this.isParsing,
      isSaving: isSaving ?? this.isSaving,
      isInitialized: isInitialized ?? this.isInitialized,
      appliedPaddingMs: appliedPaddingMs ?? this.appliedPaddingMs,
      appliedFillGaps: appliedFillGaps ?? this.appliedFillGaps,
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
      resolution: resolution ?? this.resolution,
      fileSize: fileSize ?? this.fileSize,
      codec: codec ?? this.codec,
      audioTracks: audioTracks ?? this.audioTracks,
      subtitleTracks: subtitleTracks ?? this.subtitleTracks,
      selectedAudioTrack: selectedAudioTrack ?? this.selectedAudioTrack,
      selectedOriginalSubtitle: selectedOriginalSubtitle ?? this.selectedOriginalSubtitle,
      selectedTranslationSubtitle: selectedTranslationSubtitle ?? this.selectedTranslationSubtitle,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      coverSourceMode: coverSourceMode ?? this.coverSourceMode,
      manualCoverPath: manualCoverPath ?? this.manualCoverPath,
    );
  }
}
