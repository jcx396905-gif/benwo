import '../models/todo_item_model.dart';

/// Repository interface for TodoItem operations
abstract class TodoItemRepository {
  /// Create a new todo
  Future<TodoItemModel> createTodo({
    required int userId,
    required String content,
    int? goalId,
    bool isAIGenerated = false,
    DateTime? scheduledDate,
    int? estimatedMinutes,
    String? color,
    String? aiConfirmationQuestions,
  });

  /// Get todo by ID
  Future<TodoItemModel?> getTodoById(int id);

  /// Get todos by goal ID
  Future<List<TodoItemModel>> getTodosByGoalId(int goalId);

  /// Get todos by scheduled date
  Future<List<TodoItemModel>> getTodosByDate(int userId, DateTime date);

  /// Get todos for a date range
  Future<List<TodoItemModel>> getTodosByDateRange(
    int userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get all todos for a user
  Future<List<TodoItemModel>> getTodosByUserId(int userId);

  /// Get incomplete todos for a user
  Future<List<TodoItemModel>> getIncompleteTodos(int userId);

  /// Get completed todos for a user
  Future<List<TodoItemModel>> getCompletedTodos(int userId);

  /// Update todo
  Future<void> updateTodo(TodoItemModel todo);

  /// Mark todo as completed
  Future<void> completeTodo(int todoId);

  /// Mark todo as incomplete
  Future<void> uncompleteTodo(int todoId);

  /// Delete todo
  Future<void> deleteTodo(int todoId);

  /// Delete all todos for a goal
  Future<void> deleteTodosByGoalId(int goalId);

  /// Watch todos by date
  Stream<List<TodoItemModel>> watchTodosByDate(int userId, DateTime date);

  /// Watch all todos for a user
  Stream<List<TodoItemModel>> watchTodosByUserId(int userId);
}
