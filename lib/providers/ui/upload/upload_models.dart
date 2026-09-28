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
  final bool hideParenthesesInPreview;

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
    this.hideParenthesesInPreview = false,
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
      case SubtitleMethod.manual: return manualSelection ?? quickSelection ?? aiSelection ?? videoSelection;
      case SubtitleMethod.quick: return quickSelection ?? manualSelection ?? aiSelection ?? videoSelection;
      case SubtitleMethod.ai_scan: return aiSelection ?? quickSelection ?? manualSelection ?? videoSelection;
      case SubtitleMethod.video: return videoSelection ?? aiSelection ?? quickSelection ?? manualSelection;
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
    bool? hideParenthesesInPreview,
    bool replaceVideo = false,
    bool clearSubtitleData = false,
    bool clearManualSelection = false,
    bool clearQuickSelection = false,
    bool clearAiSelection = false,
    bool clearVideoSelection = false,
    bool clearSelectedOriginalSubtitle = false,
    bool clearSelectedTranslationSubtitle = false,
    bool clearTranslationSubtitlePath = false,
    bool clearSuggestedOffset = false,
    bool clearSyncExplanation = false,
  }) {
    final clearAllSubtitleData = replaceVideo || clearSubtitleData;
    return UploadState(
      videoSource: videoSource ?? this.videoSource,
      subtitleSource: subtitleSource ?? this.subtitleSource,
      subtitleMethod: subtitleMethod ?? this.subtitleMethod,
      videoPath: replaceVideo ? videoPath : (videoPath ?? this.videoPath),
      videoDuration: replaceVideo ? videoDuration : (videoDuration ?? this.videoDuration),
      manualSelection: clearAllSubtitleData || clearManualSelection ? null : (manualSelection ?? this.manualSelection),
      quickSelection: clearAllSubtitleData || clearQuickSelection ? null : (quickSelection ?? this.quickSelection),
      aiSelection: clearAllSubtitleData || clearAiSelection ? null : (aiSelection ?? this.aiSelection),
      videoSelection: clearAllSubtitleData || clearVideoSelection ? null : (videoSelection ?? this.videoSelection),
      translationSubtitlePath: clearAllSubtitleData || clearTranslationSubtitlePath ? null : (translationSubtitlePath ?? this.translationSubtitlePath),
      fileName: replaceVideo ? fileName : (fileName ?? this.fileName),
      episode: replaceVideo ? episode : (episode ?? this.episode),
      season: replaceVideo ? season : (season ?? this.season),
      originalPreviewPhrases: clearAllSubtitleData || clearTranslationSubtitlePath ? const [] : (originalPreviewPhrases ?? this.originalPreviewPhrases),
      availableStreams: clearAllSubtitleData ? const {} : (availableStreams ?? this.availableStreams),
      selectedStreamKey: clearAllSubtitleData ? null : (selectedStreamKey ?? this.selectedStreamKey),
      aiTranscriptionLanguage: aiTranscriptionLanguage ?? this.aiTranscriptionLanguage,
      isParsing: isParsing ?? this.isParsing,
      isSaving: isSaving ?? (replaceVideo ? false : this.isSaving),
      isInitialized: isInitialized ?? this.isInitialized,
      appliedPaddingMs: clearAllSubtitleData ? 0 : (appliedPaddingMs ?? this.appliedPaddingMs),
      appliedFillGaps: clearAllSubtitleData ? false : (appliedFillGaps ?? this.appliedFillGaps),
      hideParenthesesInPreview: hideParenthesesInPreview ?? this.hideParenthesesInPreview,
      isCheckingSync: isCheckingSync ?? (clearAllSubtitleData ? false : this.isCheckingSync),
      syncStatus: syncStatus ?? (clearAllSubtitleData ? SyncMatchStatus.idle : this.syncStatus),
      suggestedOffset: clearAllSubtitleData || clearSuggestedOffset ? null : (suggestedOffset ?? this.suggestedOffset),
      syncConfidence: clearAllSubtitleData ? 0.0 : (syncConfidence ?? this.syncConfidence),
      isWrongEpisodePromptVisible: isWrongEpisodePromptVisible ?? (clearAllSubtitleData ? false : this.isWrongEpisodePromptVisible),
      syncExplanation: clearAllSubtitleData || clearSyncExplanation ? null : (syncExplanation ?? this.syncExplanation),
      syncCheckpoints: clearAllSubtitleData ? const [] : (syncCheckpoints ?? this.syncCheckpoints),
      syncPnr: clearAllSubtitleData ? 0.0 : (syncPnr ?? this.syncPnr),
      syncUniqueness: clearAllSubtitleData ? 0.0 : (syncUniqueness ?? this.syncUniqueness),
      syncConsensus: clearAllSubtitleData ? 0 : (syncConsensus ?? this.syncConsensus),
      syncTotalSegments: clearAllSubtitleData ? 0 : (syncTotalSegments ?? this.syncTotalSegments),
      analyzedVersions: clearAllSubtitleData ? const [] : (analyzedVersions ?? this.analyzedVersions),
      isEvaluatingBatch: isEvaluatingBatch ?? (clearAllSubtitleData ? false : this.isEvaluatingBatch),
      currentEvaluationIndex: clearAllSubtitleData ? 0 : (currentEvaluationIndex ?? this.currentEvaluationIndex),
      totalEvaluationCount: clearAllSubtitleData ? 0 : (totalEvaluationCount ?? this.totalEvaluationCount),
      resolution: replaceVideo ? resolution : (resolution ?? this.resolution),
      fileSize: replaceVideo ? fileSize : (fileSize ?? this.fileSize),
      codec: replaceVideo ? codec : (codec ?? this.codec),
      audioTracks: replaceVideo ? const [] : (audioTracks ?? this.audioTracks),
      subtitleTracks: replaceVideo ? const [] : (subtitleTracks ?? this.subtitleTracks),
      selectedAudioTrack: replaceVideo ? selectedAudioTrack : (selectedAudioTrack ?? this.selectedAudioTrack),
      selectedOriginalSubtitle: clearAllSubtitleData || clearSelectedOriginalSubtitle ? null : (selectedOriginalSubtitle ?? this.selectedOriginalSubtitle),
      selectedTranslationSubtitle: clearAllSubtitleData || clearSelectedTranslationSubtitle ? null : (selectedTranslationSubtitle ?? this.selectedTranslationSubtitle),
      currentStepIndex: replaceVideo ? 0 : (currentStepIndex ?? this.currentStepIndex),
      coverSourceMode: replaceVideo ? CoverSourceMode.automatic : (coverSourceMode ?? this.coverSourceMode),
      manualCoverPath: replaceVideo ? null : (manualCoverPath ?? this.manualCoverPath),
    );
  }
}
