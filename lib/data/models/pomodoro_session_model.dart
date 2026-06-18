import 'package:isar/isar.dart';

part 'pomodoro_session_model.g.dart';

@collection
class PomodoroSessionModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int planId;

  @Index()
  late int taskId;

  @Index()
  late int userId;

  int sessionIndex = 0;

  int focusMinutes = 25;

  int breakMinutes = 5;

  @enumerated
  @Index()
  PomodoroSessionStatus status = PomodoroSessionStatus.pending;

  DateTime? startedAt;

  DateTime? targetEndAt;

  DateTime? focusCompletedAt;

  DateTime? breakStartedAt;

  DateTime? breakEndAt;

  DateTime? completedAt;

  int? pausedRemainingSeconds;

  int actualFocusSeconds = 0;

  int actualBreakSeconds = 0;

  late DateTime createdAt;

  DateTime? updatedAt;
}

enum PomodoroSessionStatus {
  pending,
  focusing,
  focusPaused,
  resting,
  restPaused,
  completed,
  skipped,
  abandoned,
}
