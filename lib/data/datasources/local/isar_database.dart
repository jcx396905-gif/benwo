import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/big_goal_model.dart';
import '../../models/pomodoro_plan_model.dart';
import '../../models/pomodoro_session_model.dart';
import '../../models/pomodoro_task_model.dart';
import '../../models/saved_pomodoro_list_model.dart';
import '../../models/todo_item_model.dart';
import '../../models/user_profile_model.dart';
import '../../repositories/big_goal_repository.dart';
import '../../repositories/pomodoro_repository.dart';
import '../../repositories/todo_item_repository.dart';
import '../../repositories/user_profile_repository.dart';

class IsarDatabase {
  IsarDatabase._();

  static List<CollectionSchema<dynamic>> get schemas => [
    UserProfileModelSchema,
    BigGoalModelSchema,
    TodoItemModelSchema,
    PomodoroPlanModelSchema,
    PomodoroTaskModelSchema,
    PomodoroSessionModelSchema,
    SavedPomodoroListModelSchema,
  ];

  static Future<Isar> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    return Isar.open(schemas, directory: directory.path);
  }
}

class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Future<UserProfileModel> saveProfile({
    String? communicationStyle,
    String? bestWorkTime,
    String? taskPace,
  }) async {
    final existing = await getProfile();
    final profile =
        existing ??
        (UserProfileModel()
          ..id = UserProfileModel.singletonId
          ..createdAt = DateTime.now());
    profile
      ..communicationStyle = communicationStyle
      ..bestWorkTime = bestWorkTime
      ..taskPace = taskPace
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.userProfileModels.put(profile));
    return profile;
  }

  @override
  Future<UserProfileModel?> getProfile() {
    return _isar.userProfileModels.get(UserProfileModel.singletonId);
  }

  @override
  Stream<UserProfileModel?> watchProfile() {
    return _isar.userProfileModels.watchObject(
      UserProfileModel.singletonId,
      fireImmediately: true,
    );
  }

  @override
  Future<void> clearProfile() async {
    await _isar.writeTxn(
      () => _isar.userProfileModels.delete(UserProfileModel.singletonId),
    );
  }
}

class BigGoalRepositoryImpl implements BigGoalRepository {
  BigGoalRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Future<BigGoalModel> createGoal({
    required String title,
    String? description,
    DateTime? targetDate,
    String? color,
    String? category,
    String? aiSummary,
  }) async {
    final goal = BigGoalModel()
      ..title = title
      ..description = description
      ..targetDate = targetDate ?? DateTime.now().add(const Duration(days: 90))
      ..status = GoalStatus.inProgress
      ..color = color
      ..category = category
      ..aiSummary = aiSummary
      ..createdAt = DateTime.now();
    await _isar.writeTxn(() => _isar.bigGoalModels.put(goal));
    return goal;
  }

  @override
  Future<BigGoalModel?> getGoalById(int id) => _isar.bigGoalModels.get(id);

  @override
  Future<List<BigGoalModel>> getGoals() {
    return _isar.bigGoalModels.where().sortByCreatedAtDesc().findAll();
  }

  @override
  Future<List<BigGoalModel>> getGoalsByStatus(GoalStatus status) {
    return _isar.bigGoalModels
        .filter()
        .statusEqualTo(status)
        .sortByCreatedAtDesc()
        .findAll();
  }

  @override
  Future<void> updateGoal(BigGoalModel goal) async {
    goal.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.bigGoalModels.put(goal));
  }

  @override
  Future<void> completeGoal(int goalId) async {
    await _isar.writeTxn(() async {
      final goal = await _isar.bigGoalModels.get(goalId);
      if (goal == null) return;
      goal
        ..status = GoalStatus.completed
        ..completedAt = DateTime.now()
        ..updatedAt = DateTime.now();
      await _isar.bigGoalModels.put(goal);
    });
  }

  @override
  Future<void> abandonGoal(int goalId) async {
    await _isar.writeTxn(() async {
      final goal = await _isar.bigGoalModels.get(goalId);
      if (goal == null) return;
      goal
        ..status = GoalStatus.abandoned
        ..updatedAt = DateTime.now();
      await _isar.bigGoalModels.put(goal);
    });
  }

  @override
  Future<void> deleteGoal(int goalId) async {
    await _isar.writeTxn(() => _isar.bigGoalModels.delete(goalId));
  }

  @override
  Stream<List<BigGoalModel>> watchGoals() {
    return _isar.bigGoalModels.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  @override
  Stream<BigGoalModel?> watchGoalById(int goalId) {
    return _isar.bigGoalModels.watchObject(goalId, fireImmediately: true);
  }
}

class TodoItemRepositoryImpl implements TodoItemRepository {
  TodoItemRepositoryImpl(this._isar);

  final Isar _isar;

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  @override
  Future<TodoItemModel> createTodo({
    required String content,
    int? goalId,
    bool isAIGenerated = false,
    DateTime? scheduledDate,
    int? estimatedMinutes,
    String? color,
    String? aiConfirmationQuestions,
  }) async {
    final todo = TodoItemModel()
      ..goalId = goalId
      ..content = content
      ..isAIGenerated = isAIGenerated
      ..scheduledDate = scheduledDate ?? _startOfDay(DateTime.now())
      ..isCompleted = false
      ..estimatedMinutes = estimatedMinutes
      ..color = color
      ..aiConfirmationQuestions = aiConfirmationQuestions
      ..createdAt = DateTime.now();
    await _isar.writeTxn(() => _isar.todoItemModels.put(todo));
    return todo;
  }

  @override
  Future<TodoItemModel?> getTodoById(int id) => _isar.todoItemModels.get(id);

  @override
  Future<List<TodoItemModel>> getTodosByGoalId(int goalId) {
    return _isar.todoItemModels
        .where()
        .goalIdEqualTo(goalId)
        .sortByScheduledDate()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getTodosByDate(DateTime date) {
    return _isar.todoItemModels
        .filter()
        .scheduledDateBetween(_startOfDay(date), _endOfDay(date))
        .sortByScheduledDate()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getTodosByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _isar.todoItemModels
        .filter()
        .scheduledDateBetween(_startOfDay(startDate), _endOfDay(endDate))
        .sortByScheduledDate()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getTodos() {
    return _isar.todoItemModels.where().sortByScheduledDateDesc().findAll();
  }

  @override
  Future<List<TodoItemModel>> getIncompleteTodos() {
    return _isar.todoItemModels
        .filter()
        .isCompletedEqualTo(false)
        .sortByScheduledDate()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getCompletedTodos() {
    return _isar.todoItemModels
        .filter()
        .isCompletedEqualTo(true)
        .sortByScheduledDateDesc()
        .findAll();
  }

  @override
  Future<void> updateTodo(TodoItemModel todo) async {
    await _isar.writeTxn(() => _isar.todoItemModels.put(todo));
  }

  @override
  Future<void> completeTodo(int todoId) async {
    await _isar.writeTxn(() async {
      final todo = await _isar.todoItemModels.get(todoId);
      if (todo == null) return;
      todo
        ..isCompleted = true
        ..completedAt = DateTime.now();
      await _isar.todoItemModels.put(todo);
    });
  }

  @override
  Future<void> uncompleteTodo(int todoId) async {
    await _isar.writeTxn(() async {
      final todo = await _isar.todoItemModels.get(todoId);
      if (todo == null) return;
      todo
        ..isCompleted = false
        ..completedAt = null;
      await _isar.todoItemModels.put(todo);
    });
  }

  @override
  Future<void> deleteTodo(int todoId) async {
    await _isar.writeTxn(() => _isar.todoItemModels.delete(todoId));
  }

  @override
  Future<void> deleteTodosByGoalId(int goalId) async {
    await _isar.writeTxn(
      () => _isar.todoItemModels.where().goalIdEqualTo(goalId).deleteAll(),
    );
  }

  @override
  Stream<List<TodoItemModel>> watchTodosByDate(DateTime date) {
    return _isar.todoItemModels
        .filter()
        .scheduledDateBetween(_startOfDay(date), _endOfDay(date))
        .sortByScheduledDate()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<TodoItemModel>> watchTodos() {
    return _isar.todoItemModels.where().sortByScheduledDateDesc().watch(
      fireImmediately: true,
    );
  }
}

class PomodoroRepositoryImpl implements PomodoroRepository {
  PomodoroRepositoryImpl(this._isar);

  final Isar _isar;

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  @override
  Future<PomodoroPlanModel?> getPlanByDate(DateTime date) {
    return _isar.pomodoroPlanModels
        .filter()
        .dateBetween(_startOfDay(date), _endOfDay(date))
        .findFirst();
  }

  @override
  Future<PomodoroPlanModel> getOrCreatePlan({
    required DateTime date,
    required int defaultFocusMinutes,
    required int defaultBreakMinutes,
    required int longBreakMinutes,
    required int longBreakInterval,
    required bool autoStartBreak,
    required bool autoStartNextFocus,
  }) async {
    final existing = await getPlanByDate(date);
    if (existing != null) return existing;
    final now = DateTime.now();
    final plan = PomodoroPlanModel()
      ..date = _startOfDay(date)
      ..title = '今日番茄计划'
      ..defaultFocusMinutes = defaultFocusMinutes
      ..defaultBreakMinutes = defaultBreakMinutes
      ..longBreakMinutes = longBreakMinutes
      ..longBreakInterval = longBreakInterval
      ..autoStartBreak = autoStartBreak
      ..autoStartNextFocus = autoStartNextFocus
      ..createdAt = now
      ..updatedAt = now;
    await _isar.writeTxn(() => _isar.pomodoroPlanModels.put(plan));
    return plan;
  }

  @override
  Future<List<PomodoroTaskModel>> getTasksByPlanId(int planId) {
    return _isar.pomodoroTaskModels
        .where()
        .planIdEqualTo(planId)
        .sortByOrderIndex()
        .findAll();
  }

  @override
  Stream<List<PomodoroTaskModel>> watchTasksByPlanId(int planId) {
    return _isar.pomodoroTaskModels
        .where()
        .planIdEqualTo(planId)
        .sortByOrderIndex()
        .watch(fireImmediately: true);
  }

  @override
  Future<PomodoroTaskModel?> getTaskByTodo({
    required int planId,
    required int todoId,
  }) {
    return _isar.pomodoroTaskModels
        .where()
        .planIdEqualTo(planId)
        .filter()
        .todoIdEqualTo(todoId)
        .findFirst();
  }

  @override
  Future<PomodoroTaskModel?> getTaskById(int taskId) =>
      _isar.pomodoroTaskModels.get(taskId);

  @override
  Future<PomodoroTaskModel> saveTask(PomodoroTaskModel task) async {
    task.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.pomodoroTaskModels.put(task));
    return task;
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await _isar.writeTxn(() => _isar.pomodoroTaskModels.delete(taskId));
  }

  @override
  Future<void> reorderTasks(List<PomodoroTaskModel> tasks) async {
    await _isar.writeTxn(() async {
      for (var index = 0; index < tasks.length; index++) {
        tasks[index]
          ..orderIndex = index
          ..orderEditedByUser = true
          ..updatedAt = DateTime.now();
      }
      await _isar.pomodoroTaskModels.putAll(tasks);
    });
  }

  @override
  Future<List<PomodoroSessionModel>> getSessionsByPlanId(int planId) {
    return _isar.pomodoroSessionModels
        .where()
        .planIdEqualTo(planId)
        .sortByCreatedAt()
        .findAll();
  }

  @override
  Future<List<PomodoroSessionModel>> getSessionsByTaskId(int taskId) {
    return _isar.pomodoroSessionModels
        .where()
        .taskIdEqualTo(taskId)
        .sortBySessionIndex()
        .findAll();
  }

  @override
  Stream<List<PomodoroSessionModel>> watchSessionsByPlanId(int planId) {
    return _isar.pomodoroSessionModels
        .where()
        .planIdEqualTo(planId)
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  QueryBuilder<
    PomodoroSessionModel,
    PomodoroSessionModel,
    QAfterFilterCondition
  >
  _activeSessionsQuery() {
    return _isar.pomodoroSessionModels.filter().group(
      (query) => query
          .statusEqualTo(PomodoroSessionStatus.focusing)
          .or()
          .statusEqualTo(PomodoroSessionStatus.focusPaused)
          .or()
          .statusEqualTo(PomodoroSessionStatus.resting)
          .or()
          .statusEqualTo(PomodoroSessionStatus.restPaused),
    );
  }

  @override
  Future<PomodoroSessionModel?> getRunningSession() =>
      _activeSessionsQuery().findFirst();

  @override
  Future<PomodoroSessionModel> saveSession(PomodoroSessionModel session) async {
    session.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.pomodoroSessionModels.put(session));
    return session;
  }

  @override
  Future<void> abandonOtherRunningSessions({int? exceptSessionId}) async {
    final running = await _activeSessionsQuery().findAll();
    await _isar.writeTxn(() async {
      for (final session in running) {
        if (session.id == exceptSessionId) continue;
        session
          ..status = PomodoroSessionStatus.abandoned
          ..targetEndAt = null
          ..updatedAt = DateTime.now();
      }
      await _isar.pomodoroSessionModels.putAll(running);
    });
  }

  @override
  Future<SavedPomodoroListModel> savePomodoroList(
    SavedPomodoroListModel list,
  ) async {
    list.updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.savedPomodoroListModels.put(list));
    return list;
  }

  @override
  Stream<List<SavedPomodoroListModel>> watchSavedPomodoroLists() {
    return _isar.savedPomodoroListModels.where().sortByUpdatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  @override
  Future<List<SavedPomodoroListModel>> getSavedPomodoroLists() {
    return _isar.savedPomodoroListModels
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
  }

  @override
  Future<void> deleteSavedPomodoroList(int listId) async {
    await _isar.writeTxn(() => _isar.savedPomodoroListModels.delete(listId));
  }

  @override
  Future<void> deleteTasksByIds(List<int> taskIds) async {
    if (taskIds.isEmpty) return;
    await _isar.writeTxn(() => _isar.pomodoroTaskModels.deleteAll(taskIds));
  }

  @override
  Future<void> replaceTasksAtomically({
    required List<int> deleteTaskIds,
    required List<PomodoroTaskModel> newTasks,
  }) async {
    final now = DateTime.now();
    for (final task in newTasks) {
      task.updatedAt = now;
    }
    await _isar.writeTxn(() async {
      if (deleteTaskIds.isNotEmpty) {
        await _isar.pomodoroTaskModels.deleteAll(deleteTaskIds);
      }
      if (newTasks.isNotEmpty) {
        await _isar.pomodoroTaskModels.putAll(newTasks);
      }
    });
  }
}
