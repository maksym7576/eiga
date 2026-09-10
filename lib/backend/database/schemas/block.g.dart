// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBlockCollection on Isar {
  IsarCollection<Block> get blocks => this.collection();
}

const BlockSchema = CollectionSchema(
  name: r'Block',
  id: -1408548915874355664,
  properties: {
    r'blockPositionIndex': PropertySchema(
      id: 0,
      name: r'blockPositionIndex',
      type: IsarType.long,
    ),
    r'phraseId': PropertySchema(id: 1, name: r'phraseId', type: IsarType.long),
  },

  estimateSize: _blockEstimateSize,
  serialize: _blockSerialize,
  deserialize: _blockDeserialize,
  deserializeProp: _blockDeserializeProp,
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
  },
  links: {},
  embeddedSchemas: {},

  getId: _blockGetId,
  getLinks: _blockGetLinks,
  attach: _blockAttach,
  version: '3.3.2',
);

int _blockEstimateSize(
  Block object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _blockSerialize(
  Block object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.blockPositionIndex);
  writer.writeLong(offsets[1], object.phraseId);
}

Block _blockDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Block(
    blockPositionIndex: reader.readLongOrNull(offsets[0]),
    phraseId: reader.readLongOrNull(offsets[1]),
  );
  object.id = id;
  return object;
}

P _blockDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _blockGetId(Block object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _blockGetLinks(Block object) {
  return [];
}

void _blockAttach(IsarCollection<dynamic> col, Id id, Block object) {
  object.id = id;
}

extension BlockQueryWhereSort on QueryBuilder<Block, Block, QWhere> {
  QueryBuilder<Block, Block, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Block, Block, QAfterWhere> anyPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'phraseId'),
      );
    });
  }
}

extension BlockQueryWhere on QueryBuilder<Block, Block, QWhereClause> {
  QueryBuilder<Block, Block, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Block, Block, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> idBetween(
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

  QueryBuilder<Block, Block, QAfterWhereClause> phraseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'phraseId', value: [null]),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> phraseIdIsNotNull() {
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

  QueryBuilder<Block, Block, QAfterWhereClause> phraseIdEqualTo(int? phraseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'phraseId', value: [phraseId]),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> phraseIdNotEqualTo(
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

  QueryBuilder<Block, Block, QAfterWhereClause> phraseIdGreaterThan(
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

  QueryBuilder<Block, Block, QAfterWhereClause> phraseIdLessThan(
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

  QueryBuilder<Block, Block, QAfterWhereClause> phraseIdBetween(
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
}

extension BlockQueryFilter on QueryBuilder<Block, Block, QFilterCondition> {
  QueryBuilder<Block, Block, QAfterFilterCondition> blockPositionIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'blockPositionIndex'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  blockPositionIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'blockPositionIndex'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockPositionIndexEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'blockPositionIndex', value: value),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  blockPositionIndexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'blockPositionIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockPositionIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'blockPositionIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockPositionIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'blockPositionIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Block, Block, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Block, Block, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Block, Block, QAfterFilterCondition> phraseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'phraseId'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> phraseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'phraseId'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> phraseIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phraseId', value: value),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> phraseIdGreaterThan(
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

  QueryBuilder<Block, Block, QAfterFilterCondition> phraseIdLessThan(
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

  QueryBuilder<Block, Block, QAfterFilterCondition> phraseIdBetween(
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
}

extension BlockQueryObject on QueryBuilder<Block, Block, QFilterCondition> {}

extension BlockQueryLinks on QueryBuilder<Block, Block, QFilterCondition> {}

extension BlockQuerySortBy on QueryBuilder<Block, Block, QSortBy> {
  QueryBuilder<Block, Block, QAfterSortBy> sortByBlockPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockPositionIndex', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByBlockPositionIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockPositionIndex', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }
}

extension BlockQuerySortThenBy on QueryBuilder<Block, Block, QSortThenBy> {
  QueryBuilder<Block, Block, QAfterSortBy> thenByBlockPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockPositionIndex', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByBlockPositionIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockPositionIndex', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }
}

extension BlockQueryWhereDistinct on QueryBuilder<Block, Block, QDistinct> {
  QueryBuilder<Block, Block, QDistinct> distinctByBlockPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockPositionIndex');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phraseId');
    });
  }
}

extension BlockQueryProperty on QueryBuilder<Block, Block, QQueryProperty> {
  QueryBuilder<Block, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Block, int?, QQueryOperations> blockPositionIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockPositionIndex');
    });
  }

  QueryBuilder<Block, int?, QQueryOperations> phraseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phraseId');
    });
  }
}
