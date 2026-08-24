// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_pomodoro_list_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedPomodoroListModelCollection on Isar {
  IsarCollection<SavedPomodoroListModel> get savedPomodoroListModels =>
      this.collection();
}

const SavedPomodoroListModelSchema = CollectionSchema(
  name: r'SavedPomodoroListModel',
  id: -3072251823886331761,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
    r'taskCount': PropertySchema(
      id: 2,
      name: r'taskCount',
      type: IsarType.long,
    ),
    r'tasksJson': PropertySchema(
      id: 3,
      name: r'tasksJson',
      type: IsarType.string,
    ),
    r'totalMinutes': PropertySchema(
      id: 4,
      name: r'totalMinutes',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _savedPomodoroListModelEstimateSize,
  serialize: _savedPomodoroListModelSerialize,
  deserialize: _savedPomodoroListModelDeserialize,
  deserializeProp: _savedPomodoroListModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _savedPomodoroListModelGetId,
  getLinks: _savedPomodoroListModelGetLinks,
  attach: _savedPomodoroListModelAttach,
  version: '3.1.0+1',
);

int _savedPomodoroListModelEstimateSize(
  SavedPomodoroListModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.tasksJson.length * 3;
  return bytesCount;
}

void _savedPomodoroListModelSerialize(
  SavedPomodoroListModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.taskCount);
  writer.writeString(offsets[3], object.tasksJson);
  writer.writeLong(offsets[4], object.totalMinutes);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

SavedPomodoroListModel _savedPomodoroListModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedPomodoroListModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[1]);
  object.taskCount = reader.readLong(offsets[2]);
  object.tasksJson = reader.readString(offsets[3]);
  object.totalMinutes = reader.readLong(offsets[4]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[5]);
  return object;
}

P _savedPomodoroListModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedPomodoroListModelGetId(SavedPomodoroListModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savedPomodoroListModelGetLinks(
  SavedPomodoroListModel object,
) {
  return [];
}

void _savedPomodoroListModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  SavedPomodoroListModel object,
) {
  object.id = id;
}

extension SavedPomodoroListModelQueryWhereSort
    on QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QWhere> {
  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedPomodoroListModelQueryWhere
    on
        QueryBuilder<
          SavedPomodoroListModel,
          SavedPomodoroListModel,
          QWhereClause
        > {
  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterWhereClause
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterWhereClause
  >
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

extension SavedPomodoroListModelQueryFilter
    on
        QueryBuilder<
          SavedPomodoroListModel,
          SavedPomodoroListModel,
          QFilterCondition
        > {
  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  nameGreaterThan(
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  nameLessThan(
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  nameBetween(
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  taskCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taskCount', value: value),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  taskCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'taskCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  taskCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'taskCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  taskCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'taskCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tasksJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tasksJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tasksJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tasksJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tasksJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tasksJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tasksJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tasksJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tasksJson', value: ''),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  tasksJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tasksJson', value: ''),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  totalMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalMinutes', value: value),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  totalMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  totalMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  totalMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SavedPomodoroListModel,
    SavedPomodoroListModel,
    QAfterFilterCondition
  >
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

extension SavedPomodoroListModelQueryObject
    on
        QueryBuilder<
          SavedPomodoroListModel,
          SavedPomodoroListModel,
          QFilterCondition
        > {}

extension SavedPomodoroListModelQueryLinks
    on
        QueryBuilder<
          SavedPomodoroListModel,
          SavedPomodoroListModel,
          QFilterCondition
        > {}

extension SavedPomodoroListModelQuerySortBy
    on QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QSortBy> {
  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByTaskCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskCount', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByTaskCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskCount', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByTasksJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksJson', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByTasksJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksJson', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByTotalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SavedPomodoroListModelQuerySortThenBy
    on
        QueryBuilder<
          SavedPomodoroListModel,
          SavedPomodoroListModel,
          QSortThenBy
        > {
  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByTaskCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskCount', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByTaskCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskCount', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByTasksJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksJson', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByTasksJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tasksJson', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByTotalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.desc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SavedPomodoroListModelQueryWhereDistinct
    on QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QDistinct> {
  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QDistinct>
  distinctByTaskCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskCount');
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QDistinct>
  distinctByTasksJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tasksJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QDistinct>
  distinctByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalMinutes');
    });
  }

  QueryBuilder<SavedPomodoroListModel, SavedPomodoroListModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SavedPomodoroListModelQueryProperty
    on
        QueryBuilder<
          SavedPomodoroListModel,
          SavedPomodoroListModel,
          QQueryProperty
        > {
  QueryBuilder<SavedPomodoroListModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedPomodoroListModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SavedPomodoroListModel, String, QQueryOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SavedPomodoroListModel, int, QQueryOperations>
  taskCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskCount');
    });
  }

  QueryBuilder<SavedPomodoroListModel, String, QQueryOperations>
  tasksJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tasksJson');
    });
  }

  QueryBuilder<SavedPomodoroListModel, int, QQueryOperations>
  totalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalMinutes');
    });
  }

  QueryBuilder<SavedPomodoroListModel, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
