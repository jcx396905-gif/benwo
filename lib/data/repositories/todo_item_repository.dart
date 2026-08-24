import '../models/todo_item_model.dart';

/// Repository interface for TodoItem operations
abstract class TodoItemRepository {
  /// Create a new todo
  Future<TodoItemModel> createTodo({
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
  Future<List<TodoItemModel>> getTodosByDate(DateTime date);

  /// Get todos for a date range
  Future<List<TodoItemModel>> getTodosByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get all todos
  Future<List<TodoItemModel>> getTodos();

  /// Get incomplete todos
  Future<List<TodoItemModel>> getIncompleteTodos();

  /// Get completed todos
  Future<List<TodoItemModel>> getCompletedTodos();

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
  Stream<List<TodoItemModel>> watchTodosByDate(DateTime date);

  /// Watch all todos
  Stream<List<TodoItemModel>> watchTodos();
}
