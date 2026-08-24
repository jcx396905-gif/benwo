// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_plan_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPomodoroPlanModelCollection on Isar {
  IsarCollection<PomodoroPlanModel> get pomodoroPlanModels => this.collection();
}

const PomodoroPlanModelSchema = CollectionSchema(
  name: r'PomodoroPlanModel',
  id: 5248781770296388522,
  properties: {
    r'autoStartBreak': PropertySchema(
      id: 0,
      name: r'autoStartBreak',
      type: IsarType.bool,
    ),
    r'autoStartNextFocus': PropertySchema(
      id: 1,
      name: r'autoStartNextFocus',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(id: 3, name: r'date', type: IsarType.dateTime),
    r'defaultBreakMinutes': PropertySchema(
      id: 4,
      name: r'defaultBreakMinutes',
      type: IsarType.long,
    ),
    r'defaultFocusMinutes': PropertySchema(
      id: 5,
      name: r'defaultFocusMinutes',
      type: IsarType.long,
    ),
    r'longBreakInterval': PropertySchema(
      id: 6,
      name: r'longBreakInterval',
      type: IsarType.long,
    ),
    r'longBreakMinutes': PropertySchema(
      id: 7,
      name: r'longBreakMinutes',
      type: IsarType.long,
    ),
    r'title': PropertySchema(id: 8, name: r'title', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _pomodoroPlanModelEstimateSize,
  serialize: _pomodoroPlanModelSerialize,
  deserialize: _pomodoroPlanModelDeserialize,
  deserializeProp: _pomodoroPlanModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _pomodoroPlanModelGetId,
  getLinks: _pomodoroPlanModelGetLinks,
  attach: _pomodoroPlanModelAttach,
  version: '3.1.0+1',
);

int _pomodoroPlanModelEstimateSize(
  PomodoroPlanModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _pomodoroPlanModelSerialize(
  PomodoroPlanModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoStartBreak);
  writer.writeBool(offsets[1], object.autoStartNextFocus);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeLong(offsets[4], object.defaultBreakMinutes);
  writer.writeLong(offsets[5], object.defaultFocusMinutes);
  writer.writeLong(offsets[6], object.longBreakInterval);
  writer.writeLong(offsets[7], object.longBreakMinutes);
  writer.writeString(offsets[8], object.title);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

PomodoroPlanModel _pomodoroPlanModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PomodoroPlanModel();
  object.autoStartBreak = reader.readBool(offsets[0]);
  object.autoStartNextFocus = reader.readBool(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.defaultBreakMinutes = reader.readLong(offsets[4]);
  object.defaultFocusMinutes = reader.readLong(offsets[5]);
  object.id = id;
  object.longBreakInterval = reader.readLong(offsets[6]);
  object.longBreakMinutes = reader.readLong(offsets[7]);
  object.title = reader.readString(offsets[8]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[9]);
  return object;
}

P _pomodoroPlanModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pomodoroPlanModelGetId(PomodoroPlanModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pomodoroPlanModelGetLinks(
  PomodoroPlanModel object,
) {
  return [];
}

void _pomodoroPlanModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PomodoroPlanModel object,
) {
  object.id = id;
}

extension PomodoroPlanModelQueryWhereSort
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QWhere> {
  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension PomodoroPlanModelQueryWhere
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QWhereClause> {
  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
  dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'date', value: [date]),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
  dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
  dateGreaterThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [date],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
  dateLessThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [],
          upper: [date],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterWhereClause>
  dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [lowerDate],
          includeLower: includeLower,
          upper: [upperDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PomodoroPlanModelQueryFilter
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QFilterCondition> {
  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  autoStartBreakEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoStartBreak', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  autoStartNextFocusEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoStartNextFocus', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  dateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  dateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  defaultBreakMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultBreakMinutes', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  defaultBreakMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultBreakMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  defaultBreakMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultBreakMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  defaultBreakMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultBreakMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  defaultFocusMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultFocusMinutes', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  defaultFocusMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultFocusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  defaultFocusMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultFocusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  defaultFocusMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultFocusMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  longBreakIntervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'longBreakInterval', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  longBreakIntervalGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longBreakInterval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  longBreakIntervalLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longBreakInterval',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  longBreakIntervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longBreakInterval',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  longBreakMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'longBreakMinutes', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  longBreakMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longBreakMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  longBreakMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longBreakMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  longBreakMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longBreakMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterFilterCondition>
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

extension PomodoroPlanModelQueryObject
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QFilterCondition> {}

extension PomodoroPlanModelQueryLinks
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QFilterCondition> {}

extension PomodoroPlanModelQuerySortBy
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QSortBy> {
  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByAutoStartBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartBreak', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByAutoStartBreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartBreak', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByAutoStartNextFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartNextFocus', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByAutoStartNextFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartNextFocus', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByDefaultBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultBreakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByDefaultBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultBreakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByDefaultFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultFocusMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByDefaultFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultFocusMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByLongBreakIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByLongBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByLongBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PomodoroPlanModelQuerySortThenBy
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QSortThenBy> {
  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByAutoStartBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartBreak', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByAutoStartBreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartBreak', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByAutoStartNextFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartNextFocus', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByAutoStartNextFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartNextFocus', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByDefaultBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultBreakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByDefaultBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultBreakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByDefaultFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultFocusMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByDefaultFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultFocusMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByLongBreakIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByLongBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByLongBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PomodoroPlanModelQueryWhereDistinct
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct> {
  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByAutoStartBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoStartBreak');
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByAutoStartNextFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoStartNextFocus');
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByDefaultBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultBreakMinutes');
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByDefaultFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultFocusMinutes');
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longBreakInterval');
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByLongBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longBreakMinutes');
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PomodoroPlanModelQueryProperty
    on QueryBuilder<PomodoroPlanModel, PomodoroPlanModel, QQueryProperty> {
  QueryBuilder<PomodoroPlanModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PomodoroPlanModel, bool, QQueryOperations>
  autoStartBreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoStartBreak');
    });
  }

  QueryBuilder<PomodoroPlanModel, bool, QQueryOperations>
  autoStartNextFocusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoStartNextFocus');
    });
  }

  QueryBuilder<PomodoroPlanModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PomodoroPlanModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PomodoroPlanModel, int, QQueryOperations>
  defaultBreakMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultBreakMinutes');
    });
  }

  QueryBuilder<PomodoroPlanModel, int, QQueryOperations>
  defaultFocusMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultFocusMinutes');
    });
  }

  QueryBuilder<PomodoroPlanModel, int, QQueryOperations>
  longBreakIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longBreakInterval');
    });
  }

  QueryBuilder<PomodoroPlanModel, int, QQueryOperations>
  longBreakMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longBreakMinutes');
    });
  }

  QueryBuilder<PomodoroPlanModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<PomodoroPlanModel, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
