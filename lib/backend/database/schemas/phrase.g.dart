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
    r'isTranslated': PropertySchema(
      id: 2,
      name: r'isTranslated',
      type: IsarType.bool,
    ),
    r'isTranslating': PropertySchema(
      id: 3,
      name: r'isTranslating',
      type: IsarType.bool,
    ),
    r'originalPhrase': PropertySchema(
      id: 4,
      name: r'originalPhrase',
      type: IsarType.string,
    ),
    r'originalTokens': PropertySchema(
      id: 5,
      name: r'originalTokens',
      type: IsarType.objectList,

      target: r'TokenEntry',
    ),
    r'phraseOrder': PropertySchema(
      id: 6,
      name: r'phraseOrder',
      type: IsarType.long,
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
    r'translatedTokens': PropertySchema(
      id: 9,
      name: r'translatedTokens',
      type: IsarType.objectList,

      target: r'TokenEntry',
    ),
    r'videoId': PropertySchema(id: 10, name: r'videoId', type: IsarType.long),
  },

  estimateSize: _phraseEstimateSize,
  serialize: _phraseSerialize,
  deserialize: _phraseDeserialize,
  deserializeProp: _phraseDeserializeProp,
  idName: r'id',
  indexes: {
    r'videoId': IndexSchema(
      id: 6273887982249211799,
      name: r'videoId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'videoId',
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
  {
    final value = object.translatedPhrase;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.translatedTokens;
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
  writer.writeBool(offsets[2], object.isTranslated);
  writer.writeBool(offsets[3], object.isTranslating);
  writer.writeString(offsets[4], object.originalPhrase);
  writer.writeObjectList<TokenEntry>(
    offsets[5],
    allOffsets,
    TokenEntrySchema.serialize,
    object.originalTokens,
  );
  writer.writeLong(offsets[6], object.phraseOrder);
  writer.writeDateTime(offsets[7], object.startTime);
  writer.writeString(offsets[8], object.translatedPhrase);
  writer.writeObjectList<TokenEntry>(
    offsets[9],
    allOffsets,
    TokenEntrySchema.serialize,
    object.translatedTokens,
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
    isTranslated: reader.readBoolOrNull(offsets[2]) ?? false,
    isTranslating: reader.readBoolOrNull(offsets[3]) ?? false,
    originalPhrase: reader.readStringOrNull(offsets[4]),
    originalTokens: reader.readObjectList<TokenEntry>(
      offsets[5],
      TokenEntrySchema.deserialize,
      allOffsets,
      TokenEntry(),
    ),
    phraseOrder: reader.readLongOrNull(offsets[6]),
    startTime: reader.readDateTimeOrNull(offsets[7]),
    translatedPhrase: reader.readStringOrNull(offsets[8]),
    translatedTokens: reader.readObjectList<TokenEntry>(
      offsets[9],
      TokenEntrySchema.deserialize,
      allOffsets,
      TokenEntry(),
    ),
    videoId: reader.readLongOrNull(offsets[10]),
  );
  object.id = id;
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
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readObjectList<TokenEntry>(
            offset,
            TokenEntrySchema.deserialize,
            allOffsets,
            TokenEntry(),
          ))
          as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readObjectList<TokenEntry>(
            offset,
            TokenEntrySchema.deserialize,
            allOffsets,
            TokenEntry(),
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

  QueryBuilder<Phrase, Phrase, QAfterWhere> anyVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'videoId'),
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

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'videoId', value: [null]),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdEqualTo(int? videoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'videoId', value: [videoId]),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdNotEqualTo(
    int? videoId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId',
                lower: [],
                upper: [videoId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId',
                lower: [videoId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId',
                lower: [videoId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'videoId',
                lower: [],
                upper: [videoId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdGreaterThan(
    int? videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId',
          lower: [videoId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdLessThan(
    int? videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId',
          lower: [],
          upper: [videoId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterWhereClause> videoIdBetween(
    int? lowerVideoId,
    int? upperVideoId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'videoId',
          lower: [lowerVideoId],
          includeLower: includeLower,
          upper: [upperVideoId],
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

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> isTranslatedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isTranslated', value: value),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> isTranslatingEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isTranslating', value: value),
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

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedTokensIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'translatedTokens'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedTokensIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'translatedTokens'),
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedTokensLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedTokens', length, true, length, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedTokensIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedTokens', 0, true, 0, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedTokensIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedTokens', 0, false, 999999, true);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedTokensLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedTokens', 0, true, length, include);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedTokensLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedTokens',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition>
  translatedTokensLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedTokens',
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

  QueryBuilder<Phrase, Phrase, QAfterFilterCondition> translatedTokensElement(
    FilterQuery<TokenEntry> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'translatedTokens');
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

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByIsTranslated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslated', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByIsTranslatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslated', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByIsTranslating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslating', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> sortByIsTranslatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslating', Sort.desc);
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

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIsTranslated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslated', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIsTranslatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslated', Sort.desc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIsTranslating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslating', Sort.asc);
    });
  }

  QueryBuilder<Phrase, Phrase, QAfterSortBy> thenByIsTranslatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslating', Sort.desc);
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

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByIsTranslated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTranslated');
    });
  }

  QueryBuilder<Phrase, Phrase, QDistinct> distinctByIsTranslating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTranslating');
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

  QueryBuilder<Phrase, bool, QQueryOperations> isTranslatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTranslated');
    });
  }

  QueryBuilder<Phrase, bool, QQueryOperations> isTranslatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTranslating');
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

  QueryBuilder<Phrase, List<TokenEntry>?, QQueryOperations>
  translatedTokensProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedTokens');
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
    r'lemma': PropertySchema(id: 1, name: r'lemma', type: IsarType.string),
    r'pos': PropertySchema(id: 2, name: r'pos', type: IsarType.string),
    r'versions': PropertySchema(
      id: 3,
      name: r'versions',
      type: IsarType.objectList,

      target: r'ReadingItem',
    ),
    r'wordPosition': PropertySchema(
      id: 4,
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
  {
    final value = object.pos;
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
  writer.writeString(offsets[1], object.lemma);
  writer.writeString(offsets[2], object.pos);
  writer.writeObjectList<ReadingItem>(
    offsets[3],
    allOffsets,
    ReadingItemSchema.serialize,
    object.versions,
  );
  writer.writeLong(offsets[4], object.wordPosition);
}

TokenEntry _tokenEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TokenEntry(
    blockId: reader.readLongOrNull(offsets[0]),
    lemma: reader.readStringOrNull(offsets[1]),
    pos: reader.readStringOrNull(offsets[2]),
    versions:
        reader.readObjectList<ReadingItem>(
          offsets[3],
          ReadingItemSchema.deserialize,
          allOffsets,
          ReadingItem(),
        ) ??
        const [],
    wordPosition: reader.readLongOrNull(offsets[4]),
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
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<ReadingItem>(
                offset,
                ReadingItemSchema.deserialize,
                allOffsets,
                ReadingItem(),
              ) ??
              const [])
          as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

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

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pos'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pos'),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pos',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pos',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pos',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pos', value: ''),
      );
    });
  }

  QueryBuilder<TokenEntry, TokenEntry, QAfterFilterCondition> posIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pos', value: ''),
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
