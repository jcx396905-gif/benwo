import '../../data/models/pomodoro_task_model.dart';
import 'pomodoro_split_service.dart';

class PomodoroScheduledTask {
  const PomodoroScheduledTask({
    required this.task,
    required this.startAt,
    required this.endAt,
    required this.focusMinutes,
    required this.breakMinutes,
    required this.hasConflict,
    this.conflictReason,
  });

  final PomodoroTaskModel task;
  final DateTime startAt;
  final DateTime endAt;
  final int focusMinutes;
  final int breakMinutes;
  final bool hasConflict;
  final String? conflictReason;
}

class PomodoroScheduleResult {
  const PomodoroScheduleResult({required this.tasks, required this.conflicts});

  final List<PomodoroScheduledTask> tasks;
  final List<String> conflicts;

  bool get hasConflicts => conflicts.isNotEmpty;
}

class PomodoroScheduleService {
  const PomodoroScheduleService({
    PomodoroSplitService splitService = const PomodoroSplitService(),
  }) : _splitService = splitService;

  final PomodoroSplitService _splitService;

  PomodoroScheduleResult buildSchedule({
    required DateTime planDate,
    required List<PomodoroTaskModel> tasks,
    DateTime? earliestStart,
  }) {
    final sortedTasks = List<PomodoroTaskModel>.from(tasks)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final scheduled = <PomodoroScheduledTask>[];
    final conflicts = <String>[];
    var cursor = _normalizeCursor(planDate, earliestStart);

    for (final task in sortedTasks) {
      final split = _splitService.split(
        estimatedMinutes: task.estimatedMinutes,
        focusMinutes: task.focusMinutes,
        shortBreakMinutes: task.breakMinutes,
        longBreakMinutes: task.longBreakMinutes,
        longBreakInterval: task.longBreakInterval,
      );
      final focusMinutes = split.focusMinutes;
      final breakMinutes = split.segments
          .where((segment) => !segment.isFocus)
          .fold<int>(0, (sum, segment) => sum + segment.minutes);
      final totalMinutes = focusMinutes + breakMinutes;
      final fixedStart = _fixedStartOrNull(planDate, task.scheduledTime);
      final startAt = fixedStart ?? cursor;
      final endAt = startAt.add(Duration(minutes: totalMinutes));

      var hasConflict = false;
      String? reason;
      for (final existing in scheduled) {
        if (!_overlaps(startAt, endAt, existing.startAt, existing.endAt)) {
          continue;
        }
        hasConflict = true;
        reason = '与“${existing.task.title}”时间重叠';
        conflicts.add('“${task.title}”$reason');
        break;
      }

      if (task.isTimeLocked && fixedStart == null) {
        hasConflict = true;
        reason = '固定时间格式无效';
        conflicts.add('“${task.title}”固定时间格式无效');
      }

      scheduled.add(
        PomodoroScheduledTask(
          task: task,
          startAt: startAt,
          endAt: endAt,
          focusMinutes: focusMinutes,
          breakMinutes: breakMinutes,
          hasConflict: hasConflict,
          conflictReason: reason,
        ),
      );
      if (endAt.isAfter(cursor)) cursor = endAt;
    }

    return PomodoroScheduleResult(tasks: scheduled, conflicts: conflicts);
  }

  DateTime _normalizeCursor(DateTime planDate, DateTime? earliestStart) {
    final date = DateTime(planDate.year, planDate.month, planDate.day);
    if (earliestStart == null) return date;
    if (!_sameDay(date, earliestStart)) return date;
    return DateTime(
      date.year,
      date.month,
      date.day,
      earliestStart.hour,
      earliestStart.minute,
    );
  }

  DateTime? _fixedStartOrNull(DateTime planDate, String? scheduledTime) {
    if (scheduledTime == null || scheduledTime.trim().isEmpty) return null;
    final parts = scheduledTime.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return DateTime(planDate.year, planDate.month, planDate.day, hour, minute);
  }

  bool _overlaps(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) {
    return aStart.isBefore(bEnd) && bStart.isBefore(aEnd);
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
