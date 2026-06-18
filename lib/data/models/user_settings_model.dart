import 'package:isar/isar.dart';

part 'user_settings_model.g.dart';

@collection
class UserSettingsModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int userId;

  bool pushEnabled = true;

  String? morningPushTime;

  String? afternoonPushTime;

  String? eveningPushTime;

  @enumerated
  PushFrequency pushFrequency = PushFrequency.daily;

  String? quietHoursStart;

  String? quietHoursEnd;

  String? themePreference;

  int pomodoroFocusMinutes = 25;

  int pomodoroShortBreakMinutes = 5;

  int pomodoroLongBreakMinutes = 20;

  int pomodoroLongBreakInterval = 4;

  bool pomodoroAutoStartBreak = false;

  bool pomodoroAutoStartNextFocus = false;

  bool pomodoroSoundEnabled = true;

  bool pomodoroVibrationEnabled = true;

  bool pomodoroNotificationsEnabled = true;

  bool pomodoroKeepScreenOn = false;

  bool pomodoroAutoCompleteTodo = false;

  bool pomodoroAiEstimateEnabled = false;

  String? pomodoroAiScheduleStrategy;

  bool pomodoroWeeklyReviewEnabled = false;

  late DateTime createdAt;

  DateTime? updatedAt;
}

enum PushFrequency { daily, custom }
