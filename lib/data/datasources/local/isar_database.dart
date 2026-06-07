import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/user_model.dart';
import '../../models/user_profile_model.dart';
import '../../models/big_goal_model.dart';
import '../../models/todo_item_model.dart';
import '../../models/user_settings_model.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/user_profile_repository.dart';
import '../../repositories/big_goal_repository.dart';
import '../../repositories/todo_item_repository.dart';
import '../../repositories/user_settings_repository.dart';

/// Isar Database Schema and Repository Implementations
/// Contains all Isar collection schemas and CRUD implementations
///
/// Task 5: Local Database Configuration
class IsarDatabase {
  IsarDatabase._();

  /// Schema list for Isar.open()
  static List<CollectionSchema<dynamic>> get schemas => <CollectionSchema<dynamic>>[
        UserModelSchema,
        UserProfileModelSchema,
        BigGoalModelSchema,
        TodoItemModelSchema,
        UserSettingsModelSchema,
      ];

  /// Initialize Isar database
  static Future<Isar> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      schemas,
      directory: dir.path,
      name: 'benwo_db',
    );
  }
}

// ============================================================================
// User Repository Implementation
// ============================================================================

class UserRepositoryImpl implements UserRepository {
  final Isar _isar;

  UserRepositoryImpl(this._isar);

  @override
  Future<UserModel> createUser({
    required String email,
    required String passwordHash,
  }) async {
    final user = UserModel()
      ..email = email
      ..passwordHash = passwordHash
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userModels.put(user);
    });

    return user;
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    return _isar.userModels.where().emailEqualTo(email).findFirst();
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    return _isar.userModels.get(id);
  }

  @override
  Future<UserModel?> login({
    required String email,
    required String passwordHash,
  }) async {
    final user = await _isar.userModels.where().emailEqualTo(email).findFirst();
    if (user == null) {
      return null;
    }
    // Verify password hash matches
    if (user.passwordHash == passwordHash) {
      // Update last login time
      await updateLastLogin(user.id);
      return user;
    }
    return null;
  }

  @override
  Future<void> updateLastLogin(int userId) async {
    await _isar.writeTxn(() async {
      final user = await _isar.userModels.get(userId);
      if (user != null) {
        user.lastLoginAt = DateTime.now();
        await _isar.userModels.put(user);
      }
    });
  }

  @override
  Future<void> deleteUser(int userId) async {
    await _isar.writeTxn(() async {
      await _isar.userModels.delete(userId);
    });
  }

  @override
  Stream<UserModel?> watchUserById(int userId) {
    return _isar.userModels.watchObject(userId);
  }
}

// ============================================================================
// User Profile Repository Implementation
// ============================================================================

class UserProfileRepositoryImpl implements UserProfileRepository {
  final Isar _isar;

  UserProfileRepositoryImpl(this._isar);

  @override
  Future<UserProfileModel> saveProfile({
    required int userId,
    String? name,
    int? age,
    String? occupation,
    String? region,
    String? mbti,
    String? communicationStyle,
    String? motivationSensitivity,
    String? bestWorkTime,
    String? stressResponse,
    String? socialPreference,
    String? challenges,
    String? lifeStatus,
    int? changeTimeframeMonths,
    String? threeChanges,
    bool? hasCompletedOnboarding,
  }) async {
    UserProfileModel? profile =
        await _isar.userProfileModels.where().userIdEqualTo(userId).findFirst();

    if (profile == null) {
      profile = UserProfileModel()
        ..userId = userId
        ..name = name ?? ''
        ..createdAt = DateTime.now();
    }

    // Update provided fields
    if (name != null) profile.name = name;
    if (age != null) profile.age = age;
    if (occupation != null) profile.occupation = occupation;
    if (region != null) profile.region = region;
    if (mbti != null) profile.mbti = mbti;
    if (communicationStyle != null) profile.communicationStyle = communicationStyle;
    if (motivationSensitivity != null) profile.motivationSensitivity = motivationSensitivity;
    if (bestWorkTime != null) profile.bestWorkTime = bestWorkTime;
    if (stressResponse != null) profile.stressResponse = stressResponse;
    if (socialPreference != null) profile.socialPreference = socialPreference;
    if (challenges != null) profile.challenges = challenges;
    if (lifeStatus != null) profile.lifeStatus = lifeStatus;
    if (changeTimeframeMonths != null) profile.changeTimeframeMonths = changeTimeframeMonths;
    if (threeChanges != null) profile.threeChanges = threeChanges;
    if (hasCompletedOnboarding != null) profile.hasCompletedOnboarding = hasCompletedOnboarding;
    profile.updatedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userProfileModels.put(profile!);
    });

    return profile;
  }

  @override
  Future<UserProfileModel?> getProfileByUserId(int userId) async {
    return _isar.userProfileModels.where().userIdEqualTo(userId).findFirst();
  }

  @override
  Stream<UserProfileModel?> watchProfileByUserId(int userId) {
    return _isar.userProfileModels
        .where()
        .userIdEqualTo(userId)
        .watch(fireImmediately: true)
        .map((profiles) => profiles.isNotEmpty ? profiles.first : null);
  }

  @override
  Future<void> completeOnboarding(int userId) async {
    await _isar.writeTxn(() async {
      final profile =
          await _isar.userProfileModels.where().userIdEqualTo(userId).findFirst();
      if (profile != null) {
        profile.hasCompletedOnboarding = true;
        profile.updatedAt = DateTime.now();
        await _isar.userProfileModels.put(profile);
      }
    });
  }

  @override
  Future<void> deleteProfile(int userId) async {
    await _isar.writeTxn(() async {
      final profile =
          await _isar.userProfileModels.where().userIdEqualTo(userId).findFirst();
      if (profile != null) {
        await _isar.userProfileModels.delete(profile.id);
      }
    });
  }
}

// ============================================================================
// Big Goal Repository Implementation
// ============================================================================

class BigGoalRepositoryImpl implements BigGoalRepository {
  final Isar _isar;

  BigGoalRepositoryImpl(this._isar);

  @override
  Future<BigGoalModel> createGoal({
    required int userId,
    required String title,
    String? description,
    DateTime? targetDate,
    String? color,
    String? category,
    String? aiSummary,
  }) async {
    final goal = BigGoalModel()
      ..userId = userId
      ..title = title
      ..description = description
      ..targetDate = targetDate ?? DateTime.now().add(const Duration(days: 90))
      ..status = GoalStatus.inProgress
      ..color = color
      ..category = category
      ..aiSummary = aiSummary
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.bigGoalModels.put(goal);
    });

    return goal;
  }

  @override
  Future<BigGoalModel?> getGoalById(int id) async {
    return _isar.bigGoalModels.get(id);
  }

  @override
  Future<List<BigGoalModel>> getGoalsByUserId(int userId) async {
    return _isar.bigGoalModels
        .where()
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  @override
  Future<List<BigGoalModel>> getGoalsByStatus(int userId, GoalStatus status) async {
    return _isar.bigGoalModels
        .where()
        .userIdEqualTo(userId)
        .filter()
        .statusEqualTo(status)
        .sortByCreatedAtDesc()
        .findAll();
  }

  @override
  Future<void> updateGoal(BigGoalModel goal) async {
    goal.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.bigGoalModels.put(goal);
    });
  }

  @override
  Future<void> completeGoal(int goalId) async {
    await _isar.writeTxn(() async {
      final goal = await _isar.bigGoalModels.get(goalId);
      if (goal != null) {
        goal.status = GoalStatus.completed;
        goal.completedAt = DateTime.now();
        goal.updatedAt = DateTime.now();
        await _isar.bigGoalModels.put(goal);
      }
    });
  }

  @override
  Future<void> abandonGoal(int goalId) async {
    await _isar.writeTxn(() async {
      final goal = await _isar.bigGoalModels.get(goalId);
      if (goal != null) {
        goal.status = GoalStatus.abandoned;
        goal.updatedAt = DateTime.now();
        await _isar.bigGoalModels.put(goal);
      }
    });
  }

  @override
  Future<void> deleteGoal(int goalId) async {
    await _isar.writeTxn(() async {
      await _isar.bigGoalModels.delete(goalId);
    });
  }

  @override
  Stream<List<BigGoalModel>> watchGoalsByUserId(int userId) {
    return _isar.bigGoalModels
        .where()
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  @override
  Stream<BigGoalModel?> watchGoalById(int goalId) {
    return _isar.bigGoalModels.watchObject(goalId, fireImmediately: true);
  }
}

// ============================================================================
// Todo Item Repository Implementation
// ============================================================================

class TodoItemRepositoryImpl implements TodoItemRepository {
  final Isar _isar;

  TodoItemRepositoryImpl(this._isar);

  /// Helper to get start of day
  DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Helper to get end of day
  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  @override
  Future<TodoItemModel> createTodo({
    required int userId,
    required String content,
    int? goalId,
    bool isAIGenerated = false,
    DateTime? scheduledDate,
    int? estimatedMinutes,
    String? color,
    String? aiConfirmationQuestions,
  }) async {
    final todo = TodoItemModel()
      ..userId = userId
      ..goalId = goalId
      ..content = content
      ..isAIGenerated = isAIGenerated
      ..scheduledDate = scheduledDate ?? _startOfDay(DateTime.now())
      ..isCompleted = false
      ..estimatedMinutes = estimatedMinutes
      ..color = color
      ..aiConfirmationQuestions = aiConfirmationQuestions
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.todoItemModels.put(todo);
    });

    return todo;
  }

  @override
  Future<TodoItemModel?> getTodoById(int id) async {
    return _isar.todoItemModels.get(id);
  }

  @override
  Future<List<TodoItemModel>> getTodosByGoalId(int goalId) async {
    return _isar.todoItemModels
        .where()
        .goalIdEqualTo(goalId)
        .sortByScheduledDate()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getTodosByDate(int userId, DateTime date) async {
    final start = _startOfDay(date);
    final end = _endOfDay(date);

    return _isar.todoItemModels
        .where()
        .userIdEqualTo(userId)
        .filter()
        .scheduledDateBetween(start, end)
        .sortByScheduledDate()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getTodosByDateRange(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final start = _startOfDay(startDate);
    final end = _endOfDay(endDate);

    return _isar.todoItemModels
        .where()
        .userIdEqualTo(userId)
        .filter()
        .scheduledDateBetween(start, end)
        .sortByScheduledDate()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getTodosByUserId(int userId) async {
    return _isar.todoItemModels
        .where()
        .userIdEqualTo(userId)
        .sortByScheduledDateDesc()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getIncompleteTodos(int userId) async {
    return _isar.todoItemModels
        .where()
        .userIdEqualTo(userId)
        .filter()
        .isCompletedEqualTo(false)
        .sortByScheduledDate()
        .findAll();
  }

  @override
  Future<List<TodoItemModel>> getCompletedTodos(int userId) async {
    return _isar.todoItemModels
        .where()
        .userIdEqualTo(userId)
        .filter()
        .isCompletedEqualTo(true)
        .sortByScheduledDateDesc()
        .findAll();
  }

  @override
  Future<void> updateTodo(TodoItemModel todo) async {
    await _isar.writeTxn(() async {
      await _isar.todoItemModels.put(todo);
    });
  }

  @override
  Future<void> completeTodo(int todoId) async {
    await _isar.writeTxn(() async {
      final todo = await _isar.todoItemModels.get(todoId);
      if (todo != null) {
        todo.isCompleted = true;
        todo.completedAt = DateTime.now();
        await _isar.todoItemModels.put(todo);
      }
    });
  }

  @override
  Future<void> uncompleteTodo(int todoId) async {
    await _isar.writeTxn(() async {
      final todo = await _isar.todoItemModels.get(todoId);
      if (todo != null) {
        todo.isCompleted = false;
        todo.completedAt = null;
        await _isar.todoItemModels.put(todo);
      }
    });
  }

  @override
  Future<void> deleteTodo(int todoId) async {
    await _isar.writeTxn(() async {
      await _isar.todoItemModels.delete(todoId);
    });
  }

  @override
  Future<void> deleteTodosByGoalId(int goalId) async {
    await _isar.writeTxn(() async {
      await _isar.todoItemModels.where().goalIdEqualTo(goalId).deleteAll();
    });
  }

  @override
  Stream<List<TodoItemModel>> watchTodosByDate(int userId, DateTime date) {
    final start = _startOfDay(date);
    final end = _endOfDay(date);

    return _isar.todoItemModels
        .where()
        .userIdEqualTo(userId)
        .filter()
        .scheduledDateBetween(start, end)
        .sortByScheduledDate()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<TodoItemModel>> watchTodosByUserId(int userId) {
    return _isar.todoItemModels
        .where()
        .userIdEqualTo(userId)
        .sortByScheduledDateDesc()
        .watch(fireImmediately: true);
  }
}

// ============================================================================
// User Settings Repository Implementation
// ============================================================================

class UserSettingsRepositoryImpl implements UserSettingsRepository {
  final Isar _isar;

  UserSettingsRepositoryImpl(this._isar);

  @override
  Future<UserSettingsModel> createSettings({required int userId}) async {
    final settings = UserSettingsModel()
      ..userId = userId
      ..pushEnabled = true
      ..pushFrequency = PushFrequency.daily
      ..morningPushTime = '09:00'
      ..afternoonPushTime = '14:00'
      ..eveningPushTime = '19:00'
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.userSettingsModels.put(settings);
    });

    return settings;
  }

  @override
  Future<UserSettingsModel?> getSettingsByUserId(int userId) async {
    return _isar.userSettingsModels.where().userIdEqualTo(userId).findFirst();
  }

  @override
  Future<void> updateSettings(UserSettingsModel settings) async {
    settings.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.userSettingsModels.put(settings);
    });
  }

  @override
  Future<void> updatePushEnabled(int userId, bool enabled) async {
    await _isar.writeTxn(() async {
      final settings =
          await _isar.userSettingsModels.where().userIdEqualTo(userId).findFirst();
      if (settings != null) {
        settings.pushEnabled = enabled;
        settings.updatedAt = DateTime.now();
        await _isar.userSettingsModels.put(settings);
      }
    });
  }

  @override
  Future<void> updatePushFrequency(int userId, PushFrequency frequency) async {
    await _isar.writeTxn(() async {
      final settings =
          await _isar.userSettingsModels.where().userIdEqualTo(userId).findFirst();
      if (settings != null) {
        settings.pushFrequency = frequency;
        settings.updatedAt = DateTime.now();
        await _isar.userSettingsModels.put(settings);
      }
    });
  }

  @override
  Future<void> updateQuietHours(
    int userId, {
    String? startTime,
    String? endTime,
  }) async {
    await _isar.writeTxn(() async {
      final settings =
          await _isar.userSettingsModels.where().userIdEqualTo(userId).findFirst();
      if (settings != null) {
        if (startTime != null) settings.quietHoursStart = startTime;
        if (endTime != null) settings.quietHoursEnd = endTime;
        settings.updatedAt = DateTime.now();
        await _isar.userSettingsModels.put(settings);
      }
    });
  }

  @override
  Future<void> updateThemePreference(int userId, String themeMode) async {
    await _isar.writeTxn(() async {
      final settings =
          await _isar.userSettingsModels.where().userIdEqualTo(userId).findFirst();
      if (settings != null) {
        settings.themePreference = themeMode;
        settings.updatedAt = DateTime.now();
        await _isar.userSettingsModels.put(settings);
      }
    });
  }

  @override
  Future<void> deleteSettings(int userId) async {
    await _isar.writeTxn(() async {
      final settings =
          await _isar.userSettingsModels.where().userIdEqualTo(userId).findFirst();
      if (settings != null) {
        await _isar.userSettingsModels.delete(settings.id);
      }
    });
  }

  @override
  Stream<UserSettingsModel?> watchSettingsByUserId(int userId) {
    return _isar.userSettingsModels
        .where()
        .userIdEqualTo(userId)
        .watch(fireImmediately: true)
        .map((settings) => settings.isNotEmpty ? settings.first : null);
  }
}