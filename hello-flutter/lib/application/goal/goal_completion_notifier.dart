import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/big_goal_model.dart';
import '../../data/repositories/big_goal_repository.dart';
import '../../data/repositories/todo_item_repository.dart';
import '../../core/di/injection.dart';

/// State for goal completion detection
class GoalCompletionState {
  /// Whether all todos for the goal are completed
  final bool allTodosCompleted;

  /// Whether the goal was just completed (triggers celebration)
  final bool justCompleted;

  /// The completed goal (if justCompleted is true)
  final BigGoalModel? completedGoal;

  /// Error message if any
  final String? errorMessage;

  const GoalCompletionState({
    this.allTodosCompleted = false,
    this.justCompleted = false,
    this.completedGoal,
    this.errorMessage,
  });

  GoalCompletionState copyWith({
    bool? allTodosCompleted,
    bool? justCompleted,
    BigGoalModel? completedGoal,
    String? errorMessage,
  }) {
    return GoalCompletionState(
      allTodosCompleted: allTodosCompleted ?? this.allTodosCompleted,
      justCompleted: justCompleted ?? this.justCompleted,
      completedGoal: completedGoal ?? this.completedGoal,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier for monitoring goal completion based on todo status
class GoalCompletionNotifier extends StateNotifier<GoalCompletionState> {
  final BigGoalRepository _goalRepo;
  final TodoItemRepository _todoRepo;

  GoalCompletionNotifier(this._goalRepo, this._todoRepo)
      : super(const GoalCompletionState());

  /// Check if all todos for a goal are completed and auto-complete the goal
  Future<bool> checkAndCompleteGoal(int goalId, int userId) async {
    try {
      // Get the goal
      final goal = await _goalRepo.getGoalById(goalId);
      if (goal == null) {
        state = state.copyWith(errorMessage: 'Goal not found');
        return false;
      }

      // Skip if already completed or abandoned
      if (goal.status != GoalStatus.inProgress) {
        state = state.copyWith(allTodosCompleted: false);
        return false;
      }

      // Get all todos for this goal
      final todos = await _todoRepo.getTodosByGoalId(goalId);

      // If no todos, can't auto-complete
      if (todos.isEmpty) {
        state = state.copyWith(allTodosCompleted: false);
        return false;
      }

      // Check if all todos are completed
      final allCompleted = todos.every((todo) => todo.isCompleted);

      if (allCompleted && !state.justCompleted) {
        // Mark goal as completed
        await _goalRepo.completeGoal(goalId);

        // Get updated goal
        final updatedGoal = await _goalRepo.getGoalById(goalId);

        state = state.copyWith(
          allTodosCompleted: true,
          justCompleted: true,
          completedGoal: updatedGoal,
        );
        return true;
      } else if (!allCompleted) {
        state = state.copyWith(
          allTodosCompleted: false,
          justCompleted: false,
        );
        return false;
      }

      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Reset the justCompleted flag (after showing celebration)
  void resetCelebration() {
    state = state.copyWith(justCompleted: false, completedGoal: null);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for GoalCompletionNotifier
final goalCompletionNotifierProvider =
    StateNotifierProvider<GoalCompletionNotifier, GoalCompletionState>((ref) {
  final goalRepo = ref.watch(bigGoalRepositoryProvider);
  final todoRepo = ref.watch(todoItemRepositoryProvider);
  return GoalCompletionNotifier(goalRepo, todoRepo);
});

/// Provider to check if all todos for a goal are completed
final allTodosCompletedProvider =
    FutureProvider.family<bool, ({int goalId, int userId})>(
  (ref, params) async {
    final todoRepo = ref.watch(todoItemRepositoryProvider);
    final todos = await todoRepo.getTodosByGoalId(params.goalId);
    if (todos.isEmpty) return false;
    return todos.every((todo) => todo.isCompleted);
  },
);
