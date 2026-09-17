// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_index.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWordIndexCollection on Isar {
  IsarCollection<WordIndex> get wordIndexs => this.collection();
}

const WordIndexSchema = CollectionSchema(
  name: r'WordIndex',
  id: -7698195498269725593,
  properties: {
    r'blockId': PropertySchema(id: 0, name: r'blockId', type: IsarType.long),
    r'contextOriginal': PropertySchema(
      id: 1,
      name: r'contextOriginal',
      type: IsarType.string,
    ),
    r'contextTranslated': PropertySchema(
      id: 2,
      name: r'contextTranslated',
      type: IsarType.string,
    ),
    r'grammarCode': PropertySchema(
      id: 3,
      name: r'grammarCode',
      type: IsarType.string,
    ),
    r'lemma': PropertySchema(id: 4, name: r'lemma', type: IsarType.string),
    r'linkGroupId': PropertySchema(
      id: 5,
      name: r'linkGroupId',
      type: IsarType.long,
    ),
    r'phraseId': PropertySchema(id: 6, name: r'phraseId', type: IsarType.long),
    r'pos': PropertySchema(
      id: 7,
      name: r'pos',
      type: IsarType.byte,
      enumMap: _WordIndexposEnumValueMap,
    ),
    r'seriesName': PropertySchema(
      id: 8,
      name: r'seriesName',
      type: IsarType.string,
    ),
    r'videoId': PropertySchema(id: 9, name: r'videoId', type: IsarType.long),
    r'wordPosition': PropertySchema(
      id: 10,
      name: r'wordPosition',
      type: IsarType.long,
    ),
  },

  estimateSize: _wordIndexEstimateSize,
  serialize: _wordIndexSerialize,
  deserialize: _wordIndexDeserialize,
  deserializeProp: _wordIndexDeserializeProp,
  idName: r'id',
  indexes: {
    r'lemma': IndexSchema(
      id: -6799237479504882701,
      name: r'lemma',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lemma',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _wordIndexGetId,
  getLinks: _wordIndexGetLinks,
  attach: _wordIndexAttach,
  version: '3.3.2',
);

int _wordIndexEstimateSize(
  WordIndex object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.contextOriginal;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contextTranslated;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.grammarCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lemma.length * 3;
  {
    final value = object.seriesName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _wordIndexSerialize(
  WordIndex object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.blockId);
  writer.writeString(offsets[1], object.contextOriginal);
  writer.writeString(offsets[2], object.contextTranslated);
  writer.writeString(offsets[3], object.grammarCode);
  writer.writeString(offsets[4], object.lemma);
  writer.writeLong(offsets[5], object.linkGroupId);
  writer.writeLong(offsets[6], object.phraseId);
  writer.writeByte(offsets[7], object.pos.index);
  writer.writeString(offsets[8], object.seriesName);
  writer.writeLong(offsets[9], object.videoId);
  writer.writeLong(offsets[10], object.wordPosition);
}

WordIndex _wordIndexDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WordIndex(
    blockId: reader.readLongOrNull(offsets[0]),
    contextOriginal: reader.readStringOrNull(offsets[1]),
    contextTranslated: reader.readStringOrNull(offsets[2]),
    grammarCode: reader.readStringOrNull(offsets[3]),
    lemma: reader.readString(offsets[4]),
    linkGroupId: reader.readLongOrNull(offsets[5]),
    phraseId: reader.readLong(offsets[6]),
    pos:
        _WordIndexposValueEnumMap[reader.readByteOrNull(offsets[7])] ??
        WordPos.unknown,
    seriesName: reader.readStringOrNull(offsets[8]),
    videoId: reader.readLong(offsets[9]),
    wordPosition: reader.readLongOrNull(offsets[10]),
  );
  object.id = id;
  return object;
}

P _wordIndexDeserializeProp<P>(
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
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (_WordIndexposValueEnumMap[reader.readByteOrNull(offset)] ??
              WordPos.unknown)
          as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WordIndexposEnumValueMap = {
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
const _WordIndexposValueEnumMap = {
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

Id _wordIndexGetId(WordIndex object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wordIndexGetLinks(WordIndex object) {
  return [];
}

void _wordIndexAttach(IsarCollection<dynamic> col, Id id, WordIndex object) {
  object.id = id;
}

extension WordIndexQueryWhereSort
    on QueryBuilder<WordIndex, WordIndex, QWhere> {
  QueryBuilder<WordIndex, WordIndex, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WordIndexQueryWhere
    on QueryBuilder<WordIndex, WordIndex, QWhereClause> {
  QueryBuilder<WordIndex, WordIndex, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<WordIndex, WordIndex, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterWhereClause> idBetween(
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

  QueryBuilder<WordIndex, WordIndex, QAfterWhereClause> lemmaEqualTo(
    String lemma,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'lemma', value: [lemma]),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterWhereClause> lemmaNotEqualTo(
    String lemma,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lemma',
                lower: [],
                upper: [lemma],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lemma',
                lower: [lemma],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lemma',
                lower: [lemma],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lemma',
                lower: [],
                upper: [lemma],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension WordIndexQueryFilter
    on QueryBuilder<WordIndex, WordIndex, QFilterCondition> {
  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> blockIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> blockIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'blockId', value: value),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> blockIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> blockIdLessThan(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> blockIdBetween(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'contextOriginal'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'contextOriginal'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'contextOriginal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'contextOriginal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'contextOriginal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'contextOriginal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'contextOriginal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'contextOriginal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'contextOriginal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'contextOriginal',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'contextOriginal', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextOriginalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'contextOriginal', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'contextTranslated'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'contextTranslated'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'contextTranslated',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'contextTranslated',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'contextTranslated',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'contextTranslated',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'contextTranslated',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'contextTranslated',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'contextTranslated',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'contextTranslated',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'contextTranslated', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  contextTranslatedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'contextTranslated', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  grammarCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'grammarCode'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  grammarCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'grammarCode'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> grammarCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> grammarCodeLessThan(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> grammarCodeBetween(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> grammarCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> grammarCodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> grammarCodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  grammarCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'grammarCode', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  grammarCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'grammarCode', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaEqualTo(
    String value, {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaGreaterThan(
    String value, {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaLessThan(
    String value, {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaBetween(
    String lower,
    String upper, {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaStartsWith(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaEndsWith(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaContains(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaMatches(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lemma', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> lemmaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lemma', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  linkGroupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'linkGroupId'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  linkGroupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'linkGroupId'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> linkGroupIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'linkGroupId', value: value),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> linkGroupIdLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> linkGroupIdBetween(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> phraseIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phraseId', value: value),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> phraseIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phraseId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> phraseIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phraseId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> phraseIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phraseId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> posEqualTo(
    WordPos value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pos', value: value),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> posGreaterThan(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> posLessThan(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> posBetween(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> seriesNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'seriesName'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  seriesNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'seriesName'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> seriesNameEqualTo(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  seriesNameGreaterThan(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> seriesNameLessThan(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> seriesNameBetween(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  seriesNameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> seriesNameEndsWith(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> seriesNameContains(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> seriesNameMatches(
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  seriesNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'seriesName', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  seriesNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'seriesName', value: ''),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> videoIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoId', value: value),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> videoIdGreaterThan(
    int value, {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> videoIdLessThan(
    int value, {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> videoIdBetween(
    int lower,
    int upper, {
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  wordPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'wordPosition'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
  wordPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'wordPosition'),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> wordPositionEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wordPosition', value: value),
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition>
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

  QueryBuilder<WordIndex, WordIndex, QAfterFilterCondition> wordPositionBetween(
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

extension WordIndexQueryObject
    on QueryBuilder<WordIndex, WordIndex, QFilterCondition> {}

extension WordIndexQueryLinks
    on QueryBuilder<WordIndex, WordIndex, QFilterCondition> {}

extension WordIndexQuerySortBy on QueryBuilder<WordIndex, WordIndex, QSortBy> {
  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByContextOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextOriginal', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByContextOriginalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextOriginal', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByContextTranslated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextTranslated', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy>
  sortByContextTranslatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextTranslated', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByGrammarCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grammarCode', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByGrammarCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grammarCode', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByLemma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByLemmaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByLinkGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkGroupId', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByLinkGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkGroupId', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByPosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortBySeriesName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesName', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortBySeriesNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesName', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> sortByWordPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.desc);
    });
  }
}

extension WordIndexQuerySortThenBy
    on QueryBuilder<WordIndex, WordIndex, QSortThenBy> {
  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByContextOriginal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextOriginal', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByContextOriginalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextOriginal', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByContextTranslated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextTranslated', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy>
  thenByContextTranslatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextTranslated', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByGrammarCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grammarCode', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByGrammarCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grammarCode', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByLemma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByLemmaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByLinkGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkGroupId', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByLinkGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkGroupId', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByPosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenBySeriesName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesName', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenBySeriesNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seriesName', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.asc);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QAfterSortBy> thenByWordPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.desc);
    });
  }
}

extension WordIndexQueryWhereDistinct
    on QueryBuilder<WordIndex, WordIndex, QDistinct> {
  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockId');
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByContextOriginal({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'contextOriginal',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByContextTranslated({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'contextTranslated',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByGrammarCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grammarCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByLemma({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lemma', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByLinkGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkGroupId');
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phraseId');
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pos');
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctBySeriesName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seriesName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoId');
    });
  }

  QueryBuilder<WordIndex, WordIndex, QDistinct> distinctByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordPosition');
    });
  }
}

extension WordIndexQueryProperty
    on QueryBuilder<WordIndex, WordIndex, QQueryProperty> {
  QueryBuilder<WordIndex, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WordIndex, int?, QQueryOperations> blockIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockId');
    });
  }

  QueryBuilder<WordIndex, String?, QQueryOperations> contextOriginalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contextOriginal');
    });
  }

  QueryBuilder<WordIndex, String?, QQueryOperations>
  contextTranslatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contextTranslated');
    });
  }

  QueryBuilder<WordIndex, String?, QQueryOperations> grammarCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grammarCode');
    });
  }

  QueryBuilder<WordIndex, String, QQueryOperations> lemmaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lemma');
    });
  }

  QueryBuilder<WordIndex, int?, QQueryOperations> linkGroupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkGroupId');
    });
  }

  QueryBuilder<WordIndex, int, QQueryOperations> phraseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phraseId');
    });
  }

  QueryBuilder<WordIndex, WordPos, QQueryOperations> posProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pos');
    });
  }

  QueryBuilder<WordIndex, String?, QQueryOperations> seriesNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seriesName');
    });
  }

  QueryBuilder<WordIndex, int, QQueryOperations> videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoId');
    });
  }

  QueryBuilder<WordIndex, int?, QQueryOperations> wordPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordPosition');
    });
  }
}
