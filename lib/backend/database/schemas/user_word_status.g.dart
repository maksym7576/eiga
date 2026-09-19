// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_word_status.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserWordStatusCollection on Isar {
  IsarCollection<UserWordStatus> get userWordStatus => this.collection();
}

const UserWordStatusSchema = CollectionSchema(
  name: r'UserWordStatus',
  id: 7993867152183017501,
  properties: {
    r'lemma': PropertySchema(id: 0, name: r'lemma', type: IsarType.string),
    r'status': PropertySchema(
      id: 1,
      name: r'status',
      type: IsarType.byte,
      enumMap: _UserWordStatusstatusEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _userWordStatusEstimateSize,
  serialize: _userWordStatusSerialize,
  deserialize: _userWordStatusDeserialize,
  deserializeProp: _userWordStatusDeserializeProp,
  idName: r'id',
  indexes: {
    r'lemma': IndexSchema(
      id: -6799237479504882701,
      name: r'lemma',
      unique: true,
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

  getId: _userWordStatusGetId,
  getLinks: _userWordStatusGetLinks,
  attach: _userWordStatusAttach,
  version: '3.3.2',
);

int _userWordStatusEstimateSize(
  UserWordStatus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lemma.length * 3;
  return bytesCount;
}

void _userWordStatusSerialize(
  UserWordStatus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.lemma);
  writer.writeByte(offsets[1], object.status.index);
  writer.writeDateTime(offsets[2], object.updatedAt);
}

UserWordStatus _userWordStatusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserWordStatus(
    lemma: reader.readString(offsets[0]),
    status:
        _UserWordStatusstatusValueEnumMap[reader.readByteOrNull(offsets[1])] ??
        WordStatus.unknown,
    updatedAt: reader.readDateTimeOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _userWordStatusDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_UserWordStatusstatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              WordStatus.unknown)
          as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _UserWordStatusstatusEnumValueMap = {
  'unknown': 0,
  'learning': 1,
  'known': 2,
};
const _UserWordStatusstatusValueEnumMap = {
  0: WordStatus.unknown,
  1: WordStatus.learning,
  2: WordStatus.known,
};

Id _userWordStatusGetId(UserWordStatus object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userWordStatusGetLinks(UserWordStatus object) {
  return [];
}

void _userWordStatusAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserWordStatus object,
) {
  object.id = id;
}

extension UserWordStatusByIndex on IsarCollection<UserWordStatus> {
  Future<UserWordStatus?> getByLemma(String lemma) {
    return getByIndex(r'lemma', [lemma]);
  }

  UserWordStatus? getByLemmaSync(String lemma) {
    return getByIndexSync(r'lemma', [lemma]);
  }

  Future<bool> deleteByLemma(String lemma) {
    return deleteByIndex(r'lemma', [lemma]);
  }

  bool deleteByLemmaSync(String lemma) {
    return deleteByIndexSync(r'lemma', [lemma]);
  }

  Future<List<UserWordStatus?>> getAllByLemma(List<String> lemmaValues) {
    final values = lemmaValues.map((e) => [e]).toList();
    return getAllByIndex(r'lemma', values);
  }

  List<UserWordStatus?> getAllByLemmaSync(List<String> lemmaValues) {
    final values = lemmaValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'lemma', values);
  }

  Future<int> deleteAllByLemma(List<String> lemmaValues) {
    final values = lemmaValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'lemma', values);
  }

  int deleteAllByLemmaSync(List<String> lemmaValues) {
    final values = lemmaValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'lemma', values);
  }

  Future<Id> putByLemma(UserWordStatus object) {
    return putByIndex(r'lemma', object);
  }

  Id putByLemmaSync(UserWordStatus object, {bool saveLinks = true}) {
    return putByIndexSync(r'lemma', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLemma(List<UserWordStatus> objects) {
    return putAllByIndex(r'lemma', objects);
  }

  List<Id> putAllByLemmaSync(
    List<UserWordStatus> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'lemma', objects, saveLinks: saveLinks);
  }
}

extension UserWordStatusQueryWhereSort
    on QueryBuilder<UserWordStatus, UserWordStatus, QWhere> {
  QueryBuilder<UserWordStatus, UserWordStatus, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserWordStatusQueryWhere
    on QueryBuilder<UserWordStatus, UserWordStatus, QWhereClause> {
  QueryBuilder<UserWordStatus, UserWordStatus, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterWhereClause> idBetween(
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterWhereClause> lemmaEqualTo(
    String lemma,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'lemma', value: [lemma]),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterWhereClause>
  lemmaNotEqualTo(String lemma) {
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

extension UserWordStatusQueryFilter
    on QueryBuilder<UserWordStatus, UserWordStatus, QFilterCondition> {
  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaGreaterThan(
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaLessThan(
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaBetween(
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lemma', value: ''),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  lemmaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lemma', value: ''),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  statusEqualTo(WordStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  statusGreaterThan(WordStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  statusLessThan(WordStatus value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  statusBetween(
    WordStatus lower,
    WordStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  updatedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterFilterCondition>
  updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension UserWordStatusQueryObject
    on QueryBuilder<UserWordStatus, UserWordStatus, QFilterCondition> {}

extension UserWordStatusQueryLinks
    on QueryBuilder<UserWordStatus, UserWordStatus, QFilterCondition> {}

extension UserWordStatusQuerySortBy
    on QueryBuilder<UserWordStatus, UserWordStatus, QSortBy> {
  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> sortByLemma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.asc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> sortByLemmaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.desc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension UserWordStatusQuerySortThenBy
    on QueryBuilder<UserWordStatus, UserWordStatus, QSortThenBy> {
  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> thenByLemma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.asc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> thenByLemmaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.desc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension UserWordStatusQueryWhereDistinct
    on QueryBuilder<UserWordStatus, UserWordStatus, QDistinct> {
  QueryBuilder<UserWordStatus, UserWordStatus, QDistinct> distinctByLemma({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lemma', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<UserWordStatus, UserWordStatus, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension UserWordStatusQueryProperty
    on QueryBuilder<UserWordStatus, UserWordStatus, QQueryProperty> {
  QueryBuilder<UserWordStatus, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserWordStatus, String, QQueryOperations> lemmaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lemma');
    });
  }

  QueryBuilder<UserWordStatus, WordStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<UserWordStatus, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
