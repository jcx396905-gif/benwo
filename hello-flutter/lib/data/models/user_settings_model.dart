import 'package:isar/isar.dart';

part 'user_settings_model.g.dart';

/// User settings model for app configuration
@collection
class UserSettingsModel {
  Id id = Isar.autoIncrement;

  /// Associated user ID
  @Index(unique: true)
  late int userId;

  /// Whether push notifications are enabled
  bool pushEnabled = true;

  /// Morning push time (HH:mm format)
  String? morningPushTime;

  /// Afternoon push time (HH:mm format)
  String? afternoonPushTime;

  /// Evening push time (HH:mm format)
  String? eveningPushTime;

  /// Push frequency (daily/custom)
  @enumerated
  PushFrequency pushFrequency = PushFrequency.daily;

  /// Quiet hours start time (HH:mm format)
  String? quietHoursStart;

  /// Quiet hours end time (HH:mm format)
  String? quietHoursEnd;

  /// App theme preference (light/dark/system)
  String? themePreference;

  /// Creation timestamp
  late DateTime createdAt;

  /// Last update timestamp
  DateTime? updatedAt;
}

/// Push frequency enumeration
enum PushFrequency {
  daily,    // 每日固定时间
  custom,   // 自定义时间
}
