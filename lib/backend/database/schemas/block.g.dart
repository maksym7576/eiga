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
    r'blockTranslation': PropertySchema(
      id: 1,
      name: r'blockTranslation',
      type: IsarType.string,
    ),
    r'colorHex': PropertySchema(
      id: 2,
      name: r'colorHex',
      type: IsarType.string,
    ),
    r'contentSignature': PropertySchema(
      id: 3,
      name: r'contentSignature',
      type: IsarType.string,
    ),
    r'phraseId': PropertySchema(id: 4, name: r'phraseId', type: IsarType.long),
    r'translatedPositionIndex': PropertySchema(
      id: 5,
      name: r'translatedPositionIndex',
      type: IsarType.longList,
    ),
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
    r'contentSignature': IndexSchema(
      id: 9220733410883987810,
      name: r'contentSignature',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'contentSignature',
          type: IndexType.hash,
          caseSensitive: true,
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
  {
    final value = object.blockTranslation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.colorHex;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contentSignature;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.translatedPositionIndex.length * 8;
  return bytesCount;
}

void _blockSerialize(
  Block object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.blockPositionIndex);
  writer.writeString(offsets[1], object.blockTranslation);
  writer.writeString(offsets[2], object.colorHex);
  writer.writeString(offsets[3], object.contentSignature);
  writer.writeLong(offsets[4], object.phraseId);
  writer.writeLongList(offsets[5], object.translatedPositionIndex);
}

Block _blockDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Block(
    blockPositionIndex: reader.readLongOrNull(offsets[0]),
    blockTranslation: reader.readStringOrNull(offsets[1]),
    colorHex: reader.readStringOrNull(offsets[2]),
    contentSignature: reader.readStringOrNull(offsets[3]),
    phraseId: reader.readLongOrNull(offsets[4]),
    translatedPositionIndex: reader.readLongList(offsets[5]) ?? const [],
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
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongList(offset) ?? const []) as P;
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

  QueryBuilder<Block, Block, QAfterWhereClause> contentSignatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'contentSignature', value: [null]),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentSignatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'contentSignature',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentSignatureEqualTo(
    String? contentSignature,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'contentSignature',
          value: [contentSignature],
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentSignatureNotEqualTo(
    String? contentSignature,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'contentSignature',
                lower: [],
                upper: [contentSignature],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'contentSignature',
                lower: [contentSignature],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'contentSignature',
                lower: [contentSignature],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'contentSignature',
                lower: [],
                upper: [contentSignature],
                includeUpper: false,
              ),
            );
      }
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

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'blockTranslation'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  blockTranslationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'blockTranslation'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'blockTranslation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'blockTranslation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'blockTranslation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'blockTranslation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'blockTranslation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'blockTranslation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'blockTranslation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'blockTranslation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockTranslationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'blockTranslation', value: ''),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  blockTranslationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'blockTranslation', value: ''),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'colorHex'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'colorHex'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'colorHex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'colorHex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'colorHex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'colorHex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'colorHex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'colorHex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'colorHex',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'colorHex',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'colorHex', value: ''),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> colorHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'colorHex', value: ''),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'contentSignature'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  contentSignatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'contentSignature'),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'contentSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'contentSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'contentSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'contentSignature',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'contentSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'contentSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'contentSignature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'contentSignature',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentSignatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'contentSignature', value: ''),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  contentSignatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'contentSignature', value: ''),
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

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'translatedPositionIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'translatedPositionIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'translatedPositionIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'translatedPositionIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedPositionIndex',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'translatedPositionIndex', 0, true, 0, true);
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedPositionIndex',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedPositionIndex',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedPositionIndex',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
  translatedPositionIndexLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'translatedPositionIndex',
        lower,
        includeLower,
        upper,
        includeUpper,
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

  QueryBuilder<Block, Block, QAfterSortBy> sortByBlockTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockTranslation', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByBlockTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockTranslation', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByContentSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentSignature', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByContentSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentSignature', Sort.desc);
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

  QueryBuilder<Block, Block, QAfterSortBy> thenByBlockTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockTranslation', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByBlockTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockTranslation', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByContentSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentSignature', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByContentSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentSignature', Sort.desc);
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

  QueryBuilder<Block, Block, QDistinct> distinctByBlockTranslation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'blockTranslation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByColorHex({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorHex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByContentSignature({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'contentSignature',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phraseId');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByTranslatedPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translatedPositionIndex');
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

  QueryBuilder<Block, String?, QQueryOperations> blockTranslationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockTranslation');
    });
  }

  QueryBuilder<Block, String?, QQueryOperations> colorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorHex');
    });
  }

  QueryBuilder<Block, String?, QQueryOperations> contentSignatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentSignature');
    });
  }

  QueryBuilder<Block, int?, QQueryOperations> phraseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phraseId');
    });
  }

  QueryBuilder<Block, List<int>, QQueryOperations>
  translatedPositionIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedPositionIndex');
    });
  }
}
