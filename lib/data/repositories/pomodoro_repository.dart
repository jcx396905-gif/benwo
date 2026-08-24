import '../models/pomodoro_plan_model.dart';
import '../models/saved_pomodoro_list_model.dart';
import '../models/pomodoro_session_model.dart';
import '../models/pomodoro_task_model.dart';

abstract class PomodoroRepository {
  Future<PomodoroPlanModel?> getPlanByDate(DateTime date);

  Future<PomodoroPlanModel> getOrCreatePlan({
    required DateTime date,
    required int defaultFocusMinutes,
    required int defaultBreakMinutes,
    required int longBreakMinutes,
    required int longBreakInterval,
    required bool autoStartBreak,
    required bool autoStartNextFocus,
  });

  Future<List<PomodoroTaskModel>> getTasksByPlanId(int planId);

  Stream<List<PomodoroTaskModel>> watchTasksByPlanId(int planId);

  Future<PomodoroTaskModel?> getTaskByTodo({
    required int planId,
    required int todoId,
  });

  Future<PomodoroTaskModel?> getTaskById(int taskId);

  Future<PomodoroTaskModel> saveTask(PomodoroTaskModel task);

  Future<void> deleteTask(int taskId);

  Future<void> reorderTasks(List<PomodoroTaskModel> tasks);

  Future<List<PomodoroSessionModel>> getSessionsByPlanId(int planId);

  Future<List<PomodoroSessionModel>> getSessionsByTaskId(int taskId);

  Stream<List<PomodoroSessionModel>> watchSessionsByPlanId(int planId);

  Future<PomodoroSessionModel?> getRunningSession();

  Future<PomodoroSessionModel> saveSession(PomodoroSessionModel session);

  Future<void> abandonOtherRunningSessions({int? exceptSessionId});

  Future<SavedPomodoroListModel> savePomodoroList(SavedPomodoroListModel list);

  Stream<List<SavedPomodoroListModel>> watchSavedPomodoroLists();

  Future<List<SavedPomodoroListModel>> getSavedPomodoroLists();

  Future<void> deleteSavedPomodoroList(int listId);

  Future<void> deleteTasksByIds(List<int> taskIds);

  /// Replaces tasks as one database transaction so partial imports roll back.
  Future<void> replaceTasksAtomically({
    required List<int> deleteTaskIds,
    required List<PomodoroTaskModel> newTasks,
  });
}
