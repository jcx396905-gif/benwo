// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileModelCollection on Isar {
  IsarCollection<UserProfileModel> get userProfileModels => this.collection();
}

const UserProfileModelSchema = CollectionSchema(
  name: r'UserProfileModel',
  id: -8790468936041821297,
  properties: {
    r'bestWorkTime': PropertySchema(
      id: 0,
      name: r'bestWorkTime',
      type: IsarType.string,
    ),
    r'communicationStyle': PropertySchema(
      id: 1,
      name: r'communicationStyle',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'taskPace': PropertySchema(
      id: 3,
      name: r'taskPace',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _userProfileModelEstimateSize,
  serialize: _userProfileModelSerialize,
  deserialize: _userProfileModelDeserialize,
  deserializeProp: _userProfileModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userProfileModelGetId,
  getLinks: _userProfileModelGetLinks,
  attach: _userProfileModelAttach,
  version: '3.1.0+1',
);

int _userProfileModelEstimateSize(
  UserProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bestWorkTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.communicationStyle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.taskPace;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userProfileModelSerialize(
  UserProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bestWorkTime);
  writer.writeString(offsets[1], object.communicationStyle);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.taskPace);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

UserProfileModel _userProfileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfileModel();
  object.bestWorkTime = reader.readStringOrNull(offsets[0]);
  object.communicationStyle = reader.readStringOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.taskPace = reader.readStringOrNull(offsets[3]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[4]);
  return object;
}

P _userProfileModelDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileModelGetId(UserProfileModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileModelGetLinks(UserProfileModel object) {
  return [];
}

void _userProfileModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserProfileModel object,
) {
  object.id = id;
}

extension UserProfileModelQueryWhereSort
    on QueryBuilder<UserProfileModel, UserProfileModel, QWhere> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProfileModelQueryWhere
    on QueryBuilder<UserProfileModel, UserProfileModel, QWhereClause> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause> idBetween(
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

extension UserProfileModelQueryFilter
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bestWorkTime'),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bestWorkTime'),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bestWorkTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bestWorkTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bestWorkTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bestWorkTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bestWorkTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bestWorkTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bestWorkTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bestWorkTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bestWorkTime', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  bestWorkTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bestWorkTime', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'communicationStyle'),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'communicationStyle'),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'communicationStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'communicationStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'communicationStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'communicationStyle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'communicationStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'communicationStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'communicationStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'communicationStyle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'communicationStyle', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  communicationStyleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'communicationStyle', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'taskPace'),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'taskPace'),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'taskPace',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'taskPace',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'taskPace',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'taskPace',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'taskPace',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'taskPace',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'taskPace',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'taskPace',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taskPace', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  taskPaceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'taskPace', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

extension UserProfileModelQueryObject
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {}

extension UserProfileModelQueryLinks
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {}

extension UserProfileModelQuerySortBy
    on QueryBuilder<UserProfileModel, UserProfileModel, QSortBy> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByBestWorkTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestWorkTime', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByBestWorkTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestWorkTime', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByCommunicationStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communicationStyle', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByCommunicationStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communicationStyle', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByTaskPace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskPace', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByTaskPaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskPace', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension UserProfileModelQuerySortThenBy
    on QueryBuilder<UserProfileModel, UserProfileModel, QSortThenBy> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByBestWorkTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestWorkTime', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByBestWorkTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestWorkTime', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByCommunicationStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communicationStyle', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByCommunicationStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communicationStyle', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByTaskPace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskPace', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByTaskPaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskPace', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension UserProfileModelQueryWhereDistinct
    on QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> {
  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByBestWorkTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestWorkTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByCommunicationStyle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'communicationStyle',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByTaskPace({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskPace', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension UserProfileModelQueryProperty
    on QueryBuilder<UserProfileModel, UserProfileModel, QQueryProperty> {
  QueryBuilder<UserProfileModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProfileModel, String?, QQueryOperations>
  bestWorkTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestWorkTime');
    });
  }

  QueryBuilder<UserProfileModel, String?, QQueryOperations>
  communicationStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'communicationStyle');
    });
  }

  QueryBuilder<UserProfileModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<UserProfileModel, String?, QQueryOperations> taskPaceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskPace');
    });
  }

  QueryBuilder<UserProfileModel, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
