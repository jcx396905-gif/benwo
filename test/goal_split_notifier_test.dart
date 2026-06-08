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
  test('free text fallback keeps a simple single intent as one todo', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(throwOnPrompt: true),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input: '我等一下要去出门玩',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos, hasLength(1));
    expect(todos.single.content, '等一下要去出门玩');
  });

  test('free text AI split extracts multiple precise timed todos', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(throwOnPrompt: true),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input: '我 10 点半去看我的初中老师，然后 11 点钟回家，12 点钟去银泰拿蛋糕。',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos, hasLength(3));
    expect(todos.map((todo) => todo.content), [
      '去看初中老师',
      '回家',
      '去银泰拿蛋糕',
    ]);
    expect(todos[0].scheduledDate, DateTime(2026, 6, 8, 10, 30));
    expect(todos[1].scheduledDate, DateTime(2026, 6, 8, 11));
    expect(todos[2].scheduledDate, DateTime(2026, 6, 8, 12));
  });

  test('free text AI split preserves seconds in precise time', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(throwOnPrompt: true),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input: '18点20分30秒去拿快递',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos, hasLength(1));
    expect(todos.single.content, '去拿快递');
    expect(todos.single.scheduledDate, DateTime(2026, 6, 8, 18, 20, 30));
  });

  test('free text prompt includes user profile for personalization', () async {
    final apiClient = _FakeDeepSeekApiClient(response: '{"todos": []}');
    final notifier = GoalSplitNotifier(
      apiClient,
      _FakeTodoRepository(),
      _FakeProfileRepository(
        profile: UserProfileModel()
          ..userId = 1
          ..name = 'JCX'
          ..occupation = '学生'
          ..mbti = 'INTJ'
          ..bestWorkTime = '夜猫型'
          ..hasCompletedOnboarding = true
          ..createdAt = DateTime(2026, 6, 8),
      ),
    );

    await notifier.generateTodosFromText(
      input: '晚上8点跑步',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(apiClient.lastPrompt, contains('用户画像'));
    expect(apiClient.lastPrompt, contains('姓名:JCX'));
    expect(apiClient.lastPrompt, contains('职业:学生'));
    expect(apiClient.lastPrompt, contains('MBTI:INTJ'));
    expect(apiClient.lastPrompt, contains('最佳工作时间:夜猫型'));
  });

  test('AI duplicate step-like todos are normalized and deduplicated', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(
        response: '''
{
  "todos": [
    {"content": "第一步：我选择出门玩", "date": "2026-06-08", "time": "15:20", "estimatedMinutes": 30},
    {"content": "第二步：我选择出门玩", "date": "2026-06-08", "time": "15:20", "estimatedMinutes": 30}
  ]
}
''',
      ),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );

    final todos = await notifier.generateTodosFromText(
      input: '下午3点20出门玩',
      userId: 1,
      defaultDate: DateTime(2026, 6, 8),
    );

    expect(todos, hasLength(1));
    expect(todos.single.content, '出门玩');
    expect(todos.single.scheduledDate.hour, 15);
    expect(todos.single.scheduledDate.minute, 20);
  });

  test('goal fallback keeps precise time from goal text for reminders', () async {
    final notifier = GoalSplitNotifier(
      _FakeDeepSeekApiClient(throwOnPrompt: true),
      _FakeTodoRepository(),
      _FakeProfileRepository(),
    );
    final goal = BigGoalModel()
      ..id = 1
      ..userId = 1
      ..title = '每天晚上8点复习英语'
      ..description = '持续一个月'
      ..targetDate = DateTime(2026, 7, 8)
      ..createdAt = DateTime(2026, 6, 8);

    final success = await notifier.generateTodosForGoal(
      goal,
      desiredCount: 3,
      startDate: DateTime(2026, 6, 8),
    );

    expect(success, isTrue);
    expect(notifier.state.generatedTodos, hasLength(3));
    expect(
      notifier.state.generatedTodos.every(
        (todo) => todo.scheduledDate.hour == 20 && todo.scheduledDate.minute == 0,
      ),
      isTrue,
    );
  });
}

class _FakeDeepSeekApiClient extends DeepSeekApiClient {
  _FakeDeepSeekApiClient({this.response = '', this.throwOnPrompt = false})
    : super(Dio());

  final String response;
  final bool throwOnPrompt;
  String? lastPrompt;

  @override
  Future<String> simplePrompt(String prompt, {bool jsonMode = false}) async {
    lastPrompt = prompt;
    if (throwOnPrompt) {
      throw Exception('API unavailable');
    }
    return response;
  }
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
  ) async =>
      const [];

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
