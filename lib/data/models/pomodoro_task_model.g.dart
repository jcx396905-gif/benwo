// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_task_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPomodoroTaskModelCollection on Isar {
  IsarCollection<PomodoroTaskModel> get pomodoroTaskModels => this.collection();
}

const PomodoroTaskModelSchema = CollectionSchema(
  name: r'PomodoroTaskModel',
  id: 4240495452659860694,
  properties: {
    r'aiStepsJson': PropertySchema(
      id: 0,
      name: r'aiStepsJson',
      type: IsarType.string,
    ),
    r'breakMinutes': PropertySchema(
      id: 1,
      name: r'breakMinutes',
      type: IsarType.long,
    ),
    r'completedAt': PropertySchema(
      id: 2,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'durationEditedByUser': PropertySchema(
      id: 4,
      name: r'durationEditedByUser',
      type: IsarType.bool,
    ),
    r'estimatedMinutes': PropertySchema(
      id: 5,
      name: r'estimatedMinutes',
      type: IsarType.long,
    ),
    r'focusMinutes': PropertySchema(
      id: 6,
      name: r'focusMinutes',
      type: IsarType.long,
    ),
    r'isCompleted': PropertySchema(
      id: 7,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'isTimeLocked': PropertySchema(
      id: 8,
      name: r'isTimeLocked',
      type: IsarType.bool,
    ),
    r'longBreakInterval': PropertySchema(
      id: 9,
      name: r'longBreakInterval',
      type: IsarType.long,
    ),
    r'longBreakMinutes': PropertySchema(
      id: 10,
      name: r'longBreakMinutes',
      type: IsarType.long,
    ),
    r'orderEditedByUser': PropertySchema(
      id: 11,
      name: r'orderEditedByUser',
      type: IsarType.bool,
    ),
    r'orderIndex': PropertySchema(
      id: 12,
      name: r'orderIndex',
      type: IsarType.long,
    ),
    r'planId': PropertySchema(id: 13, name: r'planId', type: IsarType.long),
    r'plannedFocusSegments': PropertySchema(
      id: 14,
      name: r'plannedFocusSegments',
      type: IsarType.long,
    ),
    r'scheduledTime': PropertySchema(
      id: 15,
      name: r'scheduledTime',
      type: IsarType.string,
    ),
    r'sourceType': PropertySchema(
      id: 16,
      name: r'sourceType',
      type: IsarType.byte,
      enumMap: _PomodoroTaskModelsourceTypeEnumValueMap,
    ),
    r'title': PropertySchema(id: 17, name: r'title', type: IsarType.string),
    r'titleEditedByUser': PropertySchema(
      id: 18,
      name: r'titleEditedByUser',
      type: IsarType.bool,
    ),
    r'todoId': PropertySchema(id: 19, name: r'todoId', type: IsarType.long),
    r'updatedAt': PropertySchema(
      id: 20,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(id: 21, name: r'userId', type: IsarType.long),
  },
  estimateSize: _pomodoroTaskModelEstimateSize,
  serialize: _pomodoroTaskModelSerialize,
  deserialize: _pomodoroTaskModelDeserialize,
  deserializeProp: _pomodoroTaskModelDeserializeProp,
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
    r'todoId': IndexSchema(
      id: 4266691497494727738,
      name: r'todoId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'todoId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'orderIndex': IndexSchema(
      id: -6149432298716175352,
      name: r'orderIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderIndex',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'isCompleted': IndexSchema(
      id: -7936144632215868537,
      name: r'isCompleted',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isCompleted',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _pomodoroTaskModelGetId,
  getLinks: _pomodoroTaskModelGetLinks,
  attach: _pomodoroTaskModelAttach,
  version: '3.1.0+1',
);

int _pomodoroTaskModelEstimateSize(
  PomodoroTaskModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.aiStepsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.scheduledTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _pomodoroTaskModelSerialize(
  PomodoroTaskModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aiStepsJson);
  writer.writeLong(offsets[1], object.breakMinutes);
  writer.writeDateTime(offsets[2], object.completedAt);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeBool(offsets[4], object.durationEditedByUser);
  writer.writeLong(offsets[5], object.estimatedMinutes);
  writer.writeLong(offsets[6], object.focusMinutes);
  writer.writeBool(offsets[7], object.isCompleted);
  writer.writeBool(offsets[8], object.isTimeLocked);
  writer.writeLong(offsets[9], object.longBreakInterval);
  writer.writeLong(offsets[10], object.longBreakMinutes);
  writer.writeBool(offsets[11], object.orderEditedByUser);
  writer.writeLong(offsets[12], object.orderIndex);
  writer.writeLong(offsets[13], object.planId);
  writer.writeLong(offsets[14], object.plannedFocusSegments);
  writer.writeString(offsets[15], object.scheduledTime);
  writer.writeByte(offsets[16], object.sourceType.index);
  writer.writeString(offsets[17], object.title);
  writer.writeBool(offsets[18], object.titleEditedByUser);
  writer.writeLong(offsets[19], object.todoId);
  writer.writeDateTime(offsets[20], object.updatedAt);
  writer.writeLong(offsets[21], object.userId);
}

PomodoroTaskModel _pomodoroTaskModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PomodoroTaskModel();
  object.aiStepsJson = reader.readStringOrNull(offsets[0]);
  object.breakMinutes = reader.readLong(offsets[1]);
  object.completedAt = reader.readDateTimeOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.durationEditedByUser = reader.readBool(offsets[4]);
  object.estimatedMinutes = reader.readLongOrNull(offsets[5]);
  object.focusMinutes = reader.readLong(offsets[6]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[7]);
  object.isTimeLocked = reader.readBool(offsets[8]);
  object.longBreakInterval = reader.readLong(offsets[9]);
  object.longBreakMinutes = reader.readLong(offsets[10]);
  object.orderEditedByUser = reader.readBool(offsets[11]);
  object.orderIndex = reader.readLong(offsets[12]);
  object.planId = reader.readLong(offsets[13]);
  object.plannedFocusSegments = reader.readLong(offsets[14]);
  object.scheduledTime = reader.readStringOrNull(offsets[15]);
  object.sourceType =
      _PomodoroTaskModelsourceTypeValueEnumMap[reader.readByteOrNull(
        offsets[16],
      )] ??
      PomodoroTaskSourceType.todo;
  object.title = reader.readString(offsets[17]);
  object.titleEditedByUser = reader.readBool(offsets[18]);
  object.todoId = reader.readLongOrNull(offsets[19]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[20]);
  object.userId = reader.readLong(offsets[21]);
  return object;
}

P _pomodoroTaskModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (_PomodoroTaskModelsourceTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              PomodoroTaskSourceType.todo)
          as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset)) as P;
    case 20:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PomodoroTaskModelsourceTypeEnumValueMap = {
  'todo': 0,
  'manual': 1,
  'ai': 2,
  'template': 3,
};
const _PomodoroTaskModelsourceTypeValueEnumMap = {
  0: PomodoroTaskSourceType.todo,
  1: PomodoroTaskSourceType.manual,
  2: PomodoroTaskSourceType.ai,
  3: PomodoroTaskSourceType.template,
};

Id _pomodoroTaskModelGetId(PomodoroTaskModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pomodoroTaskModelGetLinks(
  PomodoroTaskModel object,
) {
  return [];
}

void _pomodoroTaskModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PomodoroTaskModel object,
) {
  object.id = id;
}

extension PomodoroTaskModelQueryWhereSort
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QWhere> {
  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhere> anyPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'planId'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhere> anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhere> anyTodoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'todoId'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhere>
  anyOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'orderIndex'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhere>
  anyIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isCompleted'),
      );
    });
  }
}

extension PomodoroTaskModelQueryWhere
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QWhereClause> {
  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  planIdEqualTo(int planId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'planId', value: [planId]),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  userIdEqualTo(int userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  todoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'todoId', value: [null]),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  todoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'todoId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  todoIdEqualTo(int? todoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'todoId', value: [todoId]),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  todoIdNotEqualTo(int? todoId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'todoId',
                lower: [],
                upper: [todoId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'todoId',
                lower: [todoId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'todoId',
                lower: [todoId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'todoId',
                lower: [],
                upper: [todoId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  todoIdGreaterThan(int? todoId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'todoId',
          lower: [todoId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  todoIdLessThan(int? todoId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'todoId',
          lower: [],
          upper: [todoId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  todoIdBetween(
    int? lowerTodoId,
    int? upperTodoId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'todoId',
          lower: [lowerTodoId],
          includeLower: includeLower,
          upper: [upperTodoId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  orderIndexEqualTo(int orderIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'orderIndex', value: [orderIndex]),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  orderIndexNotEqualTo(int orderIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderIndex',
                lower: [],
                upper: [orderIndex],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderIndex',
                lower: [orderIndex],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderIndex',
                lower: [orderIndex],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderIndex',
                lower: [],
                upper: [orderIndex],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  orderIndexGreaterThan(int orderIndex, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'orderIndex',
          lower: [orderIndex],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  orderIndexLessThan(int orderIndex, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'orderIndex',
          lower: [],
          upper: [orderIndex],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  orderIndexBetween(
    int lowerOrderIndex,
    int upperOrderIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'orderIndex',
          lower: [lowerOrderIndex],
          includeLower: includeLower,
          upper: [upperOrderIndex],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  isCompletedEqualTo(bool isCompleted) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'isCompleted',
          value: [isCompleted],
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterWhereClause>
  isCompletedNotEqualTo(bool isCompleted) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isCompleted',
                lower: [],
                upper: [isCompleted],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isCompleted',
                lower: [isCompleted],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isCompleted',
                lower: [isCompleted],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isCompleted',
                lower: [],
                upper: [isCompleted],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PomodoroTaskModelQueryFilter
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QFilterCondition> {
  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'aiStepsJson'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'aiStepsJson'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'aiStepsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'aiStepsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'aiStepsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'aiStepsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'aiStepsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'aiStepsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'aiStepsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'aiStepsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'aiStepsJson', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  aiStepsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'aiStepsJson', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  breakMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'breakMinutes', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  durationEditedByUserEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'durationEditedByUser',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  estimatedMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'estimatedMinutes'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  estimatedMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'estimatedMinutes'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  estimatedMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'estimatedMinutes', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  estimatedMinutesGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'estimatedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  estimatedMinutesLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'estimatedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  estimatedMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'estimatedMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  focusMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusMinutes', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCompleted', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  isTimeLockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isTimeLocked', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  longBreakIntervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'longBreakInterval', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  longBreakMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'longBreakMinutes', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  orderEditedByUserEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'orderEditedByUser', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  orderIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'orderIndex', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  orderIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'orderIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  orderIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'orderIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  orderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'orderIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  planIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'planId', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  plannedFocusSegmentsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'plannedFocusSegments',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  plannedFocusSegmentsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedFocusSegments',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  plannedFocusSegmentsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedFocusSegments',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  plannedFocusSegmentsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedFocusSegments',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'scheduledTime'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'scheduledTime'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'scheduledTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scheduledTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scheduledTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scheduledTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'scheduledTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'scheduledTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'scheduledTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'scheduledTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scheduledTime', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  scheduledTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scheduledTime', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  sourceTypeEqualTo(PomodoroTaskSourceType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceType', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  sourceTypeGreaterThan(PomodoroTaskSourceType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  sourceTypeLessThan(PomodoroTaskSourceType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  sourceTypeBetween(
    PomodoroTaskSourceType lower,
    PomodoroTaskSourceType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  titleEditedByUserEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'titleEditedByUser', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  todoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'todoId'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  todoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'todoId'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  todoIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'todoId', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  todoIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'todoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  todoIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'todoId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  todoIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'todoId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
  userIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: value),
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterFilterCondition>
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

extension PomodoroTaskModelQueryObject
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QFilterCondition> {}

extension PomodoroTaskModelQueryLinks
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QFilterCondition> {}

extension PomodoroTaskModelQuerySortBy
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QSortBy> {
  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByAiStepsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiStepsJson', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByAiStepsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiStepsJson', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByDurationEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationEditedByUser', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByDurationEditedByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationEditedByUser', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByEstimatedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByEstimatedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByIsTimeLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTimeLocked', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByIsTimeLockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTimeLocked', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByLongBreakIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByLongBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByLongBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByOrderEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderEditedByUser', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByOrderEditedByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderEditedByUser', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByPlannedFocusSegments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedFocusSegments', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByPlannedFocusSegmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedFocusSegments', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortBySourceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByTitleEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleEditedByUser', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByTitleEditedByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleEditedByUser', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByTodoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todoId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByTodoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todoId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PomodoroTaskModelQuerySortThenBy
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QSortThenBy> {
  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByAiStepsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiStepsJson', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByAiStepsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiStepsJson', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByDurationEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationEditedByUser', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByDurationEditedByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationEditedByUser', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByEstimatedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByEstimatedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByIsTimeLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTimeLocked', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByIsTimeLockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTimeLocked', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByLongBreakIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakInterval', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByLongBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakMinutes', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByLongBreakMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longBreakMinutes', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByOrderEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderEditedByUser', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByOrderEditedByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderEditedByUser', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByPlannedFocusSegments() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedFocusSegments', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByPlannedFocusSegmentsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedFocusSegments', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByScheduledTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByScheduledTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledTime', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenBySourceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByTitleEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleEditedByUser', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByTitleEditedByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleEditedByUser', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByTodoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todoId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByTodoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'todoId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PomodoroTaskModelQueryWhereDistinct
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct> {
  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByAiStepsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiStepsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breakMinutes');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByDurationEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationEditedByUser');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByEstimatedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedMinutes');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusMinutes');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByIsTimeLocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTimeLocked');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByLongBreakInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longBreakInterval');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByLongBreakMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longBreakMinutes');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByOrderEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderEditedByUser');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderIndex');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByPlannedFocusSegments() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedFocusSegments');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByScheduledTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'scheduledTime',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceType');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByTitleEditedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleEditedByUser');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByTodoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'todoId');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QDistinct>
  distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension PomodoroTaskModelQueryProperty
    on QueryBuilder<PomodoroTaskModel, PomodoroTaskModel, QQueryProperty> {
  QueryBuilder<PomodoroTaskModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PomodoroTaskModel, String?, QQueryOperations>
  aiStepsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiStepsJson');
    });
  }

  QueryBuilder<PomodoroTaskModel, int, QQueryOperations>
  breakMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakMinutes');
    });
  }

  QueryBuilder<PomodoroTaskModel, DateTime?, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<PomodoroTaskModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PomodoroTaskModel, bool, QQueryOperations>
  durationEditedByUserProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationEditedByUser');
    });
  }

  QueryBuilder<PomodoroTaskModel, int?, QQueryOperations>
  estimatedMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedMinutes');
    });
  }

  QueryBuilder<PomodoroTaskModel, int, QQueryOperations>
  focusMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusMinutes');
    });
  }

  QueryBuilder<PomodoroTaskModel, bool, QQueryOperations>
  isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<PomodoroTaskModel, bool, QQueryOperations>
  isTimeLockedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTimeLocked');
    });
  }

  QueryBuilder<PomodoroTaskModel, int, QQueryOperations>
  longBreakIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longBreakInterval');
    });
  }

  QueryBuilder<PomodoroTaskModel, int, QQueryOperations>
  longBreakMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longBreakMinutes');
    });
  }

  QueryBuilder<PomodoroTaskModel, bool, QQueryOperations>
  orderEditedByUserProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderEditedByUser');
    });
  }

  QueryBuilder<PomodoroTaskModel, int, QQueryOperations> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderIndex');
    });
  }

  QueryBuilder<PomodoroTaskModel, int, QQueryOperations> planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<PomodoroTaskModel, int, QQueryOperations>
  plannedFocusSegmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedFocusSegments');
    });
  }

  QueryBuilder<PomodoroTaskModel, String?, QQueryOperations>
  scheduledTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledTime');
    });
  }

  QueryBuilder<PomodoroTaskModel, PomodoroTaskSourceType, QQueryOperations>
  sourceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceType');
    });
  }

  QueryBuilder<PomodoroTaskModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<PomodoroTaskModel, bool, QQueryOperations>
  titleEditedByUserProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleEditedByUser');
    });
  }

  QueryBuilder<PomodoroTaskModel, int?, QQueryOperations> todoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'todoId');
    });
  }

  QueryBuilder<PomodoroTaskModel, DateTime?, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PomodoroTaskModel, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
