// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'known_word_status.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKnownWordStatusCollection on Isar {
  IsarCollection<KnownWordStatus> get knownWordStatus => this.collection();
}

const KnownWordStatusSchema = CollectionSchema(
  name: r'KnownWordStatus',
  id: 1307583321653418014,
  properties: {
    r'base': PropertySchema(id: 0, name: r'base', type: IsarType.string),
    r'colorHex': PropertySchema(
      id: 1,
      name: r'colorHex',
      type: IsarType.string,
    ),
    r'styleId': PropertySchema(id: 2, name: r'styleId', type: IsarType.long),
  },

  estimateSize: _knownWordStatusEstimateSize,
  serialize: _knownWordStatusSerialize,
  deserialize: _knownWordStatusDeserialize,
  deserializeProp: _knownWordStatusDeserializeProp,
  idName: r'id',
  indexes: {
    r'base': IndexSchema(
      id: -8979444590381027379,
      name: r'base',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'base',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _knownWordStatusGetId,
  getLinks: _knownWordStatusGetLinks,
  attach: _knownWordStatusAttach,
  version: '3.3.2',
);

int _knownWordStatusEstimateSize(
  KnownWordStatus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.base;
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
  return bytesCount;
}

void _knownWordStatusSerialize(
  KnownWordStatus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.base);
  writer.writeString(offsets[1], object.colorHex);
  writer.writeLong(offsets[2], object.styleId);
}

KnownWordStatus _knownWordStatusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KnownWordStatus(
    base: reader.readStringOrNull(offsets[0]),
    colorHex: reader.readStringOrNull(offsets[1]),
    styleId: reader.readLongOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _knownWordStatusDeserializeProp<P>(
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
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _knownWordStatusGetId(KnownWordStatus object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _knownWordStatusGetLinks(KnownWordStatus object) {
  return [];
}

void _knownWordStatusAttach(
  IsarCollection<dynamic> col,
  Id id,
  KnownWordStatus object,
) {
  object.id = id;
}

extension KnownWordStatusByIndex on IsarCollection<KnownWordStatus> {
  Future<KnownWordStatus?> getByBase(String? base) {
    return getByIndex(r'base', [base]);
  }

  KnownWordStatus? getByBaseSync(String? base) {
    return getByIndexSync(r'base', [base]);
  }

  Future<bool> deleteByBase(String? base) {
    return deleteByIndex(r'base', [base]);
  }

  bool deleteByBaseSync(String? base) {
    return deleteByIndexSync(r'base', [base]);
  }

  Future<List<KnownWordStatus?>> getAllByBase(List<String?> baseValues) {
    final values = baseValues.map((e) => [e]).toList();
    return getAllByIndex(r'base', values);
  }

  List<KnownWordStatus?> getAllByBaseSync(List<String?> baseValues) {
    final values = baseValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'base', values);
  }

  Future<int> deleteAllByBase(List<String?> baseValues) {
    final values = baseValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'base', values);
  }

  int deleteAllByBaseSync(List<String?> baseValues) {
    final values = baseValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'base', values);
  }

  Future<Id> putByBase(KnownWordStatus object) {
    return putByIndex(r'base', object);
  }

  Id putByBaseSync(KnownWordStatus object, {bool saveLinks = true}) {
    return putByIndexSync(r'base', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBase(List<KnownWordStatus> objects) {
    return putAllByIndex(r'base', objects);
  }

  List<Id> putAllByBaseSync(
    List<KnownWordStatus> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'base', objects, saveLinks: saveLinks);
  }
}

extension KnownWordStatusQueryWhereSort
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QWhere> {
  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension KnownWordStatusQueryWhere
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QWhereClause> {
  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause>
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause> idBetween(
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause>
  baseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'base', value: [null]),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause>
  baseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'base',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause> baseEqualTo(
    String? base,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'base', value: [base]),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterWhereClause>
  baseNotEqualTo(String? base) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'base',
                lower: [],
                upper: [base],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'base',
                lower: [base],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'base',
                lower: [base],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'base',
                lower: [],
                upper: [base],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension KnownWordStatusQueryFilter
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QFilterCondition> {
  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'base'),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'base'),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'base',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'base',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'base',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'base',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'base',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'base',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'base',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'base',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'base', value: ''),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  baseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'base', value: ''),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'colorHex'),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'colorHex'),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexGreaterThan(
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexLessThan(
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexBetween(
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'colorHex', value: ''),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  colorHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'colorHex', value: ''),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
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

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  styleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'styleId'),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  styleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'styleId'),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  styleIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'styleId', value: value),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  styleIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'styleId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  styleIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'styleId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterFilterCondition>
  styleIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'styleId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension KnownWordStatusQueryObject
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QFilterCondition> {}

extension KnownWordStatusQueryLinks
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QFilterCondition> {}

extension KnownWordStatusQuerySortBy
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QSortBy> {
  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy> sortByBase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'base', Sort.asc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy>
  sortByBaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'base', Sort.desc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy>
  sortByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy>
  sortByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy> sortByStyleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleId', Sort.asc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy>
  sortByStyleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleId', Sort.desc);
    });
  }
}

extension KnownWordStatusQuerySortThenBy
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QSortThenBy> {
  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy> thenByBase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'base', Sort.asc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy>
  thenByBaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'base', Sort.desc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy>
  thenByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy>
  thenByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy> thenByStyleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleId', Sort.asc);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QAfterSortBy>
  thenByStyleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleId', Sort.desc);
    });
  }
}

extension KnownWordStatusQueryWhereDistinct
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QDistinct> {
  QueryBuilder<KnownWordStatus, KnownWordStatus, QDistinct> distinctByBase({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'base', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QDistinct> distinctByColorHex({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorHex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KnownWordStatus, KnownWordStatus, QDistinct>
  distinctByStyleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleId');
    });
  }
}

extension KnownWordStatusQueryProperty
    on QueryBuilder<KnownWordStatus, KnownWordStatus, QQueryProperty> {
  QueryBuilder<KnownWordStatus, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KnownWordStatus, String?, QQueryOperations> baseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'base');
    });
  }

  QueryBuilder<KnownWordStatus, String?, QQueryOperations> colorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorHex');
    });
  }

  QueryBuilder<KnownWordStatus, int?, QQueryOperations> styleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleId');
    });
  }
}
