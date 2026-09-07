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
  String? tmdbId;
  bool? isAnime;
  bool? isMovie;
  bool? isAdult;
  bool? isUnverified;

  String? coverImagePath;
  String? description;
  String? bannerImage;
  List<String>? genres;

  int? colorThemeValue;

  // Pipeline
  String? pipelineIndetificator;

  // Pipeline 1
  bool? isResearchDone = false;
  String? researchInformation;

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
    String? tmdbId,
    bool? isAnime,
    bool? isMovie,
    bool? isAdult,
    bool? isUnverified,
    String? coverImagePath,
    String? description,
    String? bannerImage,
    List<String>? genres,
    int? colorThemeValue,
    String? pipelineIndetificator,
    bool? isResearchDone,
    String? researchInformation,
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
      ..tmdbId = tmdbId ?? this.tmdbId
      ..isAnime = isAnime ?? this.isAnime
      ..isMovie = isMovie ?? this.isMovie
      ..isAdult = isAdult ?? this.isAdult
      ..isUnverified = isUnverified ?? this.isUnverified
      ..coverImagePath = coverImagePath ?? this.coverImagePath
      ..description = description ?? this.description
      ..bannerImage = bannerImage ?? this.bannerImage
      ..genres = genres ?? this.genres
      ..colorThemeValue = colorThemeValue ?? this.colorThemeValue
      ..pipelineIndetificator = pipelineIndetificator ?? this.pipelineIndetificator
      ..isResearchDone = isResearchDone ?? this.isResearchDone
      ..researchInformation = researchInformation ?? this.researchInformation;
  }
}

@embedded
class AiStageHistory {
  String? stageName;
  int? durationMs;
  String? status; // 'success', 'error'
  String? modelName;

  AiStageHistory({
    this.stageName,
    this.durationMs,
    this.status,
    this.modelName,
  });
}
