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
    r'englishName': PropertySchema(
      id: 6,
      name: r'englishName',
      type: IsarType.string,
    ),
    r'episode': PropertySchema(id: 7, name: r'episode', type: IsarType.string),
    r'genres': PropertySchema(
      id: 8,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'isAdult': PropertySchema(id: 9, name: r'isAdult', type: IsarType.bool),
    r'isAnime': PropertySchema(id: 10, name: r'isAnime', type: IsarType.bool),
    r'isMovie': PropertySchema(id: 11, name: r'isMovie', type: IsarType.bool),
    r'isResearchDone': PropertySchema(
      id: 12,
      name: r'isResearchDone',
      type: IsarType.bool,
    ),
    r'isUnverified': PropertySchema(
      id: 13,
      name: r'isUnverified',
      type: IsarType.bool,
    ),
    r'japaneseName': PropertySchema(
      id: 14,
      name: r'japaneseName',
      type: IsarType.string,
    ),
    r'nameFileJumaku': PropertySchema(
      id: 15,
      name: r'nameFileJumaku',
      type: IsarType.string,
    ),
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
    r'pathSubtitle': PropertySchema(
      id: 18,
      name: r'pathSubtitle',
      type: IsarType.string,
    ),
    r'pipelineIndetificator': PropertySchema(
      id: 19,
      name: r'pipelineIndetificator',
      type: IsarType.string,
    ),
    r'researchInformation': PropertySchema(
      id: 20,
      name: r'researchInformation',
      type: IsarType.string,
    ),
    r'season': PropertySchema(id: 21, name: r'season', type: IsarType.string),
    r'textFormat': PropertySchema(
      id: 22,
      name: r'textFormat',
      type: IsarType.string,
    ),
    r'tmdbId': PropertySchema(id: 23, name: r'tmdbId', type: IsarType.string),
    r'translatedLanguage': PropertySchema(
      id: 24,
      name: r'translatedLanguage',
      type: IsarType.string,
    ),
    r'videoName': PropertySchema(
      id: 25,
      name: r'videoName',
      type: IsarType.string,
    ),
    r'videoPath': PropertySchema(
      id: 26,
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
    final value = object.englishName;
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
    final value = object.japaneseName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nameFileJumaku;
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
    final value = object.textFormat;
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
    final value = object.videoName;
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
  writer.writeString(offsets[6], object.englishName);
  writer.writeString(offsets[7], object.episode);
  writer.writeStringList(offsets[8], object.genres);
  writer.writeBool(offsets[9], object.isAdult);
  writer.writeBool(offsets[10], object.isAnime);
  writer.writeBool(offsets[11], object.isMovie);
  writer.writeBool(offsets[12], object.isResearchDone);
  writer.writeBool(offsets[13], object.isUnverified);
  writer.writeString(offsets[14], object.japaneseName);
  writer.writeString(offsets[15], object.nameFileJumaku);
  writer.writeString(offsets[16], object.nameJumaku);
  writer.writeString(offsets[17], object.originalLanguage);
  writer.writeString(offsets[18], object.pathSubtitle);
  writer.writeString(offsets[19], object.pipelineIndetificator);
  writer.writeString(offsets[20], object.researchInformation);
  writer.writeString(offsets[21], object.season);
  writer.writeString(offsets[22], object.textFormat);
  writer.writeString(offsets[23], object.tmdbId);
  writer.writeString(offsets[24], object.translatedLanguage);
  writer.writeString(offsets[25], object.videoName);
  writer.writeString(offsets[26], object.videoPath);
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
  object.englishName = reader.readStringOrNull(offsets[6]);
  object.episode = reader.readStringOrNull(offsets[7]);
  object.genres = reader.readStringList(offsets[8]);
  object.id = id;
  object.isAdult = reader.readBoolOrNull(offsets[9]);
  object.isAnime = reader.readBoolOrNull(offsets[10]);
  object.isMovie = reader.readBoolOrNull(offsets[11]);
  object.isResearchDone = reader.readBoolOrNull(offsets[12]);
  object.isUnverified = reader.readBoolOrNull(offsets[13]);
  object.japaneseName = reader.readStringOrNull(offsets[14]);
  object.nameFileJumaku = reader.readStringOrNull(offsets[15]);
  object.nameJumaku = reader.readStringOrNull(offsets[16]);
  object.originalLanguage = reader.readStringOrNull(offsets[17]);
  object.pathSubtitle = reader.readStringOrNull(offsets[18]);
  object.pipelineIndetificator = reader.readStringOrNull(offsets[19]);
  object.researchInformation = reader.readStringOrNull(offsets[20]);
  object.season = reader.readStringOrNull(offsets[21]);
  object.textFormat = reader.readStringOrNull(offsets[22]);
  object.tmdbId = reader.readStringOrNull(offsets[23]);
  object.translatedLanguage = reader.readStringOrNull(offsets[24]);
  object.videoName = reader.readStringOrNull(offsets[25]);
  object.videoPath = reader.readStringOrNull(offsets[26]);
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
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readBoolOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
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
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
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

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'englishName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'englishName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'englishName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'englishName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'englishName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> englishNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'englishName', value: ''),
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

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'japaneseName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'japaneseName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'japaneseName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'japaneseName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'japaneseName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> japaneseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'japaneseName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nameFileJumaku'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nameFileJumaku'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nameFileJumaku',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nameFileJumaku',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nameFileJumaku', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> nameFileJumakuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nameFileJumaku', value: ''),
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

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'videoName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'videoName'),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'videoName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoName', value: ''),
      );
    });
  }

  QueryBuilder<Video, Video, QAfterFilterCondition> videoNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'videoName', value: ''),
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

  QueryBuilder<Video, Video, QAfterSortBy> sortByEnglishName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByEnglishNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishName', Sort.desc);
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

  QueryBuilder<Video, Video, QAfterSortBy> sortByJapaneseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'japaneseName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByJapaneseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'japaneseName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByNameFileJumaku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameFileJumaku', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByNameFileJumakuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameFileJumaku', Sort.desc);
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

  QueryBuilder<Video, Video, QAfterSortBy> sortByVideoName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> sortByVideoNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoName', Sort.desc);
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

  QueryBuilder<Video, Video, QAfterSortBy> thenByEnglishName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByEnglishNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishName', Sort.desc);
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

  QueryBuilder<Video, Video, QAfterSortBy> thenByJapaneseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'japaneseName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByJapaneseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'japaneseName', Sort.desc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByNameFileJumaku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameFileJumaku', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByNameFileJumakuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameFileJumaku', Sort.desc);
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

  QueryBuilder<Video, Video, QAfterSortBy> thenByVideoName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoName', Sort.asc);
    });
  }

  QueryBuilder<Video, Video, QAfterSortBy> thenByVideoNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoName', Sort.desc);
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

  QueryBuilder<Video, Video, QDistinct> distinctByEnglishName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'englishName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByEpisode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
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

  QueryBuilder<Video, Video, QDistinct> distinctByJapaneseName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'japaneseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByNameFileJumaku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'nameFileJumaku',
        caseSensitive: caseSensitive,
      );
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

  QueryBuilder<Video, Video, QDistinct> distinctBySeason({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'season', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByTextFormat({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Video, Video, QDistinct> distinctByTmdbId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId', caseSensitive: caseSensitive);
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

  QueryBuilder<Video, Video, QDistinct> distinctByVideoName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoName', caseSensitive: caseSensitive);
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

  QueryBuilder<Video, String?, QQueryOperations> englishNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'englishName');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> episodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episode');
    });
  }

  QueryBuilder<Video, List<String>?, QQueryOperations> genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
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

  QueryBuilder<Video, String?, QQueryOperations> japaneseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'japaneseName');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> nameFileJumakuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameFileJumaku');
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

  QueryBuilder<Video, String?, QQueryOperations> seasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'season');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> textFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textFormat');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> translatedLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedLanguage');
    });
  }

  QueryBuilder<Video, String?, QQueryOperations> videoNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoName');
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
