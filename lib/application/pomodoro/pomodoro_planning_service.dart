import 'dart:convert';

import '../../core/utils/todo_reminder_scheduler.dart';
import '../../data/models/pomodoro_plan_model.dart';
import '../../data/models/pomodoro_task_model.dart';
import '../../data/models/todo_item_model.dart';
import '../../data/repositories/pomodoro_repository.dart';
import '../../data/repositories/todo_item_repository.dart';
import 'pomodoro_ai_service.dart';
import 'pomodoro_split_service.dart';

class PomodoroPlanningService {
  PomodoroPlanningService({
    required PomodoroRepository pomodoroRepository,
    required TodoItemRepository todoRepository,
    PomodoroSplitService splitService = const PomodoroSplitService(),
  }) : _pomodoroRepository = pomodoroRepository,
       _todoRepository = todoRepository,
       _splitService = splitService;

  final PomodoroRepository _pomodoroRepository;
  final TodoItemRepository _todoRepository;
  final PomodoroSplitService _splitService;

  DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  Future<PomodoroPlanModel> ensurePlanAndImportTodos({
    required DateTime date,
  }) async {
    final plan = await _pomodoroRepository.getOrCreatePlan(
      date: dateOnly(date),
      defaultFocusMinutes: 25,
      defaultBreakMinutes: 5,
      longBreakMinutes: 20,
      longBreakInterval: 4,
      autoStartBreak: false,
      autoStartNextFocus: false,
    );
    await importTodosForPlan(plan: plan);
    return plan;
  }

  Future<int> importTodosForPlan({required PomodoroPlanModel plan}) async {
    final todos = await _todoRepository.getTodosByDate(plan.date);
    final activeTodos = todos.where((todo) => !todo.isCompleted).toList();
    final existingTasks = await _pomodoroRepository.getTasksByPlanId(plan.id);
    var nextOrder = _nextOrder(existingTasks);
    var imported = 0;

    for (final todo in activeTodos) {
      final existing = await _pomodoroRepository.getTaskByTodo(
        planId: plan.id,
        todoId: todo.id,
      );
      if (existing != null) {
        var changed = false;
        if (!existing.titleEditedByUser && existing.title != todo.content) {
          existing.title = todo.content;
          changed = true;
        }
        if (!existing.durationEditedByUser &&
            existing.estimatedMinutes != todo.estimatedMinutes) {
          existing.estimatedMinutes = todo.estimatedMinutes;
          existing.plannedFocusSegments = _split(
            plan,
            todo.estimatedMinutes,
          ).focusSegments.length;
          changed = true;
        }
        if (changed) await _pomodoroRepository.saveTask(existing);
        continue;
      }

      final now = DateTime.now();
      final task = PomodoroTaskModel()
        ..planId = plan.id
        ..todoId = todo.id
        ..title = todo.content
        ..orderIndex = nextOrder++
        ..estimatedMinutes = todo.estimatedMinutes
        ..scheduledTime = _scheduledTimeOrNull(todo)
        ..isTimeLocked = TodoReminderScheduler.hasPreciseTime(
          todo.scheduledDate,
        )
        ..sourceType = PomodoroTaskSourceType.todo
        ..focusMinutes = plan.defaultFocusMinutes
        ..breakMinutes = plan.defaultBreakMinutes
        ..longBreakMinutes = plan.longBreakMinutes
        ..longBreakInterval = plan.longBreakInterval
        ..plannedFocusSegments = _split(
          plan,
          todo.estimatedMinutes,
        ).focusSegments.length
        ..createdAt = now
        ..updatedAt = now;
      await _pomodoroRepository.saveTask(task);
      imported++;
    }

    return imported;
  }

  Future<PomodoroTaskModel> createManualTask({
    required PomodoroPlanModel plan,
    required String title,
    int? estimatedMinutes,
    String? scheduledTime,
    PomodoroTaskSourceType sourceType = PomodoroTaskSourceType.manual,
    List<String> aiSteps = const [],
  }) async {
    final existingTasks = await _pomodoroRepository.getTasksByPlanId(plan.id);
    final now = DateTime.now();
    final task = PomodoroTaskModel()
      ..planId = plan.id
      ..title = title
      ..orderIndex = _nextOrder(existingTasks)
      ..estimatedMinutes = estimatedMinutes
      ..scheduledTime = scheduledTime
      ..isTimeLocked = scheduledTime != null
      ..sourceType = sourceType
      ..focusMinutes = plan.defaultFocusMinutes
      ..breakMinutes = plan.defaultBreakMinutes
      ..longBreakMinutes = plan.longBreakMinutes
      ..longBreakInterval = plan.longBreakInterval
      ..plannedFocusSegments = _split(
        plan,
        estimatedMinutes,
      ).focusSegments.length
      ..aiStepsJson = aiSteps.isEmpty ? null : jsonEncode(aiSteps)
      ..createdAt = now
      ..updatedAt = now;
    return _pomodoroRepository.saveTask(task);
  }

  Future<PomodoroTaskModel> addTodoToPlan({
    required PomodoroPlanModel plan,
    required TodoItemModel todo,
  }) async {
    final existing = await _pomodoroRepository.getTaskByTodo(
      planId: plan.id,
      todoId: todo.id,
    );
    if (existing != null) return existing;

    final tasks = await _pomodoroRepository.getTasksByPlanId(plan.id);
    final now = DateTime.now();
    final task = PomodoroTaskModel()
      ..planId = plan.id
      ..todoId = todo.id
      ..title = todo.content
      ..orderIndex = _nextOrder(tasks)
      ..estimatedMinutes = todo.estimatedMinutes
      ..scheduledTime = _scheduledTimeOrNull(todo)
      ..isTimeLocked = TodoReminderScheduler.hasPreciseTime(todo.scheduledDate)
      ..sourceType = PomodoroTaskSourceType.todo
      ..focusMinutes = plan.defaultFocusMinutes
      ..breakMinutes = plan.defaultBreakMinutes
      ..longBreakMinutes = plan.longBreakMinutes
      ..longBreakInterval = plan.longBreakInterval
      ..plannedFocusSegments = _split(
        plan,
        todo.estimatedMinutes,
      ).focusSegments.length
      ..createdAt = now
      ..updatedAt = now;
    return _pomodoroRepository.saveTask(task);
  }

  Future<List<PomodoroTaskModel>> saveAiDraft({
    required PomodoroPlanModel plan,
    required AiPomodoroPlanDraft draft,
  }) async {
    final saved = <PomodoroTaskModel>[];
    for (final task in draft.tasks) {
      saved.add(
        await createManualTask(
          plan: plan,
          title: task.title,
          estimatedMinutes: task.estimatedMinutes,
          scheduledTime: task.scheduledTime,
          sourceType: PomodoroTaskSourceType.ai,
          aiSteps: task.steps,
        ),
      );
    }
    return saved;
  }

  PomodoroSplitResult _split(PomodoroPlanModel plan, int? estimatedMinutes) {
    return _splitService.split(
      estimatedMinutes: estimatedMinutes,
      focusMinutes: plan.defaultFocusMinutes,
      shortBreakMinutes: plan.defaultBreakMinutes,
      longBreakMinutes: plan.longBreakMinutes,
      longBreakInterval: plan.longBreakInterval,
    );
  }

  String? _scheduledTimeOrNull(TodoItemModel todo) {
    if (!TodoReminderScheduler.hasPreciseTime(todo.scheduledDate)) return null;
    final hour = todo.scheduledDate.hour.toString().padLeft(2, '0');
    final minute = todo.scheduledDate.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int _nextOrder(List<PomodoroTaskModel> tasks) {
    if (tasks.isEmpty) return 0;
    return tasks
            .map((task) => task.orderIndex)
            .reduce((left, right) => left > right ? left : right) +
        1;
  }
}
