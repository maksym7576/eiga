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
    r'isActive': PropertySchema(id: 1, name: r'isActive', type: IsarType.bool),
    r'originalPhrase': PropertySchema(
      id: 2,
      name: r'originalPhrase',
      type: IsarType.string,
    ),
    r'originalTokens': PropertySchema(
      id: 3,
      name: r'originalTokens',
      type: IsarType.objectList,

      target: r'TokenEntry',
    ),
    r'phraseOrder': PropertySchema(
      id: 4,
      name: r'phraseOrder',
      type: IsarType.long,
    ),
    r'stageKeys': PropertySchema(
      id: 5,
      name: r'stageKeys',
      type: IsarType.stringList,
    ),
    r'stageValues': PropertySchema(
      id: 6,
      name: r'stageValues',
      type: IsarType.stringList,
    ),
    r'startTime': PropertySchema(
      id: 7,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'translatedPhrase': PropertySchema(
      id: 8,
      name: r'translatedPhrase',
      type: IsarType.string,
    ),
    r'translatedWords': PropertySchema(
      id: 9,
      name: r'translatedWords',
      type: IsarType.objectList,

      target: r'TranslationTokenEntry',
    ),
    r'videoId': PropertySchema(id: 10, name: r'videoId', type: IsarType.long),
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
  writer.writeBool(offsets[1], object.isActive);
  writer.writeString(offsets[2], object.originalPhrase);
  writer.writeObjectList<TokenEntry>(
    offsets[3],
    allOffsets,
    TokenEntrySchema.serialize,
    object.originalTokens,
  );
  writer.writeLong(offsets[4], object.phraseOrder);
  writer.writeStringList(offsets[5], object.stageKeys);
  writer.writeStringList(offsets[6], object.stageValues);
  writer.writeDateTime(offsets[7], object.startTime);
  writer.writeString(offsets[8], object.translatedPhrase);
  writer.writeObjectList<TranslationTokenEntry>(
    offsets[9],
    allOffsets,
    TranslationTokenEntrySchema.serialize,
    object.translatedWords,
  );
  writer.writeLong(offsets[10], object.videoId);
}

Phrase _phraseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Phrase(
    endTime: reader.readDateTimeOrNull(offsets[0]),
    isActive: reader.readBoolOrNull(offsets[1]) ?? false,
    originalPhrase: reader.readStringOrNull(offsets[2]),
    originalTokens: reader.readObjectList<TokenEntry>(
      offsets[3],
      TokenEntrySchema.deserialize,
      allOffsets,
      TokenEntry(),
    ),
    phraseOrder: reader.readLongOrNull(offsets[4]),
    startTime: reader.readDateTimeOrNull(offsets[7]),
    translatedPhrase: reader.readStringOrNull(offsets[8]),
    translatedWords: reader.readObjectList<TranslationTokenEntry>(
      offsets[9],
      TranslationTokenEntrySchema.deserialize,
      allOffsets,
      TranslationTokenEntry(),
    ),
    videoId: reader.readLongOrNull(offsets[10]),
  );
  object.id = id;
  object.stageKeys = reader.readStringList(offsets[5]) ?? [];
  object.stageValues = reader.readStringList(offsets[6]) ?? [];
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
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<TokenEntry>(
            offset,
            TokenEntrySchema.deserialize,
            allOffsets,
            TokenEntry(),
          ))
          as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readStringList(offset) ?? []) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readObjectList<TranslationTokenEntry>(
            offset,
            TranslationTokenEntrySchema.deserialize,
            allOffsets,
            TranslationTokenEntry(),
          ))
          as P;
    case 10:
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

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> isActiveEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
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

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
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

  QueryBuilder<Phrase, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
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

const TokenEntrySchema = Schema(
  name: r'TokenEntry',
  id: -1817502199596935943,
  properties: {
    r'blockId': PropertySchema(id: 0, name: r'blockId', type: IsarType.long),
    r'grammarFunction': PropertySchema(
      id: 1,
      name: r'grammarFunction',
      type: IsarType.byte,
      enumMap: _TokenEntrygrammarFunctionEnumValueMap,
    ),
    r'isClickable': PropertySchema(
      id: 2,
      name: r'isClickable',
      type: IsarType.bool,
    ),
    r'lemma': PropertySchema(id: 3, name: r'lemma', type: IsarType.string),
    r'pos': PropertySchema(
      id: 4,
      name: r'pos',
      type: IsarType.byte,
      enumMap: _TokenEntryposEnumValueMap,
    ),
    r'versions': PropertySchema(
      id: 5,
      name: r'versions',
      type: IsarType.objectList,

      target: r'ReadingItem',
    ),
    r'wordPosition': PropertySchema(
      id: 6,
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
    final value = object.lemma;
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
  writer.writeLong(offsets[0], object.blockId);
  writer.writeByte(offsets[1], object.grammarFunction.index);
  writer.writeBool(offsets[2], object.isClickable);
  writer.writeString(offsets[3], object.lemma);
  writer.writeByte(offsets[4], object.pos.index);
  writer.writeObjectList<ReadingItem>(
    offsets[5],
    allOffsets,
    ReadingItemSchema.serialize,
    object.versions,
  );
  writer.writeLong(offsets[6], object.wordPosition);
}

TokenEntry _tokenEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TokenEntry(
    blockId: reader.readLongOrNull(offsets[0]),
    grammarFunction:
        _TokenEntrygrammarFunctionValueEnumMap[reader.readByteOrNull(
          offsets[1],
        )] ??
        GrammarFunction.none,
    isClickable: reader.readBoolOrNull(offsets[2]) ?? true,
    lemma: reader.readStringOrNull(offsets[3]),
    pos:
        _TokenEntryposValueEnumMap[reader.readByteOrNull(offsets[4])] ??
        WordPos.unknown,
    versions:
        reader.readObjectList<ReadingItem>(
          offsets[5],
          ReadingItemSchema.deserialize,
          allOffsets,
          ReadingItem(),
        ) ??
        const [],
    wordPosition: reader.readLongOrNull(offsets[6]),
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
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (_TokenEntrygrammarFunctionValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              GrammarFunction.none)
          as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (_TokenEntryposValueEnumMap[reader.readByteOrNull(offset)] ??
              WordPos.unknown)
          as P;
    case 5:
      return (reader.readObjectList<ReadingItem>(
                offset,
                ReadingItemSchema.deserialize,
                allOffsets,
                ReadingItem(),
              ) ??
              const [])
          as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TokenEntrygrammarFunctionEnumValueMap = {
  'obj': 0,
  'subj': 1,
  'top': 2,
  'loc': 3,
  'dir': 4,
  'tim': 5,
  'mns': 6,
  'src': 7,
  'rsn': 8,
  'cnd': 9,
  'q': 10,
  'quo': 11,
  'emp': 12,
  'ctr': 13,
  'dep': 14,
  'tgt': 15,
  'cmp': 16,
  'cnj': 17,
  'oth': 18,
  'none': 19,
};
const _TokenEntrygrammarFunctionValueEnumMap = {
  0: GrammarFunction.obj,
  1: GrammarFunction.subj,
  2: GrammarFunction.top,
  3: GrammarFunction.loc,
  4: GrammarFunction.dir,
  5: GrammarFunction.tim,
  6: GrammarFunction.mns,
  7: GrammarFunction.src,
  8: GrammarFunction.rsn,
  9: GrammarFunction.cnd,
  10: GrammarFunction.q,
  11: GrammarFunction.quo,
  12: GrammarFunction.emp,
  13: GrammarFunction.ctr,
  14: GrammarFunction.dep,
  15: GrammarFunction.tgt,
  16: GrammarFunction.cmp,
  17: GrammarFunction.cnj,
  18: GrammarFunction.oth,
  19: GrammarFunction.none,
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

extension TokenEntryQueryFilter
    on QueryBuilder<TokenEntry, TokenEntry, QFilterCondition> {
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
    r'blockId': PropertySchema(id: 0, name: r'blockId', type: IsarType.long),
    r'isInferred': PropertySchema(
      id: 1,
      name: r'isInferred',
      type: IsarType.bool,
    ),
    r'sourceWordPositions': PropertySchema(
      id: 2,
      name: r'sourceWordPositions',
      type: IsarType.longList,
    ),
    r'text': PropertySchema(id: 3, name: r'text', type: IsarType.string),
    r'translatedWordPosition': PropertySchema(
      id: 4,
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
  writer.writeLong(offsets[0], object.blockId);
  writer.writeBool(offsets[1], object.isInferred);
  writer.writeLongList(offsets[2], object.sourceWordPositions);
  writer.writeString(offsets[3], object.text);
  writer.writeLong(offsets[4], object.translatedWordPosition);
}

TranslationTokenEntry _translationTokenEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TranslationTokenEntry(
    blockId: reader.readLongOrNull(offsets[0]),
    isInferred: reader.readBoolOrNull(offsets[1]) ?? false,
    sourceWordPositions: reader.readLongList(offsets[2]) ?? const [],
    text: reader.readStringOrNull(offsets[3]),
    translatedWordPosition: reader.readLongOrNull(offsets[4]),
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
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readLongList(offset) ?? const []) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

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
