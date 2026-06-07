// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserSettingsModelCollection on Isar {
  IsarCollection<UserSettingsModel> get userSettingsModels => this.collection();
}

const UserSettingsModelSchema = CollectionSchema(
  name: r'UserSettingsModel',
  id: 1840420974923084997,
  properties: {
    r'afternoonPushTime': PropertySchema(
      id: 0,
      name: r'afternoonPushTime',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'eveningPushTime': PropertySchema(
      id: 2,
      name: r'eveningPushTime',
      type: IsarType.string,
    ),
    r'morningPushTime': PropertySchema(
      id: 3,
      name: r'morningPushTime',
      type: IsarType.string,
    ),
    r'pushEnabled': PropertySchema(
      id: 4,
      name: r'pushEnabled',
      type: IsarType.bool,
    ),
    r'pushFrequency': PropertySchema(
      id: 5,
      name: r'pushFrequency',
      type: IsarType.byte,
      enumMap: _UserSettingsModelpushFrequencyEnumValueMap,
    ),
    r'quietHoursEnd': PropertySchema(
      id: 6,
      name: r'quietHoursEnd',
      type: IsarType.string,
    ),
    r'quietHoursStart': PropertySchema(
      id: 7,
      name: r'quietHoursStart',
      type: IsarType.string,
    ),
    r'themePreference': PropertySchema(
      id: 8,
      name: r'themePreference',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 10,
      name: r'userId',
      type: IsarType.long,
    )
  },
  estimateSize: _userSettingsModelEstimateSize,
  serialize: _userSettingsModelSerialize,
  deserialize: _userSettingsModelDeserialize,
  deserializeProp: _userSettingsModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userSettingsModelGetId,
  getLinks: _userSettingsModelGetLinks,
  attach: _userSettingsModelAttach,
  version: '3.1.0+1',
);

int _userSettingsModelEstimateSize(
  UserSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.afternoonPushTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.eveningPushTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.morningPushTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.quietHoursEnd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.quietHoursStart;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.themePreference;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userSettingsModelSerialize(
  UserSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.afternoonPushTime);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.eveningPushTime);
  writer.writeString(offsets[3], object.morningPushTime);
  writer.writeBool(offsets[4], object.pushEnabled);
  writer.writeByte(offsets[5], object.pushFrequency.index);
  writer.writeString(offsets[6], object.quietHoursEnd);
  writer.writeString(offsets[7], object.quietHoursStart);
  writer.writeString(offsets[8], object.themePreference);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeLong(offsets[10], object.userId);
}

UserSettingsModel _userSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserSettingsModel();
  object.afternoonPushTime = reader.readStringOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.eveningPushTime = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.morningPushTime = reader.readStringOrNull(offsets[3]);
  object.pushEnabled = reader.readBool(offsets[4]);
  object.pushFrequency = _UserSettingsModelpushFrequencyValueEnumMap[
          reader.readByteOrNull(offsets[5])] ??
      PushFrequency.daily;
  object.quietHoursEnd = reader.readStringOrNull(offsets[6]);
  object.quietHoursStart = reader.readStringOrNull(offsets[7]);
  object.themePreference = reader.readStringOrNull(offsets[8]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[9]);
  object.userId = reader.readLong(offsets[10]);
  return object;
}

P _userSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (_UserSettingsModelpushFrequencyValueEnumMap[
              reader.readByteOrNull(offset)] ??
          PushFrequency.daily) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _UserSettingsModelpushFrequencyEnumValueMap = {
  'daily': 0,
  'custom': 1,
};
const _UserSettingsModelpushFrequencyValueEnumMap = {
  0: PushFrequency.daily,
  1: PushFrequency.custom,
};

Id _userSettingsModelGetId(UserSettingsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userSettingsModelGetLinks(
    UserSettingsModel object) {
  return [];
}

void _userSettingsModelAttach(
    IsarCollection<dynamic> col, Id id, UserSettingsModel object) {
  object.id = id;
}

extension UserSettingsModelByIndex on IsarCollection<UserSettingsModel> {
  Future<UserSettingsModel?> getByUserId(int userId) {
    return getByIndex(r'userId', [userId]);
  }

  UserSettingsModel? getByUserIdSync(int userId) {
    return getByIndexSync(r'userId', [userId]);
  }

  Future<bool> deleteByUserId(int userId) {
    return deleteByIndex(r'userId', [userId]);
  }

  bool deleteByUserIdSync(int userId) {
    return deleteByIndexSync(r'userId', [userId]);
  }

  Future<List<UserSettingsModel?>> getAllByUserId(List<int> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'userId', values);
  }

  List<UserSettingsModel?> getAllByUserIdSync(List<int> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'userId', values);
  }

  Future<int> deleteAllByUserId(List<int> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'userId', values);
  }

  int deleteAllByUserIdSync(List<int> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'userId', values);
  }

  Future<Id> putByUserId(UserSettingsModel object) {
    return putByIndex(r'userId', object);
  }

  Id putByUserIdSync(UserSettingsModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserId(List<UserSettingsModel> objects) {
    return putAllByIndex(r'userId', objects);
  }

  List<Id> putAllByUserIdSync(List<UserSettingsModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId', objects, saveLinks: saveLinks);
  }
}

extension UserSettingsModelQueryWhereSort
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QWhere> {
  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhere> anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }
}

extension UserSettingsModelQueryWhere
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QWhereClause> {
  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
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

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      userIdEqualTo(int userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      userIdNotEqualTo(int userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      userIdGreaterThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [userId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      userIdLessThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [],
        upper: [userId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterWhereClause>
      userIdBetween(
    int lowerUserId,
    int upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [lowerUserId],
        includeLower: includeLower,
        upper: [upperUserId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserSettingsModelQueryFilter
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QFilterCondition> {
  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'afternoonPushTime',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'afternoonPushTime',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afternoonPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'afternoonPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'afternoonPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'afternoonPushTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'afternoonPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'afternoonPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'afternoonPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'afternoonPushTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'afternoonPushTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      afternoonPushTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'afternoonPushTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eveningPushTime',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eveningPushTime',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eveningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eveningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eveningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eveningPushTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eveningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eveningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eveningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eveningPushTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eveningPushTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      eveningPushTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eveningPushTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'morningPushTime',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'morningPushTime',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'morningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'morningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'morningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'morningPushTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'morningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'morningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'morningPushTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'morningPushTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'morningPushTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      morningPushTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'morningPushTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      pushEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pushEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      pushFrequencyEqualTo(PushFrequency value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pushFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      pushFrequencyGreaterThan(
    PushFrequency value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pushFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      pushFrequencyLessThan(
    PushFrequency value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pushFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      pushFrequencyBetween(
    PushFrequency lower,
    PushFrequency upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pushFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'quietHoursEnd',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'quietHoursEnd',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietHoursEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quietHoursEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quietHoursEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quietHoursEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quietHoursEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quietHoursEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quietHoursEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quietHoursEnd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietHoursEnd',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursEndIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quietHoursEnd',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'quietHoursStart',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'quietHoursStart',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietHoursStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quietHoursStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quietHoursStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quietHoursStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quietHoursStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quietHoursStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quietHoursStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quietHoursStart',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quietHoursStart',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      quietHoursStartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quietHoursStart',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'themePreference',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'themePreference',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themePreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themePreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themePreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themePreference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'themePreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'themePreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'themePreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'themePreference',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themePreference',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      themePreferenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'themePreference',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      userIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterFilterCondition>
      userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserSettingsModelQueryObject
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QFilterCondition> {}

extension UserSettingsModelQueryLinks
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QFilterCondition> {}

extension UserSettingsModelQuerySortBy
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QSortBy> {
  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByAfternoonPushTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afternoonPushTime', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByAfternoonPushTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afternoonPushTime', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByEveningPushTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningPushTime', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByEveningPushTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningPushTime', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByMorningPushTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningPushTime', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByMorningPushTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningPushTime', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByPushEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByPushFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushFrequency', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByPushFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushFrequency', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByQuietHoursEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByQuietHoursEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByQuietHoursStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByQuietHoursStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByThemePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByThemePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserSettingsModelQuerySortThenBy
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QSortThenBy> {
  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByAfternoonPushTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afternoonPushTime', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByAfternoonPushTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'afternoonPushTime', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByEveningPushTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningPushTime', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByEveningPushTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningPushTime', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByMorningPushTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningPushTime', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByMorningPushTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningPushTime', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByPushEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByPushFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushFrequency', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByPushFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pushFrequency', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByQuietHoursEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByQuietHoursEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByQuietHoursStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByQuietHoursStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByThemePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByThemePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserSettingsModelQueryWhereDistinct
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct> {
  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByAfternoonPushTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'afternoonPushTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByEveningPushTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eveningPushTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByMorningPushTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'morningPushTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByPushEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pushEnabled');
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByPushFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pushFrequency');
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByQuietHoursEnd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quietHoursEnd',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByQuietHoursStart({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quietHoursStart',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByThemePreference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themePreference',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<UserSettingsModel, UserSettingsModel, QDistinct>
      distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension UserSettingsModelQueryProperty
    on QueryBuilder<UserSettingsModel, UserSettingsModel, QQueryProperty> {
  QueryBuilder<UserSettingsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserSettingsModel, String?, QQueryOperations>
      afternoonPushTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'afternoonPushTime');
    });
  }

  QueryBuilder<UserSettingsModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<UserSettingsModel, String?, QQueryOperations>
      eveningPushTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eveningPushTime');
    });
  }

  QueryBuilder<UserSettingsModel, String?, QQueryOperations>
      morningPushTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'morningPushTime');
    });
  }

  QueryBuilder<UserSettingsModel, bool, QQueryOperations>
      pushEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pushEnabled');
    });
  }

  QueryBuilder<UserSettingsModel, PushFrequency, QQueryOperations>
      pushFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pushFrequency');
    });
  }

  QueryBuilder<UserSettingsModel, String?, QQueryOperations>
      quietHoursEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietHoursEnd');
    });
  }

  QueryBuilder<UserSettingsModel, String?, QQueryOperations>
      quietHoursStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietHoursStart');
    });
  }

  QueryBuilder<UserSettingsModel, String?, QQueryOperations>
      themePreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themePreference');
    });
  }

  QueryBuilder<UserSettingsModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<UserSettingsModel, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
