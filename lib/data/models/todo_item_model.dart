import 'package:isar/isar.dart';

part 'todo_item_model.g.dart';

/// Todo item model for daily tasks
@collection
class TodoItemModel {
  Id id = Isar.autoIncrement;

  /// Associated goal ID (null if user-created without goal)
  @Index()
  int? goalId;

  /// Associated user ID
  @Index()
  late int userId;

  /// Todo content
  late String content;

  /// Whether this todo was AI-generated
  bool isAIGenerated = false;

  /// Scheduled date for the todo
  @Index()
  late DateTime scheduledDate;

  /// Whether the todo is completed
  @Index()
  bool isCompleted = false;

  /// Estimated completion time in minutes
  int? estimatedMinutes;

  /// Todo color (inherited from goal or custom)
  String? color;

  /// AI-generated confirmation questions (JSON string)
  String? aiConfirmationQuestions;

  /// Creation timestamp
  late DateTime createdAt;

  /// Completion timestamp
  DateTime? completedAt;
}
