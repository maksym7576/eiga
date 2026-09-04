// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAiModelCollection on Isar {
  IsarCollection<AiModel> get aiModels => this.collection();
}

const AiModelSchema = CollectionSchema(
  name: r'AiModel',
  id: 4790848544183827605,
  properties: {
    r'contextWindow': PropertySchema(
      id: 0,
      name: r'contextWindow',
      type: IsarType.long,
    ),
    r'currentDailyMaxLimit': PropertySchema(
      id: 1,
      name: r'currentDailyMaxLimit',
      type: IsarType.long,
    ),
    r'currentMaxLimit': PropertySchema(
      id: 2,
      name: r'currentMaxLimit',
      type: IsarType.long,
    ),
    r'currentPhrasesPerRequest': PropertySchema(
      id: 3,
      name: r'currentPhrasesPerRequest',
      type: IsarType.long,
    ),
    r'currentStreamingEnabled': PropertySchema(
      id: 4,
      name: r'currentStreamingEnabled',
      type: IsarType.bool,
    ),
    r'dailyUsed': PropertySchema(
      id: 5,
      name: r'dailyUsed',
      type: IsarType.long,
    ),
    r'defaultDailyMaxLimit': PropertySchema(
      id: 6,
      name: r'defaultDailyMaxLimit',
      type: IsarType.long,
    ),
    r'defaultLimit': PropertySchema(
      id: 7,
      name: r'defaultLimit',
      type: IsarType.long,
    ),
    r'defaultPhrasesPerRequest': PropertySchema(
      id: 8,
      name: r'defaultPhrasesPerRequest',
      type: IsarType.long,
    ),
    r'estimatedTokensPerSec': PropertySchema(
      id: 9,
      name: r'estimatedTokensPerSec',
      type: IsarType.long,
    ),
    r'inputPricePerMToken': PropertySchema(
      id: 10,
      name: r'inputPricePerMToken',
      type: IsarType.double,
    ),
    r'isDailyMaxLimitCustom': PropertySchema(
      id: 11,
      name: r'isDailyMaxLimitCustom',
      type: IsarType.bool,
    ),
    r'isMaxLimitCustom': PropertySchema(
      id: 12,
      name: r'isMaxLimitCustom',
      type: IsarType.bool,
    ),
    r'isPhrasesPerRequestCustom': PropertySchema(
      id: 13,
      name: r'isPhrasesPerRequestCustom',
      type: IsarType.bool,
    ),
    r'isStreamingCustom': PropertySchema(
      id: 14,
      name: r'isStreamingCustom',
      type: IsarType.bool,
    ),
    r'maxOutputTokens': PropertySchema(
      id: 15,
      name: r'maxOutputTokens',
      type: IsarType.long,
    ),
    r'name': PropertySchema(id: 16, name: r'name', type: IsarType.string),
    r'outputPricePerMToken': PropertySchema(
      id: 17,
      name: r'outputPricePerMToken',
      type: IsarType.double,
    ),
    r'provider': PropertySchema(
      id: 18,
      name: r'provider',
      type: IsarType.string,
      enumMap: _AiModelproviderEnumValueMap,
    ),
    r'quality': PropertySchema(
      id: 19,
      name: r'quality',
      type: IsarType.string,
      enumMap: _AiModelqualityEnumValueMap,
    ),
    r'speed': PropertySchema(
      id: 20,
      name: r'speed',
      type: IsarType.string,
      enumMap: _AiModelspeedEnumValueMap,
    ),
    r'supportedInputs': PropertySchema(
      id: 21,
      name: r'supportedInputs',
      type: IsarType.stringList,
      enumMap: _AiModelsupportedInputsEnumValueMap,
    ),
    r'supportedSteps': PropertySchema(
      id: 22,
      name: r'supportedSteps',
      type: IsarType.stringList,
      enumMap: _AiModelsupportedStepsEnumValueMap,
    ),
    r'supportsLiveApi': PropertySchema(
      id: 23,
      name: r'supportsLiveApi',
      type: IsarType.bool,
    ),
    r'supportsStreaming': PropertySchema(
      id: 24,
      name: r'supportsStreaming',
      type: IsarType.bool,
    ),
    r'supportsThinking': PropertySchema(
      id: 25,
      name: r'supportsThinking',
      type: IsarType.bool,
    ),
    r'supportsWebSearch': PropertySchema(
      id: 26,
      name: r'supportsWebSearch',
      type: IsarType.bool,
    ),
    r'url': PropertySchema(id: 27, name: r'url', type: IsarType.string),
    r'used': PropertySchema(id: 28, name: r'used', type: IsarType.long),
  },

  estimateSize: _aiModelEstimateSize,
  serialize: _aiModelSerialize,
  deserialize: _aiModelDeserialize,
  deserializeProp: _aiModelDeserializeProp,
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
  },
  links: {},
  embeddedSchemas: {},

  getId: _aiModelGetId,
  getLinks: _aiModelGetLinks,
  attach: _aiModelAttach,
  version: '3.3.2',
);

int _aiModelEstimateSize(
  AiModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.provider.name.length * 3;
  bytesCount += 3 + object.quality.name.length * 3;
  bytesCount += 3 + object.speed.name.length * 3;
  bytesCount += 3 + object.supportedInputs.length * 3;
  {
    for (var i = 0; i < object.supportedInputs.length; i++) {
      final value = object.supportedInputs[i];
      bytesCount += value.name.length * 3;
    }
  }
  bytesCount += 3 + object.supportedSteps.length * 3;
  {
    for (var i = 0; i < object.supportedSteps.length; i++) {
      final value = object.supportedSteps[i];
      bytesCount += value.name.length * 3;
    }
  }
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _aiModelSerialize(
  AiModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.contextWindow);
  writer.writeLong(offsets[1], object.currentDailyMaxLimit);
  writer.writeLong(offsets[2], object.currentMaxLimit);
  writer.writeLong(offsets[3], object.currentPhrasesPerRequest);
  writer.writeBool(offsets[4], object.currentStreamingEnabled);
  writer.writeLong(offsets[5], object.dailyUsed);
  writer.writeLong(offsets[6], object.defaultDailyMaxLimit);
  writer.writeLong(offsets[7], object.defaultLimit);
  writer.writeLong(offsets[8], object.defaultPhrasesPerRequest);
  writer.writeLong(offsets[9], object.estimatedTokensPerSec);
  writer.writeDouble(offsets[10], object.inputPricePerMToken);
  writer.writeBool(offsets[11], object.isDailyMaxLimitCustom);
  writer.writeBool(offsets[12], object.isMaxLimitCustom);
  writer.writeBool(offsets[13], object.isPhrasesPerRequestCustom);
  writer.writeBool(offsets[14], object.isStreamingCustom);
  writer.writeLong(offsets[15], object.maxOutputTokens);
  writer.writeString(offsets[16], object.name);
  writer.writeDouble(offsets[17], object.outputPricePerMToken);
  writer.writeString(offsets[18], object.provider.name);
  writer.writeString(offsets[19], object.quality.name);
  writer.writeString(offsets[20], object.speed.name);
  writer.writeStringList(
    offsets[21],
    object.supportedInputs.map((e) => e.name).toList(),
  );
  writer.writeStringList(
    offsets[22],
    object.supportedSteps.map((e) => e.name).toList(),
  );
  writer.writeBool(offsets[23], object.supportsLiveApi);
  writer.writeBool(offsets[24], object.supportsStreaming);
  writer.writeBool(offsets[25], object.supportsThinking);
  writer.writeBool(offsets[26], object.supportsWebSearch);
  writer.writeString(offsets[27], object.url);
  writer.writeLong(offsets[28], object.used);
}

AiModel _aiModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AiModel();
  object.contextWindow = reader.readLong(offsets[0]);
  object.currentDailyMaxLimit = reader.readLong(offsets[1]);
  object.currentMaxLimit = reader.readLong(offsets[2]);
  object.currentPhrasesPerRequest = reader.readLong(offsets[3]);
  object.currentStreamingEnabled = reader.readBool(offsets[4]);
  object.dailyUsed = reader.readLong(offsets[5]);
  object.defaultDailyMaxLimit = reader.readLong(offsets[6]);
  object.defaultLimit = reader.readLong(offsets[7]);
  object.defaultPhrasesPerRequest = reader.readLong(offsets[8]);
  object.estimatedTokensPerSec = reader.readLong(offsets[9]);
  object.id = id;
  object.inputPricePerMToken = reader.readDouble(offsets[10]);
  object.isDailyMaxLimitCustom = reader.readBool(offsets[11]);
  object.isMaxLimitCustom = reader.readBool(offsets[12]);
  object.isPhrasesPerRequestCustom = reader.readBool(offsets[13]);
  object.isStreamingCustom = reader.readBool(offsets[14]);
  object.maxOutputTokens = reader.readLong(offsets[15]);
  object.name = reader.readString(offsets[16]);
  object.outputPricePerMToken = reader.readDouble(offsets[17]);
  object.provider =
      _AiModelproviderValueEnumMap[reader.readStringOrNull(offsets[18])] ??
      AiProvider.google;
  object.quality =
      _AiModelqualityValueEnumMap[reader.readStringOrNull(offsets[19])] ??
      ModelQuality.basic;
  object.speed =
      _AiModelspeedValueEnumMap[reader.readStringOrNull(offsets[20])] ??
      ModelSpeed.ultraFast;
  object.supportedInputs =
      reader
          .readStringList(offsets[21])
          ?.map((e) => _AiModelsupportedInputsValueEnumMap[e] ?? InputType.text)
          .toList() ??
      [];
  object.supportedSteps =
      reader
          .readStringList(offsets[22])
          ?.map(
            (e) =>
                _AiModelsupportedStepsValueEnumMap[e] ??
                TranslationPipelineStep.research,
          )
          .toList() ??
      [];
  object.supportsLiveApi = reader.readBool(offsets[23]);
  object.supportsStreaming = reader.readBool(offsets[24]);
  object.supportsThinking = reader.readBool(offsets[25]);
  object.supportsWebSearch = reader.readBool(offsets[26]);
  object.url = reader.readString(offsets[27]);
  object.used = reader.readLong(offsets[28]);
  return object;
}

P _aiModelDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (_AiModelproviderValueEnumMap[reader.readStringOrNull(offset)] ??
              AiProvider.google)
          as P;
    case 19:
      return (_AiModelqualityValueEnumMap[reader.readStringOrNull(offset)] ??
              ModelQuality.basic)
          as P;
    case 20:
      return (_AiModelspeedValueEnumMap[reader.readStringOrNull(offset)] ??
              ModelSpeed.ultraFast)
          as P;
    case 21:
      return (reader
                  .readStringList(offset)
                  ?.map(
                    (e) =>
                        _AiModelsupportedInputsValueEnumMap[e] ??
                        InputType.text,
                  )
                  .toList() ??
              [])
          as P;
    case 22:
      return (reader
                  .readStringList(offset)
                  ?.map(
                    (e) =>
                        _AiModelsupportedStepsValueEnumMap[e] ??
                        TranslationPipelineStep.research,
                  )
                  .toList() ??
              [])
          as P;
    case 23:
      return (reader.readBool(offset)) as P;
    case 24:
      return (reader.readBool(offset)) as P;
    case 25:
      return (reader.readBool(offset)) as P;
    case 26:
      return (reader.readBool(offset)) as P;
    case 27:
      return (reader.readString(offset)) as P;
    case 28:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AiModelproviderEnumValueMap = {
  r'google': r'google',
  r'openai': r'openai',
  r'anthropic': r'anthropic',
  r'custom': r'custom',
};
const _AiModelproviderValueEnumMap = {
  r'google': AiProvider.google,
  r'openai': AiProvider.openai,
  r'anthropic': AiProvider.anthropic,
  r'custom': AiProvider.custom,
};
const _AiModelqualityEnumValueMap = {
  r'basic': r'basic',
  r'standard': r'standard',
  r'high': r'high',
  r'frontier': r'frontier',
};
const _AiModelqualityValueEnumMap = {
  r'basic': ModelQuality.basic,
  r'standard': ModelQuality.standard,
  r'high': ModelQuality.high,
  r'frontier': ModelQuality.frontier,
};
const _AiModelspeedEnumValueMap = {
  r'ultraFast': r'ultraFast',
  r'fast': r'fast',
  r'medium': r'medium',
  r'slow': r'slow',
};
const _AiModelspeedValueEnumMap = {
  r'ultraFast': ModelSpeed.ultraFast,
  r'fast': ModelSpeed.fast,
  r'medium': ModelSpeed.medium,
  r'slow': ModelSpeed.slow,
};
const _AiModelsupportedInputsEnumValueMap = {
  r'text': r'text',
  r'image': r'image',
  r'audio': r'audio',
  r'video': r'video',
  r'pdf': r'pdf',
};
const _AiModelsupportedInputsValueEnumMap = {
  r'text': InputType.text,
  r'image': InputType.image,
  r'audio': InputType.audio,
  r'video': InputType.video,
  r'pdf': InputType.pdf,
};
const _AiModelsupportedStepsEnumValueMap = {
  r'research': r'research',
  r'translate': r'translate',
  r'morphemes': r'morphemes',
  r'fullTranslate': r'fullTranslate',
};
const _AiModelsupportedStepsValueEnumMap = {
  r'research': TranslationPipelineStep.research,
  r'translate': TranslationPipelineStep.translate,
  r'morphemes': TranslationPipelineStep.morphemes,
  r'fullTranslate': TranslationPipelineStep.fullTranslate,
};

Id _aiModelGetId(AiModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _aiModelGetLinks(AiModel object) {
  return [];
}

void _aiModelAttach(IsarCollection<dynamic> col, Id id, AiModel object) {
  object.id = id;
}

extension AiModelByIndex on IsarCollection<AiModel> {
  Future<AiModel?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  AiModel? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<AiModel?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<AiModel?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(AiModel object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(AiModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<AiModel> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<AiModel> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension AiModelQueryWhereSort on QueryBuilder<AiModel, AiModel, QWhere> {
  QueryBuilder<AiModel, AiModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AiModelQueryWhere on QueryBuilder<AiModel, AiModel, QWhereClause> {
  QueryBuilder<AiModel, AiModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<AiModel, AiModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<AiModel, AiModel, QAfterWhereClause> nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterWhereClause> nameNotEqualTo(
    String name,
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
}

extension AiModelQueryFilter
    on QueryBuilder<AiModel, AiModel, QFilterCondition> {
  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> contextWindowEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'contextWindow', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  contextWindowGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'contextWindow',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> contextWindowLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'contextWindow',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> contextWindowBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'contextWindow',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentDailyMaxLimitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentDailyMaxLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentDailyMaxLimitGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentDailyMaxLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentDailyMaxLimitLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentDailyMaxLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentDailyMaxLimitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentDailyMaxLimit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> currentMaxLimitEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentMaxLimit', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentMaxLimitGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentMaxLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> currentMaxLimitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentMaxLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> currentMaxLimitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentMaxLimit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentPhrasesPerRequestEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentPhrasesPerRequest',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentPhrasesPerRequestGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentPhrasesPerRequest',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentPhrasesPerRequestLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentPhrasesPerRequest',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentPhrasesPerRequestBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentPhrasesPerRequest',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  currentStreamingEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentStreamingEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> dailyUsedEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dailyUsed', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> dailyUsedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dailyUsed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> dailyUsedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dailyUsed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> dailyUsedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dailyUsed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  defaultDailyMaxLimitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultDailyMaxLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  defaultDailyMaxLimitGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultDailyMaxLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  defaultDailyMaxLimitLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultDailyMaxLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  defaultDailyMaxLimitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultDailyMaxLimit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> defaultLimitEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultLimit', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> defaultLimitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> defaultLimitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> defaultLimitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultLimit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  defaultPhrasesPerRequestEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultPhrasesPerRequest',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  defaultPhrasesPerRequestGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultPhrasesPerRequest',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  defaultPhrasesPerRequestLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultPhrasesPerRequest',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  defaultPhrasesPerRequestBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultPhrasesPerRequest',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  estimatedTokensPerSecEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'estimatedTokensPerSec',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  estimatedTokensPerSecGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'estimatedTokensPerSec',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  estimatedTokensPerSecLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'estimatedTokensPerSec',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  estimatedTokensPerSecBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'estimatedTokensPerSec',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  inputPricePerMTokenEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'inputPricePerMToken',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  inputPricePerMTokenGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inputPricePerMToken',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  inputPricePerMTokenLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inputPricePerMToken',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  inputPricePerMTokenBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inputPricePerMToken',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  isDailyMaxLimitCustomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'isDailyMaxLimitCustom',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> isMaxLimitCustomEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isMaxLimitCustom', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  isPhrasesPerRequestCustomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'isPhrasesPerRequestCustom',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  isStreamingCustomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isStreamingCustom', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> maxOutputTokensEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'maxOutputTokens', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  maxOutputTokensGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maxOutputTokens',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> maxOutputTokensLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maxOutputTokens',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> maxOutputTokensBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maxOutputTokens',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameEqualTo(
    String value, {
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameLessThan(
    String value, {
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameContains(
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  outputPricePerMTokenEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'outputPricePerMToken',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  outputPricePerMTokenGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'outputPricePerMToken',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  outputPricePerMTokenLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'outputPricePerMToken',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  outputPricePerMTokenBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'outputPricePerMToken',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerEqualTo(
    AiProvider value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'provider',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerGreaterThan(
    AiProvider value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'provider',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerLessThan(
    AiProvider value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'provider',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerBetween(
    AiProvider lower,
    AiProvider upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'provider',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'provider',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'provider',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'provider',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'provider',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'provider', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> providerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'provider', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityEqualTo(
    ModelQuality value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'quality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityGreaterThan(
    ModelQuality value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'quality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityLessThan(
    ModelQuality value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'quality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityBetween(
    ModelQuality lower,
    ModelQuality upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'quality',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'quality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'quality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'quality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'quality',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'quality', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> qualityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'quality', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedEqualTo(
    ModelSpeed value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'speed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedGreaterThan(
    ModelSpeed value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'speed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedLessThan(
    ModelSpeed value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'speed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedBetween(
    ModelSpeed lower,
    ModelSpeed upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'speed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'speed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'speed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'speed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'speed',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'speed', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> speedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'speed', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementEqualTo(InputType value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'supportedInputs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementGreaterThan(
    InputType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'supportedInputs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementLessThan(
    InputType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'supportedInputs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementBetween(
    InputType lower,
    InputType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'supportedInputs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'supportedInputs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'supportedInputs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'supportedInputs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'supportedInputs',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supportedInputs', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'supportedInputs', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedInputs', length, true, length, true);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedInputs', 0, true, 0, true);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedInputs', 0, false, 999999, true);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedInputs', 0, true, length, include);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'supportedInputs',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedInputsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'supportedInputs',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementEqualTo(
    TranslationPipelineStep value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'supportedSteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementGreaterThan(
    TranslationPipelineStep value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'supportedSteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementLessThan(
    TranslationPipelineStep value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'supportedSteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementBetween(
    TranslationPipelineStep lower,
    TranslationPipelineStep upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'supportedSteps',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'supportedSteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'supportedSteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'supportedSteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'supportedSteps',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supportedSteps', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'supportedSteps', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedSteps', length, true, length, true);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedSteps', 0, true, 0, true);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedSteps', 0, false, 999999, true);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedSteps', 0, true, length, include);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'supportedSteps', length, include, 999999, true);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportedStepsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'supportedSteps',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> supportsLiveApiEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supportsLiveApi', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportsStreamingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supportsStreaming', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> supportsThinkingEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supportsThinking', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition>
  supportsWebSearchEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supportsWebSearch', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'url',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'url',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'url',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'url', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'url', value: ''),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> usedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'used', value: value),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> usedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'used',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> usedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'used',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterFilterCondition> usedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'used',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AiModelQueryObject
    on QueryBuilder<AiModel, AiModel, QFilterCondition> {}

extension AiModelQueryLinks
    on QueryBuilder<AiModel, AiModel, QFilterCondition> {}

extension AiModelQuerySortBy on QueryBuilder<AiModel, AiModel, QSortBy> {
  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByContextWindow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextWindow', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByContextWindowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextWindow', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByCurrentDailyMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDailyMaxLimit', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByCurrentDailyMaxLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDailyMaxLimit', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByCurrentMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMaxLimit', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByCurrentMaxLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMaxLimit', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByCurrentPhrasesPerRequest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhrasesPerRequest', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByCurrentPhrasesPerRequestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhrasesPerRequest', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByCurrentStreamingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreamingEnabled', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByCurrentStreamingEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreamingEnabled', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByDailyUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyUsed', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByDailyUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyUsed', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByDefaultDailyMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDailyMaxLimit', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByDefaultDailyMaxLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDailyMaxLimit', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByDefaultLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultLimit', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByDefaultLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultLimit', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByDefaultPhrasesPerRequest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPhrasesPerRequest', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByDefaultPhrasesPerRequestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPhrasesPerRequest', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByEstimatedTokensPerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedTokensPerSec', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByEstimatedTokensPerSecDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedTokensPerSec', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByInputPricePerMToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputPricePerMToken', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByInputPricePerMTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputPricePerMToken', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByIsDailyMaxLimitCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDailyMaxLimitCustom', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByIsDailyMaxLimitCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDailyMaxLimitCustom', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByIsMaxLimitCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMaxLimitCustom', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByIsMaxLimitCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMaxLimitCustom', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByIsPhrasesPerRequestCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPhrasesPerRequestCustom', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByIsPhrasesPerRequestCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPhrasesPerRequestCustom', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByIsStreamingCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStreamingCustom', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByIsStreamingCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStreamingCustom', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByMaxOutputTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxOutputTokens', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByMaxOutputTokensDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxOutputTokens', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByOutputPricePerMToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputPricePerMToken', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  sortByOutputPricePerMTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputPricePerMToken', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySupportsLiveApi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsLiveApi', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySupportsLiveApiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsLiveApi', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySupportsStreaming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsStreaming', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySupportsStreamingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsStreaming', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySupportsThinking() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsThinking', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySupportsThinkingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsThinking', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySupportsWebSearch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsWebSearch', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortBySupportsWebSearchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsWebSearch', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'used', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> sortByUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'used', Sort.desc);
    });
  }
}

extension AiModelQuerySortThenBy
    on QueryBuilder<AiModel, AiModel, QSortThenBy> {
  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByContextWindow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextWindow', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByContextWindowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextWindow', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByCurrentDailyMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDailyMaxLimit', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByCurrentDailyMaxLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDailyMaxLimit', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByCurrentMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMaxLimit', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByCurrentMaxLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMaxLimit', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByCurrentPhrasesPerRequest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhrasesPerRequest', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByCurrentPhrasesPerRequestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhrasesPerRequest', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByCurrentStreamingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreamingEnabled', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByCurrentStreamingEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreamingEnabled', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByDailyUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyUsed', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByDailyUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyUsed', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByDefaultDailyMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDailyMaxLimit', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByDefaultDailyMaxLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDailyMaxLimit', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByDefaultLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultLimit', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByDefaultLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultLimit', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByDefaultPhrasesPerRequest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPhrasesPerRequest', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByDefaultPhrasesPerRequestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPhrasesPerRequest', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByEstimatedTokensPerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedTokensPerSec', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByEstimatedTokensPerSecDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedTokensPerSec', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByInputPricePerMToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputPricePerMToken', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByInputPricePerMTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputPricePerMToken', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByIsDailyMaxLimitCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDailyMaxLimitCustom', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByIsDailyMaxLimitCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDailyMaxLimitCustom', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByIsMaxLimitCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMaxLimitCustom', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByIsMaxLimitCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMaxLimitCustom', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByIsPhrasesPerRequestCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPhrasesPerRequestCustom', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByIsPhrasesPerRequestCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPhrasesPerRequestCustom', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByIsStreamingCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStreamingCustom', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByIsStreamingCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStreamingCustom', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByMaxOutputTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxOutputTokens', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByMaxOutputTokensDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxOutputTokens', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByOutputPricePerMToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputPricePerMToken', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy>
  thenByOutputPricePerMTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outputPricePerMToken', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySupportsLiveApi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsLiveApi', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySupportsLiveApiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsLiveApi', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySupportsStreaming() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsStreaming', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySupportsStreamingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsStreaming', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySupportsThinking() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsThinking', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySupportsThinkingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsThinking', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySupportsWebSearch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsWebSearch', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenBySupportsWebSearchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsWebSearch', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'used', Sort.asc);
    });
  }

  QueryBuilder<AiModel, AiModel, QAfterSortBy> thenByUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'used', Sort.desc);
    });
  }
}

extension AiModelQueryWhereDistinct
    on QueryBuilder<AiModel, AiModel, QDistinct> {
  QueryBuilder<AiModel, AiModel, QDistinct> distinctByContextWindow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contextWindow');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByCurrentDailyMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentDailyMaxLimit');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByCurrentMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentMaxLimit');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct>
  distinctByCurrentPhrasesPerRequest() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPhrasesPerRequest');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct>
  distinctByCurrentStreamingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreamingEnabled');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByDailyUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyUsed');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByDefaultDailyMaxLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultDailyMaxLimit');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByDefaultLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultLimit');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct>
  distinctByDefaultPhrasesPerRequest() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultPhrasesPerRequest');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByEstimatedTokensPerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedTokensPerSec');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByInputPricePerMToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputPricePerMToken');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByIsDailyMaxLimitCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDailyMaxLimitCustom');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByIsMaxLimitCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMaxLimitCustom');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct>
  distinctByIsPhrasesPerRequestCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPhrasesPerRequestCustom');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByIsStreamingCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isStreamingCustom');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByMaxOutputTokens() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxOutputTokens');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByOutputPricePerMToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outputPricePerMToken');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByProvider({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'provider', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByQuality({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quality', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctBySpeed({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speed', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctBySupportedInputs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportedInputs');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctBySupportedSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportedSteps');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctBySupportsLiveApi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportsLiveApi');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctBySupportsStreaming() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportsStreaming');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctBySupportsThinking() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportsThinking');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctBySupportsWebSearch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportsWebSearch');
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AiModel, AiModel, QDistinct> distinctByUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'used');
    });
  }
}

extension AiModelQueryProperty
    on QueryBuilder<AiModel, AiModel, QQueryProperty> {
  QueryBuilder<AiModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> contextWindowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contextWindow');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> currentDailyMaxLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentDailyMaxLimit');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> currentMaxLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentMaxLimit');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations>
  currentPhrasesPerRequestProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPhrasesPerRequest');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations>
  currentStreamingEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreamingEnabled');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> dailyUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyUsed');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> defaultDailyMaxLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultDailyMaxLimit');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> defaultLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultLimit');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations>
  defaultPhrasesPerRequestProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPhrasesPerRequest');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> estimatedTokensPerSecProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedTokensPerSec');
    });
  }

  QueryBuilder<AiModel, double, QQueryOperations>
  inputPricePerMTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputPricePerMToken');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations>
  isDailyMaxLimitCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDailyMaxLimitCustom');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations> isMaxLimitCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMaxLimitCustom');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations>
  isPhrasesPerRequestCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPhrasesPerRequestCustom');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations> isStreamingCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isStreamingCustom');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> maxOutputTokensProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxOutputTokens');
    });
  }

  QueryBuilder<AiModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<AiModel, double, QQueryOperations>
  outputPricePerMTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outputPricePerMToken');
    });
  }

  QueryBuilder<AiModel, AiProvider, QQueryOperations> providerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'provider');
    });
  }

  QueryBuilder<AiModel, ModelQuality, QQueryOperations> qualityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quality');
    });
  }

  QueryBuilder<AiModel, ModelSpeed, QQueryOperations> speedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speed');
    });
  }

  QueryBuilder<AiModel, List<InputType>, QQueryOperations>
  supportedInputsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportedInputs');
    });
  }

  QueryBuilder<AiModel, List<TranslationPipelineStep>, QQueryOperations>
  supportedStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportedSteps');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations> supportsLiveApiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportsLiveApi');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations> supportsStreamingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportsStreaming');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations> supportsThinkingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportsThinking');
    });
  }

  QueryBuilder<AiModel, bool, QQueryOperations> supportsWebSearchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportsWebSearch');
    });
  }

  QueryBuilder<AiModel, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }

  QueryBuilder<AiModel, int, QQueryOperations> usedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'used');
    });
  }
}
