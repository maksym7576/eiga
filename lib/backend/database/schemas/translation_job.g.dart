// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_job.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTranslationJobCollection on Isar {
  IsarCollection<TranslationJob> get translationJobs => this.collection();
}

const TranslationJobSchema = CollectionSchema(
  name: r'TranslationJob',
  id: -222899793982030664,
  properties: {
    r'completedSteps': PropertySchema(
      id: 0,
      name: r'completedSteps',
      type: IsarType.long,
    ),
    r'endTime': PropertySchema(
      id: 1,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'errorMessage': PropertySchema(
      id: 2,
      name: r'errorMessage',
      type: IsarType.string,
    ),
    r'errorStage': PropertySchema(
      id: 3,
      name: r'errorStage',
      type: IsarType.string,
    ),
    r'executionPlan': PropertySchema(
      id: 4,
      name: r'executionPlan',
      type: IsarType.string,
    ),
    r'isAuto': PropertySchema(id: 5, name: r'isAuto', type: IsarType.bool),
    r'modelName': PropertySchema(
      id: 6,
      name: r'modelName',
      type: IsarType.string,
    ),
    r'phase': PropertySchema(id: 7, name: r'phase', type: IsarType.string),
    r'pipelineId': PropertySchema(
      id: 8,
      name: r'pipelineId',
      type: IsarType.string,
    ),
    r'processedPhrases': PropertySchema(
      id: 9,
      name: r'processedPhrases',
      type: IsarType.long,
    ),
    r'stageHistory': PropertySchema(
      id: 10,
      name: r'stageHistory',
      type: IsarType.objectList,

      target: r'AiStageHistory',
    ),
    r'startTime': PropertySchema(
      id: 11,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(id: 12, name: r'status', type: IsarType.string),
    r'totalPhrases': PropertySchema(
      id: 13,
      name: r'totalPhrases',
      type: IsarType.long,
    ),
    r'translatedAt': PropertySchema(
      id: 14,
      name: r'translatedAt',
      type: IsarType.dateTime,
    ),
    r'videoId': PropertySchema(id: 15, name: r'videoId', type: IsarType.long),
  },

  estimateSize: _translationJobEstimateSize,
  serialize: _translationJobSerialize,
  deserialize: _translationJobDeserialize,
  deserializeProp: _translationJobDeserializeProp,
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
  embeddedSchemas: {r'AiStageHistory': AiStageHistorySchema},

  getId: _translationJobGetId,
  getLinks: _translationJobGetLinks,
  attach: _translationJobAttach,
  version: '3.3.2',
);

int _translationJobEstimateSize(
  TranslationJob object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.errorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.errorStage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.executionPlan;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modelName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phase;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pipelineId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.stageHistory;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[AiStageHistory]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += AiStageHistorySchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _translationJobSerialize(
  TranslationJob object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completedSteps);
  writer.writeDateTime(offsets[1], object.endTime);
  writer.writeString(offsets[2], object.errorMessage);
  writer.writeString(offsets[3], object.errorStage);
  writer.writeString(offsets[4], object.executionPlan);
  writer.writeBool(offsets[5], object.isAuto);
  writer.writeString(offsets[6], object.modelName);
  writer.writeString(offsets[7], object.phase);
  writer.writeString(offsets[8], object.pipelineId);
  writer.writeLong(offsets[9], object.processedPhrases);
  writer.writeObjectList<AiStageHistory>(
    offsets[10],
    allOffsets,
    AiStageHistorySchema.serialize,
    object.stageHistory,
  );
  writer.writeDateTime(offsets[11], object.startTime);
  writer.writeString(offsets[12], object.status);
  writer.writeLong(offsets[13], object.totalPhrases);
  writer.writeDateTime(offsets[14], object.translatedAt);
  writer.writeLong(offsets[15], object.videoId);
}

TranslationJob _translationJobDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TranslationJob(
    completedSteps: reader.readLongOrNull(offsets[0]),
    endTime: reader.readDateTimeOrNull(offsets[1]),
    errorMessage: reader.readStringOrNull(offsets[2]),
    errorStage: reader.readStringOrNull(offsets[3]),
    executionPlan: reader.readStringOrNull(offsets[4]),
    isAuto: reader.readBoolOrNull(offsets[5]),
    modelName: reader.readStringOrNull(offsets[6]),
    phase: reader.readStringOrNull(offsets[7]),
    pipelineId: reader.readStringOrNull(offsets[8]),
    processedPhrases: reader.readLongOrNull(offsets[9]),
    stageHistory: reader.readObjectList<AiStageHistory>(
      offsets[10],
      AiStageHistorySchema.deserialize,
      allOffsets,
      AiStageHistory(),
    ),
    startTime: reader.readDateTimeOrNull(offsets[11]),
    status: reader.readStringOrNull(offsets[12]),
    totalPhrases: reader.readLongOrNull(offsets[13]),
    translatedAt: reader.readDateTimeOrNull(offsets[14]),
    videoId: reader.readLong(offsets[15]),
  );
  object.id = id;
  return object;
}

P _translationJobDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readObjectList<AiStageHistory>(
            offset,
            AiStageHistorySchema.deserialize,
            allOffsets,
            AiStageHistory(),
          ))
          as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _translationJobGetId(TranslationJob object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _translationJobGetLinks(TranslationJob object) {
  return [];
}

void _translationJobAttach(
  IsarCollection<dynamic> col,
  Id id,
  TranslationJob object,
) {
  object.id = id;
}

extension TranslationJobQueryWhereSort
    on QueryBuilder<TranslationJob, TranslationJob, QWhere> {
  QueryBuilder<TranslationJob, TranslationJob, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhere> anyVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'videoId'),
      );
    });
  }
}

extension TranslationJobQueryWhere
    on QueryBuilder<TranslationJob, TranslationJob, QWhereClause> {
  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause> idBetween(
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause>
  videoIdEqualTo(int videoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'videoId', value: [videoId]),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause>
  videoIdNotEqualTo(int videoId) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause>
  videoIdGreaterThan(int videoId, {bool include = false}) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause>
  videoIdLessThan(int videoId, {bool include = false}) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterWhereClause>
  videoIdBetween(
    int lowerVideoId,
    int upperVideoId, {
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

extension TranslationJobQueryFilter
    on QueryBuilder<TranslationJob, TranslationJob, QFilterCondition> {
  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  completedStepsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'completedSteps'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  completedStepsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'completedSteps'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  completedStepsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedSteps', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  completedStepsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedSteps',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  completedStepsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedSteps',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  completedStepsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedSteps',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'endTime'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'endTime'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  endTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endTime', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  endTimeGreaterThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  endTimeLessThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  endTimeBetween(
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'errorMessage'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'errorMessage'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'errorMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'errorMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'errorMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'errorMessage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'errorMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'errorMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'errorMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'errorMessage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'errorMessage', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'errorMessage', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'errorStage'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'errorStage'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'errorStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'errorStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'errorStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'errorStage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'errorStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'errorStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'errorStage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'errorStage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'errorStage', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  errorStageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'errorStage', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'executionPlan'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'executionPlan'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'executionPlan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'executionPlan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'executionPlan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'executionPlan',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'executionPlan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'executionPlan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'executionPlan',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'executionPlan',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'executionPlan', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  executionPlanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'executionPlan', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  isAutoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isAuto'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  isAutoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isAuto'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  isAutoEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isAuto', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'modelName'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'modelName'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'modelName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'modelName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'modelName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'modelName', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  modelNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'modelName', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'phase'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'phase'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phase',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'phase',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'phase',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phase', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  phaseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'phase', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pipelineId'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pipelineId'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pipelineId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pipelineId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pipelineId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pipelineId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pipelineId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pipelineId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pipelineId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pipelineId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pipelineId', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  pipelineIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pipelineId', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  processedPhrasesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'processedPhrases'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  processedPhrasesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'processedPhrases'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  processedPhrasesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'processedPhrases', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  processedPhrasesGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'processedPhrases',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  processedPhrasesLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'processedPhrases',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  processedPhrasesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'processedPhrases',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'stageHistory'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'stageHistory'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageHistory', length, true, length, true);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageHistory', 0, true, 0, true);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageHistory', 0, false, 999999, true);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageHistory', 0, true, length, include);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'stageHistory', length, include, 999999, true);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stageHistory',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startTime'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startTime'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  startTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startTime', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  startTimeGreaterThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  startTimeLessThan(DateTime? value, {bool include = false}) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  startTimeBetween(
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'status'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'status'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  totalPhrasesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'totalPhrases'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  totalPhrasesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'totalPhrases'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  totalPhrasesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalPhrases', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  totalPhrasesGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalPhrases',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  totalPhrasesLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalPhrases',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  totalPhrasesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalPhrases',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  translatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'translatedAt'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  translatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'translatedAt'),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  translatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'translatedAt', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  translatedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'translatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  translatedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'translatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  translatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'translatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  videoIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoId', value: value),
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  videoIdGreaterThan(int value, {bool include = false}) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  videoIdLessThan(int value, {bool include = false}) {
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

  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  videoIdBetween(
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
}

extension TranslationJobQueryObject
    on QueryBuilder<TranslationJob, TranslationJob, QFilterCondition> {
  QueryBuilder<TranslationJob, TranslationJob, QAfterFilterCondition>
  stageHistoryElement(FilterQuery<AiStageHistory> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'stageHistory');
    });
  }
}

extension TranslationJobQueryLinks
    on QueryBuilder<TranslationJob, TranslationJob, QFilterCondition> {}

extension TranslationJobQuerySortBy
    on QueryBuilder<TranslationJob, TranslationJob, QSortBy> {
  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByCompletedSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSteps', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByCompletedStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSteps', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByErrorStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorStage', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByErrorStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorStage', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByExecutionPlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executionPlan', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByExecutionPlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executionPlan', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> sortByIsAuto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAuto', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByIsAutoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAuto', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> sortByModelName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByModelNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> sortByPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> sortByPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByPipelineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipelineId', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByPipelineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipelineId', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByProcessedPhrases() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedPhrases', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByProcessedPhrasesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedPhrases', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByTotalPhrases() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPhrases', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByTotalPhrasesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPhrases', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByTranslatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedAt', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByTranslatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedAt', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> sortByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  sortByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension TranslationJobQuerySortThenBy
    on QueryBuilder<TranslationJob, TranslationJob, QSortThenBy> {
  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByCompletedSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSteps', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByCompletedStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedSteps', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByErrorStage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorStage', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByErrorStageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorStage', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByExecutionPlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executionPlan', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByExecutionPlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executionPlan', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByIsAuto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAuto', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByIsAutoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAuto', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByModelName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByModelNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelName', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByPipelineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipelineId', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByPipelineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pipelineId', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByProcessedPhrases() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedPhrases', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByProcessedPhrasesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedPhrases', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByTotalPhrases() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPhrases', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByTotalPhrasesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPhrases', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByTranslatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedAt', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByTranslatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedAt', Sort.desc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy> thenByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QAfterSortBy>
  thenByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension TranslationJobQueryWhereDistinct
    on QueryBuilder<TranslationJob, TranslationJob, QDistinct> {
  QueryBuilder<TranslationJob, TranslationJob, QDistinct>
  distinctByCompletedSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedSteps');
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct>
  distinctByErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct> distinctByErrorStage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorStage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct>
  distinctByExecutionPlan({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'executionPlan',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct> distinctByIsAuto() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAuto');
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct> distinctByModelName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct> distinctByPhase({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phase', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct> distinctByPipelineId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pipelineId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct>
  distinctByProcessedPhrases() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'processedPhrases');
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct>
  distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct>
  distinctByTotalPhrases() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPhrases');
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct>
  distinctByTranslatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translatedAt');
    });
  }

  QueryBuilder<TranslationJob, TranslationJob, QDistinct> distinctByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoId');
    });
  }
}

extension TranslationJobQueryProperty
    on QueryBuilder<TranslationJob, TranslationJob, QQueryProperty> {
  QueryBuilder<TranslationJob, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TranslationJob, int?, QQueryOperations>
  completedStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedSteps');
    });
  }

  QueryBuilder<TranslationJob, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<TranslationJob, String?, QQueryOperations>
  errorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorMessage');
    });
  }

  QueryBuilder<TranslationJob, String?, QQueryOperations> errorStageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorStage');
    });
  }

  QueryBuilder<TranslationJob, String?, QQueryOperations>
  executionPlanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'executionPlan');
    });
  }

  QueryBuilder<TranslationJob, bool?, QQueryOperations> isAutoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAuto');
    });
  }

  QueryBuilder<TranslationJob, String?, QQueryOperations> modelNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelName');
    });
  }

  QueryBuilder<TranslationJob, String?, QQueryOperations> phaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phase');
    });
  }

  QueryBuilder<TranslationJob, String?, QQueryOperations> pipelineIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pipelineId');
    });
  }

  QueryBuilder<TranslationJob, int?, QQueryOperations>
  processedPhrasesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'processedPhrases');
    });
  }

  QueryBuilder<TranslationJob, List<AiStageHistory>?, QQueryOperations>
  stageHistoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stageHistory');
    });
  }

  QueryBuilder<TranslationJob, DateTime?, QQueryOperations>
  startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<TranslationJob, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TranslationJob, int?, QQueryOperations> totalPhrasesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPhrases');
    });
  }

  QueryBuilder<TranslationJob, DateTime?, QQueryOperations>
  translatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedAt');
    });
  }

  QueryBuilder<TranslationJob, int, QQueryOperations> videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoId');
    });
  }
}
