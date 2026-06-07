import 'package:isar/isar.dart';

part 'big_goal_model.g.dart';

@collection
class BigGoalModel {
  Id id = Isar.autoIncrement;

  @Index()
  late int userId;

  late String title;

  String? description;

  late DateTime targetDate;

  @enumerated
  GoalStatus status = GoalStatus.inProgress;

  String? color;

  String? category;

  String? aiSummary;

  late DateTime createdAt;

  DateTime? updatedAt;

  DateTime? completedAt;
}

enum GoalStatus { inProgress, completed, abandoned }
