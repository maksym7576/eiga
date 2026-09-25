// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phrase.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPhraseCollection on Isar {
  IsarCollection<Phrase> get phrases => this.collection();
}

const PhraseSchema = CollectionSchema(
  name: r'Phrase',
  id: -3655984391187093744,
  properties: {
    r'endTime': PropertySchema(
      id: 0,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'idiomSpansIsar': PropertySchema(
      id: 1,
      name: r'idiomSpansIsar',
      type: IsarType.stringList,
    ),
    r'isActive': PropertySchema(id: 2, name: r'isActive', type: IsarType.bool),
    r'isSynced': PropertySchema(id: 3, name: r'isSynced', type: IsarType.bool),
    r'lastSyncedAt': PropertySchema(
      id: 4,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'linkGroups': PropertySchema(
      id: 5,
      name: r'linkGroups',
      type: IsarType.objectList,

      target: r'LinkGroup',
    ),
    r'originalPhrase': PropertySchema(
      id: 6,
      name: r'originalPhrase',
      type: IsarType.string,
    ),
    r'originalTokens': PropertySchema(
      id: 7,
      name: r'originalTokens',
      type: IsarType.objectList,

      target: r'TokenEntry',
    ),
    r'phraseOrder': PropertySchema(
      id: 8,
      name: r'phraseOrder',
      type: IsarType.long,
    ),
    r'stageKeys': PropertySchema(
      id: 9,
      name: r'stageKeys',
      type: IsarType.stringList,
    ),
    r'stageValues': PropertySchema(
      id: 10,
      name: r'stageValues',
      type: IsarType.stringList,
    ),
    r'startTime': PropertySchema(
      id: 11,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'translatedPhrase': PropertySchema(
      id: 12,
      name: r'translatedPhrase',
      type: IsarType.string,
    ),
    r'translatedWords': PropertySchema(
      id: 13,
      name: r'translatedWords',
      type: IsarType.objectList,

      target: r'TranslationTokenEntry',
    ),
    r'videoId': PropertySchema(id: 14, name: r'videoId', type: IsarType.long),
  },

  estimateSize: _phraseEstimateSize,
  serialize: _phraseSerialize,
  deserialize: _phraseDeserialize,
  deserializeProp: _phraseDeserializeProp,
  idName: r'id',
  indexes: {
    r'videoId_phraseOrder': IndexSchema(
      id: -1645952549077780234,
      name: r'videoId_phraseOrder',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'videoId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'phraseOrder',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'originalPhrase': IndexSchema(
      id: 494614094168722199,
      name: r'originalPhrase',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'originalPhrase',
          type: IndexType.value,
          caseSensitive: true,
        ),
      ],
    ),
    r'translatedPhrase': IndexSchema(
      id: 7440086370273614602,
      name: r'translatedPhrase',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'translatedPhrase',
          type: IndexType.value,
          caseSensitive: true,
        ),
      ],
    ),
    r'startTime': IndexSchema(
      id: -3870335341264752872,
      name: r'startTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startTime',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'endTime': IndexSchema(
      id: 6854976694250177488,
      name: r'endTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'endTime',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {
    r'TokenEntry': TokenEntrySchema,
    r'ReadingItem': ReadingItemSchema,
    r'TranslationTokenEntry': TranslationTokenEntrySchema,
    r'LinkGroup': LinkGroupSchema,
  },

  getId: _phraseGetId,
  getLinks: _phraseGetLinks,
  attach: _phraseAttach,
  version: '3.3.2',
);

int _phraseEstimateSize(
  Phrase object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.idiomSpansIsar.length * 3;
  {
    for (var i = 0; i < object.idiomSpansIsar.length; i++) {
      final value = object.idiomSpansIsar[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final list = object.linkGroups;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[LinkGroup]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += LinkGroupSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.originalPhrase;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.originalTokens;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[TokenEntry]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += TokenEntrySchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  bytesCount += 3 + object.stageKeys.length * 3;
  {
    for (var i = 0; i < object.stageKeys.length; i++) {
      final value = object.stageKeys[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.stageValues.length * 3;
  {
    for (var i = 0; i < object.stageValues.length; i++) {
      final value = object.stageValues[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.translatedPhrase;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.translatedWords;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[TranslationTokenEntry]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += TranslationTokenEntrySchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  return bytesCount;
}

void _phraseSerialize(
  Phrase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endTime);
  writer.writeStringList(offsets[1], object.idiomSpansIsar);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeBool(offsets[3], object.isSynced);
  writer.writeDateTime(offsets[4], object.lastSyncedAt);
  writer.writeObjectList<LinkGroup>(
    offsets[5],
    allOffsets,
    LinkGroupSchema.serialize,
    object.linkGroups,
  );
  writer.writeString(offsets[6], object.originalPhrase);
  writer.writeObjectList<TokenEntry>(
    offsets[7],
    allOffsets,
    TokenEntrySchema.serialize,
    object.originalTokens,
  );
  writer.writeLong(offsets[8], object.phraseOrder);
  writer.writeStringList(offsets[9], object.stageKeys);
  writer.writeStringList(offsets[10], object.stageValues);
  writer.writeDateTime(offsets[11], object.startTime);
  writer.writeString(offsets[12], object.translatedPhrase);
  writer.writeObjectList<TranslationTokenEntry>(
    offsets[13],
    allOffsets,
    TranslationTokenEntrySchema.serialize,
    object.translatedWords,
  );
  writer.writeLong(offsets[14], object.videoId);
}

Phrase _phraseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Phrase(
    endTime: reader.readDateTimeOrNull(offsets[0]),
    isActive: reader.readBoolOrNull(offsets[2]) ?? false,
    linkGroups: reader.readObjectList<LinkGroup>(
      offsets[5],
      LinkGroupSchema.deserialize,
      allOffsets,
      LinkGroup(),
    ),
    originalPhrase: reader.readStringOrNull(offsets[6]),
    originalTokens: reader.readObjectList<TokenEntry>(
      offsets[7],
      TokenEntrySchema.deserialize,
      allOffsets,
      TokenEntry(),
    ),
    phraseOrder: reader.readLongOrNull(offsets[8]),
    startTime: reader.readDateTimeOrNull(offsets[11]),
    translatedPhrase: reader.readStringOrNull(offsets[12]),
    translatedWords: reader.readObjectList<TranslationTokenEntry>(
      offsets[13],
      TranslationTokenEntrySchema.deserialize,
      allOffsets,
      TranslationTokenEntry(),
    ),
    videoId: reader.readLongOrNull(offsets[14]),
  );
  object.id = id;
  object.idiomSpansIsar = reader.readStringList(offsets[1]) ?? [];
  object.isSynced = reader.readBool(offsets[3]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[4]);
  object.stageKeys = reader.readStringList(offsets[9]) ?? [];
  object.stageValues = reader.readStringList(offsets[10]) ?? [];
  return object;
}

P _phraseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readObjectList<LinkGroup>(
            offset,
            LinkGroupSchema.deserialize,
            allOffsets,
            LinkGroup(),
          ))
          as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readObjectList<TokenEntry>(
            offset,
            TokenEntrySchema.deserialize,
            allOffsets,
            TokenEntry(),
          ))
          as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringList(offset) ?? []) as P;
    case 10:
      return (reader.readStringList(offset) ?? []) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readObjectList<TranslationTokenEntry>(
            offset,
            TranslationTokenEntrySchema.deserialize,
            allOffsets,
            TranslationTokenEntry(),
          ))
          as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _phraseGetId(Phrase object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _phraseGetLinks(Phrase object) {
  return [];
}

void _phraseAttach(IsarCollection<dynamic> col, Id id, Phrase object) {
  object.id = id;
}

extension PhraseQueryWhereSort on QueryBuilder<Phrase, Phrase, QWhere> {
  QueryBuilder<Phrase, Phrase, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhere> anyVideoIdPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'videoId_phraseOrder'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhere> anyOriginalPhrase() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'originalPhrase'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhere> anyTranslatedPhrase() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'translatedPhrase'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhere> anyStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startTime'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhere> anyEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'endTime'),
      );
    });
  }
}

extension PhraseQueryWhere on QueryBuilder<Phrase, Phrase, QWhereClause> {
  QueryBuilder<Phrase, Phrase, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> idBetween(
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

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdIsNullAnyPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'videoId_phraseOrder',
          value: [null],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdIsNotNullAnyPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId_phraseOrder',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdEqualToAnyPhraseOrder(
    int? videoId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'videoId_phraseOrder',
          value: [videoId],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdNotEqualToAnyPhraseOrder(int? videoId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId_phraseOrder',
                lower: [],
                upper: [videoId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId_phraseOrder',
                lower: [videoId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId_phraseOrder',
                lower: [videoId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId_phraseOrder',
                lower: [],
                upper: [videoId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdGreaterThanAnyPhraseOrder(int? videoId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId_phraseOrder',
          lower: [videoId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdLessThanAnyPhraseOrder(
    int? videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId_phraseOrder',
          lower: [],
          upper: [videoId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdBetweenAnyPhraseOrder(
    int? lowerVideoId,
    int? upperVideoId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId_phraseOrder',
          lower: [lowerVideoId],
          includeLower: includeLower,
          upper: [upperVideoId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdEqualToPhraseOrderIsNull(int? videoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'videoId_phraseOrder',
          value: [videoId, null],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdEqualToPhraseOrderIsNotNull(int? videoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId_phraseOrder',
          lower: [videoId, null],
          includeLower: false,
          upper: [videoId],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdPhraseOrderEqualTo(
    int? videoId,
    int? phraseOrder,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'videoId_phraseOrder',
          value: [videoId, phraseOrder],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdEqualToPhraseOrderNotEqualTo(int? videoId, int? phraseOrder) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId_phraseOrder',
                lower: [videoId],
                upper: [videoId, phraseOrder],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId_phraseOrder',
                lower: [videoId, phraseOrder],
                includeLower: false,
                upper: [videoId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId_phraseOrder',
                lower: [videoId, phraseOrder],
                includeLower: false,
                upper: [videoId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId_phraseOrder',
                lower: [videoId],
                upper: [videoId, phraseOrder],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdEqualToPhraseOrderGreaterThan(
    int? videoId,
    int? phraseOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId_phraseOrder',
          lower: [videoId, phraseOrder],
          includeLower: include,
          upper: [videoId],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdEqualToPhraseOrderLessThan(
    int? videoId,
    int? phraseOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId_phraseOrder',
          lower: [videoId],
          upper: [videoId, phraseOrder],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause>
  videoIdEqualToPhraseOrderBetween(
    int? videoId,
    int? lowerPhraseOrder,
    int? upperPhraseOrder, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId_phraseOrder',
          lower: [videoId, lowerPhraseOrder],
          includeLower: includeLower,
          upper: [videoId, upperPhraseOrder],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'originalPhrase', value: [null]),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'originalPhrase',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseEqualTo(
    String? originalPhrase,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'originalPhrase',
          value: [originalPhrase],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseNotEqualTo(
    String? originalPhrase,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'originalPhrase',
                lower: [],
                upper: [originalPhrase],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'originalPhrase',
                lower: [originalPhrase],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'originalPhrase',
                lower: [originalPhrase],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'originalPhrase',
                lower: [],
                upper: [originalPhrase],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseGreaterThan(
    String? originalPhrase, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'originalPhrase',
          lower: [originalPhrase],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseLessThan(
    String? originalPhrase, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'originalPhrase',
          lower: [],
          upper: [originalPhrase],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseBetween(
    String? lowerOriginalPhrase,
    String? upperOriginalPhrase, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'originalPhrase',
          lower: [lowerOriginalPhrase],
          includeLower: includeLower,
          upper: [upperOriginalPhrase],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseStartsWith(
    String OriginalPhrasePrefix,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'originalPhrase',
          lower: [OriginalPhrasePrefix],
          upper: ['$OriginalPhrasePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'originalPhrase', value: ['']),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> originalPhraseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(
                indexName: r'originalPhrase',
                upper: [''],
              ),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'originalPhrase',
                lower: [''],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'originalPhrase',
                lower: [''],
              ),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(
                indexName: r'originalPhrase',
                upper: [''],
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'translatedPhrase', value: [null]),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'translatedPhrase',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseEqualTo(
    String? translatedPhrase,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'translatedPhrase',
          value: [translatedPhrase],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseNotEqualTo(
    String? translatedPhrase,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'translatedPhrase',
                lower: [],
                upper: [translatedPhrase],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'translatedPhrase',
                lower: [translatedPhrase],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'translatedPhrase',
                lower: [translatedPhrase],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'translatedPhrase',
                lower: [],
                upper: [translatedPhrase],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseGreaterThan(
    String? translatedPhrase, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'translatedPhrase',
          lower: [translatedPhrase],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseLessThan(
    String? translatedPhrase, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'translatedPhrase',
          lower: [],
          upper: [translatedPhrase],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseBetween(
    String? lowerTranslatedPhrase,
    String? upperTranslatedPhrase, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'translatedPhrase',
          lower: [lowerTranslatedPhrase],
          includeLower: includeLower,
          upper: [upperTranslatedPhrase],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseStartsWith(
    String TranslatedPhrasePrefix,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'translatedPhrase',
          lower: [TranslatedPhrasePrefix],
          upper: ['$TranslatedPhrasePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'translatedPhrase', value: ['']),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> translatedPhraseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(
                indexName: r'translatedPhrase',
                upper: [''],
              ),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'translatedPhrase',
                lower: [''],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'translatedPhrase',
                lower: [''],
              ),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(
                indexName: r'translatedPhrase',
                upper: [''],
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'startTime', value: [null]),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startTime',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> startTimeEqualTo(
    DateTime? startTime,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'startTime', value: [startTime]),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> startTimeNotEqualTo(
    DateTime? startTime,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startTime',
                lower: [],
                upper: [startTime],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startTime',
                lower: [startTime],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startTime',
                lower: [startTime],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startTime',
                lower: [],
                upper: [startTime],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> startTimeGreaterThan(
    DateTime? startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startTime',
          lower: [startTime],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> startTimeLessThan(
    DateTime? startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startTime',
          lower: [],
          upper: [startTime],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> startTimeBetween(
    DateTime? lowerStartTime,
    DateTime? upperStartTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startTime',
          lower: [lowerStartTime],
          includeLower: includeLower,
          upper: [upperStartTime],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'endTime', value: [null]),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'endTime',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> endTimeEqualTo(
    DateTime? endTime,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'endTime', value: [endTime]),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> endTimeNotEqualTo(
    DateTime? endTime,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'endTime',
                lower: [],
                upper: [endTime],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'endTime',
                lower: [endTime],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'endTime',
                lower: [endTime],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'endTime',
                lower: [],
                upper: [endTime],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> endTimeGreaterThan(
    DateTime? endTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'endTime',
          lower: [endTime],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> endTimeLessThan(
    DateTime? endTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'endTime',
          lower: [],
          upper: [endTime],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> endTimeBetween(
    DateTime? lowerEndTime,
    DateTime? upperEndTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'endTime',
          lower: [lowerEndTime],
          includeLower: includeLower,
          upper: [upperEndTime],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PhraseQueryFilter on QueryBuilder<Phrase, Phrase, QFilterCondition> {
  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'endTime'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'endTime'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> endTimeEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endTime', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'idiomSpansIsar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'idiomSpansIsar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'idiomSpansIsar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'idiomSpansIsar',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'idiomSpansIsar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'idiomSpansIsar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'idiomSpansIsar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'idiomSpansIsar',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'idiomSpansIsar', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'idiomSpansIsar', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'idiomSpansIsar', length, true, length, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> idiomSpansIsarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'idiomSpansIsar', 0, true, 0, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'idiomSpansIsar', 0, false, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'idiomSpansIsar', 0, true, length, include);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'idiomSpansIsar', length, include, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  idiomSpansIsarLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'idiomSpansIsar',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> isActiveEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> isSyncedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSynced', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSyncedAt'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSyncedAt'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> lastSyncedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSyncedAt', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> lastSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSyncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> lastSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSyncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSyncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> linkGroupsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'linkGroups'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> linkGroupsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'linkGroups'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> linkGroupsLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'linkGroups', length, true, length, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> linkGroupsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'linkGroups', 0, true, 0, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> linkGroupsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'linkGroups', 0, false, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> linkGroupsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'linkGroups', 0, true, length, include);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  linkGroupsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'linkGroups', length, include, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> linkGroupsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkGroups',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'originalPhrase'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  originalPhraseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'originalPhrase'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'originalPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'originalPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'originalPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'originalPhrase',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'originalPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'originalPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'originalPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'originalPhrase',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalPhraseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'originalPhrase', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  originalPhraseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'originalPhrase', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalTokensIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'originalTokens'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  originalTokensIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'originalTokens'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  originalTokensLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'originalTokens', length, true, length, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalTokensIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'originalTokens', 0, true, 0, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  originalTokensIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'originalTokens', 0, false, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  originalTokensLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'originalTokens', 0, true, length, include);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  originalTokensLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'originalTokens', length, include, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  originalTokensLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'originalTokens',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> phraseOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'phraseOrder'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> phraseOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'phraseOrder'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> phraseOrderEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phraseOrder', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> phraseOrderGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phraseOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> phraseOrderLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phraseOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> phraseOrderBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phraseOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stageKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageKeysElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stageKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stageKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stageKeys',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageKeysElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'stageKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'stageKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'stageKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'stageKeys',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageKeysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stageKeys', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageKeysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'stageKeys', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageKeys', length, true, length, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageKeys', 0, true, 0, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageKeys', 0, false, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageKeys', 0, true, length, include);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageKeysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageKeys', length, include, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageKeysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stageKeys',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageValuesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'stageValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageValuesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stageValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageValuesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stageValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageValuesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stageValues',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageValuesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'stageValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageValuesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'stageValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageValuesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'stageValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageValuesElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'stageValues',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageValuesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stageValues', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageValuesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'stageValues', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageValuesLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageValues', length, true, length, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageValuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageValues', 0, true, 0, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageValuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageValues', 0, false, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageValuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageValues', 0, true, length, include);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  stageValuesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageValues', length, include, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> stageValuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stageValues',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startTime'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startTime'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> startTimeEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startTime', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> startTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> startTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> startTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedPhraseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'translatedPhrase'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedPhraseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'translatedPhrase'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedPhraseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'translatedPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedPhraseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'translatedPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedPhraseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'translatedPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedPhraseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'translatedPhrase',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedPhraseStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'translatedPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedPhraseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'translatedPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedPhraseContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'translatedPhrase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedPhraseMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'translatedPhrase',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedPhraseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'translatedPhrase', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedPhraseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'translatedPhrase', value: ''),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedWordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'translatedWords'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedWordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'translatedWords'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedWords', length, true, length, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedWords', 0, true, 0, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedWords', 0, false, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedWordsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedWords', 0, true, length, include);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedWordsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> videoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'videoId'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> videoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'videoId'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> videoIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoId', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> videoIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> videoIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> videoIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PhraseQueryObject on QueryBuilder<Phrase, Phrase, QFilterCondition> {
  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> linkGroupsElement(
    FilterQuery<LinkGroup> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'linkGroups');
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> originalTokensElement(
    FilterQuery<TokenEntry> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'originalTokens');
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedWordsElement(
    FilterQuery<TranslationTokenEntry> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'translatedWords');
    });
  }
}

extension PhraseQueryLinks on QueryBuilder<Phrase, Phrase, QFilterCondition> {}

extension PhraseQuerySortBy on QueryBuilder<Phrase, Phrase, QSortBy> {
  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByOriginalPhrase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPhrase', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByOriginalPhraseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPhrase', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseOrder', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByPhraseOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseOrder', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByTranslatedPhrase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedPhrase', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByTranslatedPhraseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedPhrase', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension PhraseQuerySortThenBy on QueryBuilder<Phrase, Phrase, QSortThenBy> {
  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByOriginalPhrase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPhrase', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByOriginalPhraseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPhrase', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseOrder', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByPhraseOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseOrder', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByTranslatedPhrase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedPhrase', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByTranslatedPhraseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedPhrase', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension PhraseQueryWhereDistinct on QueryBuilder<Phrase, Phrase, QDistinct> {
  QueryBuilder<Phrase, Phrase, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByIdiomSpansIsar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idiomSpansIsar');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByOriginalPhrase({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'originalPhrase',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phraseOrder');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByStageKeys() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stageKeys');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByStageValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stageValues');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByTranslatedPhrase({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'translatedPhrase',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoId');
    });
  }
}

extension PhraseQueryProperty on QueryBuilder<Phrase, Phrase, QQueryProperty> {
  QueryBuilder<Phrase, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Phrase, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<Phrase, List<String>, QQueryOperations>
  idiomSpansIsarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idiomSpansIsar');
    });
  }

  QueryBuilder<Phrase, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<Phrase, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<Phrase, DateTime?, QQueryOperations> lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<Phrase, List<LinkGroup>?, QQueryOperations>
  linkGroupsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkGroups');
    });
  }

  QueryBuilder<Phrase, String?, QQueryOperations> originalPhraseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalPhrase');
    });
  }

  QueryBuilder<Phrase, List<TokenEntry>?, QQueryOperations>
  originalTokensProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalTokens');
    });
  }

  QueryBuilder<Phrase, int?, QQueryOperations> phraseOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phraseOrder');
    });
  }

  QueryBuilder<Phrase, List<String>, QQueryOperations> stageKeysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stageKeys');
    });
  }

  QueryBuilder<Phrase, List<String>, QQueryOperations> stageValuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stageValues');
    });
  }

  QueryBuilder<Phrase, DateTime?, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<Phrase, String?, QQueryOperations> translatedPhraseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedPhrase');
    });
  }

  QueryBuilder<Phrase, List<TranslationTokenEntry>?, QQueryOperations>
  translatedWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedWords');
    });
  }

  QueryBuilder<Phrase, int?, QQueryOperations> videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoId');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const LinkGroupSchema = Schema(
  name: r'LinkGroup',
  id: 6319180353830571810,
  properties: {
    r'groupId': PropertySchema(id: 0, name: r'groupId', type: IsarType.long),
    r'headSourcePosition': PropertySchema(
      id: 1,
      name: r'headSourcePosition',
      type: IsarType.long,
    ),
    r'isIdiom': PropertySchema(id: 2, name: r'isIdiom', type: IsarType.bool),
    r'relatedGroupIds': PropertySchema(
      id: 3,
      name: r'relatedGroupIds',
      type: IsarType.longList,
    ),
    r'sourcePositions': PropertySchema(
      id: 4,
      name: r'sourcePositions',
      type: IsarType.longList,
    ),
    r'targetPositions': PropertySchema(
      id: 5,
      name: r'targetPositions',
      type: IsarType.longList,
    ),
  },

  estimateSize: _linkGroupEstimateSize,
  serialize: _linkGroupSerialize,
  deserialize: _linkGroupDeserialize,
  deserializeProp: _linkGroupDeserializeProp,
);

int _linkGroupEstimateSize(
  LinkGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.relatedGroupIds.length * 8;
  bytesCount += 3 + object.sourcePositions.length * 8;
  bytesCount += 3 + object.targetPositions.length * 8;
  return bytesCount;
}

void _linkGroupSerialize(
  LinkGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.groupId);
  writer.writeLong(offsets[1], object.headSourcePosition);
  writer.writeBool(offsets[2], object.isIdiom);
  writer.writeLongList(offsets[3], object.relatedGroupIds);
  writer.writeLongList(offsets[4], object.sourcePositions);
  writer.writeLongList(offsets[5], object.targetPositions);
}

LinkGroup _linkGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LinkGroup(
    groupId: reader.readLongOrNull(offsets[0]),
    headSourcePosition: reader.readLongOrNull(offsets[1]),
    isIdiom: reader.readBoolOrNull(offsets[2]) ?? false,
    relatedGroupIds: reader.readLongList(offsets[3]) ?? const [],
    sourcePositions: reader.readLongList(offsets[4]) ?? const [],
    targetPositions: reader.readLongList(offsets[5]) ?? const [],
  );
  return object;
}

P _linkGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readLongList(offset) ?? const []) as P;
    case 4:
      return (reader.readLongList(offset) ?? const []) as P;
    case 5:
      return (reader.readLongList(offset) ?? const []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension LinkGroupQueryFilter
    on QueryBuilder<LinkGroup, LinkGroup, QFilterCondition> {
  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition> groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'groupId'),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition> groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'groupId'),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition> groupIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'groupId', value: value),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition> groupIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'groupId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition> groupIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'groupId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition> groupIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'groupId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  headSourcePositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'headSourcePosition'),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  headSourcePositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'headSourcePosition'),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  headSourcePositionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'headSourcePosition', value: value),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  headSourcePositionGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'headSourcePosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  headSourcePositionLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'headSourcePosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  headSourcePositionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'headSourcePosition',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition> isIdiomEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isIdiom', value: value),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'relatedGroupIds', value: value),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relatedGroupIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relatedGroupIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relatedGroupIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relatedGroupIds', length, true, length, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relatedGroupIds', 0, true, 0, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relatedGroupIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'relatedGroupIds', 0, true, length, include);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relatedGroupIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  relatedGroupIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relatedGroupIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourcePositions', value: value),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourcePositions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourcePositions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourcePositions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourcePositions', length, true, length, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourcePositions', 0, true, 0, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourcePositions', 0, false, 999999, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourcePositions', 0, true, length, include);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourcePositions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  sourcePositionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourcePositions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetPositions', value: value),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetPositions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetPositions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetPositions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'targetPositions', length, true, length, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'targetPositions', 0, true, 0, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'targetPositions', 0, false, 999999, true);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'targetPositions', 0, true, length, include);
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'targetPositions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LinkGroup, LinkGroup, QAfterFilterCondition>
  targetPositionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'targetPositions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension LinkGroupQueryObject
    on QueryBuilder<LinkGroup, LinkGroup, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TokenEntrySchema = Schema(
  name: r'TokenEntry',
  id: -1817502199596935943,
  properties: {
    r'aspect': PropertySchema(
      id: 0,
      name: r'aspect',
      type: IsarType.byte,
      enumMap: _TokenEntryaspectEnumValueMap,
    ),
    r'attachMode': PropertySchema(
      id: 1,
      name: r'attachMode',
      type: IsarType.byte,
      enumMap: _TokenEntryattachModeEnumValueMap,
    ),
    r'blockId': PropertySchema(id: 2, name: r'blockId', type: IsarType.long),
    r'grammarCode': PropertySchema(
      id: 3,
      name: r'grammarCode',
      type: IsarType.string,
    ),
    r'grammarFunction': PropertySchema(
      id: 4,
      name: r'grammarFunction',
      type: IsarType.byte,
      enumMap: _TokenEntrygrammarFunctionEnumValueMap,
    ),
    r'groupRole': PropertySchema(
      id: 5,
      name: r'groupRole',
      type: IsarType.byte,
      enumMap: _TokenEntrygroupRoleEnumValueMap,
    ),
    r'headPosition': PropertySchema(
      id: 6,
      name: r'headPosition',
      type: IsarType.long,
    ),
    r'isClickable': PropertySchema(
      id: 7,
      name: r'isClickable',
      type: IsarType.bool,
    ),
    r'lemma': PropertySchema(id: 8, name: r'lemma', type: IsarType.string),
    r'linkGroupId': PropertySchema(
      id: 9,
      name: r'linkGroupId',
      type: IsarType.long,
    ),
    r'modality': PropertySchema(
      id: 10,
      name: r'modality',
      type: IsarType.byte,
      enumMap: _TokenEntrymodalityEnumValueMap,
    ),
    r'polarity': PropertySchema(
      id: 11,
      name: r'polarity',
      type: IsarType.byte,
      enumMap: _TokenEntrypolarityEnumValueMap,
    ),
    r'politeness': PropertySchema(
      id: 12,
      name: r'politeness',
      type: IsarType.byte,
      enumMap: _TokenEntrypolitenessEnumValueMap,
    ),
    r'pos': PropertySchema(
      id: 13,
      name: r'pos',
      type: IsarType.byte,
      enumMap: _TokenEntryposEnumValueMap,
    ),
    r'relationLabel': PropertySchema(
      id: 14,
      name: r'relationLabel',
      type: IsarType.string,
    ),
    r'surface': PropertySchema(id: 15, name: r'surface', type: IsarType.string),
    r'tense': PropertySchema(
      id: 16,
      name: r'tense',
      type: IsarType.byte,
      enumMap: _TokenEntrytenseEnumValueMap,
    ),
    r'versions': PropertySchema(
      id: 17,
      name: r'versions',
      type: IsarType.objectList,

      target: r'ReadingItem',
    ),
    r'wordPosition': PropertySchema(
      id: 18,
      name: r'wordPosition',
      type: IsarType.long,
    ),
  },

  estimateSize: _tokenEntryEstimateSize,
  serialize: _tokenEntrySerialize,
  deserialize: _tokenEntryDeserialize,
  deserializeProp: _tokenEntryDeserializeProp,
);

int _tokenEntryEstimateSize(
  TokenEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.grammarCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lemma;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.relationLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.surface;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.versions.length * 3;
  {
    final offsets = allOffsets[ReadingItem]!;
    for (var i = 0; i < object.versions.length; i++) {
      final value = object.versions[i];
      bytesCount += ReadingItemSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _tokenEntrySerialize(
  TokenEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.aspect.index);
  writer.writeByte(offsets[1], object.attachMode.index);
  writer.writeLong(offsets[2], object.blockId);
  writer.writeString(offsets[3], object.grammarCode);
  writer.writeByte(offsets[4], object.grammarFunction.index);
  writer.writeByte(offsets[5], object.groupRole.index);
  writer.writeLong(offsets[6], object.headPosition);
  writer.writeBool(offsets[7], object.isClickable);
  writer.writeString(offsets[8], object.lemma);
  writer.writeLong(offsets[9], object.linkGroupId);
  writer.writeByte(offsets[10], object.modality.index);
  writer.writeByte(offsets[11], object.polarity.index);
  writer.writeByte(offsets[12], object.politeness.index);
  writer.writeByte(offsets[13], object.pos.index);
  writer.writeString(offsets[14], object.relationLabel);
  writer.writeString(offsets[15], object.surface);
  writer.writeByte(offsets[16], object.tense.index);
  writer.writeObjectList<ReadingItem>(
    offsets[17],
    allOffsets,
    ReadingItemSchema.serialize,
    object.versions,
  );
  writer.writeLong(offsets[18], object.wordPosition);
}

TokenEntry _tokenEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TokenEntry(
    aspect:
        _TokenEntryaspectValueEnumMap[reader.readByteOrNull(offsets[0])] ??
        Aspect.none,
    attachMode:
        _TokenEntryattachModeValueEnumMap[reader.readByteOrNull(offsets[1])] ??
        AttachMode.none,
    blockId: reader.readLongOrNull(offsets[2]),
    grammarCode: reader.readStringOrNull(offsets[3]),
    grammarFunction:
        _TokenEntrygrammarFunctionValueEnumMap[reader.readByteOrNull(
          offsets[4],
        )] ??
        GrammarFunction.none,
    groupRole:
        _TokenEntrygroupRoleValueEnumMap[reader.readByteOrNull(offsets[5])] ??
        GroupRole.head,
    headPosition: reader.readLongOrNull(offsets[6]),
    isClickable: reader.readBoolOrNull(offsets[7]) ?? true,
    lemma: reader.readStringOrNull(offsets[8]),
    linkGroupId: reader.readLongOrNull(offsets[9]),
    modality:
        _TokenEntrymodalityValueEnumMap[reader.readByteOrNull(offsets[10])] ??
        Modality.none,
    polarity:
        _TokenEntrypolarityValueEnumMap[reader.readByteOrNull(offsets[11])] ??
        Polarity.affirmative,
    politeness:
        _TokenEntrypolitenessValueEnumMap[reader.readByteOrNull(offsets[12])] ??
        Politeness.plain,
    pos:
        _TokenEntryposValueEnumMap[reader.readByteOrNull(offsets[13])] ??
        WordPos.unknown,
    relationLabel: reader.readStringOrNull(offsets[14]),
    surface: reader.readStringOrNull(offsets[15]),
    tense:
        _TokenEntrytenseValueEnumMap[reader.readByteOrNull(offsets[16])] ??
        Tense.none,
    versions:
        reader.readObjectList<ReadingItem>(
          offsets[17],
          ReadingItemSchema.deserialize,
          allOffsets,
          ReadingItem(),
        ) ??
        const [],
    wordPosition: reader.readLongOrNull(offsets[18]),
  );
  return object;
}

P _tokenEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_TokenEntryaspectValueEnumMap[reader.readByteOrNull(offset)] ??
              Aspect.none)
          as P;
    case 1:
      return (_TokenEntryattachModeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              AttachMode.none)
          as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (_TokenEntrygrammarFunctionValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              GrammarFunction.none)
          as P;
    case 5:
      return (_TokenEntrygroupRoleValueEnumMap[reader.readByteOrNull(offset)] ??
              GroupRole.head)
          as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (_TokenEntrymodalityValueEnumMap[reader.readByteOrNull(offset)] ??
              Modality.none)
          as P;
    case 11:
      return (_TokenEntrypolarityValueEnumMap[reader.readByteOrNull(offset)] ??
              Polarity.affirmative)
          as P;
    case 12:
      return (_TokenEntrypolitenessValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              Politeness.plain)
          as P;
    case 13:
      return (_TokenEntryposValueEnumMap[reader.readByteOrNull(offset)] ??
              WordPos.unknown)
          as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (_TokenEntrytenseValueEnumMap[reader.readByteOrNull(offset)] ??
              Tense.none)
          as P;
    case 17:
      return (reader.readObjectList<ReadingItem>(
                offset,
                ReadingItemSchema.deserialize,
                allOffsets,
                ReadingItem(),
              ) ??
              const [])
          as P;
    case 18:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TokenEntryaspectEnumValueMap = {
  'none': 0,
  'progressive': 1,
  'resultative': 2,
  'perfective': 3,
  'preparatory': 4,
  'attempt': 5,
  'inceptive': 6,
  'continuative': 7,
  'iterative': 8,
  'benefactive': 9,
};
const _TokenEntryaspectValueEnumMap = {
  0: Aspect.none,
  1: Aspect.progressive,
  2: Aspect.resultative,
  3: Aspect.perfective,
  4: Aspect.preparatory,
  5: Aspect.attempt,
  6: Aspect.inceptive,
  7: Aspect.continuative,
  8: Aspect.iterative,
  9: Aspect.benefactive,
};
const _TokenEntryattachModeEnumValueMap = {'merge': 0, 'modify': 1, 'none': 2};
const _TokenEntryattachModeValueEnumMap = {
  0: AttachMode.merge,
  1: AttachMode.modify,
  2: AttachMode.none,
};
const _TokenEntrygrammarFunctionEnumValueMap = {
  'subj': 0,
  'obj': 1,
  'obj2': 2,
  'top': 3,
  'ctr': 4,
  'poss': 5,
  'mod': 6,
  'apos': 7,
  'loc': 8,
  'dir': 9,
  'src': 10,
  'tgt': 11,
  'tim': 12,
  'mns': 13,
  'rsn': 14,
  'prp': 15,
  'cnd': 16,
  'cnc': 17,
  'cmp': 18,
  'lim': 19,
  'deg': 20,
  'quo': 21,
  'cnj': 22,
  'emp': 23,
  'q': 24,
  'itj': 25,
  'pred': 26,
  'dep': 27,
  'oth': 28,
  'none': 29,
};
const _TokenEntrygrammarFunctionValueEnumMap = {
  0: GrammarFunction.subj,
  1: GrammarFunction.obj,
  2: GrammarFunction.obj2,
  3: GrammarFunction.top,
  4: GrammarFunction.ctr,
  5: GrammarFunction.poss,
  6: GrammarFunction.mod,
  7: GrammarFunction.apos,
  8: GrammarFunction.loc,
  9: GrammarFunction.dir,
  10: GrammarFunction.src,
  11: GrammarFunction.tgt,
  12: GrammarFunction.tim,
  13: GrammarFunction.mns,
  14: GrammarFunction.rsn,
  15: GrammarFunction.prp,
  16: GrammarFunction.cnd,
  17: GrammarFunction.cnc,
  18: GrammarFunction.cmp,
  19: GrammarFunction.lim,
  20: GrammarFunction.deg,
  21: GrammarFunction.quo,
  22: GrammarFunction.cnj,
  23: GrammarFunction.emp,
  24: GrammarFunction.q,
  25: GrammarFunction.itj,
  26: GrammarFunction.pred,
  27: GrammarFunction.dep,
  28: GrammarFunction.oth,
  29: GrammarFunction.none,
};
const _TokenEntrygroupRoleEnumValueMap = {
  'head': 0,
  'particle': 1,
  'auxiliary': 2,
  'suffix': 3,
  'prefix': 4,
  'inflection': 5,
  'punct': 6,
};
const _TokenEntrygroupRoleValueEnumMap = {
  0: GroupRole.head,
  1: GroupRole.particle,
  2: GroupRole.auxiliary,
  3: GroupRole.suffix,
  4: GroupRole.prefix,
  5: GroupRole.inflection,
  6: GroupRole.punct,
};
const _TokenEntrymodalityEnumValueMap = {
  'none': 0,
  'hearsay': 1,
  'appearance': 2,
  'conjecture': 3,
  'likelihood': 4,
  'certainty': 5,
  'obligation': 6,
  'permission': 7,
  'prohibition': 8,
  'desire': 9,
  'volition': 10,
  'ability': 11,
  'passive': 12,
  'causative': 13,
  'causativePassive': 14,
  'conditional': 15,
};
const _TokenEntrymodalityValueEnumMap = {
  0: Modality.none,
  1: Modality.hearsay,
  2: Modality.appearance,
  3: Modality.conjecture,
  4: Modality.likelihood,
  5: Modality.certainty,
  6: Modality.obligation,
  7: Modality.permission,
  8: Modality.prohibition,
  9: Modality.desire,
  10: Modality.volition,
  11: Modality.ability,
  12: Modality.passive,
  13: Modality.causative,
  14: Modality.causativePassive,
  15: Modality.conditional,
};
const _TokenEntrypolarityEnumValueMap = {'affirmative': 0, 'negative': 1};
const _TokenEntrypolarityValueEnumMap = {
  0: Polarity.affirmative,
  1: Polarity.negative,
};
const _TokenEntrypolitenessEnumValueMap = {
  'plain': 0,
  'polite': 1,
  'humble': 2,
  'honorific': 3,
};
const _TokenEntrypolitenessValueEnumMap = {
  0: Politeness.plain,
  1: Politeness.polite,
  2: Politeness.humble,
  3: Politeness.honorific,
};
const _TokenEntryposEnumValueMap = {
  'v': 0,
  'i': 1,
  'd': 2,
  'n': 3,
  'p': 4,
  'x': 5,
  's': 6,
  'o': 7,
  'unknown': 8,
};
const _TokenEntryposValueEnumMap = {
  0: WordPos.v,
  1: WordPos.i,
  2: WordPos.d,
  3: WordPos.n,
  4: WordPos.p,
  5: WordPos.x,
  6: WordPos.s,
  7: WordPos.o,
  8: WordPos.unknown,
};
const _TokenEntrytenseEnumValueMap = {'none': 0, 'nonPast': 1, 'past': 2};
const _TokenEntrytenseValueEnumMap = {
  0: Tense.none,
  1: Tense.nonPast,
  2: Tense.past,
};

extension TokenEntryQueryFilter
    on QueryBuilder<TokenEntry, TokenEntry, QFilterCondition> {
  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> aspectEqualTo(
    Aspect value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'aspect', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> aspectGreaterThan(
    Aspect value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'aspect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> aspectLessThan(
    Aspect value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'aspect',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> aspectBetween(
    Aspect lower,
    Aspect upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'aspect',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> attachModeEqualTo(
    AttachMode value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'attachMode', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  attachModeGreaterThan(AttachMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'attachMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  attachModeLessThan(AttachMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'attachMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> attachModeBetween(
    AttachMode lower,
    AttachMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'attachMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  blockIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> blockIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'blockId', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  blockIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'blockId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> blockIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'blockId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> blockIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'blockId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'grammarCode'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'grammarCode'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'grammarCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'grammarCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'grammarCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'grammarCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'grammarCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'grammarCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'grammarCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'grammarCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'grammarCode', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'grammarCode', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarFunctionEqualTo(GrammarFunction value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'grammarFunction', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarFunctionGreaterThan(GrammarFunction value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'grammarFunction',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarFunctionLessThan(GrammarFunction value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'grammarFunction',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  grammarFunctionBetween(
    GrammarFunction lower,
    GrammarFunction upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'grammarFunction',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> groupRoleEqualTo(
    GroupRole value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'groupRole', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  groupRoleGreaterThan(GroupRole value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'groupRole',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> groupRoleLessThan(
    GroupRole value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'groupRole',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> groupRoleBetween(
    GroupRole lower,
    GroupRole upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'groupRole',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  headPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'headPosition'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  headPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'headPosition'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  headPositionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'headPosition', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  headPositionGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'headPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  headPositionLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'headPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  headPositionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'headPosition',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  isClickableEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isClickable', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lemma'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lemma'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lemma',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lemma',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lemma',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lemma',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lemma',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lemma',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lemma',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lemma',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> lemmaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lemma', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  lemmaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lemma', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  linkGroupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'linkGroupId'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  linkGroupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'linkGroupId'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  linkGroupIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linkGroupId', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  linkGroupIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'linkGroupId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  linkGroupIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'linkGroupId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  linkGroupIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'linkGroupId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> modalityEqualTo(
    Modality value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'modality', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  modalityGreaterThan(Modality value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'modality',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> modalityLessThan(
    Modality value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'modality',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> modalityBetween(
    Modality lower,
    Modality upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'modality',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> polarityEqualTo(
    Polarity value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'polarity', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  polarityGreaterThan(Polarity value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'polarity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> polarityLessThan(
    Polarity value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'polarity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> polarityBetween(
    Polarity lower,
    Polarity upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'polarity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> politenessEqualTo(
    Politeness value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'politeness', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  politenessGreaterThan(Politeness value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'politeness',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  politenessLessThan(Politeness value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'politeness',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> politenessBetween(
    Politeness lower,
    Politeness upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'politeness',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posEqualTo(
    WordPos value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pos', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posGreaterThan(
    WordPos value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pos',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posLessThan(
    WordPos value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pos',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posBetween(
    WordPos lower,
    WordPos upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pos',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'relationLabel'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'relationLabel'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'relationLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relationLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relationLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relationLabel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'relationLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'relationLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'relationLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'relationLabel',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'relationLabel', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  relationLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'relationLabel', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'surface'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  surfaceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'surface'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'surface',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  surfaceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'surface',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'surface',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'surface',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'surface',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'surface',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'surface',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'surface',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> surfaceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'surface', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  surfaceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'surface', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> tenseEqualTo(
    Tense value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tense', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> tenseGreaterThan(
    Tense value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tense',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> tenseLessThan(
    Tense value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tense',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> tenseBetween(
    Tense lower,
    Tense upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tense',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  versionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', length, true, length, true);
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  versionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', 0, true, 0, true);
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  versionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', 0, false, 999999, true);
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  versionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', 0, true, length, include);
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  versionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', length, include, 999999, true);
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  versionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'versions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  wordPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'wordPosition'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  wordPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'wordPosition'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  wordPositionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wordPosition', value: value),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  wordPositionGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'wordPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  wordPositionLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'wordPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition>
  wordPositionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'wordPosition',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TokenEntryQueryObject
    on QueryBuilder<TokenEntry, TokenEntry, QFilterCondition> {
  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> versionsElement(
    FilterQuery<ReadingItem> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'versions');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TranslationTokenEntrySchema = Schema(
  name: r'TranslationTokenEntry',
  id: -8365075102984640999,
  properties: {
    r'attachMode': PropertySchema(
      id: 0,
      name: r'attachMode',
      type: IsarType.byte,
      enumMap: _TranslationTokenEntryattachModeEnumValueMap,
    ),
    r'blockId': PropertySchema(id: 1, name: r'blockId', type: IsarType.long),
    r'isInferred': PropertySchema(
      id: 2,
      name: r'isInferred',
      type: IsarType.bool,
    ),
    r'linkGroupId': PropertySchema(
      id: 3,
      name: r'linkGroupId',
      type: IsarType.long,
    ),
    r'sourceWordPositions': PropertySchema(
      id: 4,
      name: r'sourceWordPositions',
      type: IsarType.longList,
    ),
    r'text': PropertySchema(id: 5, name: r'text', type: IsarType.string),
    r'translatedWordPosition': PropertySchema(
      id: 6,
      name: r'translatedWordPosition',
      type: IsarType.long,
    ),
  },

  estimateSize: _translationTokenEntryEstimateSize,
  serialize: _translationTokenEntrySerialize,
  deserialize: _translationTokenEntryDeserialize,
  deserializeProp: _translationTokenEntryDeserializeProp,
);

int _translationTokenEntryEstimateSize(
  TranslationTokenEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.sourceWordPositions.length * 8;
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _translationTokenEntrySerialize(
  TranslationTokenEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.attachMode.index);
  writer.writeLong(offsets[1], object.blockId);
  writer.writeBool(offsets[2], object.isInferred);
  writer.writeLong(offsets[3], object.linkGroupId);
  writer.writeLongList(offsets[4], object.sourceWordPositions);
  writer.writeString(offsets[5], object.text);
  writer.writeLong(offsets[6], object.translatedWordPosition);
}

TranslationTokenEntry _translationTokenEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TranslationTokenEntry(
    attachMode:
        _TranslationTokenEntryattachModeValueEnumMap[reader.readByteOrNull(
          offsets[0],
        )] ??
        AttachMode.none,
    blockId: reader.readLongOrNull(offsets[1]),
    isInferred: reader.readBoolOrNull(offsets[2]) ?? false,
    linkGroupId: reader.readLongOrNull(offsets[3]),
    sourceWordPositions: reader.readLongList(offsets[4]) ?? const [],
    text: reader.readStringOrNull(offsets[5]),
    translatedWordPosition: reader.readLongOrNull(offsets[6]),
  );
  return object;
}

P _translationTokenEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_TranslationTokenEntryattachModeValueEnumMap[reader
                  .readByteOrNull(offset)] ??
              AttachMode.none)
          as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongList(offset) ?? const []) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TranslationTokenEntryattachModeEnumValueMap = {
  'merge': 0,
  'modify': 1,
  'none': 2,
};
const _TranslationTokenEntryattachModeValueEnumMap = {
  0: AttachMode.merge,
  1: AttachMode.modify,
  2: AttachMode.none,
};

extension TranslationTokenEntryQueryFilter
    on
        QueryBuilder<
          TranslationTokenEntry,
          TranslationTokenEntry,
          QFilterCondition
        > {
  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  attachModeEqualTo(AttachMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'attachMode', value: value),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  attachModeGreaterThan(AttachMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'attachMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  attachModeLessThan(AttachMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'attachMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  attachModeBetween(
    AttachMode lower,
    AttachMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'attachMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  blockIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  blockIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'blockId', value: value),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  blockIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'blockId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  blockIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'blockId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  blockIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'blockId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  isInferredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isInferred', value: value),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  linkGroupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'linkGroupId'),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  linkGroupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'linkGroupId'),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  linkGroupIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linkGroupId', value: value),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  linkGroupIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'linkGroupId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  linkGroupIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'linkGroupId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  linkGroupIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'linkGroupId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceWordPositions', value: value),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceWordPositions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceWordPositions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceWordPositions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceWordPositions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceWordPositions', 0, true, 0, true);
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceWordPositions', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceWordPositions', 0, true, length, include);
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceWordPositions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  sourceWordPositionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sourceWordPositions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'text'),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'text'),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'text',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'text',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  translatedWordPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'translatedWordPosition'),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  translatedWordPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'translatedWordPosition'),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  translatedWordPositionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'translatedWordPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  translatedWordPositionGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'translatedWordPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  translatedWordPositionLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'translatedWordPosition',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TranslationTokenEntry,
    TranslationTokenEntry,
    QAfterFilterCondition
  >
  translatedWordPositionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'translatedWordPosition',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TranslationTokenEntryQueryObject
    on
        QueryBuilder<
          TranslationTokenEntry,
          TranslationTokenEntry,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ReadingItemSchema = Schema(
  name: r'ReadingItem',
  id: 710003338608000221,
  properties: {
    r'key': PropertySchema(id: 0, name: r'key', type: IsarType.string),
    r'text': PropertySchema(id: 1, name: r'text', type: IsarType.string),
  },

  estimateSize: _readingItemEstimateSize,
  serialize: _readingItemSerialize,
  deserialize: _readingItemDeserialize,
  deserializeProp: _readingItemDeserializeProp,
);

int _readingItemEstimateSize(
  ReadingItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.key;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _readingItemSerialize(
  ReadingItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeString(offsets[1], object.text);
}

ReadingItem _readingItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingItem(
    key: reader.readStringOrNull(offsets[0]),
    text: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _readingItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ReadingItemQueryFilter
    on QueryBuilder<ReadingItem, ReadingItem, QFilterCondition> {
  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'key'),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'key'),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'text'),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition>
  textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'text'),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'text',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'text',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition>
  textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }
}

extension ReadingItemQueryObject
    on QueryBuilder<ReadingItem, ReadingItem, QFilterCondition> {}
