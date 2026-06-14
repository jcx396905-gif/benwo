import 'package:isar/isar.dart';

part 'user_profile_model.g.dart';

/// User profile model for onboarding and personalization
@collection
class UserProfileModel {
  Id id = Isar.autoIncrement;

  /// Associated user ID
  @Index()
  late int userId;

  /// User's name
  late String name;

  /// User's age
  int? age;

  /// Occupation (学生/在职/自由职业/退休/其他)
  String? occupation;

  /// Region/Location
  String? region;

  /// MBTI personality type (16 types)
  String? mbti;

  /// Communication style preference (鼓励型/直接型/分析型)
  String? communicationStyle;

  /// Motivation sensitivity level (高/中/低)
  String? motivationSensitivity;

  /// Best work time preference (早起型/夜猫型/弹性)
  String? bestWorkTime;

  /// Stress response style (喜欢被推动/需要缓冲空间)
  String? stressResponse;

  /// Social preference (独立完成/喜欢协作)
  String? socialPreference;

  /// Challenges user is facing (stored as comma-separated string)
  String? challenges;

  /// Life status (学生/在职/自由职业/退休)
  String? lifeStatus;

  /// Expected change timeframe (month count)
  int? changeTimeframeMonths;

  /// Three changes user wants most (stored as comma-separated string)
  String? threeChanges;

  /// Whether onboarding is completed
  bool hasCompletedOnboarding = false;

  /// Profile creation timestamp
  late DateTime createdAt;

  /// Last update timestamp
  DateTime? updatedAt;
}
