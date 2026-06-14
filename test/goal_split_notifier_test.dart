import 'dart:async';

import 'package:benwo/application/goal/goal_split_notifier.dart';
import 'package:benwo/core/di/injection.dart';
import 'package:benwo/data/models/big_goal_model.dart';
import 'package:benwo/data/models/todo_item_model.dart';
import 'package:benwo/data/models/user_profile_model.dart';
import 'package:benwo/data/repositories/todo_item_repository.dart';
import 'package:benwo/data/repositories/user_profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('free text split uses AI result with precise times', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(
        response: '''
{
  "todos": [
    {"content": "visit my middle school teacher", "date": "2026-06-08", "time": "10:30", "estimatedMinutes": 60},
    {"content": "go home", "date": "2026-06-08", "time": "11:00", "estimatedMinutes": 20},
    {"content": "pick up cake at Intime", "date": "2026-06-08", "time": "12:00", "estimatedMinutes": 30}
  ]
}
''',
      ),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input:
          'I will visit my middle school teacher at 10:30, go home at 11:00, and pick up cake at 12:00.',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos, hasLength(3));
    expect(todos.map((todo) => todo.content), [
      'visit my middle school teacher',
      'go home',
      'pick up cake at Intime',
    ]);
    expect(todos[0].scheduledDate, DateTime(2026, 6, 8, 10, 30));
    expect(todos[1].scheduledDate, DateTime(2026, 6, 8, 11));
    expect(todos[2].scheduledDate, DateTime(2026, 6, 8, 12));
  });

  test('free text split preserves AI seconds in precise time', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(
        response: '''
{
  "todos": [
    {"content": "pick up package", "date": "2026-06-08", "time": "18:20:30", "estimatedMinutes": 20}
  ]
}
''',
      ),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input: 'Pick up package at 18:20:30.',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos, hasLength(1));
    expect(todos.single.content, 'pick up package');
    expect(todos.single.scheduledDate, DateTime(2026, 6, 8, 18, 20, 30));
  });

  test('free text split parses Chinese clock time returned by AI', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(
        response: '''
{
  "todos": [
    {"content": "睡觉", "date": "2026-06-08", "time": "10点钟", "estimatedMinutes": 30}
  ]
}
''',
      ),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input: '我 10 点钟要睡觉',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos.single.content, '睡觉');
    expect(todos.single.scheduledDate, DateTime(2026, 6, 8, 10));
  });

  test(
    'free text split recovers time from AI content when time field is null',
    () async {
      final notifier = GoalSplitNotifier(
        _FakeDeepSeekApiClient(
          response: '''
{
  "todos": [
    {"content": "10点钟要睡觉", "date": "2026-06-08", "time": null, "estimatedMinutes": 30}
  ]
}
''',
        ),
        _FakeTodoRepository(),
        _FakeProfileRepository(),
      );

      final todos = await notifier.generateTodosFromText(
        input: '我 10 点钟要睡觉',
        userId: 1,
        defaultDate: DateTime(2026, 6, 8),
      );

      expect(todos.single.content, '睡觉');
      expect(todos.single.scheduledDate, DateTime(2026, 6, 8, 10));
    },
  );

  test('free text split keeps separate times for multiple todos', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(
        response: '''
{
  "todos": [
    {"content": "写作业", "date": "2026-06-08", "time": "上午9点", "estimatedMinutes": 30},
    {"content": "去健身", "date": "2026-06-08", "time": "下午3点半", "estimatedMinutes": 60},
    {"content": "背单词", "date": "2026-06-08", "time": "晚上九点", "estimatedMinutes": 30}
  ]
}
''',
      ),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input: '上午9点写作业，下午3点半去健身，晚上九点背单词',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos.map((todo) => todo.content), ['写作业', '去健身', '背单词']);
    expect(todos[0].scheduledDate, DateTime(2026, 6, 8, 9));
    expect(todos[1].scheduledDate, DateTime(2026, 6, 8, 15, 30));
    expect(todos[2].scheduledDate, DateTime(2026, 6, 8, 21));
  });

  test(
    'free text split does not use local fallback for offline network errors',
    () async {
      final notifier = GoalSplitNotifier(
        _FakeDeepSeekApiClient(throwError: _networkUnavailableError()),
        _FakeTodoRepository(),
        _FakeProfileRepository(),
      );

      expect(
        () => notifier.generateTodosFromText(
          input: 'go out for fun',
          userId: 1,
          defaultDate: DateTime(2026, 6, 8),
        ),
        throwsA(isA<DioException>()),
      );
    },
  );

  test('free text split does not use local fallback for API errors', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(throwError: Exception('API returned bad output')),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    expect(
      () => notifier.generateTodosFromText(
        input: 'go out for fun',
        userId: 1,
        defaultDate: DateTime(2026, 6, 8),
      ),
      throwsA(isA<Exception>()),
    );
  });

  test(
    'free text split retries AI once when cloud returns empty todos',
    () async {
      final apiClient = _FakeDeepSeekApiClient(
        responses: [
          '{"todos":[]}',
          '''
{
  "todos": [
    {"content": "write homework", "date": "2026-06-08", "time": "18:00", "estimatedMinutes": 30}
  ]
}
''',
        ],
      );
      final notifier = GoalSplitNotifier(
        apiClient,
        _FakeTodoRepository(),
        _FakeProfileRepository(),
      );

      final todos = await notifier.generateTodosFromText(
        input: 'write homework',
        userId: 1,
        defaultDate: DateTime(2026, 6, 8),
      );

      expect(apiClient.promptCount, 2);
      expect(todos.single.content, 'write homework');
      expect(todos.single.isLocalGenerated, isFalse);
    },
  );

  test('free text parser accepts a top-level todos array from AI', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(
        response: '''
[
  {"content": "wash clothes", "date": "2026-06-08", "time": null, "estimatedMinutes": 30},
  {"content": "clean desk", "date": "2026-06-08", "time": null, "estimatedMinutes": 20}
]
''',
      ),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input: 'wash clothes and clean desk',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos.map((todo) => todo.content), ['wash clothes', 'clean desk']);
  });

  test(
    'free text split times out instead of waiting indefinitely',
    () async {
      final notifier = GoalSplitNotifier(
        _FakeDeepSeekApiClient(
          response: '{"todos":[]}',
          delay: const Duration(seconds: 35),
        ),
        _FakeTodoRepository(),
        _FakeProfileRepository(),
      );

      expect(
        () => notifier.generateTodosFromText(
          input: 'wash clothes and clean desk',
          userId: 1,
          defaultDate: DateTime(2026, 6, 8),
        ),
        throwsA(isA<TimeoutException>()),
      );
    },
    timeout: const Timeout(Duration(seconds: 40)),
  );

  test(
    'free text prompt requires multiple tasks to be split separately',
    () async {
      final apiClient = _FakeDeepSeekApiClient(
        response: '''
{
  "todos": [
    {"content": "wash clothes", "date": "2026-06-08", "time": null, "estimatedMinutes": 30}
  ]
}
''',
      );
      final notifier = GoalSplitNotifier(
        apiClient,
        _FakeTodoRepository(),
        _FakeProfileRepository(),
      );

      await notifier.generateTodosFromText(
        input: 'wash clothes and clean desk',
        userId: 1,
        defaultDate: DateTime(2026, 6, 8),
      );

      expect(apiClient.lastPrompt, contains('multiple tasks'));
      expect(apiClient.lastPrompt, contains('split them into separate todos'));
      expect(apiClient.lastPrompt, contains('Do not merge unrelated actions'));
      expect(apiClient.lastPrompt, contains('at least 2 todos'));
    },
  );

  test('free text prompt includes user profile for personalization', () async {
    final apiClient = _FakeDeepSeekApiClient(response: '{"todos": []}');
    final notifier = GoalSplitNotifier(
      apiClient,
      _FakeTodoRepository(),
      _FakeProfileRepository(
        profile: UserProfileModel()
          ..userId = 1
          ..name = 'JCX'
          ..age = 18
          ..occupation = 'student'
          ..region = 'Hangzhou'
          ..mbti = 'INTJ'
          ..communicationStyle = '鼓励型'
          ..bestWorkTime = 'night'
          ..challenges = '拖延症'
          ..changeTimeframeMonths = 3
          ..hasCompletedOnboarding = true
          ..createdAt = DateTime(2026, 6, 8),
      ),
    );

    await expectLater(
      () => notifier.generateTodosFromText(
        input: 'run at 20:00',
        userId: 1,
        defaultDate: DateTime(2026, 6, 8),
      ),
      throwsA(isA<AiSplitException>()),
    );

    expect(apiClient.lastPrompt, contains('用户画像'));
    expect(apiClient.lastPrompt, contains('JCX'));
    expect(apiClient.lastPrompt, contains('18'));
    expect(apiClient.lastPrompt, contains('student'));
    expect(apiClient.lastPrompt, contains('Hangzhou'));
    expect(apiClient.lastPrompt, contains('INTJ'));
    expect(apiClient.lastPrompt, contains('鼓励型'));
    expect(apiClient.lastPrompt, contains('night'));
    expect(apiClient.lastPrompt, contains('拖延症'));
    expect(apiClient.lastPrompt, contains('3个月'));
  });

  test('goal split uses cloud result instead of local replacement', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(
        response: '''
{
  "todos": [
    {"content": "prepare a weight-loss breakfast under the calorie target", "dayOffset": 0, "time": "08:00", "estimatedMinutes": 25},
    {"content": "complete a 30-minute cardio workout", "dayOffset": 1, "time": "19:00", "estimatedMinutes": 40}
  ]
}
''',
      ),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );
    final goal = _goal(
      title: 'lose ten pounds',
      description: 'adjust diet and exercise',
      targetDate: DateTime(2026, 6, 10),
    );

    final success = await notifier.generateTodosForGoal(
      goal,
      startDate: DateTime(2026, 6, 8),
    );

    expect(success, isTrue);
    expect(notifier.state.generatedTodos, hasLength(2));
    expect(
      notifier.state.generatedTodos.map((todo) => todo.content),
      contains('prepare a weight-loss breakfast under the calorie target'),
    );
    expect(notifier.state.generatedTodos[0].scheduledDate.hour, 8);
    expect(notifier.state.generatedTodos[1].scheduledDate.day, 9);
  });

  test(
    'goal split keeps sparse cloud output and does not local-replace it',
    () async {
      final notifier = GoalSplitNotifier(
        _FakeDeepSeekApiClient(
          response: '''
{
  "todos": [
    {"content": "prepare plan", "dayOffset": 0, "time": null, "estimatedMinutes": 30}
  ]
}
''',
        ),
        _FakeTodoRepository(),
        _FakeProfileRepository(),
      );

      final success = await notifier.generateTodosForGoal(
        _goal(targetDate: DateTime(2026, 6, 15)),
        startDate: DateTime(2026, 6, 8),
      );

      expect(success, isTrue);
      expect(notifier.state.generatedTodos, hasLength(1));
      expect(notifier.state.generatedTodos.single.content, 'prepare plan');
    },
  );

  test('goal split uses local fallback only when offline', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(throwError: _networkUnavailableError()),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final success = await notifier.generateTodosForGoal(
      _goal(title: 'learn English', targetDate: DateTime(2026, 6, 10)),
      startDate: DateTime(2026, 6, 8),
    );

    expect(success, isTrue);
    expect(notifier.state.generatedTodos, hasLength(3));
    expect(
      notifier.state.generatedTodos.every((todo) => todo.isLocalGenerated),
      isTrue,
    );
  });

  test(
    'goal split reports AI failure instead of local fallback for API errors',
    () async {
      final notifier = GoalSplitNotifier(
        _FakeDeepSeekApiClient(throwError: Exception('API failed')),
        _FakeTodoRepository(),
        _FakeProfileRepository(),
      );

      final success = await notifier.generateTodosForGoal(
        _goal(targetDate: DateTime(2026, 6, 10)),
        startDate: DateTime(2026, 6, 8),
      );

      expect(success, isFalse);
      expect(notifier.state.generatedTodos, isEmpty);
      expect(notifier.state.errorMessage, isNotNull);
    },
  );
}

BigGoalModel _goal({
  String title = 'learn English',
  String? description = 'one week plan',
  DateTime? targetDate,
}) {
  return BigGoalModel()
    ..id = 1
    ..userId = 1
    ..title = title
    ..description = description
    ..targetDate = targetDate ?? DateTime(2026, 6, 15)
    ..createdAt = DateTime(2026, 6, 8);
}

class _FakeDeepSeekApiClient extends DeepSeekApiClient {
  _FakeDeepSeekApiClient({
    this.response = '',
    this.responses = const [],
    this.throwError,
    this.delay = Duration.zero,
  }) : super(Dio());

  final String response;
  final List<String> responses;
  final Object? throwError;
  final Duration delay;
  String? lastPrompt;
  int promptCount = 0;

  @override
  Future<String> simplePrompt(String prompt, {bool jsonMode = false}) async {
    lastPrompt = prompt;
    promptCount++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final error = throwError;
    if (error != null) {
      throw error;
    }
    if (responses.isNotEmpty && promptCount <= responses.length) {
      return responses[promptCount - 1];
    }
    return response;
  }
}

DioException _networkUnavailableError() {
  return DioException.connectionError(
    requestOptions: RequestOptions(path: '/chat/completions'),
    reason: 'network unavailable',
  );
}

class _FakeProfileRepository implements UserProfileRepository {
  _FakeProfileRepository({this.profile});

  final UserProfileModel? profile;

  @override
  Future<void> completeOnboarding(int userId) async {}

  @override
  Future<void> deleteProfile(int userId) async {}

  @override
  Future<UserProfileModel?> getProfileByUserId(int userId) async => profile;

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
    return UserProfileModel()
      ..userId = userId
      ..name = name ?? ''
      ..age = age
      ..occupation = occupation
      ..region = region
      ..mbti = mbti
      ..communicationStyle = communicationStyle
      ..motivationSensitivity = motivationSensitivity
      ..bestWorkTime = bestWorkTime
      ..stressResponse = stressResponse
      ..socialPreference = socialPreference
      ..challenges = challenges
      ..lifeStatus = lifeStatus
      ..changeTimeframeMonths = changeTimeframeMonths
      ..threeChanges = threeChanges
      ..hasCompletedOnboarding = hasCompletedOnboarding ?? false
      ..createdAt = DateTime(2026, 6, 8);
  }

  @override
  Stream<UserProfileModel?> watchProfileByUserId(int userId) {
    return Stream.value(profile);
  }
}

class _FakeTodoRepository implements TodoItemRepository {
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
    return TodoItemModel()
      ..id = 1
      ..userId = userId
      ..content = content
      ..goalId = goalId
      ..isAIGenerated = isAIGenerated
      ..scheduledDate = scheduledDate ?? DateTime(2026, 6, 8)
      ..estimatedMinutes = estimatedMinutes
      ..color = color
      ..aiConfirmationQuestions = aiConfirmationQuestions
      ..createdAt = DateTime(2026, 6, 8);
  }

  @override
  Future<void> completeTodo(int todoId) async {}

  @override
  Future<void> deleteTodo(int todoId) async {}

  @override
  Future<void> deleteTodosByGoalId(int goalId) async {}

  @override
  Future<TodoItemModel?> getTodoById(int id) async => null;

  @override
  Future<List<TodoItemModel>> getTodosByDate(int userId, DateTime date) async =>
      const [];

  @override
  Future<List<TodoItemModel>> getTodosByDateRange(
    int userId,
    DateTime startDate,
    DateTime endDate,
  ) async => const [];

  @override
  Future<List<TodoItemModel>> getTodosByGoalId(int goalId) async => const [];

  @override
  Future<List<TodoItemModel>> getTodosByUserId(int userId) async => const [];

  @override
  Future<List<TodoItemModel>> getIncompleteTodos(int userId) async => const [];

  @override
  Future<List<TodoItemModel>> getCompletedTodos(int userId) async => const [];

  @override
  Future<void> uncompleteTodo(int todoId) async {}

  @override
  Future<void> updateTodo(TodoItemModel todo) async {}

  @override
  Stream<List<TodoItemModel>> watchTodosByDate(int userId, DateTime date) {
    return const Stream.empty();
  }

  @override
  Stream<List<TodoItemModel>> watchTodosByUserId(int userId) {
    return const Stream.empty();
  }
}
