// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPomodoroSessionModelCollection on Isar {
  IsarCollection<PomodoroSessionModel> get pomodoroSessionModels =>
      this.collection();
}

const PomodoroSessionModelSchema = CollectionSchema(
  name: r'PomodoroSessionModel',
  id: -4261804283330556400,
  properties: {
    r'actualBreakSeconds': PropertySchema(
      id: 0,
      name: r'actualBreakSeconds',
      type: IsarType.long,
    ),
    r'actualFocusSeconds': PropertySchema(
      id: 1,
      name: r'actualFocusSeconds',
      type: IsarType.long,
    ),
    r'breakEndAt': PropertySchema(
      id: 2,
      name: r'breakEndAt',
      type: IsarType.dateTime,
    ),
    r'breakMinutes': PropertySchema(
      id: 3,
      name: r'breakMinutes',
      type: IsarType.long,
    ),
    r'breakStartedAt': PropertySchema(
      id: 4,
      name: r'breakStartedAt',
      type: IsarType.dateTime,
    ),
    r'completedAt': PropertySchema(
      id: 5,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 6,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'focusCompletedAt': PropertySchema(
      id: 7,
      name: r'focusCompletedAt',
      type: IsarType.dateTime,
    ),
    r'focusMinutes': PropertySchema(
      id: 8,
      name: r'focusMinutes',
      type: IsarType.long,
    ),
    r'pausedRemainingSeconds': PropertySchema(
      id: 9,
      name: r'pausedRemainingSeconds',
      type: IsarType.long,
    ),
    r'planId': PropertySchema(id: 10, name: r'planId', type: IsarType.long),
    r'sessionIndex': PropertySchema(
      id: 11,
      name: r'sessionIndex',
      type: IsarType.long,
    ),
    r'startedAt': PropertySchema(
      id: 12,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 13,
      name: r'status',
      type: IsarType.byte,
      enumMap: _PomodoroSessionModelstatusEnumValueMap,
    ),
    r'targetEndAt': PropertySchema(
      id: 14,
      name: r'targetEndAt',
      type: IsarType.dateTime,
    ),
    r'taskId': PropertySchema(id: 15, name: r'taskId', type: IsarType.long),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(id: 17, name: r'userId', type: IsarType.long),
  },
  estimateSize: _pomodoroSessionModelEstimateSize,
  serialize: _pomodoroSessionModelSerialize,
  deserialize: _pomodoroSessionModelDeserialize,
  deserializeProp: _pomodoroSessionModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'planId': IndexSchema(
      id: 7282644713036731817,
      name: r'planId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'planId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'taskId': IndexSchema(
      id: -6391211041487498726,
      name: r'taskId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _pomodoroSessionModelGetId,
  getLinks: _pomodoroSessionModelGetLinks,
  attach: _pomodoroSessionModelAttach,
  version: '3.1.0+1',
);

int _pomodoroSessionModelEstimateSize(
  PomodoroSessionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _pomodoroSessionModelSerialize(
  PomodoroSessionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actualBreakSeconds);
  writer.writeLong(offsets[1], object.actualFocusSeconds);
  writer.writeDateTime(offsets[2], object.breakEndAt);
  writer.writeLong(offsets[3], object.breakMinutes);
  writer.writeDateTime(offsets[4], object.breakStartedAt);
  writer.writeDateTime(offsets[5], object.completedAt);
  writer.writeDateTime(offsets[6], object.createdAt);
  writer.writeDateTime(offsets[7], object.focusCompletedAt);
  writer.writeLong(offsets[8], object.focusMinutes);
  writer.writeLong(offsets[9], object.pausedRemainingSeconds);
  writer.writeLong(offsets[10], object.planId);
  writer.writeLong(offsets[11], object.sessionIndex);
  writer.writeDateTime(offsets[12], object.startedAt);
  writer.writeByte(offsets[13], object.status.index);
  writer.writeDateTime(offsets[14], object.targetEndAt);
  writer.writeLong(offsets[15], object.taskId);
  writer.writeDateTime(offsets[16], object.updatedAt);
  writer.writeLong(offsets[17], object.userId);
}

PomodoroSessionModel _pomodoroSessionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PomodoroSessionModel();
  object.actualBreakSeconds = reader.readLong(offsets[0]);
  object.actualFocusSeconds = reader.readLong(offsets[1]);
  object.breakEndAt = reader.readDateTimeOrNull(offsets[2]);
  object.breakMinutes = reader.readLong(offsets[3]);
  object.breakStartedAt = reader.readDateTimeOrNull(offsets[4]);
  object.completedAt = reader.readDateTimeOrNull(offsets[5]);
  object.createdAt = reader.readDateTime(offsets[6]);
  object.focusCompletedAt = reader.readDateTimeOrNull(offsets[7]);
  object.focusMinutes = reader.readLong(offsets[8]);
  object.id = id;
  object.pausedRemainingSeconds = reader.readLongOrNull(offsets[9]);
  object.planId = reader.readLong(offsets[10]);
  object.sessionIndex = reader.readLong(offsets[11]);
  object.startedAt = reader.readDateTimeOrNull(offsets[12]);
  object.status =
      _PomodoroSessionModelstatusValueEnumMap[reader.readByteOrNull(
        offsets[13],
      )] ??
      PomodoroSessionStatus.pending;
  object.targetEndAt = reader.readDateTimeOrNull(offsets[14]);
  object.taskId = reader.readLong(offsets[15]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[16]);
  object.userId = reader.readLong(offsets[17]);
  return object;
}

P _pomodoroSessionModelDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (_PomodoroSessionModelstatusValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              PomodoroSessionStatus.pending)
          as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PomodoroSessionModelstatusEnumValueMap = {
  'pending': 0,
  'focusing': 1,
  'focusPaused': 2,
  'resting': 3,
  'restPaused': 4,
  'completed': 5,
  'skipped': 6,
  'abandoned': 7,
};
const _PomodoroSessionModelstatusValueEnumMap = {
  0: PomodoroSessionStatus.pending,
  1: PomodoroSessionStatus.focusing,
  2: PomodoroSessionStatus.focusPaused,
  3: PomodoroSessionStatus.resting,
  4: PomodoroSessionStatus.restPaused,
  5: PomodoroSessionStatus.completed,
  6: PomodoroSessionStatus.skipped,
  7: PomodoroSessionStatus.abandoned,
};

Id _pomodoroSessionModelGetId(PomodoroSessionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pomodoroSessionModelGetLinks(
  PomodoroSessionModel object,
) {
  return [];
}

void _pomodoroSessionModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PomodoroSessionModel object,
) {
  object.id = id;
}

extension PomodoroSessionModelQueryWhereSort
    on QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QWhere> {
  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhere>
  anyPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'planId'),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhere>
  anyTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'taskId'),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhere>
  anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhere>
  anyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'status'),
      );
    });
  }
}

extension PomodoroSessionModelQueryWhere
    on QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QWhereClause> {
  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  planIdEqualTo(int planId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'planId', value: [planId]),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  planIdNotEqualTo(int planId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'planId',
                lower: [],
                upper: [planId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'planId',
                lower: [planId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'planId',
                lower: [planId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'planId',
                lower: [],
                upper: [planId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  planIdGreaterThan(int planId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'planId',
          lower: [planId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  planIdLessThan(int planId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'planId',
          lower: [],
          upper: [planId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  planIdBetween(
    int lowerPlanId,
    int upperPlanId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'planId',
          lower: [lowerPlanId],
          includeLower: includeLower,
          upper: [upperPlanId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  taskIdEqualTo(int taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'taskId', value: [taskId]),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  taskIdNotEqualTo(int taskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'taskId',
                lower: [],
                upper: [taskId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'taskId',
                lower: [taskId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'taskId',
                lower: [taskId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'taskId',
                lower: [],
                upper: [taskId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  taskIdGreaterThan(int taskId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'taskId',
          lower: [taskId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  taskIdLessThan(int taskId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'taskId',
          lower: [],
          upper: [taskId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  taskIdBetween(
    int lowerTaskId,
    int upperTaskId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'taskId',
          lower: [lowerTaskId],
          includeLower: includeLower,
          upper: [upperTaskId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  userIdEqualTo(int userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  userIdNotEqualTo(int userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  userIdGreaterThan(int userId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'userId',
          lower: [userId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  userIdLessThan(int userId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'userId',
          lower: [],
          upper: [userId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  userIdBetween(
    int lowerUserId,
    int upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'userId',
          lower: [lowerUserId],
          includeLower: includeLower,
          upper: [upperUserId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  statusEqualTo(PomodoroSessionStatus status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  statusNotEqualTo(PomodoroSessionStatus status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  statusGreaterThan(PomodoroSessionStatus status, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'status',
          lower: [status],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  statusLessThan(PomodoroSessionStatus status, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'status',
          lower: [],
          upper: [status],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterWhereClause>
  statusBetween(
    PomodoroSessionStatus lowerStatus,
    PomodoroSessionStatus upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'status',
          lower: [lowerStatus],
          includeLower: includeLower,
          upper: [upperStatus],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PomodoroSessionModelQueryFilter
    on
        QueryBuilder<
          PomodoroSessionModel,
          PomodoroSessionModel,
          QFilterCondition
        > {
  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  actualBreakSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'actualBreakSeconds', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  actualBreakSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'actualBreakSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  actualBreakSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'actualBreakSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  actualBreakSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'actualBreakSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  actualFocusSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'actualFocusSeconds', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  actualFocusSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'actualFocusSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  actualFocusSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'actualFocusSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  actualFocusSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'actualFocusSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakEndAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'breakEndAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakEndAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'breakEndAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakEndAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'breakEndAt', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakEndAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'breakEndAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakEndAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'breakEndAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakEndAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'breakEndAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'breakMinutes', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'breakMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'breakMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'breakMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakStartedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'breakStartedAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakStartedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'breakStartedAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakStartedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'breakStartedAt', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakStartedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'breakStartedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakStartedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'breakStartedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  breakStartedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'breakStartedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  completedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  completedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusCompletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'focusCompletedAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusCompletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'focusCompletedAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusCompletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusCompletedAt', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusCompletedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'focusCompletedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusCompletedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'focusCompletedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusCompletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'focusCompletedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusMinutes', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'focusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'focusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  focusMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'focusMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  pausedRemainingSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pausedRemainingSeconds'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  pausedRemainingSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pausedRemainingSeconds'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  pausedRemainingSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pausedRemainingSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  pausedRemainingSecondsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pausedRemainingSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  pausedRemainingSecondsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pausedRemainingSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  pausedRemainingSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pausedRemainingSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  planIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'planId', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  planIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'planId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  planIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'planId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  planIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'planId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  sessionIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sessionIndex', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  sessionIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sessionIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  sessionIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sessionIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  sessionIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sessionIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  startedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startedAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  startedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startedAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  startedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedAt', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  startedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  startedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  startedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  statusEqualTo(PomodoroSessionStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  statusGreaterThan(PomodoroSessionStatus value, {bool include = false}) {
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

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  statusLessThan(PomodoroSessionStatus value, {bool include = false}) {
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

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  statusBetween(
    PomodoroSessionStatus lower,
    PomodoroSessionStatus upper, {
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

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  targetEndAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'targetEndAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  targetEndAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'targetEndAt'),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  targetEndAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetEndAt', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  targetEndAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetEndAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  targetEndAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetEndAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  targetEndAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetEndAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  taskIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taskId', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  taskIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'taskId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  taskIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'taskId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  taskIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'taskId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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
    PomodoroSessionModel,
    PomodoroSessionModel,
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

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  userIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: value),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  userIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  userIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PomodoroSessionModelQueryObject
    on
        QueryBuilder<
          PomodoroSessionModel,
          PomodoroSessionModel,
          QFilterCondition
        > {}

extension PomodoroSessionModelQueryLinks
    on
        QueryBuilder<
          PomodoroSessionModel,
          PomodoroSessionModel,
          QFilterCondition
        > {}

extension PomodoroSessionModelQuerySortBy
    on QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QSortBy> {
  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByActualBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualBreakSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByActualBreakSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualBreakSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByActualFocusSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualFocusSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByActualFocusSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualFocusSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByBreakEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakEndAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByBreakEndAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakEndAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByBreakStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakStartedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByBreakStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakStartedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByFocusCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusCompletedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByFocusCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusCompletedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByPausedRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedRemainingSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByPausedRemainingSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedRemainingSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortBySessionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionIndex', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortBySessionIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionIndex', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByTargetEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetEndAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByTargetEndAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetEndAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PomodoroSessionModelQuerySortThenBy
    on QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QSortThenBy> {
  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByActualBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualBreakSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByActualBreakSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualBreakSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByActualFocusSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualFocusSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByActualFocusSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualFocusSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByBreakEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakEndAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByBreakEndAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakEndAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByBreakStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakStartedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByBreakStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakStartedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByFocusCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusCompletedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByFocusCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusCompletedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByPausedRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedRemainingSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByPausedRemainingSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedRemainingSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenBySessionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionIndex', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenBySessionIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionIndex', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByTargetEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetEndAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByTargetEndAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetEndAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PomodoroSessionModelQueryWhereDistinct
    on QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct> {
  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByActualBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualBreakSeconds');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByActualFocusSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualFocusSeconds');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByBreakEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breakEndAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breakMinutes');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByBreakStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breakStartedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByFocusCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusCompletedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusMinutes');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByPausedRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pausedRemainingSeconds');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctBySessionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionIndex');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByTargetEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetEndAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionModel, QDistinct>
  distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension PomodoroSessionModelQueryProperty
    on
        QueryBuilder<
          PomodoroSessionModel,
          PomodoroSessionModel,
          QQueryProperty
        > {
  QueryBuilder<PomodoroSessionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PomodoroSessionModel, int, QQueryOperations>
  actualBreakSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualBreakSeconds');
    });
  }

  QueryBuilder<PomodoroSessionModel, int, QQueryOperations>
  actualFocusSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualFocusSeconds');
    });
  }

  QueryBuilder<PomodoroSessionModel, DateTime?, QQueryOperations>
  breakEndAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakEndAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, int, QQueryOperations>
  breakMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakMinutes');
    });
  }

  QueryBuilder<PomodoroSessionModel, DateTime?, QQueryOperations>
  breakStartedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakStartedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, DateTime?, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, DateTime?, QQueryOperations>
  focusCompletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusCompletedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, int, QQueryOperations>
  focusMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusMinutes');
    });
  }

  QueryBuilder<PomodoroSessionModel, int?, QQueryOperations>
  pausedRemainingSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pausedRemainingSeconds');
    });
  }

  QueryBuilder<PomodoroSessionModel, int, QQueryOperations> planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<PomodoroSessionModel, int, QQueryOperations>
  sessionIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionIndex');
    });
  }

  QueryBuilder<PomodoroSessionModel, DateTime?, QQueryOperations>
  startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, PomodoroSessionStatus, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<PomodoroSessionModel, DateTime?, QQueryOperations>
  targetEndAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetEndAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, int, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<PomodoroSessionModel, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PomodoroSessionModel, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
