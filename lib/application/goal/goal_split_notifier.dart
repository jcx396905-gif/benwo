import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection.dart';
import '../../core/utils/todo_reminder_scheduler.dart';
import '../../data/models/big_goal_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/repositories/todo_item_repository.dart';
import '../../data/repositories/user_profile_repository.dart';

class GeneratedTodoItem {
  final String content;
  final DateTime scheduledDate;
  final int estimatedMinutes;
  final bool isConfirmed;

  const GeneratedTodoItem({
    required this.content,
    required this.scheduledDate,
    required this.estimatedMinutes,
    this.isConfirmed = false,
  });

  GeneratedTodoItem copyWith({
    String? content,
    DateTime? scheduledDate,
    int? estimatedMinutes,
    bool? isConfirmed,
  }) {
    return GeneratedTodoItem(
      content: content ?? this.content,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }
}

class TimeOfDayLike {
  final int hour;
  final int minute;
  final int second;

  const TimeOfDayLike(this.hour, this.minute, {this.second = 0});
}

class GoalSplitState {
  final bool isLoading;
  final String? errorMessage;
  final List<GeneratedTodoItem> generatedTodos;
  final bool isCompleted;

  const GoalSplitState({
    this.isLoading = false,
    this.errorMessage,
    this.generatedTodos = const [],
    this.isCompleted = false,
  });

  GoalSplitState copyWith({
    bool? isLoading,
    Object? errorMessage = _unchanged,
    List<GeneratedTodoItem>? generatedTodos,
    bool? isCompleted,
  }) {
    return GoalSplitState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _unchanged
          ? this.errorMessage
          : errorMessage as String?,
      generatedTodos: generatedTodos ?? this.generatedTodos,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

const Object _unchanged = Object();
const Duration _aiSplitTimeout = Duration(seconds: 45);

class AiSplitException implements Exception {
  final String message;

  const AiSplitException(this.message);

  @override
  String toString() => message;
}

class GoalSplitNotifier extends StateNotifier<GoalSplitState> {
  GoalSplitNotifier(
    this._apiClient,
    this._todoRepository,
    this._profileRepository,
  ) : super(const GoalSplitState());

  final DeepSeekApiClient _apiClient;
  final TodoItemRepository _todoRepository;
  final UserProfileRepository _profileRepository;

  Future<bool> generateTodosForGoal(
    BigGoalModel goal, {
    int? desiredCount,
    DateTime? startDate,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      generatedTodos: const [],
      isCompleted: false,
    );

    try {
      final todos = await _generateGoalTodos(
        goal,
        desiredCount: desiredCount,
        startDate: startDate ?? DateTime.now(),
      );
      state = state.copyWith(isLoading: false, generatedTodos: todos);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'AI generation failed: $e',
      );
      return false;
    }
  }

  Future<List<GeneratedTodoItem>> generateTodosFromText({
    required String input,
    required int userId,
    required DateTime defaultDate,
    int? desiredCount,
  }) async {
    final trimmedInput = input.trim();
    if (trimmedInput.isEmpty) return const [];

    try {
      final response = await _apiClient
          .simplePrompt(
            _buildFreeTextPrompt(
              trimmedInput,
              profile: await _loadProfile(userId),
              desiredCount: desiredCount,
              defaultDate: defaultDate,
            ),
            jsonMode: true,
          )
          .timeout(_aiSplitTimeout);
      final parsed = _sanitizeGeneratedTodos(
        _parseFreeTextResponse(response, defaultDate),
        sourceText: trimmedInput,
      );
      if (parsed.isNotEmpty) {
        return _limitTodos(parsed, desiredCount);
      }
      throw const AiSplitException('AI did not return usable todos.');
    } catch (error) {
      if (!_isOfflineError(error)) rethrow;
    }

    final explicitTimedTodos = _extractExplicitTimedTodos(
      trimmedInput,
      defaultDate: defaultDate,
    );
    if (explicitTimedTodos.isNotEmpty) {
      return _limitTodos(explicitTimedTodos, desiredCount);
    }

    return _generateLocalTodosFromText(
      trimmedInput,
      desiredCount: desiredCount,
      defaultDate: defaultDate,
    );
  }

  Future<List<GeneratedTodoItem>> _generateGoalTodos(
    BigGoalModel goal, {
    required DateTime startDate,
    int? desiredCount,
  }) async {
    try {
      final response = await _apiClient
          .simplePrompt(
            _buildGoalPrompt(
              goal,
              profile: await _loadProfile(goal.userId),
              desiredCount: desiredCount,
              startDate: startDate,
            ),
            jsonMode: true,
          )
          .timeout(_aiSplitTimeout);
      final parsed = _sanitizeGeneratedTodos(
        _parseGoalResponse(response, goal, startDate),
        sourceText: '${goal.title} ${goal.description ?? ''}',
      );
      if (parsed.isNotEmpty) {
        return _limitGoalTodos(parsed, goal, startDate);
      }
      throw const AiSplitException('AI did not return usable goal todos.');
    } catch (error) {
      if (!_isOfflineError(error)) rethrow;
    }

    return _generateLocalTodosForGoal(
      goal,
      desiredCount: desiredCount,
      startDate: startDate,
    );
  }

  String _buildGoalPrompt(
    BigGoalModel goal, {
    required UserProfileModel? profile,
    required DateTime startDate,
    int? desiredCount,
  }) {
    final today = _dateOnly(DateTime.now());
    final baseDate = _dateOnly(startDate);
    final targetDate = _dateOnly(goal.targetDate);
    final maxDays = targetDate.difference(baseDate).inDays.clamp(1, 3650);
    final description = goal.description?.trim().isNotEmpty == true
        ? goal.description!.trim()
        : '\u65e0';
    final category = goal.category?.trim().isNotEmpty == true
        ? goal.category!.trim()
        : '\u672a\u5206\u7c7b';

    return '''
You are a careful long-term goal planning assistant.
Split the user's BIG GOAL into concrete calendar todos. Return task content in the same language as the user's goal.

Goal title: ${goal.title}
Goal description: $description
Goal category: $category
鐢ㄦ埛鐢诲儚 / User profile: ${_formatProfile(profile)}
Today: ${_formatIsoDate(today)}
Start date: ${_formatIsoDate(baseDate)}
Target date: ${_formatIsoDate(targetDate)}
Plan days: ${maxDays + 1}
Desired task count: ${_describeDesiredCount(desiredCount)}

Rules:
1. This is BIG GOAL splitting, not one-day todo splitting. Every task must be directly related to the goal topic.
2. First infer the concrete domain of the goal from title, description, category, dates, and user profile. Then generate tasks only for that domain. Do not output generic productivity filler.
3. For weight-loss or fitness goals such as \u51cf\u80a5, \u51cf\u8102, \u4f53\u91cd, \u996e\u98df, \u8fd0\u52a8, generate tasks about meals, calorie control, exercise, weighing, water, sleep, body measurements, and review. Never output generic planning filler.
4. If desired task count is AI auto, generate one todo for every calendar day from start date to target date, inclusive. If the user selected a count, generate exactly that many todos and distribute them across multiple dates, not all on one day.
5. dayOffset is an integer from 0 to $maxDays.
6. content must be a concrete action that can be done that day. Do not write generic text such as "split the goal into steps", "complete today's smallest action", "record progress and blockers", or "adjust the next plan".
7. estimatedMinutes must be an integer, usually 10 to 180.
8. If the user gave an exact time, return time as HH:mm or HH:mm:ss. Otherwise return null.
9. Return JSON only, no Markdown, no explanation.

JSON shape:
{"todos":[{"content":"\u4efb\u52a1\u5185\u5bb9","dayOffset":0,"time":"09:30","estimatedMinutes":30}]}
''';
  }

  String _buildFreeTextPrompt(
    String input, {
    required UserProfileModel? profile,
    required DateTime defaultDate,
    int? desiredCount,
  }) {
    final today = _dateOnly(DateTime.now());
    final baseDate = _dateOnly(defaultDate);

    return '''
You are a todo splitting assistant. Split the user's text into todos for the default date or the exact date mentioned by the user. Return task content in the same language as the user input.

Today: ${_formatIsoDate(today)}
Default date: ${_formatIsoDate(baseDate)}
Desired task count: ${_describeDesiredCount(desiredCount)}
鐢ㄦ埛鐢诲儚 / User profile: ${_formatProfile(profile)}
User input: $input

Rules:
1. This is TODO splitting, not long-term goal splitting. Generate todos for today or the user-specified date only.
2. If the input is one simple intent, create one todo. Split into multiple todos only when the input contains multiple items, clear steps, or multiple exact times.
3. If the user mentions several exact times, create one todo for each time and preserve the exact time.
4. Return date as YYYY-MM-DD.
5. If the user mentions an exact time, return time as HH:mm or HH:mm:ss. Otherwise return null.
6. content must be a natural action. Do not write \u7b2c\u4e00\u6b65, \u7b2c\u4e8c\u6b65, \u6211\u9009\u62e9, \u6211\u51b3\u5b9a, or \u6211\u5c06\u8981.
7. Return JSON only, no Markdown, no explanation.

JSON shape:
{"todos":[{"content":"\u5f85\u529e\u5185\u5bb9","date":"${_formatIsoDate(baseDate)}","time":"09:30","estimatedMinutes":30}]}
''';
  }

  List<GeneratedTodoItem> _parseGoalResponse(
    String response,
    BigGoalModel goal,
    DateTime startDate,
  ) {
    try {
      final decoded = _decodeTodosJson(response);
      final todosJson = decoded['todos'];
      if (todosJson is! List) return const [];

      final baseDate = _dateOnly(startDate);
      final maxOffset = _dateOnly(
        goal.targetDate,
      ).difference(baseDate).inDays.clamp(1, 3650);
      final todos = <GeneratedTodoItem>[];

      for (final item in todosJson) {
        if (item is! Map<String, dynamic>) continue;
        final content = item['content']?.toString().trim();
        if (content == null || content.isEmpty) continue;

        final rawOffset = item['dayOffset'];
        final rawMinutes = item['estimatedMinutes'];
        final timeText = item['time']?.toString();
        final dayOffset = rawOffset is num
            ? rawOffset.toInt().clamp(0, maxOffset)
            : 0;
        final estimatedMinutes = rawMinutes is num
            ? rawMinutes.toInt().clamp(10, 240)
            : 30;

        todos.add(
          GeneratedTodoItem(
            content: content,
            scheduledDate: _combineDateAndTime(
              baseDate.add(Duration(days: dayOffset)),
              timeText,
            ),
            estimatedMinutes: estimatedMinutes,
          ),
        );
      }

      return todos.take(_maxGoalPlanTodos).toList();
    } catch (_) {
      return const [];
    }
  }

  List<GeneratedTodoItem> _parseFreeTextResponse(
    String response,
    DateTime defaultDate,
  ) {
    try {
      final decoded = _decodeTodosJson(response);
      final todosJson = decoded['todos'];
      if (todosJson is! List) return const [];

      final fallbackDate = _dateOnly(defaultDate);
      final todos = <GeneratedTodoItem>[];

      for (final item in todosJson) {
        if (item is! Map<String, dynamic>) continue;
        final content = item['content']?.toString().trim();
        if (content == null || content.isEmpty) continue;

        final parsedDate = DateTime.tryParse(item['date']?.toString() ?? '');
        final timeText = item['time']?.toString();
        final rawMinutes = item['estimatedMinutes'];
        final estimatedMinutes = rawMinutes is num
            ? rawMinutes.toInt().clamp(10, 240)
            : 30;

        todos.add(
          GeneratedTodoItem(
            content: content,
            scheduledDate: _combineDateAndTime(
              parsedDate ?? fallbackDate,
              timeText,
            ),
            estimatedMinutes: estimatedMinutes,
          ),
        );
      }

      return todos.take(20).toList();
    } catch (_) {
      return const [];
    }
  }

  Map<String, dynamic> _decodeTodosJson(String response) {
    final jsonMatch = RegExp(r'\{[\s\S]*"todos"[\s\S]*\}').firstMatch(response);
    final decoded = jsonDecode(jsonMatch?.group(0) ?? response);
    if (decoded is Map<String, dynamic>) return decoded;
    return const {};
  }

  List<GeneratedTodoItem> _generateLocalTodosForGoal(
    BigGoalModel goal, {
    required DateTime startDate,
    int? desiredCount,
  }) {
    final baseDate = _dateOnly(startDate);
    final daysUntilTarget = _dateOnly(
      goal.targetDate,
    ).difference(baseDate).inDays.clamp(1, 3650);
    final dayCount = _goalPlanDayCount(goal, startDate);
    final taskCount = desiredCount ?? dayCount.clamp(1, _maxGoalPlanTodos);
    final templates = _getTaskTemplatesForGoal(goal);
    final step = (daysUntilTarget / taskCount).ceil().clamp(1, 30);
    final fallbackTime = _extractTimeFromText(
      '${goal.title} ${goal.description ?? ''}',
    );

    return List.generate(taskCount, (index) {
      final template = templates[index % templates.length];
      final dayOffset = desiredCount == null
          ? index.clamp(0, daysUntilTarget)
          : (index * step).clamp(0, daysUntilTarget);
      return GeneratedTodoItem(
        content: desiredCount == null
            ? '\u7b2c${index + 1}\u5929\uff1a${template.content}'
            : template.content,
        scheduledDate: _combineDateAndTime(
          baseDate.add(Duration(days: dayOffset)),
          fallbackTime,
        ),
        estimatedMinutes: template.estimatedMinutes,
      );
    });
  }

  List<GeneratedTodoItem> _generateLocalTodosFromText(
    String input, {
    required DateTime defaultDate,
    int? desiredCount,
  }) {
    final parts = input
        .split(RegExp(r'[\n，。；;、]+|(?:然后|再去|以及|并且|还要)'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    final fallbackParts = parts.isEmpty ? [input] : parts;
    final isSingleSimpleIntent =
        fallbackParts.length == 1 && _isSimpleSingleIntent(fallbackParts.first);
    final taskCount = _resolveDesiredCount(
      isSingleSimpleIntent ? null : desiredCount,
      fallback: isSingleSimpleIntent ? 1 : fallbackParts.length.clamp(1, 6),
    );

    return List.generate(taskCount, (index) {
      final raw = fallbackParts[index % fallbackParts.length];
      final content = _normalizeTodoContent(raw);
      return GeneratedTodoItem(
        content: content,
        scheduledDate: _combineDateAndTime(
          defaultDate,
          _extractTimeFromText(raw),
        ),
        estimatedMinutes: 30,
      );
    });
  }

  List<GeneratedTodoItem> _extractExplicitTimedTodos(
    String input, {
    required DateTime defaultDate,
  }) {
    final clauses = input
        .split(RegExp(r'[\n，。；;、]+|(?:然后|再去|以及|并且|还要)'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    final todos = <GeneratedTodoItem>[];

    for (final clause in clauses) {
      final timeText = _extractTimeFromText(clause);
      if (timeText == null) continue;
      final content = _normalizeTodoContent(_removeTimeExpressions(clause));
      if (content.isEmpty) continue;

      todos.add(
        GeneratedTodoItem(
          content: content,
          scheduledDate: _combineDateAndTime(defaultDate, timeText),
          estimatedMinutes: _guessEstimatedMinutes(content),
        ),
      );
    }

    return _dedupeTodos(todos);
  }

  List<GeneratedTodoItem> _sanitizeGeneratedTodos(
    List<GeneratedTodoItem> todos, {
    required String sourceText,
  }) {
    final seen = <String>{};
    final sanitized = <GeneratedTodoItem>[];

    for (final todo in todos) {
      final content = _normalizeTodoContent(
        _removeTimeExpressions(todo.content),
      );
      if (content.isEmpty) continue;
      if (_isLowQualityGeneratedContent(content, sourceText)) continue;

      final key = content.replaceAll(RegExp(r'\s+'), '').toLowerCase();
      if (!seen.add(key)) continue;

      sanitized.add(todo.copyWith(content: content));
    }

    return sanitized;
  }

  List<GeneratedTodoItem> _dedupeTodos(List<GeneratedTodoItem> todos) {
    final seen = <String>{};
    final result = <GeneratedTodoItem>[];
    for (final todo in todos) {
      final key = todo.content.replaceAll(RegExp(r'\s+'), '').toLowerCase();
      if (seen.add(key)) result.add(todo);
    }
    return result;
  }

  List<GeneratedTodoItem> _limitTodos(
    List<GeneratedTodoItem> todos,
    int? desiredCount,
  ) {
    final limit = desiredCount?.clamp(1, 20);
    return limit == null ? todos.take(20).toList() : todos.take(limit).toList();
  }

  List<GeneratedTodoItem> _limitGoalTodos(
    List<GeneratedTodoItem> todos,
    BigGoalModel goal,
    DateTime startDate,
  ) {
    final maxCount = _goalPlanDayCount(
      goal,
      startDate,
    ).clamp(1, _maxGoalPlanTodos);
    return todos.take(maxCount).toList();
  }

  int _goalPlanDayCount(BigGoalModel goal, DateTime startDate) {
    final baseDate = _dateOnly(startDate);
    final targetDate = _dateOnly(goal.targetDate);
    return targetDate.difference(baseDate).inDays.clamp(0, 3650) + 1;
  }

  bool _isWeightLossGoal(String text) {
    return _containsAny(text, [
      '\u51cf\u80a5',
      '\u51cf\u8102',
      '\u7626',
      '\u4f53\u91cd',
      '\u63a7\u5236\u996e\u98df',
      '\u996e\u98df',
      '\u70ed\u91cf',
      '\u8fd0\u52a8',
      '\u5065\u8eab',
      '\u8dd1\u6b65',
      '\u8102\u80aa',
      '\u5341\u65a4',
      '\u65a4',
    ]);
  }

  static const int _maxGoalPlanTodos = 366;

  int _resolveDesiredCount(int? desiredCount, {required int fallback}) {
    return (desiredCount ?? fallback).clamp(1, 20);
  }

  String _describeDesiredCount(int? desiredCount) {
    return desiredCount == null
        ? '\u0041\u0049 \u81ea\u52a8\u9009\u62e9'
        : '$desiredCount';
  }

  List<_TodoTemplate> _getTaskTemplatesForGoal(BigGoalModel goal) {
    final text =
        '${goal.title} ${goal.description ?? ''} ${goal.category ?? ''}';

    if (_isWeightLossGoal(text)) {
      return const [
        _TodoTemplate(
          '\u8bb0\u5f55\u6668\u8d77\u4f53\u91cd\u548c\u8170\u56f4',
          10,
        ),
        _TodoTemplate(
          '\u89c4\u5212\u4eca\u5929\u4e09\u9910\u5e76\u51cf\u5c11\u9ad8\u7cd6\u9ad8\u6cb9\u98df\u7269',
          20,
        ),
        _TodoTemplate(
          '\u5b8c\u621030\u5206\u949f\u4e2d\u7b49\u5f3a\u5ea6\u6709\u6c27\u8fd0\u52a8',
          40,
        ),
        _TodoTemplate(
          '\u559d\u591f\u996e\u6c34\u5e76\u51cf\u5c11\u542b\u7cd6\u996e\u6599',
          10,
        ),
        _TodoTemplate('\u665a\u9910\u540e\u6563\u6b6520\u5206\u949f', 25),
        _TodoTemplate(
          '\u590d\u76d8\u4eca\u5929\u70ed\u91cf\u6444\u5165\u548c\u8fd0\u52a8\u5b8c\u6210\u60c5\u51b5',
          15,
        ),
        _TodoTemplate(
          '\u63d0\u524d\u51c6\u5907\u4e00\u4efd\u4f4e\u70ed\u91cf\u9ad8\u86cb\u767d\u9910',
          30,
        ),
      ];
    }

    if (_containsAny(text, [
      '\u5b66\u4e60',
      '\u8003\u8bd5',
      '\u82f1\u8bed',
      '\u8bfe\u7a0b',
      '\u590d\u4e60',
      '\u9605\u8bfb',
      '\u80cc\u5355\u8bcd',
      '\u8003\u7814',
    ])) {
      return const [
        _TodoTemplate(
          '\u5b8c\u6210\u4e00\u8f6e\u77e5\u8bc6\u70b9\u5b66\u4e60\u548c\u7b14\u8bb0\u6574\u7406',
          25,
        ),
        _TodoTemplate(
          '\u505a\u4e00\u7ec4\u7ec3\u4e60\u9898\u5e76\u6807\u8bb0\u9519\u9898',
          45,
        ),
        _TodoTemplate(
          '\u590d\u4e60\u6628\u5929\u7684\u91cd\u70b9\u5185\u5bb9',
          25,
        ),
        _TodoTemplate(
          '\u6574\u7406\u4eca\u65e5\u5b66\u4e60\u603b\u7ed3\u548c\u660e\u65e5\u8ba1\u5212',
          30,
        ),
        _TodoTemplate(
          '\u80cc\u8bf510\u4e2a\u6838\u5fc3\u77e5\u8bc6\u70b9\u6216\u5355\u8bcd',
          10,
        ),
      ];
    }

    if (_containsAny(text, [
      '\u5065\u5eb7',
      '\u7761\u7720',
      '\u4f5c\u606f',
      '\u65e9\u7761',
      '\u8fd0\u52a8',
      '\u8dd1\u6b65',
      '\u5065\u8eab',
    ])) {
      return const [
        _TodoTemplate(
          '\u5b8c\u6210\u4eca\u5929\u7684\u5065\u5eb7\u884c\u52a8\u5e76\u8bb0\u5f55\u7ed3\u679c',
          40,
        ),
        _TodoTemplate(
          '\u8bb0\u5f55\u7761\u7720\u3001\u996e\u6c34\u548c\u8eab\u4f53\u72b6\u6001',
          10,
        ),
        _TodoTemplate(
          '\u505a\u4e00\u6b21\u8f7b\u91cf\u62c9\u4f38\u6216\u6709\u6c27\u8bad\u7ec3',
          30,
        ),
        _TodoTemplate(
          '\u590d\u76d8\u5f71\u54cd\u5065\u5eb7\u4e60\u60ef\u7684\u963b\u788d',
          15,
        ),
      ];
    }

    if (_containsAny(text, [
      '\u5de5\u4f5c',
      '\u9879\u76ee',
      '\u4ea7\u54c1',
      '\u4ee3\u7801',
      '\u5f00\u53d1',
      '\u8bba\u6587',
      '\u62a5\u544a',
      '\u521b\u4e1a',
    ])) {
      return const [
        _TodoTemplate(
          '\u660e\u786e\u4eca\u5929\u8981\u4ea4\u4ed8\u7684\u4e00\u4e2a\u5c0f\u6210\u679c',
          20,
        ),
        _TodoTemplate(
          '\u5b8c\u6210\u4e00\u6bb5\u6838\u5fc3\u5de5\u4f5c\u5e76\u4fdd\u5b58\u8fdb\u5ea6',
          90,
        ),
        _TodoTemplate(
          '\u68c0\u67e5\u5e76\u6574\u7406\u9047\u5230\u7684\u95ee\u9898\u6e05\u5355',
          15,
        ),
        _TodoTemplate(
          '\u590d\u76d8\u4eca\u65e5\u4ea7\u51fa\u5e76\u5b89\u6392\u4e0b\u4e00\u6b65',
          25,
        ),
      ];
    }

    if (_containsAny(text, [
      '\u7701\u94b1',
      '\u5b58\u94b1',
      '\u7406\u8d22',
      '\u9884\u7b97',
      '\u8fd8\u6b3e',
      '\u6536\u5165',
      '\u5f00\u9500',
    ])) {
      return const [
        _TodoTemplate(
          '\u8bb0\u5f55\u4eca\u5929\u7684\u6536\u5165\u548c\u652f\u51fa',
          10,
        ),
        _TodoTemplate(
          '\u68c0\u67e5\u672c\u5468\u9884\u7b97\u4f7f\u7528\u60c5\u51b5',
          20,
        ),
        _TodoTemplate(
          '\u51cf\u5c11\u4e00\u9879\u975e\u5fc5\u8981\u6d88\u8d39',
          15,
        ),
        _TodoTemplate(
          '\u590d\u76d8\u672c\u9636\u6bb5\u5b58\u94b1\u8fdb\u5ea6',
          30,
        ),
      ];
    }

    if (_containsAny(text, [
      '\u6574\u7406',
      '\u6536\u7eb3',
      '\u623f\u95f4',
      '\u642c\u5bb6',
      '\u6e05\u7406',
      '\u5bb6\u52a1',
    ])) {
      return const [
        _TodoTemplate(
          '\u6574\u7406\u4e00\u4e2a\u5c0f\u533a\u57df\u5e76\u62cd\u7167\u8bb0\u5f55',
          30,
        ),
        _TodoTemplate(
          '\u4e22\u5f03\u6216\u5f52\u4f4d\u4e00\u6279\u65e0\u7528\u7269\u54c1',
          30,
        ),
        _TodoTemplate(
          '\u6e05\u6d01\u4eca\u5929\u6307\u5b9a\u7684\u7a7a\u95f4',
          25,
        ),
        _TodoTemplate(
          '\u5217\u51fa\u4e0b\u4e00\u6b21\u6574\u7406\u6e05\u5355',
          15,
        ),
      ];
    }

    if (_containsAny(text, [
      '\u670b\u53cb',
      '\u5bb6\u4eba',
      '\u5173\u7cfb',
      '\u6c9f\u901a',
      '\u793e\u4ea4',
      '\u8001\u5e08',
      '\u540c\u5b66',
    ])) {
      return const [
        _TodoTemplate(
          '\u8054\u7cfb\u4e00\u4f4d\u76f8\u5173\u7684\u4eba\u5e76\u786e\u8ba4\u4e0b\u4e00\u6b65',
          15,
        ),
        _TodoTemplate('\u51c6\u5907\u4e00\u6b21\u6c9f\u901a\u8981\u70b9', 20),
        _TodoTemplate(
          '\u8bb0\u5f55\u6c9f\u901a\u7ed3\u679c\u548c\u540e\u7eed\u4e8b\u9879',
          15,
        ),
        _TodoTemplate(
          '\u5b89\u6392\u4e00\u6b21\u8f7b\u91cf\u4e92\u52a8\u6216\u89c1\u9762',
          10,
        ),
      ];
    }

    return const [
      _TodoTemplate(
        '\u5b8c\u6210\u4e00\u4e2a\u548c\u76ee\u6807\u76f4\u63a5\u76f8\u5173\u7684\u5c0f\u884c\u52a8',
        20,
      ),
      _TodoTemplate(
        '\u63a8\u8fdb\u76ee\u6807\u4e2d\u7684\u4e00\u4e2a\u5177\u4f53\u73af\u8282',
        40,
      ),
      _TodoTemplate(
        '\u8bb0\u5f55\u4eca\u5929\u5b8c\u6210\u60c5\u51b5\u548c\u95ee\u9898',
        15,
      ),
      _TodoTemplate(
        '\u6839\u636e\u8fdb\u5ea6\u8c03\u6574\u4e0b\u4e00\u6b65\u4efb\u52a1',
        15,
      ),
    ];
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }

  bool _isSimpleSingleIntent(String text) {
    final normalized = text.trim();
    if (normalized.isEmpty) return true;
    if (normalized.length <= 22) return true;

    final hasComplexMarker = RegExp(
      '(计划|项目|目标|学习|复习|整理|准备|完成|再|多个|几件|今天.*明天|明天.*后天)',
    ).hasMatch(normalized);
    return !hasComplexMarker;
  }

  String _normalizeTodoContent(String content) {
    var normalized = content.trim();
    normalized = normalized.replaceFirst(
      RegExp(r'^第?[一二三四五六七八九十\d]+[步项]?[、.。:：)]*\s*'),
      '',
    );
    normalized = normalized.replaceFirst(
      RegExp(r'^(我选择|我决定|我将要|我要|我需要|我打算)\s*'),
      '',
    );
    normalized = normalized.replaceAll(
      RegExp('我的(?=(?:小学|初中|高中|大学)?(?:老师|同学|朋友|同事))'),
      '',
    );
    return normalized.trim();
  }

  String _removeTimeExpressions(String content) {
    var normalized = content;
    for (final pattern in _timeExpressionPatterns) {
      normalized = normalized.replaceAll(pattern, '');
    }
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
    return normalized.trim();
  }

  int _guessEstimatedMinutes(String content) {
    if (_containsAny(content, ['回家', '拿', '取', '买'])) return 20;
    if (_containsAny(content, ['看', '见', '拜访', '老师', '朋友'])) return 60;
    if (_containsAny(content, ['跑步', '运动', '健身'])) return 45;
    return 30;
  }

  bool _isLowQualityGeneratedContent(String content, String sourceText) {
    final compactContent = content.replaceAll(RegExp(r'\s+'), '');
    final compactSource = sourceText.replaceAll(RegExp(r'\s+'), '');

    if (RegExp(
      r'^\u7b2c?[\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\d]+[\u6b65\u9879]',
    ).hasMatch(content)) {
      return true;
    }
    if (RegExp(
      r'^(\u6211\u9009\u62e9|\u6211\u51b3\u5b9a|\u6211\u5c06\u8981)$',
    ).hasMatch(content)) {
      return true;
    }
    if (_containsAny(content, [
      '\u628a\u76ee\u6807\u62c6\u6210\u4e09\u4e2a\u53ef\u6267\u884c\u7684\u5c0f\u6b65\u9aa4',
      '\u5b8c\u6210\u4eca\u5929\u7684\u6700\u5c0f\u53ef\u884c\u52a8\u4f5c',
      '\u8bb0\u5f55\u8fdb\u5c55\u548c\u9047\u5230\u7684\u963b\u788d',
      '\u8c03\u6574\u4e0b\u4e00\u6b65\u8ba1\u5212',
      '\u6211\u9009\u62e9\u51fa\u95e8\u73a9',
    ])) {
      return true;
    }
    if (compactContent.length <= 2) return true;
    if (compactSource.isNotEmpty && compactContent == compactSource) {
      return false;
    }
    return false;
  }

  void updateTodoContent(int index, String content) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    updatedTodos[index] = updatedTodos[index].copyWith(content: content);
    state = state.copyWith(generatedTodos: updatedTodos, errorMessage: null);
  }

  void updateTodoDate(int index, DateTime date) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    final oldDate = state.generatedTodos[index].scheduledDate;
    updatedTodos[index] = updatedTodos[index].copyWith(
      scheduledDate: DateTime(
        date.year,
        date.month,
        date.day,
        oldDate.hour,
        oldDate.minute,
        oldDate.second,
      ),
    );
    state = state.copyWith(generatedTodos: updatedTodos, errorMessage: null);
  }

  void updateTodoTime(int index, TimeOfDayLike? time) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    final oldDate = state.generatedTodos[index].scheduledDate;
    updatedTodos[index] = updatedTodos[index].copyWith(
      scheduledDate: time == null
          ? _dateOnly(oldDate)
          : DateTime(
              oldDate.year,
              oldDate.month,
              oldDate.day,
              time.hour,
              time.minute,
              time.second,
            ),
    );
    state = state.copyWith(generatedTodos: updatedTodos, errorMessage: null);
  }

  void updateTodoMinutes(int index, int minutes) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    updatedTodos[index] = updatedTodos[index].copyWith(
      estimatedMinutes: minutes.clamp(10, 240),
    );
    state = state.copyWith(generatedTodos: updatedTodos, errorMessage: null);
  }

  void removeTodo(int index) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos)
      ..removeAt(index);
    state = state.copyWith(generatedTodos: updatedTodos, errorMessage: null);
  }

  void addTodo(GeneratedTodoItem todo) {
    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos)
      ..add(todo);
    state = state.copyWith(generatedTodos: updatedTodos, errorMessage: null);
  }

  void confirmAllTodos() {
    final updatedTodos = state.generatedTodos
        .map((todo) => todo.copyWith(isConfirmed: true))
        .toList();
    state = state.copyWith(generatedTodos: updatedTodos, errorMessage: null);
  }

  Future<bool> saveTodosToDatabase(BigGoalModel goal) async {
    if (state.generatedTodos.isEmpty) {
      state = state.copyWith(errorMessage: 'No tasks to save.');
      return false;
    }

    final hasUnconfirmedTodos = state.generatedTodos.any(
      (todo) => !todo.isConfirmed,
    );
    if (hasUnconfirmedTodos) {
      state = state.copyWith(errorMessage: 'Please confirm all tasks first.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      for (final todo in state.generatedTodos) {
        final savedTodo = await _todoRepository.createTodo(
          userId: goal.userId,
          content: todo.content,
          goalId: goal.id,
          isAIGenerated: true,
          scheduledDate: todo.scheduledDate,
          estimatedMinutes: todo.estimatedMinutes,
          color: goal.color,
        );
        await TodoReminderScheduler.scheduleForTodo(savedTodo);
      }

      state = state.copyWith(isLoading: false, isCompleted: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Save failed: $e');
      return false;
    }
  }

  void reset() {
    state = const GoalSplitState();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<UserProfileModel?> _loadProfile(int userId) async {
    try {
      return _profileRepository.getProfileByUserId(userId);
    } catch (_) {
      return null;
    }
  }

  String _formatProfile(UserProfileModel? profile) {
    if (profile == null) return 'No profile';
    final parts = <String>[
      'name:${profile.name}',
      if (profile.age != null) 'age:${profile.age}',
      if (profile.occupation?.isNotEmpty == true)
        'occupation:${profile.occupation}',
      if (profile.mbti?.isNotEmpty == true) 'MBTI:${profile.mbti}',
      if (profile.communicationStyle?.isNotEmpty == true)
        'communication:${profile.communicationStyle}',
      if (profile.motivationSensitivity?.isNotEmpty == true)
        'motivation:${profile.motivationSensitivity}',
      if (profile.bestWorkTime?.isNotEmpty == true)
        'bestWorkTime:${profile.bestWorkTime}',
      if (profile.stressResponse?.isNotEmpty == true)
        'stressResponse:${profile.stressResponse}',
      if (profile.socialPreference?.isNotEmpty == true)
        'socialPreference:${profile.socialPreference}',
      if (profile.lifeStatus?.isNotEmpty == true)
        'lifeStatus:${profile.lifeStatus}',
      if (profile.challenges?.isNotEmpty == true)
        'challenges:${profile.challenges}',
      if (profile.threeChanges?.isNotEmpty == true)
        'desiredChanges:${profile.threeChanges}',
    ];
    return parts.join('; ');
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

bool _isOfflineError(Object error) {
  if (error is SocketException) return true;
  if (error is TimeoutException) return false;
  if (error is DioException) {
    if (error.type == DioExceptionType.connectionError) return true;
    return error.error is SocketException;
  }
  return false;
}

DateTime _combineDateAndTime(DateTime date, String? timeText) {
  final time = _parseTimeText(timeText);
  if (time == null) return date;
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
    time.second,
  );
}

TimeOfDayLike? _parseTimeText(String? raw) {
  if (raw == null) return null;
  final text = raw.trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;

  final colonMatch = RegExp(
    r'(\d{1,2})[:：](\d{1,2})(?:[:：](\d{1,2}))?',
  ).firstMatch(text);
  if (colonMatch != null) {
    final hour = int.tryParse(colonMatch.group(1)!);
    final minute = int.tryParse(colonMatch.group(2)!);
    final second = int.tryParse(colonMatch.group(3) ?? '0') ?? 0;
    return _validTime(hour, minute, second);
  }

  final cnMatch = _chineseTimePattern.firstMatch(text);
  if (cnMatch != null) {
    var hour = int.tryParse(cnMatch.group(1)!);
    final hasHalf = cnMatch.group(2) == '半';
    final minute = hasHalf ? 30 : int.tryParse(cnMatch.group(3) ?? '0') ?? 0;
    final second = int.tryParse(cnMatch.group(4) ?? '0') ?? 0;
    if ((text.contains('下午') || text.contains('晚上')) &&
        hour != null &&
        hour < 12) {
      hour += 12;
    }
    if (text.contains('中午') && hour != null && hour < 11) {
      hour += 12;
    }
    return _validTime(hour, minute, second);
  }

  return null;
}

TimeOfDayLike? _validTime(int? hour, int? minute, int second) {
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23) return null;
  if (minute < 0 || minute > 59) return null;
  if (second < 0 || second > 59) return null;
  return TimeOfDayLike(hour, minute, second: second);
}

String? _extractTimeFromText(String text) {
  final colonMatch = RegExp(
    r'\d{1,2}[:：]\d{1,2}(?:[:：]\d{1,2})?',
  ).firstMatch(text);
  if (colonMatch != null) return colonMatch.group(0);
  final cnMatch = _chineseTimePattern.firstMatch(text);
  return cnMatch?.group(0);
}

final RegExp _chineseTimePattern = RegExp(
  r'(?:凌晨|早上|上午|中午|下午|晚上)?\s*(\d{1,2})\s*(?:点钟|时钟|点|时)(半|(?:(\d{1,2})\s*分?)?)?(?:(\d{1,2})\s*秒)?',
);

final List<RegExp> _timeExpressionPatterns = [
  RegExp(r'\d{1,2}[:：]\d{1,2}(?:[:：]\d{1,2})?'),
  _chineseTimePattern,
];

String _formatIsoDate(DateTime date) {
  final normalized = _dateOnly(date);
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day';
}

class _TodoTemplate {
  final String content;
  final int estimatedMinutes;

  const _TodoTemplate(this.content, this.estimatedMinutes);
}

final goalSplitNotifierProvider =
    StateNotifierProvider<GoalSplitNotifier, GoalSplitState>((ref) {
      final apiClient = ref.watch(deepseekApiClientProvider);
      final todoRepository = ref.watch(todoItemRepositoryProvider);
      final profileRepository = ref.watch(userProfileRepositoryProvider);
      return GoalSplitNotifier(apiClient, todoRepository, profileRepository);
    });
