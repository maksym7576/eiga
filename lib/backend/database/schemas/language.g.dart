// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLanguageCollection on Isar {
  IsarCollection<Language> get languages => this.collection();
}

const LanguageSchema = CollectionSchema(
  name: r'Language',
  id: -2011595345252117802,
  properties: {
    r'code': PropertySchema(id: 0, name: r'code', type: IsarType.string),
    r'iconLabel': PropertySchema(
      id: 1,
      name: r'iconLabel',
      type: IsarType.string,
    ),
    r'isSupported': PropertySchema(
      id: 2,
      name: r'isSupported',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'readingLabels': PropertySchema(
      id: 4,
      name: r'readingLabels',
      type: IsarType.stringList,
    ),
    r'readingOptions': PropertySchema(
      id: 5,
      name: r'readingOptions',
      type: IsarType.stringList,
    ),
    r'removeAllSpaces': PropertySchema(
      id: 6,
      name: r'removeAllSpaces',
      type: IsarType.bool,
    ),
    r'spacingOptions': PropertySchema(
      id: 7,
      name: r'spacingOptions',
      type: IsarType.stringList,
    ),
    r'subtitle': PropertySchema(
      id: 8,
      name: r'subtitle',
      type: IsarType.string,
    ),
    r'tokenizationMethod': PropertySchema(
      id: 9,
      name: r'tokenizationMethod',
      type: IsarType.byte,
      enumMap: _LanguagetokenizationMethodEnumValueMap,
    ),
  },

  estimateSize: _languageEstimateSize,
  serialize: _languageSerialize,
  deserialize: _languageDeserialize,
  deserializeProp: _languageDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'code': IndexSchema(
      id: 329780482934683790,
      name: r'code',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'code',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _languageGetId,
  getLinks: _languageGetLinks,
  attach: _languageAttach,
  version: '3.3.2',
);

int _languageEstimateSize(
  Language object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.code;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.iconLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.readingLabels.length * 3;
  {
    for (var i = 0; i < object.readingLabels.length; i++) {
      final value = object.readingLabels[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.readingOptions.length * 3;
  {
    for (var i = 0; i < object.readingOptions.length; i++) {
      final value = object.readingOptions[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.spacingOptions.length * 3;
  {
    for (var i = 0; i < object.spacingOptions.length; i++) {
      final value = object.spacingOptions[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.subtitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _languageSerialize(
  Language object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.code);
  writer.writeString(offsets[1], object.iconLabel);
  writer.writeBool(offsets[2], object.isSupported);
  writer.writeString(offsets[3], object.name);
  writer.writeStringList(offsets[4], object.readingLabels);
  writer.writeStringList(offsets[5], object.readingOptions);
  writer.writeBool(offsets[6], object.removeAllSpaces);
  writer.writeStringList(offsets[7], object.spacingOptions);
  writer.writeString(offsets[8], object.subtitle);
  writer.writeByte(offsets[9], object.tokenizationMethod.index);
}

Language _languageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Language(
    code: reader.readStringOrNull(offsets[0]),
    iconLabel: reader.readStringOrNull(offsets[1]),
    isSupported: reader.readBoolOrNull(offsets[2]) ?? false,
    name: reader.readStringOrNull(offsets[3]),
    readingLabels: reader.readStringList(offsets[4]) ?? const [],
    readingOptions: reader.readStringList(offsets[5]) ?? const [],
    removeAllSpaces: reader.readBoolOrNull(offsets[6]) ?? false,
    spacingOptions: reader.readStringList(offsets[7]) ?? const [],
    subtitle: reader.readStringOrNull(offsets[8]),
    tokenizationMethod:
        _LanguagetokenizationMethodValueEnumMap[reader.readByteOrNull(
          offsets[9],
        )] ??
        TokenizationMethod.local,
  );
  object.id = id;
  return object;
}

P _languageDeserializeProp<P>(
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
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? const []) as P;
    case 5:
      return (reader.readStringList(offset) ?? const []) as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 7:
      return (reader.readStringList(offset) ?? const []) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (_LanguagetokenizationMethodValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              TokenizationMethod.local)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LanguagetokenizationMethodEnumValueMap = {'local': 0, 'ai': 1};
const _LanguagetokenizationMethodValueEnumMap = {
  0: TokenizationMethod.local,
  1: TokenizationMethod.ai,
};

Id _languageGetId(Language object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _languageGetLinks(Language object) {
  return [];
}

void _languageAttach(IsarCollection<dynamic> col, Id id, Language object) {
  object.id = id;
}

extension LanguageByIndex on IsarCollection<Language> {
  Future<Language?> getByName(String? name) {
    return getByIndex(r'name', [name]);
  }

  Language? getByNameSync(String? name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String? name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String? name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<Language?>> getAllByName(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<Language?> getAllByNameSync(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String?> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(Language object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(Language object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<Language> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<Language> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }

  Future<Language?> getByCode(String? code) {
    return getByIndex(r'code', [code]);
  }

  Language? getByCodeSync(String? code) {
    return getByIndexSync(r'code', [code]);
  }

  Future<bool> deleteByCode(String? code) {
    return deleteByIndex(r'code', [code]);
  }

  bool deleteByCodeSync(String? code) {
    return deleteByIndexSync(r'code', [code]);
  }

  Future<List<Language?>> getAllByCode(List<String?> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndex(r'code', values);
  }

  List<Language?> getAllByCodeSync(List<String?> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'code', values);
  }

  Future<int> deleteAllByCode(List<String?> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'code', values);
  }

  int deleteAllByCodeSync(List<String?> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'code', values);
  }

  Future<Id> putByCode(Language object) {
    return putByIndex(r'code', object);
  }

  Id putByCodeSync(Language object, {bool saveLinks = true}) {
    return putByIndexSync(r'code', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCode(List<Language> objects) {
    return putAllByIndex(r'code', objects);
  }

  List<Id> putAllByCodeSync(List<Language> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'code', objects, saveLinks: saveLinks);
  }
}

extension LanguageQueryWhereSort on QueryBuilder<Language, Language, QWhere> {
  QueryBuilder<Language, Language, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LanguageQueryWhere on QueryBuilder<Language, Language, QWhereClause> {
  QueryBuilder<Language, Language, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Language, Language, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> idBetween(
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

  QueryBuilder<Language, Language, QAfterWhereClause> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [null]),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> nameEqualTo(
    String? name,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> nameNotEqualTo(
    String? name,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> codeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'code', value: [null]),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> codeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'code',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> codeEqualTo(
    String? code,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'code', value: [code]),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterWhereClause> codeNotEqualTo(
    String? code,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [],
                upper: [code],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [code],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [code],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code',
                lower: [],
                upper: [code],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension LanguageQueryFilter
    on QueryBuilder<Language, Language, QFilterCondition> {
  QueryBuilder<Language, Language, QAfterFilterCondition> codeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'code'),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'code'),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'code',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'code',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'iconLabel'),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'iconLabel'),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'iconLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'iconLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'iconLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'iconLabel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'iconLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'iconLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'iconLabel',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'iconLabel',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> iconLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'iconLabel', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  iconLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'iconLabel', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Language, Language, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Language, Language, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Language, Language, QAfterFilterCondition> isSupportedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isSupported', value: value),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Language, Language, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Language, Language, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Language, Language, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Language, Language, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Language, Language, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Language, Language, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Language, Language, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Language, Language, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'readingLabels',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'readingLabels',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'readingLabels',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'readingLabels',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'readingLabels',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'readingLabels',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'readingLabels',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'readingLabels',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'readingLabels', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'readingLabels', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingLabels', length, true, length, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingLabels', 0, true, 0, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingLabels', 0, false, 999999, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingLabels', 0, true, length, include);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingLabels', length, include, 999999, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingLabelsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readingLabels',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'readingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'readingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'readingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'readingOptions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'readingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'readingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'readingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'readingOptions',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'readingOptions', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'readingOptions', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingOptions', length, true, length, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingOptions', 0, true, 0, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingOptions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingOptions', 0, true, length, include);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'readingOptions', length, include, 999999, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  readingOptionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'readingOptions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  removeAllSpacesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'removeAllSpaces', value: value),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'spacingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'spacingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'spacingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'spacingOptions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'spacingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'spacingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'spacingOptions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'spacingOptions',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'spacingOptions', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'spacingOptions', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'spacingOptions', length, true, length, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'spacingOptions', 0, true, 0, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'spacingOptions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'spacingOptions', 0, true, length, include);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'spacingOptions', length, include, 999999, true);
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  spacingOptionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'spacingOptions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'subtitle'),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'subtitle'),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'subtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'subtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'subtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'subtitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'subtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'subtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'subtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'subtitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'subtitle', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition> subtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'subtitle', value: ''),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  tokenizationMethodEqualTo(TokenizationMethod value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tokenizationMethod', value: value),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  tokenizationMethodGreaterThan(
    TokenizationMethod value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tokenizationMethod',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  tokenizationMethodLessThan(TokenizationMethod value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tokenizationMethod',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Language, Language, QAfterFilterCondition>
  tokenizationMethodBetween(
    TokenizationMethod lower,
    TokenizationMethod upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tokenizationMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LanguageQueryObject
    on QueryBuilder<Language, Language, QFilterCondition> {}

extension LanguageQueryLinks
    on QueryBuilder<Language, Language, QFilterCondition> {}

extension LanguageQuerySortBy on QueryBuilder<Language, Language, QSortBy> {
  QueryBuilder<Language, Language, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByIconLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconLabel', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByIconLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconLabel', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByIsSupportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByRemoveAllSpaces() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'removeAllSpaces', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByRemoveAllSpacesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'removeAllSpaces', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> sortByTokenizationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenizationMethod', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy>
  sortByTokenizationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenizationMethod', Sort.desc);
    });
  }
}

extension LanguageQuerySortThenBy
    on QueryBuilder<Language, Language, QSortThenBy> {
  QueryBuilder<Language, Language, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByIconLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconLabel', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByIconLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconLabel', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByIsSupportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByRemoveAllSpaces() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'removeAllSpaces', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByRemoveAllSpacesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'removeAllSpaces', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenBySubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenBySubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtitle', Sort.desc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy> thenByTokenizationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenizationMethod', Sort.asc);
    });
  }

  QueryBuilder<Language, Language, QAfterSortBy>
  thenByTokenizationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenizationMethod', Sort.desc);
    });
  }
}

extension LanguageQueryWhereDistinct
    on QueryBuilder<Language, Language, QDistinct> {
  QueryBuilder<Language, Language, QDistinct> distinctByCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctByIconLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSupported');
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctByReadingLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingLabels');
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctByReadingOptions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingOptions');
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctByRemoveAllSpaces() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'removeAllSpaces');
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctBySpacingOptions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spacingOptions');
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctBySubtitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Language, Language, QDistinct> distinctByTokenizationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tokenizationMethod');
    });
  }
}

extension LanguageQueryProperty
    on QueryBuilder<Language, Language, QQueryProperty> {
  QueryBuilder<Language, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Language, String?, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<Language, String?, QQueryOperations> iconLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconLabel');
    });
  }

  QueryBuilder<Language, bool, QQueryOperations> isSupportedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSupported');
    });
  }

  QueryBuilder<Language, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Language, List<String>, QQueryOperations>
  readingLabelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingLabels');
    });
  }

  QueryBuilder<Language, List<String>, QQueryOperations>
  readingOptionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingOptions');
    });
  }

  QueryBuilder<Language, bool, QQueryOperations> removeAllSpacesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'removeAllSpaces');
    });
  }

  QueryBuilder<Language, List<String>, QQueryOperations>
  spacingOptionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spacingOptions');
    });
  }

  QueryBuilder<Language, String?, QQueryOperations> subtitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtitle');
    });
  }

  QueryBuilder<Language, TokenizationMethod, QQueryOperations>
  tokenizationMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tokenizationMethod');
    });
  }
}
