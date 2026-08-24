import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection.dart';
import '../../core/utils/notification_service.dart';
import '../../data/models/pomodoro_plan_model.dart';
import '../../data/models/saved_pomodoro_list_model.dart';
import '../../data/models/pomodoro_session_model.dart';
import '../../data/models/pomodoro_task_model.dart';
import '../../data/repositories/pomodoro_repository.dart';
import '../../data/repositories/todo_item_repository.dart';
import 'pomodoro_ai_service.dart';
import 'pomodoro_planning_service.dart';
import 'pomodoro_schedule_service.dart';
import 'pomodoro_split_service.dart';

final pomodoroSplitServiceProvider = Provider<PomodoroSplitService>((ref) {
  return const PomodoroSplitService();
});

final pomodoroScheduleServiceProvider = Provider<PomodoroScheduleService>((
  ref,
) {
  return PomodoroScheduleService(
    splitService: ref.watch(pomodoroSplitServiceProvider),
  );
});

final pomodoroPlanningServiceProvider = Provider<PomodoroPlanningService>((
  ref,
) {
  return PomodoroPlanningService(
    pomodoroRepository: ref.watch(pomodoroRepositoryProvider),
    todoRepository: ref.watch(todoItemRepositoryProvider),
    splitService: ref.watch(pomodoroSplitServiceProvider),
  );
});

final pomodoroAiServiceProvider = Provider<PomodoroAiService>((ref) {
  return PomodoroAiService(ref.watch(deepseekApiClientProvider));
});

final todayPomodoroPlanProvider =
    FutureProvider.family<PomodoroPlanModel, DateTime>((ref, date) {
      return ref
          .watch(pomodoroPlanningServiceProvider)
          .ensurePlanAndImportTodos(date: date);
    });

final pomodoroTasksProvider =
    StreamProvider.family<List<PomodoroTaskModel>, int>((ref, planId) {
      return ref.watch(pomodoroRepositoryProvider).watchTasksByPlanId(planId);
    });

final pomodoroSessionsProvider =
    StreamProvider.family<List<PomodoroSessionModel>, int>((ref, planId) {
      return ref
          .watch(pomodoroRepositoryProvider)
          .watchSessionsByPlanId(planId);
    });

final savedPomodoroListsProvider = StreamProvider<List<SavedPomodoroListModel>>(
  (ref) {
    return ref.watch(pomodoroRepositoryProvider).watchSavedPomodoroLists();
  },
);

final pomodoroActionsProvider = Provider<PomodoroActions>((ref) {
  return PomodoroActions(
    pomodoroRepository: ref.watch(pomodoroRepositoryProvider),
    todoRepository: ref.watch(todoItemRepositoryProvider),
    planningService: ref.watch(pomodoroPlanningServiceProvider),
  );
});

class PomodoroActions {
  PomodoroActions({
    required PomodoroRepository pomodoroRepository,
    required TodoItemRepository todoRepository,
    required PomodoroPlanningService planningService,
  }) : _pomodoroRepository = pomodoroRepository,
       _todoRepository = todoRepository,
       _planningService = planningService;

  final PomodoroRepository _pomodoroRepository;
  final TodoItemRepository _todoRepository;
  final PomodoroPlanningService _planningService;

  Future<void> importTodos(PomodoroPlanModel plan) {
    return _planningService.importTodosForPlan(plan: plan);
  }

  Future<PomodoroTaskModel> addManualTask({
    required PomodoroPlanModel plan,
    required String title,
    int? estimatedMinutes,
    String? scheduledTime,
  }) {
    return _planningService.createManualTask(
      plan: plan,
      title: title,
      estimatedMinutes: estimatedMinutes,
      scheduledTime: scheduledTime,
    );
  }

  Future<void> saveAiDraft({
    required PomodoroPlanModel plan,
    required AiPomodoroPlanDraft draft,
  }) async {
    await _planningService.saveAiDraft(plan: plan, draft: draft);
  }

  Future<void> updateTaskDuration(PomodoroTaskModel task, int minutes) async {
    final split = const PomodoroSplitService().split(
      estimatedMinutes: minutes,
      focusMinutes: task.focusMinutes,
      shortBreakMinutes: task.breakMinutes,
      longBreakMinutes: task.longBreakMinutes,
      longBreakInterval: task.longBreakInterval,
    );
    task
      ..estimatedMinutes = minutes
      ..durationEditedByUser = true
      ..plannedFocusSegments = split.focusSegments.length;
    await _pomodoroRepository.saveTask(task);
  }

  Future<void> toggleTimeLock(PomodoroTaskModel task) async {
    if (!task.isTimeLocked && !_isValidClockTime(task.scheduledTime)) return;
    task.isTimeLocked = !task.isTimeLocked;
    await _pomodoroRepository.saveTask(task);
  }

  bool _isValidClockTime(String? value) {
    if (value == null) return false;
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(value.trim());
    if (match == null) return false;
    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    return hour != null &&
        minute != null &&
        hour >= 0 &&
        hour <= 23 &&
        minute >= 0 &&
        minute <= 59;
  }

  Future<void> moveTask({
    required List<PomodoroTaskModel> tasks,
    required int fromIndex,
    required int toIndex,
  }) async {
    final updated = List<PomodoroTaskModel>.from(tasks);
    final item = updated.removeAt(fromIndex);
    updated.insert(toIndex, item);
    await _pomodoroRepository.reorderTasks(updated);
  }

  Future<void> removeTask(PomodoroTaskModel task) async {
    final running = await _pomodoroRepository.getRunningSession();
    if (running != null && running.taskId == task.id) {
      throw StateError('请先结束当前番茄钟，再删除任务');
    }
    await _pomodoroRepository.deleteTask(task.id);
  }

  Future<SavedPomodoroListModel> saveCurrentList({
    required PomodoroPlanModel plan,
    required String name,
  }) async {
    final tasks = await _pomodoroRepository.getTasksByPlanId(plan.id);
    final activeTasks = tasks.where((task) => !task.isCompleted).toList();
    final now = DateTime.now();
    final totalMinutes = activeTasks.fold<int>(
      0,
      (sum, task) => sum + (task.estimatedMinutes ?? task.focusMinutes),
    );
    final list = SavedPomodoroListModel()
      ..name = name.trim().isEmpty ? plan.title : name.trim()
      ..tasksJson = jsonEncode(
        activeTasks
            .map((task) => _SavedPomodoroTask.fromTask(task).toJson())
            .toList(),
      )
      ..taskCount = activeTasks.length
      ..totalMinutes = totalMinutes
      ..createdAt = now
      ..updatedAt = now;
    return _pomodoroRepository.savePomodoroList(list);
  }

  Future<SavedPomodoroListModel> renameSavedList({
    required SavedPomodoroListModel list,
    required String name,
  }) {
    list.name = name.trim();
    return _pomodoroRepository.savePomodoroList(list);
  }

  Future<void> deleteSavedList(SavedPomodoroListModel list) {
    return _pomodoroRepository.deleteSavedPomodoroList(list.id);
  }

  Future<int> addSavedListToPlan({
    required PomodoroPlanModel plan,
    required SavedPomodoroListModel list,
    required bool replaceToday,
  }) async {
    final decoded = jsonDecode(list.tasksJson);
    if (decoded is! List) {
      throw const FormatException('保存的番茄清单格式无效');
    }
    final templates = <_SavedPomodoroTask>[];
    for (final item in decoded) {
      if (item is! Map) {
        throw const FormatException('保存的番茄任务格式无效');
      }
      templates.add(
        _SavedPomodoroTask.fromJson(Map<String, dynamic>.from(item)),
      );
    }

    final existing = await _pomodoroRepository.getTasksByPlanId(plan.id);
    final sessions = await _pomodoroRepository.getSessionsByPlanId(plan.id);
    final hasRunning = sessions.any(_isActiveSession);
    if (replaceToday && hasRunning) {
      throw StateError('当前有番茄正在进行，不能替换今日计划');
    }

    var removableIds = <int>[];
    if (replaceToday) {
      final completedTaskIds = sessions
          .where((item) => item.status == PomodoroSessionStatus.completed)
          .map((item) => item.taskId)
          .toSet();
      removableIds = existing
          .where(
            (task) => !task.isCompleted && !completedTaskIds.contains(task.id),
          )
          .map((task) => task.id)
          .toList();
    }

    final baseTasks = replaceToday
        ? existing.where((task) => !removableIds.contains(task.id)).toList()
        : existing;
    var nextOrder = baseTasks.isEmpty
        ? 0
        : baseTasks
                  .map((task) => task.orderIndex)
                  .reduce((a, b) => a > b ? a : b) +
              1;
    final newTasks = <PomodoroTaskModel>[];
    for (final template in templates) {
      final task = PomodoroTaskModel()
        ..planId = plan.id
        ..title = template.title
        ..orderIndex = nextOrder++
        ..estimatedMinutes = template.estimatedMinutes
        ..scheduledTime = template.scheduledTime
        ..isTimeLocked = template.isTimeLocked
        ..sourceType = PomodoroTaskSourceType.template
        ..focusMinutes = template.focusMinutes
        ..breakMinutes = template.breakMinutes
        ..longBreakMinutes = template.longBreakMinutes
        ..longBreakInterval = template.longBreakInterval
        ..plannedFocusSegments = template.plannedFocusSegments
        ..aiStepsJson = template.aiStepsJson
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
      newTasks.add(task);
    }
    if (replaceToday) {
      await _pomodoroRepository.replaceTasksAtomically(
        deleteTaskIds: removableIds,
        newTasks: newTasks,
      );
    } else {
      for (final task in newTasks) {
        await _pomodoroRepository.saveTask(task);
      }
    }
    return newTasks.length;
  }

  Future<PomodoroSessionModel> startTask(PomodoroTaskModel task) async {
    final previousSession = await _pomodoroRepository.getRunningSession();
    if (previousSession != null) {
      await _cancelSessionNotification(previousSession);
    }
    await _pomodoroRepository.abandonOtherRunningSessions();
    final sessions = await _pomodoroRepository.getSessionsByTaskId(task.id);
    final completedFocusCount = sessions
        .where((item) => item.status == PomodoroSessionStatus.completed)
        .length;

    final split = const PomodoroSplitService().split(
      estimatedMinutes: task.estimatedMinutes,
      focusMinutes: task.focusMinutes,
      shortBreakMinutes: task.breakMinutes,
      longBreakMinutes: task.longBreakMinutes,
      longBreakInterval: task.longBreakInterval,
      completedFocusCountBeforeTask: completedFocusCount,
    );
    final focusIndex = completedFocusCount.clamp(
      0,
      split.focusSegments.length - 1,
    );
    final focus = split.focusSegments[focusIndex];
    final breakMinutes = _breakMinutesAfterFocus(
      task: task,
      completedFocusCount: completedFocusCount + 1,
      hasMoreFocus: completedFocusCount < split.focusSegments.length - 1,
    );
    final now = DateTime.now();
    final session = PomodoroSessionModel()
      ..planId = task.planId
      ..taskId = task.id
      ..sessionIndex = completedFocusCount
      ..focusMinutes = focus.minutes
      ..breakMinutes = breakMinutes
      ..status = PomodoroSessionStatus.focusing
      ..startedAt = now
      ..activeSegmentStartedAt = now
      ..targetEndAt = now.add(Duration(minutes: focus.minutes))
      ..createdAt = now
      ..updatedAt = now;
    final saved = await _pomodoroRepository.saveSession(session);
    await _scheduleSessionEndNotification(
      saved,
      title: '专注时间结束',
      body: '“${task.title}”可以进入休息或完成确认了。',
    );
    return saved;
  }

  Future<void> pauseSession(PomodoroSessionModel session) async {
    await _cancelSessionNotification(session);
    final now = DateTime.now();
    final remaining = session.targetEndAt?.difference(now).inSeconds ?? 0;
    if (session.status == PomodoroSessionStatus.focusing) {
      session
        ..actualFocusSeconds += _activeSegmentSeconds(
          session.activeSegmentStartedAt ??
              (session.actualFocusSeconds == 0 ? session.startedAt : null),
          now,
        )
        ..status = PomodoroSessionStatus.focusPaused;
    } else if (session.status == PomodoroSessionStatus.resting) {
      session
        ..actualBreakSeconds += _activeSegmentSeconds(
          session.activeSegmentStartedAt ??
              (session.actualBreakSeconds == 0 ? session.breakStartedAt : null),
          now,
        )
        ..status = PomodoroSessionStatus.restPaused;
    }
    session
      ..activeSegmentStartedAt = null
      ..pausedRemainingSeconds = remaining < 0 ? 0 : remaining;
    await _pomodoroRepository.saveSession(session);
  }

  Future<void> resumeSession(PomodoroSessionModel session) async {
    final remaining = session.pausedRemainingSeconds;
    if (remaining == null) return;
    final now = DateTime.now();
    if (session.status == PomodoroSessionStatus.focusPaused) {
      session.status = PomodoroSessionStatus.focusing;
    } else if (session.status == PomodoroSessionStatus.restPaused) {
      session.status = PomodoroSessionStatus.resting;
    }
    session
      ..targetEndAt = now.add(Duration(seconds: remaining))
      ..activeSegmentStartedAt = now
      ..pausedRemainingSeconds = null;
    await _pomodoroRepository.saveSession(session);
    await _scheduleSessionEndNotification(
      session,
      title: session.status == PomodoroSessionStatus.resting
          ? '休息时间结束'
          : '专注时间结束',
      body: session.status == PomodoroSessionStatus.resting
          ? '可以回到下一轮专注了。'
          : '可以进入休息或完成确认了。',
    );
  }

  Future<void> completeFocus(PomodoroSessionModel session) async {
    await _cancelSessionNotification(session);
    final now = DateTime.now();
    session
      ..actualFocusSeconds += _activeSegmentSeconds(
        session.activeSegmentStartedAt ??
            (session.status == PomodoroSessionStatus.focusing &&
                    session.actualFocusSeconds == 0
                ? session.startedAt
                : null),
        now,
      )
      ..focusCompletedAt = now;

    if (session.breakMinutes > 0) {
      session
        ..status = PomodoroSessionStatus.resting
        ..breakStartedAt = now
        ..activeSegmentStartedAt = now
        ..targetEndAt = now.add(Duration(minutes: session.breakMinutes));
    } else {
      session
        ..status = PomodoroSessionStatus.completed
        ..completedAt = now
        ..activeSegmentStartedAt = null
        ..targetEndAt = null;
    }

    await _pomodoroRepository.saveSession(session);
    if (session.status == PomodoroSessionStatus.resting) {
      await _scheduleSessionEndNotification(
        session,
        title: '休息时间结束',
        body: '可以回到下一轮专注了。',
      );
    } else {
      await _completeTaskIfNeeded(session.taskId);
    }
  }

  Future<void> completeBreak(PomodoroSessionModel session) async {
    await _cancelSessionNotification(session);
    final now = DateTime.now();
    session
      ..actualBreakSeconds += _activeSegmentSeconds(
        session.activeSegmentStartedAt ??
            (session.status == PomodoroSessionStatus.resting &&
                    session.actualBreakSeconds == 0
                ? session.breakStartedAt
                : null),
        now,
      )
      ..breakEndAt = now
      ..completedAt = now
      ..status = PomodoroSessionStatus.completed
      ..activeSegmentStartedAt = null
      ..targetEndAt = null;
    await _pomodoroRepository.saveSession(session);
    await _completeTaskIfNeeded(session.taskId);
  }

  Future<void> abandonSession(PomodoroSessionModel session) async {
    await _cancelSessionNotification(session);
    session
      ..status = PomodoroSessionStatus.abandoned
      ..activeSegmentStartedAt = null
      ..targetEndAt = null;
    await _pomodoroRepository.saveSession(session);
  }

  Future<void> completeTask(PomodoroTaskModel task) async {
    task
      ..isCompleted = true
      ..completedAt = DateTime.now();
    await _pomodoroRepository.saveTask(task);
    if (task.todoId != null) {
      await _todoRepository.completeTodo(task.todoId!);
    }
  }

  int _breakMinutesAfterFocus({
    required PomodoroTaskModel task,
    required int completedFocusCount,
    required bool hasMoreFocus,
  }) {
    if (!hasMoreFocus) return 0;
    if (completedFocusCount % task.longBreakInterval == 0) {
      return task.longBreakMinutes;
    }
    return task.breakMinutes;
  }

  int _activeSegmentSeconds(DateTime? startedAt, DateTime completedAt) {
    if (startedAt == null) return 0;
    final elapsed = completedAt.difference(startedAt).inSeconds;
    return elapsed < 0 ? 0 : elapsed;
  }

  Future<void> _completeTaskIfNeeded(int taskId) async {
    final task = await _pomodoroRepository.getTaskById(taskId);
    if (task == null || task.isCompleted) return;
    final sessions = await _pomodoroRepository.getSessionsByTaskId(taskId);
    final completed = sessions
        .where((item) => item.status == PomodoroSessionStatus.completed)
        .length;
    if (completed < task.plannedFocusSegments) return;

    task
      ..isCompleted = true
      ..completedAt = DateTime.now();
    await _pomodoroRepository.saveTask(task);
    if (task.todoId != null) {
      await _todoRepository.completeTodo(task.todoId!);
    }
  }

  Future<void> _scheduleSessionEndNotification(
    PomodoroSessionModel session, {
    required String title,
    required String body,
  }) async {
    if (!await _pomodoroNotificationsEnabled()) return;
    final target = session.targetEndAt;
    if (target == null || !target.isAfter(DateTime.now())) return;
    try {
      final notificationService = NotificationService();
      await notificationService.initialize();
      final hasPermission = await notificationService.requestPermissions();
      if (!hasPermission) return;
      await notificationService.scheduleTodoReminderSafely(
        id: _sessionNotificationId(session.id),
        title: title,
        body: body,
        scheduledTime: target,
        payload: 'pomodoro:${session.id}',
      );
    } catch (_) {
      // Timer state must keep working even when notification setup fails.
    }
  }

  Future<void> _cancelSessionNotification(PomodoroSessionModel session) async {
    try {
      final notificationService = NotificationService();
      await notificationService.initialize();
      await notificationService.cancelNotification(
        _sessionNotificationId(session.id),
      );
    } catch (_) {
      // Notification cleanup must not block pomodoro state transitions.
    }
  }

  Future<bool> _pomodoroNotificationsEnabled() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getBool('push_enabled') ?? true) &&
        (preferences.getBool('pomodoro_notifications_enabled') ?? true);
  }

  int _sessionNotificationId(int sessionId) => 200000 + sessionId;

  bool _isActiveSession(PomodoroSessionModel session) {
    return session.status == PomodoroSessionStatus.focusing ||
        session.status == PomodoroSessionStatus.focusPaused ||
        session.status == PomodoroSessionStatus.resting ||
        session.status == PomodoroSessionStatus.restPaused;
  }
}

class _SavedPomodoroTask {
  const _SavedPomodoroTask({
    required this.title,
    required this.estimatedMinutes,
    required this.scheduledTime,
    required this.isTimeLocked,
    required this.focusMinutes,
    required this.breakMinutes,
    required this.longBreakMinutes,
    required this.longBreakInterval,
    required this.plannedFocusSegments,
    required this.aiStepsJson,
  });

  factory _SavedPomodoroTask.fromTask(PomodoroTaskModel task) {
    return _SavedPomodoroTask(
      title: task.title,
      estimatedMinutes: task.estimatedMinutes,
      scheduledTime: task.scheduledTime,
      isTimeLocked: task.isTimeLocked,
      focusMinutes: task.focusMinutes,
      breakMinutes: task.breakMinutes,
      longBreakMinutes: task.longBreakMinutes,
      longBreakInterval: task.longBreakInterval,
      plannedFocusSegments: task.plannedFocusSegments,
      aiStepsJson: task.aiStepsJson,
    );
  }

  factory _SavedPomodoroTask.fromJson(Map<String, dynamic> json) {
    final focusMinutes = _intValue(json['focusMinutes'], 25);
    return _SavedPomodoroTask(
      title: json['title']?.toString() ?? '未命名番茄',
      estimatedMinutes: json['estimatedMinutes'] is int
          ? json['estimatedMinutes'] as int
          : null,
      scheduledTime: json['scheduledTime']?.toString(),
      isTimeLocked: json['isTimeLocked'] == true,
      focusMinutes: focusMinutes,
      breakMinutes: _intValue(json['breakMinutes'], 5),
      longBreakMinutes: _intValue(json['longBreakMinutes'], 20),
      longBreakInterval: _intValue(json['longBreakInterval'], 4),
      plannedFocusSegments: _intValue(json['plannedFocusSegments'], 1),
      aiStepsJson: json['aiStepsJson']?.toString(),
    );
  }

  final String title;
  final int? estimatedMinutes;
  final String? scheduledTime;
  final bool isTimeLocked;
  final int focusMinutes;
  final int breakMinutes;
  final int longBreakMinutes;
  final int longBreakInterval;
  final int plannedFocusSegments;
  final String? aiStepsJson;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'estimatedMinutes': estimatedMinutes,
      'scheduledTime': scheduledTime,
      'isTimeLocked': isTimeLocked,
      'focusMinutes': focusMinutes,
      'breakMinutes': breakMinutes,
      'longBreakMinutes': longBreakMinutes,
      'longBreakInterval': longBreakInterval,
      'plannedFocusSegments': plannedFocusSegments,
      'aiStepsJson': aiStepsJson,
    };
  }

  static int _intValue(Object? value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
