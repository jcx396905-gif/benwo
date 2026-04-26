import 'package:isar/isar.dart';

part 'big_goal_model.g.dart';

/// Big goal model for main objectives
@collection
class BigGoalModel {
  Id id = Isar.autoIncrement;

  /// Associated user ID
  @Index()
  late int userId;

  /// Goal title
  late String title;

  /// Goal description
  String? description;

  /// Target completion date
  late DateTime targetDate;

  /// Goal status (进行中/已完成/已放弃)
  @enumerated
  GoalStatus status = GoalStatus.inProgress;

  /// Goal color (for visual identification, hex string like #7FA99B)
  String? color;

  /// Goal category (学业/职业/健康/关系/个人成长/财务/其他)
  String? category;

  /// AI-generated summary of the goal
  String? aiSummary;

  /// Creation timestamp
  late DateTime createdAt;

  /// Last update timestamp
  DateTime? updatedAt;

  /// Completion timestamp (when status changed to 已完成)
  DateTime? completedAt;
}

/// Goal status enumeration
enum GoalStatus {
  inProgress,  // 进行中
  completed,   // 已完成
  abandoned,   // 已放弃
}
