// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specific_word_style.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSpecificWordStyleCollection on Isar {
  IsarCollection<SpecificWordStyle> get specificWordStyles => this.collection();
}

const SpecificWordStyleSchema = CollectionSchema(
  name: r'SpecificWordStyle',
  id: 2607856416232595474,
  properties: {
    r'borderColorValue': PropertySchema(
      id: 0,
      name: r'borderColorValue',
      type: IsarType.long,
    ),
    r'borderSize': PropertySchema(
      id: 1,
      name: r'borderSize',
      type: IsarType.long,
    ),
    r'colorValue': PropertySchema(
      id: 2,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'fontWeightIndex': PropertySchema(
      id: 3,
      name: r'fontWeightIndex',
      type: IsarType.long,
    ),
    r'name': PropertySchema(id: 4, name: r'name', type: IsarType.string),
  },

  estimateSize: _specificWordStyleEstimateSize,
  serialize: _specificWordStyleSerialize,
  deserialize: _specificWordStyleDeserialize,
  deserializeProp: _specificWordStyleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _specificWordStyleGetId,
  getLinks: _specificWordStyleGetLinks,
  attach: _specificWordStyleAttach,
  version: '3.3.2',
);

int _specificWordStyleEstimateSize(
  SpecificWordStyle object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _specificWordStyleSerialize(
  SpecificWordStyle object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.borderColorValue);
  writer.writeLong(offsets[1], object.borderSize);
  writer.writeLong(offsets[2], object.colorValue);
  writer.writeLong(offsets[3], object.fontWeightIndex);
  writer.writeString(offsets[4], object.name);
}

SpecificWordStyle _specificWordStyleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SpecificWordStyle();
  object.borderColorValue = reader.readLong(offsets[0]);
  object.borderSize = reader.readLong(offsets[1]);
  object.colorValue = reader.readLong(offsets[2]);
  object.fontWeightIndex = reader.readLong(offsets[3]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[4]);
  return object;
}

P _specificWordStyleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _specificWordStyleGetId(SpecificWordStyle object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _specificWordStyleGetLinks(
  SpecificWordStyle object,
) {
  return [];
}

void _specificWordStyleAttach(
  IsarCollection<dynamic> col,
  Id id,
  SpecificWordStyle object,
) {
  object.id = id;
}

extension SpecificWordStyleQueryWhereSort
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QWhere> {
  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SpecificWordStyleQueryWhere
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QWhereClause> {
  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterWhereClause>
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

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterWhereClause>
  idBetween(
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

extension SpecificWordStyleQueryFilter
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QFilterCondition> {
  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  borderColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorValue', value: value),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  borderColorValueGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  borderColorValueLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  borderColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  borderSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderSize', value: value),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  borderSizeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  borderSizeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  borderSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  colorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'colorValue', value: value),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  colorValueGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'colorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  colorValueLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'colorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'colorValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  fontWeightIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fontWeightIndex', value: value),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  fontWeightIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fontWeightIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  fontWeightIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fontWeightIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  fontWeightIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fontWeightIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
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

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
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

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
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

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }
}

extension SpecificWordStyleQueryObject
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QFilterCondition> {}

extension SpecificWordStyleQueryLinks
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QFilterCondition> {}

extension SpecificWordStyleQuerySortBy
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QSortBy> {
  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByBorderColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderColorValue', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByBorderColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderColorValue', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByBorderSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderSize', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByBorderSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderSize', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByFontWeightIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontWeightIndex', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByFontWeightIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontWeightIndex', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension SpecificWordStyleQuerySortThenBy
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QSortThenBy> {
  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByBorderColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderColorValue', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByBorderColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderColorValue', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByBorderSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderSize', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByBorderSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderSize', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByFontWeightIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontWeightIndex', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByFontWeightIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontWeightIndex', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension SpecificWordStyleQueryWhereDistinct
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QDistinct> {
  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QDistinct>
  distinctByBorderColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'borderColorValue');
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QDistinct>
  distinctByBorderSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'borderSize');
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QDistinct>
  distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QDistinct>
  distinctByFontWeightIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontWeightIndex');
    });
  }

  QueryBuilder<SpecificWordStyle, SpecificWordStyle, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension SpecificWordStyleQueryProperty
    on QueryBuilder<SpecificWordStyle, SpecificWordStyle, QQueryProperty> {
  QueryBuilder<SpecificWordStyle, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SpecificWordStyle, int, QQueryOperations>
  borderColorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'borderColorValue');
    });
  }

  QueryBuilder<SpecificWordStyle, int, QQueryOperations> borderSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'borderSize');
    });
  }

  QueryBuilder<SpecificWordStyle, int, QQueryOperations> colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<SpecificWordStyle, int, QQueryOperations>
  fontWeightIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontWeightIndex');
    });
  }

  QueryBuilder<SpecificWordStyle, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
