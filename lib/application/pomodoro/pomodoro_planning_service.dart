import 'dart:convert';

import '../../core/utils/todo_reminder_scheduler.dart';
import '../../data/models/pomodoro_plan_model.dart';
import '../../data/models/pomodoro_task_model.dart';
import '../../data/models/todo_item_model.dart';
import '../../data/models/user_settings_model.dart';
import '../../data/repositories/pomodoro_repository.dart';
import '../../data/repositories/todo_item_repository.dart';
import '../../data/repositories/user_settings_repository.dart';
import 'pomodoro_ai_service.dart';
import 'pomodoro_split_service.dart';

class PomodoroPlanningService {
  PomodoroPlanningService({
    required PomodoroRepository pomodoroRepository,
    required TodoItemRepository todoRepository,
    required UserSettingsRepository settingsRepository,
    PomodoroSplitService splitService = const PomodoroSplitService(),
  }) : _pomodoroRepository = pomodoroRepository,
       _todoRepository = todoRepository,
       _settingsRepository = settingsRepository,
       _splitService = splitService;

  final PomodoroRepository _pomodoroRepository;
  final TodoItemRepository _todoRepository;
  final UserSettingsRepository _settingsRepository;
  final PomodoroSplitService _splitService;

  DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  Future<PomodoroPlanModel> ensurePlanAndImportTodos({
    required int userId,
    required DateTime date,
  }) async {
    final settings = await _getOrCreateSettings(userId);
    final plan = await _pomodoroRepository.getOrCreatePlan(
      userId: userId,
      date: dateOnly(date),
      defaultFocusMinutes: settings.pomodoroFocusMinutes,
      defaultBreakMinutes: settings.pomodoroShortBreakMinutes,
      longBreakMinutes: settings.pomodoroLongBreakMinutes,
      longBreakInterval: settings.pomodoroLongBreakInterval,
      autoStartBreak: settings.pomodoroAutoStartBreak,
      autoStartNextFocus: settings.pomodoroAutoStartNextFocus,
    );
    await importTodosForPlan(plan: plan, settings: settings);
    return plan;
  }

  Future<int> importTodosForPlan({
    required PomodoroPlanModel plan,
    UserSettingsModel? settings,
  }) async {
    final effectiveSettings =
        settings ?? await _getOrCreateSettings(plan.userId);
    final todos = await _todoRepository.getTodosByDate(plan.userId, plan.date);
    final activeTodos = todos.where((todo) => !todo.isCompleted).toList();
    final existingTasks = await _pomodoroRepository.getTasksByPlanId(plan.id);
    var nextOrder = existingTasks.length;
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
          final split = _splitService.split(
            estimatedMinutes: todo.estimatedMinutes,
            focusMinutes: effectiveSettings.pomodoroFocusMinutes,
            shortBreakMinutes: effectiveSettings.pomodoroShortBreakMinutes,
            longBreakMinutes: effectiveSettings.pomodoroLongBreakMinutes,
            longBreakInterval: effectiveSettings.pomodoroLongBreakInterval,
          );
          existing.plannedFocusSegments = split.focusSegments.length;
          changed = true;
        }
        if (changed) await _pomodoroRepository.saveTask(existing);
        continue;
      }

      final split = _splitService.split(
        estimatedMinutes: todo.estimatedMinutes,
        focusMinutes: effectiveSettings.pomodoroFocusMinutes,
        shortBreakMinutes: effectiveSettings.pomodoroShortBreakMinutes,
        longBreakMinutes: effectiveSettings.pomodoroLongBreakMinutes,
        longBreakInterval: effectiveSettings.pomodoroLongBreakInterval,
      );
      final now = DateTime.now();
      final task = PomodoroTaskModel()
        ..planId = plan.id
        ..userId = plan.userId
        ..todoId = todo.id
        ..title = todo.content
        ..orderIndex = nextOrder++
        ..estimatedMinutes = todo.estimatedMinutes
        ..scheduledTime = _scheduledTimeOrNull(todo)
        ..isTimeLocked = TodoReminderScheduler.hasPreciseTime(
          todo.scheduledDate,
        )
        ..sourceType = PomodoroTaskSourceType.todo
        ..focusMinutes = effectiveSettings.pomodoroFocusMinutes
        ..breakMinutes = effectiveSettings.pomodoroShortBreakMinutes
        ..longBreakMinutes = effectiveSettings.pomodoroLongBreakMinutes
        ..longBreakInterval = effectiveSettings.pomodoroLongBreakInterval
        ..plannedFocusSegments = split.focusSegments.length
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
    final settings = await _getOrCreateSettings(plan.userId);
    final existingTasks = await _pomodoroRepository.getTasksByPlanId(plan.id);
    final split = _splitService.split(
      estimatedMinutes: estimatedMinutes,
      focusMinutes: settings.pomodoroFocusMinutes,
      shortBreakMinutes: settings.pomodoroShortBreakMinutes,
      longBreakMinutes: settings.pomodoroLongBreakMinutes,
      longBreakInterval: settings.pomodoroLongBreakInterval,
    );
    final now = DateTime.now();
    final task = PomodoroTaskModel()
      ..planId = plan.id
      ..userId = plan.userId
      ..title = title
      ..orderIndex = existingTasks.length
      ..estimatedMinutes = estimatedMinutes
      ..scheduledTime = scheduledTime
      ..isTimeLocked = scheduledTime != null
      ..sourceType = sourceType
      ..focusMinutes = settings.pomodoroFocusMinutes
      ..breakMinutes = settings.pomodoroShortBreakMinutes
      ..longBreakMinutes = settings.pomodoroLongBreakMinutes
      ..longBreakInterval = settings.pomodoroLongBreakInterval
      ..plannedFocusSegments = split.focusSegments.length
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

    final settings = await _getOrCreateSettings(plan.userId);
    final tasks = await _pomodoroRepository.getTasksByPlanId(plan.id);
    final split = _splitService.split(
      estimatedMinutes: todo.estimatedMinutes,
      focusMinutes: settings.pomodoroFocusMinutes,
      shortBreakMinutes: settings.pomodoroShortBreakMinutes,
      longBreakMinutes: settings.pomodoroLongBreakMinutes,
      longBreakInterval: settings.pomodoroLongBreakInterval,
    );
    final now = DateTime.now();
    final task = PomodoroTaskModel()
      ..planId = plan.id
      ..userId = plan.userId
      ..todoId = todo.id
      ..title = todo.content
      ..orderIndex = tasks.length
      ..estimatedMinutes = todo.estimatedMinutes
      ..scheduledTime = _scheduledTimeOrNull(todo)
      ..isTimeLocked = TodoReminderScheduler.hasPreciseTime(todo.scheduledDate)
      ..sourceType = PomodoroTaskSourceType.todo
      ..focusMinutes = settings.pomodoroFocusMinutes
      ..breakMinutes = settings.pomodoroShortBreakMinutes
      ..longBreakMinutes = settings.pomodoroLongBreakMinutes
      ..longBreakInterval = settings.pomodoroLongBreakInterval
      ..plannedFocusSegments = split.focusSegments.length
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

  Future<UserSettingsModel> _getOrCreateSettings(int userId) async {
    final existing = await _settingsRepository.getSettingsByUserId(userId);
    return existing ?? _settingsRepository.createSettings(userId: userId);
  }

  String? _scheduledTimeOrNull(TodoItemModel todo) {
    if (!TodoReminderScheduler.hasPreciseTime(todo.scheduledDate)) return null;
    final hour = todo.scheduledDate.hour.toString().padLeft(2, '0');
    final minute = todo.scheduledDate.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
