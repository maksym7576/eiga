// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVideoCollection on Isar {
  IsarCollection<Video> get videos => this.collection();
}

const VideoSchema = CollectionSchema(
  name: r'Video',
  id: 113594071489080673,
  properties: {
    r'anilistId': PropertySchema(
      id: 0,
      name: r'anilistId',
      type: IsarType.long,
    ),
    r'bannerImage': PropertySchema(
      id: 1,
      name: r'bannerImage',
      type: IsarType.string,
    ),
    r'colorThemeValue': PropertySchema(
      id: 2,
      name: r'colorThemeValue',
      type: IsarType.long,
    ),
    r'coverImagePath': PropertySchema(
      id: 3,
      name: r'coverImagePath',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 5,
      name: r'description',
      type: IsarType.string,
    ),
    r'episode': PropertySchema(id: 6, name: r'episode', type: IsarType.string),
    r'fileName': PropertySchema(
      id: 7,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'genres': PropertySchema(
      id: 8,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'imdbId': PropertySchema(id: 9, name: r'imdbId', type: IsarType.string),
    r'isAdult': PropertySchema(id: 10, name: r'isAdult', type: IsarType.bool),
    r'isAnime': PropertySchema(id: 11, name: r'isAnime', type: IsarType.bool),
    r'isMovie': PropertySchema(id: 12, name: r'isMovie', type: IsarType.bool),
    r'isResearchDone': PropertySchema(
      id: 13,
      name: r'isResearchDone',
      type: IsarType.bool,
    ),
    r'isUnverified': PropertySchema(
      id: 14,
      name: r'isUnverified',
      type: IsarType.bool,
    ),
    r'malId': PropertySchema(id: 15, name: r'malId', type: IsarType.long),
    r'nameJumaku': PropertySchema(
      id: 16,
      name: r'nameJumaku',
      type: IsarType.string,
    ),
    r'originalLanguage': PropertySchema(
      id: 17,
      name: r'originalLanguage',
      type: IsarType.string,
    ),
    r'originalName': PropertySchema(
      id: 18,
      name: r'originalName',
      type: IsarType.string,
    ),
    r'pathSubtitle': PropertySchema(
      id: 19,
      name: r'pathSubtitle',
      type: IsarType.string,
    ),
    r'pipelineIndetificator': PropertySchema(
      id: 20,
      name: r'pipelineIndetificator',
      type: IsarType.string,
    ),
    r'researchInformation': PropertySchema(
      id: 21,
      name: r'researchInformation',
      type: IsarType.string,
    ),
    r'score': PropertySchema(id: 22, name: r'score', type: IsarType.double),
    r'season': PropertySchema(id: 23, name: r'season', type: IsarType.string),
    r'seriesName': PropertySchema(
      id: 24,
      name: r'seriesName',
      type: IsarType.string,
    ),
    r'shikimoriId': PropertySchema(
      id: 25,
      name: r'shikimoriId',
      type: IsarType.long,
    ),
    r'status': PropertySchema(id: 26, name: r'status', type: IsarType.string),
    r'subtitleFileName': PropertySchema(
      id: 27,
      name: r'subtitleFileName',
      type: IsarType.string,
    ),
    r'textFormat': PropertySchema(
      id: 28,
      name: r'textFormat',
      type: IsarType.string,
    ),
    r'thetvdbId': PropertySchema(
      id: 29,
      name: r'thetvdbId',
      type: IsarType.string,
    ),
    r'tmdbId': PropertySchema(id: 30, name: r'tmdbId', type: IsarType.string),
    r'totalEpisodes': PropertySchema(
      id: 31,
      name: r'totalEpisodes',
      type: IsarType.long,
    ),
    r'translatedLanguage': PropertySchema(
      id: 32,
      name: r'translatedLanguage',
      type: IsarType.string,
    ),
    r'tvmazeId': PropertySchema(id: 33, name: r'tvmazeId', type: IsarType.long),
    r'videoPath': PropertySchema(
      id: 34,
      name: r'videoPath',
      type: IsarType.string,
    ),
  },

  estimateSize: _videoEstimateSize,
  serialize: _videoSerialize,
  deserialize: _videoDeserialize,
  deserializeProp: _videoDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _videoGetId,
  getLinks: _videoGetLinks,
  attach: _videoAttach,
  version: '3.3.2',
);

int _videoEstimateSize(
  Video object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bannerImage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.coverImagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.episode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fileName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.genres;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.imdbId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nameJumaku;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.originalLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.originalName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pathSubtitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pipelineIndetificator;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.researchInformation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.season;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.seriesName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.subtitleFileName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.textFormat;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.thetvdbId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.tmdbId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.translatedLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.videoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _videoSerialize(
  Video object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.anilistId);
  writer.writeString(offsets[1], object.bannerImage);
  writer.writeLong(offsets[2], object.colorThemeValue);
  writer.writeString(offsets[3], object.coverImagePath);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.description);
  writer.writeString(offsets[6], object.episode);
  writer.writeString(offsets[7], object.fileName);
  writer.writeStringList(offsets[8], object.genres);
  writer.writeString(offsets[9], object.imdbId);
  writer.writeBool(offsets[10], object.isAdult);
  writer.writeBool(offsets[11], object.isAnime);
  writer.writeBool(offsets[12], object.isMovie);
  writer.writeBool(offsets[13], object.isResearchDone);
  writer.writeBool(offsets[14], object.isUnverified);
  writer.writeLong(offsets[15], object.malId);
  writer.writeString(offsets[16], object.nameJumaku);
  writer.writeString(offsets[17], object.originalLanguage);
  writer.writeString(offsets[18], object.originalName);
  writer.writeString(offsets[19], object.pathSubtitle);
  writer.writeString(offsets[20], object.pipelineIndetificator);
  writer.writeString(offsets[21], object.researchInformation);
  writer.writeDouble(offsets[22], object.score);
  writer.writeString(offsets[23], object.season);
  writer.writeString(offsets[24], object.seriesName);
  writer.writeLong(offsets[25], object.shikimoriId);
  writer.writeString(offsets[26], object.status);
  writer.writeString(offsets[27], object.subtitleFileName);
  writer.writeString(offsets[28], object.textFormat);
  writer.writeString(offsets[29], object.thetvdbId);
  writer.writeString(offsets[30], object.tmdbId);
  writer.writeLong(offsets[31], object.totalEpisodes);
  writer.writeString(offsets[32], object.translatedLanguage);
  writer.writeLong(offsets[33], object.tvmazeId);
  writer.writeString(offsets[34], object.videoPath);
}

Video _videoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Video();
  object.anilistId = reader.readLongOrNull(offsets[0]);
  object.bannerImage = reader.readStringOrNull(offsets[1]);
  object.colorThemeValue = reader.readLongOrNull(offsets[2]);
  object.coverImagePath = reader.readStringOrNull(offsets[3]);
  object.createdAt = reader.readDateTimeOrNull(offsets[4]);
  object.description = reader.readStringOrNull(offsets[5]);
  object.episode = reader.readStringOrNull(offsets[6]);
  object.fileName = reader.readStringOrNull(offsets[7]);
  object.genres = reader.readStringList(offsets[8]);
  object.id = id;
  object.imdbId = reader.readStringOrNull(offsets[9]);
  object.isAdult = reader.readBoolOrNull(offsets[10]);
  object.isAnime = reader.readBoolOrNull(offsets[11]);
  object.isMovie = reader.readBoolOrNull(offsets[12]);
  object.isResearchDone = reader.readBoolOrNull(offsets[13]);
  object.isUnverified = reader.readBoolOrNull(offsets[14]);
  object.malId = reader.readLongOrNull(offsets[15]);
  object.nameJumaku = reader.readStringOrNull(offsets[16]);
  object.originalLanguage = reader.readStringOrNull(offsets[17]);
  object.originalName = reader.readStringOrNull(offsets[18]);
  object.pathSubtitle = reader.readStringOrNull(offsets[19]);
  object.pipelineIndetificator = reader.readStringOrNull(offsets[20]);
  object.researchInformation = reader.readStringOrNull(offsets[21]);
  object.score = reader.readDoubleOrNull(offsets[22]);
  object.season = reader.readStringOrNull(offsets[23]);
  object.seriesName = reader.readStringOrNull(offsets[24]);
  object.shikimoriId = reader.readLongOrNull(offsets[25]);
  object.status = reader.readStringOrNull(offsets[26]);
  object.subtitleFileName = reader.readStringOrNull(offsets[27]);
  object.textFormat = reader.readStringOrNull(offsets[28]);
  object.thetvdbId = reader.readStringOrNull(offsets[29]);
  object.tmdbId = reader.readStringOrNull(offsets[30]);
  object.totalEpisodes = reader.readLongOrNull(offsets[31]);
  object.translatedLanguage = reader.readStringOrNull(offsets[32]);
  object.tvmazeId = reader.readLongOrNull(offsets[33]);
  object.videoPath = reader.readStringOrNull(offsets[34]);
  return object;
}

P _videoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringList(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readBoolOrNull(offset)) as P;
    case 14:
      return (reader.readBoolOrNull(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readDoubleOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readLongOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
    case 29:
      return (reader.readStringOrNull(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    case 31:
      return (reader.readLongOrNull(offset)) as P;
    case 32:
      return (reader.readStringOrNull(offset)) as P;
    case 33:
      return (reader.readLongOrNull(offset)) as P;
    case 34:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _videoGetId(Video object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _videoGetLinks(Video object) {
  return [];
}

void _videoAttach(IsarCollection<dynamic> col, Id id, Video object) {
  object.id = id;
}

extension VideoQueryWhereSort on QueryBuilder<Video, Video, QWhere> {
  QueryBuilder<Video, Video, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VideoQueryWhere on QueryBuilder<Video, Video, QWhereClause> {
  QueryBuilder<Video, Video, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Video, Video, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Video, Video, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension VideoQueryFilter on QueryBuilder<Video, Video, QFilterCondition> {
  QueryBuilder<Video, Video, QAfterFilterCondition> anilistIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'anilistId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> anilistIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'anilistId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> anilistIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'anilistId', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> anilistIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'anilistId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> anilistIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'anilistId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> anilistIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'anilistId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bannerImage'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bannerImage'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bannerImage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bannerImage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bannerImage', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> bannerImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bannerImage', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> colorThemeValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'colorThemeValue'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> colorThemeValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'colorThemeValue'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> colorThemeValueEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'colorThemeValue', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> colorThemeValueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'colorThemeValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> colorThemeValueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'colorThemeValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> colorThemeValueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'colorThemeValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'coverImagePath'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'coverImagePath'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coverImagePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coverImagePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverImagePath', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> coverImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coverImagePath', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> createdAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'description'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'description'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'episode'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'episode'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'episode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'episode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'episode', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> episodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'episode', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fileName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fileName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fileName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fileName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fileName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fileName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'genres'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'genres'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'genres',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'genres',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genres', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'genres', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, true, length, true);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, 0, true);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, false, 999999, true);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, length, include);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, include, 999999, true);
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> genresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'imdbId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'imdbId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'imdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'imdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'imdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'imdbId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'imdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'imdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'imdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'imdbId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'imdbId', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> imdbIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'imdbId', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isAdultIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isAdult'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isAdultIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isAdult'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isAdultEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isAdult', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isAnimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isAnime'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isAnimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isAnime'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isAnimeEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isAnime', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isMovieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isMovie'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isMovieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isMovie'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isMovieEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isMovie', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isResearchDoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isResearchDone'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isResearchDoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isResearchDone'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isResearchDoneEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isResearchDone', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isUnverifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isUnverified'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isUnverifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isUnverified'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> isUnverifiedEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isUnverified', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> malIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'malId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> malIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'malId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> malIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'malId', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> malIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'malId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> malIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'malId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> malIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'malId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nameJumaku'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nameJumaku'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nameJumaku',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nameJumaku',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nameJumaku', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameJumakuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nameJumaku', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'originalLanguage'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  originalLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'originalLanguage'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'originalLanguage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'originalLanguage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'originalLanguage', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  originalLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'originalLanguage', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'originalName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'originalName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'originalName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'originalName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'originalName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'originalName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'originalName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'originalName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'originalName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'originalName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'originalName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> originalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'originalName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pathSubtitle'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pathSubtitle'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pathSubtitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pathSubtitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pathSubtitle', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> pathSubtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pathSubtitle', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pipelineIndetificator'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pipelineIndetificator'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pipelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pipelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pipelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pipelineIndetificator',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pipelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pipelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pipelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pipelineIndetificator',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pipelineIndetificator', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  pipelineIndetificatorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'pipelineIndetificator',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  researchInformationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'researchInformation'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  researchInformationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'researchInformation'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> researchInformationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  researchInformationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> researchInformationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> researchInformationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'researchInformation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  researchInformationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> researchInformationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> researchInformationContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> researchInformationMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'researchInformation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  researchInformationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'researchInformation', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  researchInformationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'researchInformation',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> scoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'score'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> scoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'score'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> scoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> scoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> scoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> scoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'score',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'season'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'season'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'season',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'season',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'season', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'season', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'seriesName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'seriesName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'seriesName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'seriesName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'seriesName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'seriesName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'seriesName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'seriesName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'seriesName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'seriesName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'seriesName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> seriesNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'seriesName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> shikimoriIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'shikimoriId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> shikimoriIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'shikimoriId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> shikimoriIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shikimoriId', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> shikimoriIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shikimoriId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> shikimoriIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shikimoriId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> shikimoriIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shikimoriId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'status'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'status'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'subtitleFileName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  subtitleFileNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'subtitleFileName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'subtitleFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'subtitleFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'subtitleFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'subtitleFileName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'subtitleFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'subtitleFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'subtitleFileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'subtitleFileName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> subtitleFileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'subtitleFileName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  subtitleFileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'subtitleFileName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textFormat'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textFormat'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textFormat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'textFormat',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textFormat', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> textFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'textFormat', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'thetvdbId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'thetvdbId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'thetvdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'thetvdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'thetvdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'thetvdbId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'thetvdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'thetvdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'thetvdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'thetvdbId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'thetvdbId', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> thetvdbIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'thetvdbId', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tmdbId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tmdbId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tmdbId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tmdbId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tmdbId', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tmdbIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tmdbId', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> totalEpisodesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'totalEpisodes'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> totalEpisodesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'totalEpisodes'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> totalEpisodesEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalEpisodes', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> totalEpisodesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalEpisodes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> totalEpisodesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalEpisodes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> totalEpisodesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalEpisodes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> translatedLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'translatedLanguage'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  translatedLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'translatedLanguage'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> translatedLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  translatedLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> translatedLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> translatedLanguageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'translatedLanguage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  translatedLanguageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> translatedLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> translatedLanguageContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> translatedLanguageMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'translatedLanguage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  translatedLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'translatedLanguage', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition>
  translatedLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'translatedLanguage', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tvmazeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tvmazeId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tvmazeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tvmazeId'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tvmazeIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tvmazeId', value: value),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tvmazeIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tvmazeId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tvmazeIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tvmazeId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> tvmazeIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tvmazeId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'videoPath'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'videoPath'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'videoPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoPath', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'videoPath', value: ''),
      );
    });
  }
}

extension VideoQueryObject on QueryBuilder<Video, Video, QFilterCondition> {}

extension VideoQueryLinks on QueryBuilder<Video, Video, QFilterCondition> {}

extension VideoQuerySortBy on QueryBuilder<Video, Video, QSortBy> {
  QueryBuilder<Video, Video, QAfterSortBy> sortByAnilistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anilistId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByAnilistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anilistId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByColorThemeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorThemeValue', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByColorThemeValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorThemeValue', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByCoverImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImagePath', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByCoverImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImagePath', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episode', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByEpisodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episode', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByImdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByImdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdult', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsAdultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdult', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsAnime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnime', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsAnimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnime', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsMovieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsResearchDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResearchDone', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsResearchDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResearchDone', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsUnverified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUnverified', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByIsUnverifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUnverified', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByMalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByNameJumaku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameJumaku', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByNameJumakuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameJumaku', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByPathSubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathSubtitle', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByPathSubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathSubtitle', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByPipelineIndetificator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipelineIndetificator', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByPipelineIndetificatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipelineIndetificator', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByResearchInformation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'researchInformation', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByResearchInformationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'researchInformation', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortBySeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortBySeasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortBySeriesName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortBySeriesNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByShikimoriId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shikimoriId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByShikimoriIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shikimoriId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortBySubtitleFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitleFileName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortBySubtitleFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitleFileName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTextFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textFormat', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTextFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textFormat', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByThetvdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thetvdbId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByThetvdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thetvdbId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTotalEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEpisodes', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTotalEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEpisodes', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTranslatedLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedLanguage', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTranslatedLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedLanguage', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTvmazeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvmazeId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByTvmazeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvmazeId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }
}

extension VideoQuerySortThenBy on QueryBuilder<Video, Video, QSortThenBy> {
  QueryBuilder<Video, Video, QAfterSortBy> thenByAnilistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anilistId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByAnilistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anilistId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByColorThemeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorThemeValue', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByColorThemeValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorThemeValue', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByCoverImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImagePath', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByCoverImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImagePath', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episode', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByEpisodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episode', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByImdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByImdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imdbId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdult', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsAdultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdult', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsAnime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnime', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsAnimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnime', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsMovieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsResearchDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResearchDone', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsResearchDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResearchDone', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsUnverified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUnverified', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByIsUnverifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUnverified', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByMalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByNameJumaku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameJumaku', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByNameJumakuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameJumaku', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByOriginalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByOriginalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByPathSubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathSubtitle', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByPathSubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathSubtitle', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByPipelineIndetificator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipelineIndetificator', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByPipelineIndetificatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipelineIndetificator', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByResearchInformation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'researchInformation', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByResearchInformationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'researchInformation', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenBySeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenBySeasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenBySeriesName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenBySeriesNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByShikimoriId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shikimoriId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByShikimoriIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shikimoriId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenBySubtitleFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitleFileName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenBySubtitleFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitleFileName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTextFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textFormat', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTextFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textFormat', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByThetvdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thetvdbId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByThetvdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thetvdbId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTotalEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEpisodes', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTotalEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEpisodes', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTranslatedLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedLanguage', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTranslatedLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedLanguage', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTvmazeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvmazeId', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByTvmazeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvmazeId', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }
}

extension VideoQueryWhereDistinct on QueryBuilder<Video, Video, QDistinct> {
  QueryBuilder<Video, Video, QDistinct> distinctByAnilistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'anilistId');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByBannerImage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bannerImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByColorThemeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorThemeValue');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByCoverImagePath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'coverImagePath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByEpisode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByFileName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByImdbId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imdbId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByIsAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAdult');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByIsAnime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAnime');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMovie');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByIsResearchDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isResearchDone');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByIsUnverified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUnverified');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'malId');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByNameJumaku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameJumaku', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByOriginalLanguage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'originalLanguage',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByOriginalName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByPathSubtitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pathSubtitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByPipelineIndetificator({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'pipelineIndetificator',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByResearchInformation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'researchInformation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctBySeason({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'season', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctBySeriesName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seriesName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByShikimoriId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shikimoriId');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctBySubtitleFileName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'subtitleFileName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByTextFormat({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByThetvdbId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thetvdbId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByTmdbId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByTotalEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalEpisodes');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByTranslatedLanguage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'translatedLanguage',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByTvmazeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvmazeId');
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByVideoPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoPath', caseSensitive: caseSensitive);
    });
  }
}

extension VideoQueryProperty on QueryBuilder<Video, Video, QQueryProperty> {
  QueryBuilder<Video, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Video, int?, QQueryOperations> anilistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'anilistId');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> bannerImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bannerImage');
    });
  }

  QueryBuilder<Video, int?, QQueryOperations> colorThemeValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorThemeValue');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> coverImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverImagePath');
    });
  }

  QueryBuilder<Video, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> episodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episode');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<Video, List<String>?, QQueryOperations> genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> imdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imdbId');
    });
  }

  QueryBuilder<Video, bool?, QQueryOperations> isAdultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAdult');
    });
  }

  QueryBuilder<Video, bool?, QQueryOperations> isAnimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAnime');
    });
  }

  QueryBuilder<Video, bool?, QQueryOperations> isMovieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMovie');
    });
  }

  QueryBuilder<Video, bool?, QQueryOperations> isResearchDoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isResearchDone');
    });
  }

  QueryBuilder<Video, bool?, QQueryOperations> isUnverifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUnverified');
    });
  }

  QueryBuilder<Video, int?, QQueryOperations> malIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'malId');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> nameJumakuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameJumaku');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> originalLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalLanguage');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> originalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalName');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> pathSubtitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pathSubtitle');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations>
  pipelineIndetificatorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pipelineIndetificator');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> researchInformationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'researchInformation');
    });
  }

  QueryBuilder<Video, double?, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> seasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'season');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> seriesNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seriesName');
    });
  }

  QueryBuilder<Video, int?, QQueryOperations> shikimoriIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shikimoriId');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> subtitleFileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtitleFileName');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> textFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textFormat');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> thetvdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thetvdbId');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<Video, int?, QQueryOperations> totalEpisodesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalEpisodes');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> translatedLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedLanguage');
    });
  }

  QueryBuilder<Video, int?, QQueryOperations> tvmazeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvmazeId');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> videoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoPath');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AiStageHistorySchema = Schema(
  name: r'AiStageHistory',
  id: -2286225573989994230,
  properties: {
    r'durationMs': PropertySchema(
      id: 0,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'modelName': PropertySchema(
      id: 1,
      name: r'modelName',
      type: IsarType.string,
    ),
    r'stageName': PropertySchema(
      id: 2,
      name: r'stageName',
      type: IsarType.string,
    ),
    r'status': PropertySchema(id: 3, name: r'status', type: IsarType.string),
  },

  estimateSize: _aiStageHistoryEstimateSize,
  serialize: _aiStageHistorySerialize,
  deserialize: _aiStageHistoryDeserialize,
  deserializeProp: _aiStageHistoryDeserializeProp,
);

int _aiStageHistoryEstimateSize(
  AiStageHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.modelName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.stageName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _aiStageHistorySerialize(
  AiStageHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMs);
  writer.writeString(offsets[1], object.modelName);
  writer.writeString(offsets[2], object.stageName);
  writer.writeString(offsets[3], object.status);
}

AiStageHistory _aiStageHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AiStageHistory(
    durationMs: reader.readLongOrNull(offsets[0]),
    modelName: reader.readStringOrNull(offsets[1]),
    stageName: reader.readStringOrNull(offsets[2]),
    status: reader.readStringOrNull(offsets[3]),
  );
  return object;
}

P _aiStageHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AiStageHistoryQueryFilter
    on QueryBuilder<AiStageHistory, AiStageHistory, QFilterCondition> {
  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  durationMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'durationMs'),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  durationMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'durationMs'),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  durationMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationMs', value: value),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  durationMsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  durationMsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  durationMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'modelName'),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'modelName'),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'modelName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'modelName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'modelName', value: ''),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  modelNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'modelName', value: ''),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'stageName'),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'stageName'),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stageName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stageName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stageName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stageName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'stageName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'stageName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'stageName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'stageName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stageName', value: ''),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  stageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'stageName', value: ''),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'status'),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'status'),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<AiStageHistory, AiStageHistory, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }
}

extension AiStageHistoryQueryObject
    on QueryBuilder<AiStageHistory, AiStageHistory, QFilterCondition> {}
