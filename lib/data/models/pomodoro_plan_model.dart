import 'package:isar/isar.dart';

part 'pomodoro_plan_model.g.dart';

/// A user's pomodoro plan for one calendar day.
@collection
class PomodoroPlanModel {
  Id id = Isar.autoIncrement;

  /// Day represented by this plan. Stored at local midnight.
  @Index()
  late DateTime date;

  late String title;

  int defaultFocusMinutes = 25;

  int defaultBreakMinutes = 5;

  int longBreakMinutes = 20;

  int longBreakInterval = 4;

  bool autoStartBreak = false;

  bool autoStartNextFocus = false;

  late DateTime createdAt;

  DateTime? updatedAt;
}
