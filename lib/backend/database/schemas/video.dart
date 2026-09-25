import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

part 'video.g.dart';

@collection
class Video {
  Id id = Isar.autoIncrement;

  String? originalLanguage;
  String? translatedLanguage;
  String? textFormat;
  String? pathSubtitle;
  String? videoPath;
  DateTime? createdAt;
  String? fileName;
  String? episode;
  String? season;

  // Metadata
  String? nameJumaku;
  String? seriesName;
  String? originalName;
  String? subtitleFileName;
  int? anilistId;
  int? tvmazeId;
  int? shikimoriId;
  int? malId;
  String? tmdbId;
  String? imdbId;
  String? thetvdbId;
  bool? isAnime;
  bool? isMovie;
  bool? isAdult;
  bool? isUnverified;

  String? coverImagePath;
  String? description;
  String? bannerImage;
  List<String>? genres;
  String? status;
  double? score;
  int? totalEpisodes;

  int? colorThemeValue;

  // Pipeline
  String? pipelineIndetificator;

  // Pipeline 1
  bool? isResearchDone = false;
  String? researchInformation;

  bool? isSubtitleReady;
  String? subtitleSource; // 'local', 'jimaku', 'ai'
  int? appliedPaddingMs;
  bool? appliedFillGaps;

  String? audioStatus = 'pending'; 
  String? transcriptionStatus = 'pending';
  double? processingProgress = 0.0;
  int? transcriptionResumeSeconds = 0;

  // Metadata service used for creation
  String? metadataProvider; // 'anilist', 'shikimori', 'tvmaze', 'manual'
  String? subtitleMethodUsed; // 'quick', 'ai_scan', 'manual', 'video'

  bool isCached = false;

  int? lastPositionMs;

  bool isSynced = false;
  DateTime? lastSyncedAt;

  int? selectedAudioTrackIndex;

  Video();

  @ignore
  Color? get colorTheme {
    if (colorThemeValue == null) return null;
    return Color(colorThemeValue!);
  }

  @ignore
  set colorTheme(Color? color) {
    colorThemeValue = color?.value;
  }

  Video copyWith({
    Id? id,
    String? originalLanguage,
    String? translatedLanguage,
    String? textFormat,
    String? pathSubtitle,
    String? videoPath,
    DateTime? createdAt,
    String? fileName,
    String? episode,
    String? season,
    String? nameJumaku,
    String? seriesName,
    String? originalName,
    String? subtitleFileName,
    int? anilistId,
    int? tvmazeId,
    int? shikimoriId,
    int? malId,
    String? tmdbId,
    String? imdbId,
    String? thetvdbId,
    bool? isAnime,
    bool? isMovie,
    bool? isAdult,
    bool? isUnverified,
    String? coverImagePath,
    String? description,
    String? bannerImage,
    List<String>? genres,
    String? status,
    double? score,
    int? totalEpisodes,
    int? colorThemeValue,
    String? pipelineIndetificator,
    bool? isResearchDone,
    String? researchInformation,
    bool? isSubtitleReady,
    String? subtitleSource,
    int? appliedPaddingMs,
    bool? appliedFillGaps,
    String? audioStatus,
    String? transcriptionStatus,
    double? processingProgress,
    int? transcriptionResumeSeconds,
    bool? isCached,
    int? lastPositionMs,
    int? selectedAudioTrackIndex,
  }) {
    return Video()
      ..id = id ?? this.id
      ..originalLanguage = originalLanguage ?? this.originalLanguage
      ..translatedLanguage = translatedLanguage ?? this.translatedLanguage
      ..textFormat = textFormat ?? this.textFormat
      ..pathSubtitle = pathSubtitle ?? this.pathSubtitle
      ..videoPath = videoPath ?? this.videoPath
      ..createdAt = createdAt ?? this.createdAt
      ..fileName = fileName ?? this.fileName
      ..episode = episode ?? this.episode
      ..season = season ?? this.season
      ..nameJumaku = nameJumaku ?? this.nameJumaku
      ..seriesName = seriesName ?? this.seriesName
      ..originalName = originalName ?? this.originalName
      ..subtitleFileName = subtitleFileName ?? this.subtitleFileName
      ..anilistId = anilistId ?? this.anilistId
      ..tvmazeId = tvmazeId ?? this.tvmazeId
      ..shikimoriId = shikimoriId ?? this.shikimoriId
      ..malId = malId ?? this.malId
      ..tmdbId = tmdbId ?? this.tmdbId
      ..imdbId = imdbId ?? this.imdbId
      ..thetvdbId = thetvdbId ?? this.thetvdbId
      ..isAnime = isAnime ?? this.isAnime
      ..isMovie = isMovie ?? this.isMovie
      ..isAdult = isAdult ?? this.isAdult
      ..isUnverified = isUnverified ?? this.isUnverified
      ..coverImagePath = coverImagePath ?? this.coverImagePath
      ..description = description ?? this.description
      ..bannerImage = bannerImage ?? this.bannerImage
      ..genres = genres ?? this.genres
      ..status = status ?? this.status
      ..score = score ?? this.score
      ..totalEpisodes = totalEpisodes ?? this.totalEpisodes
      ..colorThemeValue = colorThemeValue ?? this.colorThemeValue
      ..pipelineIndetificator = pipelineIndetificator ?? this.pipelineIndetificator
      ..isResearchDone = isResearchDone ?? this.isResearchDone
      ..researchInformation = researchInformation ?? this.researchInformation
      ..isSubtitleReady = isSubtitleReady ?? this.isSubtitleReady
      ..subtitleSource = subtitleSource ?? this.subtitleSource
      ..appliedPaddingMs = appliedPaddingMs ?? this.appliedPaddingMs
      ..appliedFillGaps = appliedFillGaps ?? this.appliedFillGaps
      ..audioStatus = audioStatus ?? this.audioStatus
      ..transcriptionStatus = transcriptionStatus ?? this.transcriptionStatus
      ..processingProgress = processingProgress ?? this.processingProgress
      ..transcriptionResumeSeconds = transcriptionResumeSeconds ?? this.transcriptionResumeSeconds
      ..isCached = isCached ?? this.isCached
      ..lastPositionMs = lastPositionMs ?? this.lastPositionMs
      ..selectedAudioTrackIndex = selectedAudioTrackIndex ?? this.selectedAudioTrackIndex;
  }
}
