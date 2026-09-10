// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWordCollection on Isar {
  IsarCollection<Word> get words => this.collection();
}

const WordSchema = CollectionSchema(
  name: r'Word',
  id: 2997905348638732671,
  properties: {
    r'blockId': PropertySchema(id: 0, name: r'blockId', type: IsarType.long),
    r'grammarFunction': PropertySchema(
      id: 1,
      name: r'grammarFunction',
      type: IsarType.byte,
      enumMap: _WordgrammarFunctionEnumValueMap,
    ),
    r'isClickable': PropertySchema(
      id: 2,
      name: r'isClickable',
      type: IsarType.bool,
    ),
    r'lemma': PropertySchema(id: 3, name: r'lemma', type: IsarType.string),
    r'phraseId': PropertySchema(id: 4, name: r'phraseId', type: IsarType.long),
    r'pos': PropertySchema(
      id: 5,
      name: r'pos',
      type: IsarType.byte,
      enumMap: _WordposEnumValueMap,
    ),
    r'versions': PropertySchema(
      id: 6,
      name: r'versions',
      type: IsarType.objectList,

      target: r'ReadingItem',
    ),
    r'wordPosition': PropertySchema(
      id: 7,
      name: r'wordPosition',
      type: IsarType.long,
    ),
  },

  estimateSize: _wordEstimateSize,
  serialize: _wordSerialize,
  deserialize: _wordDeserialize,
  deserializeProp: _wordDeserializeProp,
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
  embeddedSchemas: {r'ReadingItem': ReadingItemSchema},

  getId: _wordGetId,
  getLinks: _wordGetLinks,
  attach: _wordAttach,
  version: '3.3.2',
);

int _wordEstimateSize(
  Word object,
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

void _wordSerialize(
  Word object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.blockId);
  writer.writeByte(offsets[1], object.grammarFunction.index);
  writer.writeBool(offsets[2], object.isClickable);
  writer.writeString(offsets[3], object.lemma);
  writer.writeLong(offsets[4], object.phraseId);
  writer.writeByte(offsets[5], object.pos.index);
  writer.writeObjectList<ReadingItem>(
    offsets[6],
    allOffsets,
    ReadingItemSchema.serialize,
    object.versions,
  );
  writer.writeLong(offsets[7], object.wordPosition);
}

Word _wordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Word(
    blockId: reader.readLongOrNull(offsets[0]),
    grammarFunction:
        _WordgrammarFunctionValueEnumMap[reader.readByteOrNull(offsets[1])] ??
        GrammarFunction.none,
    isClickable: reader.readBoolOrNull(offsets[2]) ?? true,
    lemma: reader.readStringOrNull(offsets[3]),
    phraseId: reader.readLongOrNull(offsets[4]),
    pos:
        _WordposValueEnumMap[reader.readByteOrNull(offsets[5])] ??
        WordPos.unknown,
    versions:
        reader.readObjectList<ReadingItem>(
          offsets[6],
          ReadingItemSchema.deserialize,
          allOffsets,
          ReadingItem(),
        ) ??
        const [],
    wordPosition: reader.readLongOrNull(offsets[7]),
  );
  object.id = id;
  return object;
}

P _wordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (_WordgrammarFunctionValueEnumMap[reader.readByteOrNull(offset)] ??
              GrammarFunction.none)
          as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (_WordposValueEnumMap[reader.readByteOrNull(offset)] ??
              WordPos.unknown)
          as P;
    case 6:
      return (reader.readObjectList<ReadingItem>(
                offset,
                ReadingItemSchema.deserialize,
                allOffsets,
                ReadingItem(),
              ) ??
              const [])
          as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WordgrammarFunctionEnumValueMap = {
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
const _WordgrammarFunctionValueEnumMap = {
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
const _WordposEnumValueMap = {
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
const _WordposValueEnumMap = {
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

Id _wordGetId(Word object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wordGetLinks(Word object) {
  return [];
}

void _wordAttach(IsarCollection<dynamic> col, Id id, Word object) {
  object.id = id;
}

extension WordQueryWhereSort on QueryBuilder<Word, Word, QWhere> {
  QueryBuilder<Word, Word, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Word, Word, QAfterWhere> anyPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'phraseId'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhere> anyBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'blockId'),
      );
    });
  }
}

extension WordQueryWhere on QueryBuilder<Word, Word, QWhereClause> {
  QueryBuilder<Word, Word, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Word, Word, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idBetween(
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

  QueryBuilder<Word, Word, QAfterWhereClause> phraseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'phraseId', value: [null]),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> phraseIdIsNotNull() {
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

  QueryBuilder<Word, Word, QAfterWhereClause> phraseIdEqualTo(int? phraseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'phraseId', value: [phraseId]),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> phraseIdNotEqualTo(
    int? phraseId,
  ) {
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

  QueryBuilder<Word, Word, QAfterWhereClause> phraseIdGreaterThan(
    int? phraseId, {
    bool include = false,
  }) {
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

  QueryBuilder<Word, Word, QAfterWhereClause> phraseIdLessThan(
    int? phraseId, {
    bool include = false,
  }) {
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

  QueryBuilder<Word, Word, QAfterWhereClause> phraseIdBetween(
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

  QueryBuilder<Word, Word, QAfterWhereClause> blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'blockId', value: [null]),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> blockIdIsNotNull() {
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

  QueryBuilder<Word, Word, QAfterWhereClause> blockIdEqualTo(int? blockId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'blockId', value: [blockId]),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> blockIdNotEqualTo(int? blockId) {
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

  QueryBuilder<Word, Word, QAfterWhereClause> blockIdGreaterThan(
    int? blockId, {
    bool include = false,
  }) {
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

  QueryBuilder<Word, Word, QAfterWhereClause> blockIdLessThan(
    int? blockId, {
    bool include = false,
  }) {
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

  QueryBuilder<Word, Word, QAfterWhereClause> blockIdBetween(
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

  QueryBuilder<Word, Word, QAfterWhereClause> lemmaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'lemma', value: [null]),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> lemmaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'lemma',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> lemmaEqualTo(String? lemma) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'lemma', value: [lemma]),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> lemmaNotEqualTo(String? lemma) {
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

extension WordQueryFilter on QueryBuilder<Word, Word, QFilterCondition> {
  QueryBuilder<Word, Word, QAfterFilterCondition> blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> blockIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'blockId'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> blockIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'blockId', value: value),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> blockIdGreaterThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> blockIdLessThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> blockIdBetween(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> grammarFunctionEqualTo(
    GrammarFunction value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'grammarFunction', value: value),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> grammarFunctionGreaterThan(
    GrammarFunction value, {
    bool include = false,
  }) {
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

  QueryBuilder<Word, Word, QAfterFilterCondition> grammarFunctionLessThan(
    GrammarFunction value, {
    bool include = false,
  }) {
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

  QueryBuilder<Word, Word, QAfterFilterCondition> grammarFunctionBetween(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> isClickableEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isClickable', value: value),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lemma'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lemma'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaEqualTo(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaGreaterThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaLessThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaBetween(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaStartsWith(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaEndsWith(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaContains(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaMatches(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lemma', value: ''),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> lemmaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lemma', value: ''),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phraseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'phraseId'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phraseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'phraseId'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phraseIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phraseId', value: value),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phraseIdGreaterThan(
    int? value, {
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

  QueryBuilder<Word, Word, QAfterFilterCondition> phraseIdLessThan(
    int? value, {
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

  QueryBuilder<Word, Word, QAfterFilterCondition> phraseIdBetween(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> posEqualTo(WordPos value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pos', value: value),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> posGreaterThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> posLessThan(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> posBetween(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> versionsLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', length, true, length, true);
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> versionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', 0, true, 0, true);
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> versionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> versionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', 0, true, length, include);
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> versionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'versions', length, include, 999999, true);
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> versionsLengthBetween(
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

  QueryBuilder<Word, Word, QAfterFilterCondition> wordPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'wordPosition'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> wordPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'wordPosition'),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> wordPositionEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wordPosition', value: value),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> wordPositionGreaterThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Word, Word, QAfterFilterCondition> wordPositionLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Word, Word, QAfterFilterCondition> wordPositionBetween(
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

extension WordQueryObject on QueryBuilder<Word, Word, QFilterCondition> {
  QueryBuilder<Word, Word, QAfterFilterCondition> versionsElement(
    FilterQuery<ReadingItem> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'versions');
    });
  }
}

extension WordQueryLinks on QueryBuilder<Word, Word, QFilterCondition> {}

extension WordQuerySortBy on QueryBuilder<Word, Word, QSortBy> {
  QueryBuilder<Word, Word, QAfterSortBy> sortByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByGrammarFunction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grammarFunction', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByGrammarFunctionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grammarFunction', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByIsClickable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isClickable', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByIsClickableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isClickable', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByLemma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByLemmaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByPosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByWordPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.desc);
    });
  }
}

extension WordQuerySortThenBy on QueryBuilder<Word, Word, QSortThenBy> {
  QueryBuilder<Word, Word, QAfterSortBy> thenByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByGrammarFunction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grammarFunction', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByGrammarFunctionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grammarFunction', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByIsClickable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isClickable', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByIsClickableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isClickable', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByLemma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByLemmaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByPosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByWordPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.desc);
    });
  }
}

extension WordQueryWhereDistinct on QueryBuilder<Word, Word, QDistinct> {
  QueryBuilder<Word, Word, QDistinct> distinctByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockId');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByGrammarFunction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grammarFunction');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByIsClickable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isClickable');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByLemma({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lemma', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phraseId');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pos');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordPosition');
    });
  }
}

extension WordQueryProperty on QueryBuilder<Word, Word, QQueryProperty> {
  QueryBuilder<Word, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Word, int?, QQueryOperations> blockIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockId');
    });
  }

  QueryBuilder<Word, GrammarFunction, QQueryOperations>
  grammarFunctionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grammarFunction');
    });
  }

  QueryBuilder<Word, bool, QQueryOperations> isClickableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isClickable');
    });
  }

  QueryBuilder<Word, String?, QQueryOperations> lemmaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lemma');
    });
  }

  QueryBuilder<Word, int?, QQueryOperations> phraseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phraseId');
    });
  }

  QueryBuilder<Word, WordPos, QQueryOperations> posProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pos');
    });
  }

  QueryBuilder<Word, List<ReadingItem>, QQueryOperations> versionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'versions');
    });
  }

  QueryBuilder<Word, int?, QQueryOperations> wordPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordPosition');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

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
