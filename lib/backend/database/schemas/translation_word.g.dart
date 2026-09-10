// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_word.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTranslationWordCollection on Isar {
  IsarCollection<TranslationWord> get translationWords => this.collection();
}

const TranslationWordSchema = CollectionSchema(
  name: r'TranslationWord',
  id: -6726847396706738779,
  properties: {
    r'blockId': PropertySchema(id: 0, name: r'blockId', type: IsarType.long),
    r'isInferred': PropertySchema(
      id: 1,
      name: r'isInferred',
      type: IsarType.bool,
    ),
    r'phraseId': PropertySchema(id: 2, name: r'phraseId', type: IsarType.long),
    r'sourceWordPositions': PropertySchema(
      id: 3,
      name: r'sourceWordPositions',
      type: IsarType.longList,
    ),
    r'text': PropertySchema(id: 4, name: r'text', type: IsarType.string),
    r'translatedWordPosition': PropertySchema(
      id: 5,
      name: r'translatedWordPosition',
      type: IsarType.long,
    ),
  },

  estimateSize: _translationWordEstimateSize,
  serialize: _translationWordSerialize,
  deserialize: _translationWordDeserialize,
  deserializeProp: _translationWordDeserializeProp,
  idName: r'id',
  indexes: {
    r'phraseId': IndexSchema(
      id: -1936705100628921048,
      name: r'phraseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'phraseId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'blockId': IndexSchema(
      id: -413886092950911832,
      name: r'blockId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'blockId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _translationWordGetId,
  getLinks: _translationWordGetLinks,
  attach: _translationWordAttach,
  version: '3.3.2',
);

int _translationWordEstimateSize(
  TranslationWord object,
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

void _translationWordSerialize(
  TranslationWord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.blockId);
  writer.writeBool(offsets[1], object.isInferred);
  writer.writeLong(offsets[2], object.phraseId);
  writer.writeLongList(offsets[3], object.sourceWordPositions);
  writer.writeString(offsets[4], object.text);
  writer.writeLong(offsets[5], object.translatedWordPosition);
}

TranslationWord _translationWordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TranslationWord(
    blockId: reader.readLongOrNull(offsets[0]),
    isInferred: reader.readBoolOrNull(offsets[1]) ?? false,
    phraseId: reader.readLongOrNull(offsets[2]),
    sourceWordPositions: reader.readLongList(offsets[3]) ?? const [],
    text: reader.readStringOrNull(offsets[4]),
    translatedWordPosition: reader.readLongOrNull(offsets[5]),
  );
  object.id = id;
  return object;
}

P _translationWordDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongList(offset) ?? const []) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _translationWordGetId(TranslationWord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _translationWordGetLinks(TranslationWord object) {
  return [];
}

void _translationWordAttach(
  IsarCollection<dynamic> col,
  Id id,
  TranslationWord object,
) {
  object.id = id;
}

extension TranslationWordQueryWhereSort
    on QueryBuilder<TranslationWord, TranslationWord, QWhere> {
  QueryBuilder<TranslationWord, TranslationWord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhere> anyPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'phraseId'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhere> anyBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'blockId'),
      );
    });
  }
}

extension TranslationWordQueryWhere
    on QueryBuilder<TranslationWord, TranslationWord, QWhereClause> {
  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause> idBetween(
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  phraseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'phraseId', value: [null]),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  phraseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'phraseId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  phraseIdEqualTo(int? phraseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'phraseId', value: [phraseId]),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  phraseIdNotEqualTo(int? phraseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'phraseId',
                lower: [],
                upper: [phraseId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'phraseId',
                lower: [phraseId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'phraseId',
                lower: [phraseId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'phraseId',
                lower: [],
                upper: [phraseId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  phraseIdGreaterThan(int? phraseId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'phraseId',
          lower: [phraseId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  phraseIdLessThan(int? phraseId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'phraseId',
          lower: [],
          upper: [phraseId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  phraseIdBetween(
    int? lowerPhraseId,
    int? upperPhraseId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'phraseId',
          lower: [lowerPhraseId],
          includeLower: includeLower,
          upper: [upperPhraseId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'blockId', value: [null]),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  blockIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'blockId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  blockIdEqualTo(int? blockId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'blockId', value: [blockId]),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  blockIdNotEqualTo(int? blockId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'blockId',
                lower: [],
                upper: [blockId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'blockId',
                lower: [blockId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'blockId',
                lower: [blockId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'blockId',
                lower: [],
                upper: [blockId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  blockIdGreaterThan(int? blockId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'blockId',
          lower: [blockId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  blockIdLessThan(int? blockId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'blockId',
          lower: [],
          upper: [blockId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterWhereClause>
  blockIdBetween(
    int? lowerBlockId,
    int? upperBlockId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'blockId',
          lower: [lowerBlockId],
          includeLower: includeLower,
          upper: [upperBlockId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TranslationWordQueryFilter
    on QueryBuilder<TranslationWord, TranslationWord, QFilterCondition> {
  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  blockIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  blockIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'blockId', value: value),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  isInferredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isInferred', value: value),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  phraseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'phraseId'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  phraseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'phraseId'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  phraseIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phraseId', value: value),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  phraseIdGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  phraseIdLessThan(int? value, {bool include = false}) {
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  phraseIdBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  sourceWordPositionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceWordPositions', value: value),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  sourceWordPositionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceWordPositions', 0, true, 0, true);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  sourceWordPositionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceWordPositions', 0, false, 999999, true);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  sourceWordPositionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sourceWordPositions', 0, true, length, include);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'text'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'text'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  translatedWordPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'translatedWordPosition'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
  translatedWordPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'translatedWordPosition'),
      );
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

  QueryBuilder<TranslationWord, TranslationWord, QAfterFilterCondition>
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

extension TranslationWordQueryObject
    on QueryBuilder<TranslationWord, TranslationWord, QFilterCondition> {}

extension TranslationWordQueryLinks
    on QueryBuilder<TranslationWord, TranslationWord, QFilterCondition> {}

extension TranslationWordQuerySortBy
    on QueryBuilder<TranslationWord, TranslationWord, QSortBy> {
  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy> sortByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  sortByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  sortByIsInferred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInferred', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  sortByIsInferredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInferred', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  sortByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  sortByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  sortByTranslatedWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedWordPosition', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  sortByTranslatedWordPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedWordPosition', Sort.desc);
    });
  }
}

extension TranslationWordQuerySortThenBy
    on QueryBuilder<TranslationWord, TranslationWord, QSortThenBy> {
  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy> thenByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  thenByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  thenByIsInferred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInferred', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  thenByIsInferredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInferred', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  thenByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  thenByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  thenByTranslatedWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedWordPosition', Sort.asc);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QAfterSortBy>
  thenByTranslatedWordPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedWordPosition', Sort.desc);
    });
  }
}

extension TranslationWordQueryWhereDistinct
    on QueryBuilder<TranslationWord, TranslationWord, QDistinct> {
  QueryBuilder<TranslationWord, TranslationWord, QDistinct>
  distinctByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockId');
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QDistinct>
  distinctByIsInferred() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isInferred');
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QDistinct>
  distinctByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phraseId');
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QDistinct>
  distinctBySourceWordPositions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceWordPositions');
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QDistinct> distinctByText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationWord, TranslationWord, QDistinct>
  distinctByTranslatedWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translatedWordPosition');
    });
  }
}

extension TranslationWordQueryProperty
    on QueryBuilder<TranslationWord, TranslationWord, QQueryProperty> {
  QueryBuilder<TranslationWord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TranslationWord, int?, QQueryOperations> blockIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockId');
    });
  }

  QueryBuilder<TranslationWord, bool, QQueryOperations> isInferredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isInferred');
    });
  }

  QueryBuilder<TranslationWord, int?, QQueryOperations> phraseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phraseId');
    });
  }

  QueryBuilder<TranslationWord, List<int>, QQueryOperations>
  sourceWordPositionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceWordPositions');
    });
  }

  QueryBuilder<TranslationWord, String?, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<TranslationWord, int?, QQueryOperations>
  translatedWordPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedWordPosition');
    });
  }
}
