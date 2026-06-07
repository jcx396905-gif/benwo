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

  late DateTime createdAt;

  DateTime? updatedAt;
}

enum PushFrequency { daily, custom }
