import '../models/big_goal_model.dart';

/// Repository interface for BigGoal operations
abstract class BigGoalRepository {
  /// Create a new goal
  Future<BigGoalModel> createGoal({
    required int userId,
    required String title,
    String? description,
    DateTime? targetDate,
    String? color,
    String? category,
    String? aiSummary,
  });

  /// Get goal by ID
  Future<BigGoalModel?> getGoalById(int id);

  /// Get all goals for a user
  Future<List<BigGoalModel>> getGoalsByUserId(int userId);

  /// Get goals by status
  Future<List<BigGoalModel>> getGoalsByStatus(int userId, GoalStatus status);

  /// Update goal
  Future<void> updateGoal(BigGoalModel goal);

  /// Mark goal as completed
  Future<void> completeGoal(int goalId);

  /// Mark goal as abandoned
  Future<void> abandonGoal(int goalId);

  /// Delete goal
  Future<void> deleteGoal(int goalId);

  /// Watch all goals for a user
  Stream<List<BigGoalModel>> watchGoalsByUserId(int userId);

  /// Watch goal by ID
  Stream<BigGoalModel?> watchGoalById(int goalId);
}
