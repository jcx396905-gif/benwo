import 'package:isar/isar.dart';

part 'pomodoro_task_model.g.dart';

@collection
class PomodoroTaskModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int planId;

  @Index()
  late int userId;

  @Index()
  int? todoId;

  late String title;

  @Index()
  int orderIndex = 0;

  int? estimatedMinutes;

  /// Optional HH:mm precise start time copied from the source todo or user edit.
  String? scheduledTime;

  bool isTimeLocked = false;

  @Index()
  bool isCompleted = false;

  @enumerated
  PomodoroTaskSourceType sourceType = PomodoroTaskSourceType.manual;

  bool titleEditedByUser = false;

  bool durationEditedByUser = false;

  bool orderEditedByUser = false;

  int focusMinutes = 25;

  int breakMinutes = 5;

  int longBreakMinutes = 20;

  int longBreakInterval = 4;

  int plannedFocusSegments = 1;

  String? aiStepsJson;

  late DateTime createdAt;

  DateTime? updatedAt;

  DateTime? completedAt;
}

enum PomodoroTaskSourceType { todo, manual, ai, template }
