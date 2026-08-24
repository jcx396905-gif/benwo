import 'package:benwo/application/pomodoro/pomodoro_planning_service.dart';
import 'package:benwo/application/pomodoro/pomodoro_providers.dart';
import 'package:benwo/data/models/pomodoro_plan_model.dart';
import 'package:benwo/data/models/pomodoro_session_model.dart';
import 'package:benwo/data/models/pomodoro_task_model.dart';
import 'package:benwo/data/models/saved_pomodoro_list_model.dart';
import 'package:benwo/data/repositories/pomodoro_repository.dart';
import 'package:benwo/data/repositories/todo_item_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not lock a task that has no valid start time', () async {
    final repository = _FakePomodoroRepository();
    final actions = PomodoroActions(
      pomodoroRepository: repository,
      todoRepository: _FakeTodoRepository(),
      planningService: _FakePomodoroPlanningService(),
    );
    final task = PomodoroTaskModel()
      ..planId = 1
      ..title = 'Task'
      ..createdAt = DateTime(2026, 7, 20);

    await actions.toggleTimeLock(task);

    expect(task.isTimeLocked, isFalse);
    expect(repository.savedTasks, isEmpty);
  });

  test('final focus completes its task and linked todo', () async {
    final task = _task(id: 8, plannedFocusSegments: 1)..todoId = 12;
    final session = _session(
      id: 21,
      taskId: task.id,
      status: PomodoroSessionStatus.focusing,
      breakMinutes: 0,
    );
    final repository = _FakePomodoroRepository(
      tasks: [task],
      sessions: [session],
    );
    final todoRepository = _FakeTodoRepository();
    final actions = _actions(repository, todoRepository);

    await actions.completeFocus(session);

    expect(session.status, PomodoroSessionStatus.completed);
    expect(task.isCompleted, isTrue);
    expect(todoRepository.completedTodoIds, [12]);
  });

  test('paused time is not added to actual focus seconds', () async {
    final task = _task(id: 8, plannedFocusSegments: 2);
    final session =
        _session(
            id: 21,
            taskId: task.id,
            status: PomodoroSessionStatus.focusPaused,
            breakMinutes: 0,
          )
          ..startedAt = DateTime.now().subtract(const Duration(hours: 1))
          ..actualFocusSeconds = 10;
    final repository = _FakePomodoroRepository(
      tasks: [task],
      sessions: [session],
    );

    await _actions(repository, _FakeTodoRepository()).completeFocus(session);

    expect(session.actualFocusSeconds, 10);
  });

  test('invalid saved list is validated before replacing today', () async {
    final existing = _task(id: 8);
    final repository = _FakePomodoroRepository(tasks: [existing]);
    final list = SavedPomodoroListModel()
      ..name = 'Broken'
      ..tasksJson = '{not-json}'
      ..createdAt = DateTime(2026, 7, 20);

    await expectLater(
      _actions(
        repository,
        _FakeTodoRepository(),
      ).addSavedListToPlan(plan: _plan(), list: list, replaceToday: true),
      throwsFormatException,
    );

    expect(repository.deletedTaskIds, isEmpty);
  });

  test(
    'valid saved list replaces today through one atomic operation',
    () async {
      final existing = _task(id: 8);
      final repository = _FakePomodoroRepository(tasks: [existing]);
      final list = SavedPomodoroListModel()
        ..name = 'Saved'
        ..tasksJson = '[{"title":"New task"}]'
        ..createdAt = DateTime(2026, 7, 20);

      final imported = await _actions(
        repository,
        _FakeTodoRepository(),
      ).addSavedListToPlan(plan: _plan(), list: list, replaceToday: true);

      expect(imported, 1);
      expect(repository.atomicReplaceCalls, 1);
      expect(repository.atomicDeletedTaskIds, [8]);
      expect(repository.atomicNewTasks.single.title, 'New task');
      expect(repository.deletedTaskIds, isEmpty);
      expect(repository.savedTasks, isEmpty);
    },
  );
}

class _FakePomodoroRepository extends Fake implements PomodoroRepository {
  _FakePomodoroRepository({
    List<PomodoroTaskModel>? tasks,
    List<PomodoroSessionModel>? sessions,
  }) : tasks = tasks ?? [],
       sessions = sessions ?? [];

  final List<PomodoroTaskModel> tasks;
  final List<PomodoroSessionModel> sessions;
  final List<PomodoroTaskModel> savedTasks = [];
  final List<int> deletedTaskIds = [];
  final List<int> atomicDeletedTaskIds = [];
  final List<PomodoroTaskModel> atomicNewTasks = [];
  int atomicReplaceCalls = 0;

  @override
  Future<List<PomodoroTaskModel>> getTasksByPlanId(int planId) async {
    return tasks.where((task) => task.planId == planId).toList();
  }

  @override
  Future<PomodoroTaskModel?> getTaskById(int taskId) async {
    return tasks.where((task) => task.id == taskId).firstOrNull;
  }

  @override
  Future<List<PomodoroSessionModel>> getSessionsByPlanId(int planId) async {
    return sessions.where((session) => session.planId == planId).toList();
  }

  @override
  Future<List<PomodoroSessionModel>> getSessionsByTaskId(int taskId) async {
    return sessions.where((session) => session.taskId == taskId).toList();
  }

  @override
  Future<PomodoroTaskModel> saveTask(PomodoroTaskModel task) async {
    savedTasks.add(task);
    return task;
  }

  @override
  Future<PomodoroSessionModel> saveSession(PomodoroSessionModel session) async {
    if (!sessions.contains(session)) sessions.add(session);
    return session;
  }

  @override
  Future<void> deleteTasksByIds(List<int> taskIds) async {
    deletedTaskIds.addAll(taskIds);
    tasks.removeWhere((task) => taskIds.contains(task.id));
  }

  @override
  Future<void> replaceTasksAtomically({
    required List<int> deleteTaskIds,
    required List<PomodoroTaskModel> newTasks,
  }) async {
    atomicReplaceCalls++;
    atomicDeletedTaskIds.addAll(deleteTaskIds);
    atomicNewTasks.addAll(newTasks);
  }
}

class _FakeTodoRepository extends Fake implements TodoItemRepository {
  final List<int> completedTodoIds = [];

  @override
  Future<void> completeTodo(int todoId) async {
    completedTodoIds.add(todoId);
  }
}

class _FakePomodoroPlanningService extends Fake
    implements PomodoroPlanningService {}

PomodoroActions _actions(
  PomodoroRepository pomodoroRepository,
  TodoItemRepository todoRepository,
) {
  return PomodoroActions(
    pomodoroRepository: pomodoroRepository,
    todoRepository: todoRepository,
    planningService: _FakePomodoroPlanningService(),
  );
}

PomodoroPlanModel _plan() {
  return PomodoroPlanModel()
    ..id = 1
    ..date = DateTime(2026, 7, 20)
    ..title = 'Today'
    ..createdAt = DateTime(2026, 7, 20);
}

PomodoroTaskModel _task({int id = 1, int plannedFocusSegments = 1}) {
  return PomodoroTaskModel()
    ..id = id
    ..planId = 1
    ..title = 'Task'
    ..plannedFocusSegments = plannedFocusSegments
    ..createdAt = DateTime(2026, 7, 20);
}

PomodoroSessionModel _session({
  required int id,
  required int taskId,
  required PomodoroSessionStatus status,
  required int breakMinutes,
}) {
  return PomodoroSessionModel()
    ..id = id
    ..planId = 1
    ..taskId = taskId
    ..status = status
    ..focusMinutes = 25
    ..breakMinutes = breakMinutes
    ..startedAt = DateTime.now().subtract(const Duration(seconds: 10))
    ..createdAt = DateTime(2026, 7, 20);
}
