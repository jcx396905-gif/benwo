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
  final bool isLocalGenerated;

  const GeneratedTodoItem({
    required this.content,
    required this.scheduledDate,
    required this.estimatedMinutes,
    this.isConfirmed = false,
    this.isLocalGenerated = false,
  });

  GeneratedTodoItem copyWith({
    String? content,
    DateTime? scheduledDate,
    int? estimatedMinutes,
    bool? isConfirmed,
    bool? isLocalGenerated,
  }) {
    return GeneratedTodoItem(
      content: content ?? this.content,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      isLocalGenerated: isLocalGenerated ?? this.isLocalGenerated,
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
const Duration _todoSplitTimeout = Duration(seconds: 25);
const Duration _goalSplitTimeout = Duration(seconds: 75);

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

  Future<bool> generateTodosForGoalStreaming(
    BigGoalModel goal, {
    int? desiredCount,
    DateTime? startDate,
  }) async {
    final baseDate = startDate ?? DateTime.now();
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      generatedTodos: const [],
      isCompleted: false,
    );

    try {
      final todos = <GeneratedTodoItem>[];
      var buffer = StringBuffer();
      final profile = await _loadProfile(goal.userId);
      await for (final chunk
          in _apiClient
              .streamPrompt(
                _buildGoalStreamingPrompt(
                  goal,
                  profile: profile,
                  desiredCount: desiredCount,
                  startDate: baseDate,
                ),
              )
              .timeout(_goalSplitTimeout)) {
        buffer.write(chunk);
        final parsed = _drainGoalTodoLines(buffer.toString(), goal, baseDate);
        buffer = StringBuffer(parsed.remaining);
        for (final todo in parsed.todos) {
          final sanitized = _sanitizeGeneratedTodos([
            todo,
          ], sourceText: '${goal.title} ${goal.description ?? ''}');
          if (sanitized.isEmpty) continue;
          final newTodo = sanitized.single;
          final key = newTodo.content.replaceAll(RegExp(r'\s+'), '');
          final exists = todos.any(
            (item) => item.content.replaceAll(RegExp(r'\s+'), '') == key,
          );
          if (exists) continue;
          todos.add(newTodo);
          state = state.copyWith(generatedTodos: List.unmodifiable(todos));
        }
      }

      final tail = _drainGoalTodoLines(
        '${buffer.toString()}\n',
        goal,
        baseDate,
      );
      for (final todo in tail.todos) {
        final sanitized = _sanitizeGeneratedTodos([
          todo,
        ], sourceText: '${goal.title} ${goal.description ?? ''}');
        if (sanitized.isEmpty) continue;
        todos.add(sanitized.single);
      }

      final limited = _limitGoalTodos(todos, goal, baseDate);
      if (limited.isEmpty) {
        throw const AiSplitException('AI 没有返回可用任务，请稍后重试。');
      }
      state = state.copyWith(
        isLoading: false,
        generatedTodos: List.unmodifiable(limited),
      );
      return true;
    } catch (e) {
      if (_isOfflineError(e)) {
        final todos = _generateLocalTodosForGoal(
          goal,
          desiredCount: desiredCount,
          startDate: baseDate,
        );
        state = state.copyWith(isLoading: false, generatedTodos: todos);
        return true;
      }
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

    return _generateCloudTodosFromText(
      trimmedInput,
      userId: userId,
      desiredCount: desiredCount,
      defaultDate: defaultDate,
    ).timeout(_todoSplitTimeout);
  }

  Future<List<GeneratedTodoItem>> _generateCloudTodosFromText(
    String trimmedInput, {
    required int userId,
    required DateTime defaultDate,
    int? desiredCount,
  }) async {
    final profile = await _loadProfile(userId);
    final prompts = [
      _buildFreeTextPrompt(
        trimmedInput,
        profile: profile,
        desiredCount: desiredCount,
        defaultDate: defaultDate,
      ),
      _buildFreeTextRetryPrompt(
        trimmedInput,
        profile: profile,
        desiredCount: desiredCount,
        defaultDate: defaultDate,
      ),
    ];

    for (final prompt in prompts) {
      final response = await _apiClient.simplePrompt(prompt, jsonMode: true);
      final parsed = _sanitizeGeneratedTodos(
        _parseFreeTextResponse(response, defaultDate),
        sourceText: trimmedInput,
      );
      if (parsed.isNotEmpty) {
        return _limitTodos(parsed, desiredCount);
      }
    }
    throw const AiSplitException('AI 没有返回可用待办，请换一种更具体的写法再试。');
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
          .timeout(_goalSplitTimeout);
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
用户画像:
${_formatProfile(profile)}
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
5. Use the user profile from the app to adjust task difficulty, tone, timing, and workload. If profile fields are missing, do not invent them.
6. dayOffset is an integer from 0 to $maxDays.
7. content must be a concrete action that can be done that day. Do not write generic text such as "split the goal into steps", "complete today's smallest action", "record progress and blockers", or "adjust the next plan".
8. estimatedMinutes must be an integer, usually 10 to 180.
9. If the user gave an exact time, return time as HH:mm or HH:mm:ss. Otherwise return null.
10. Return JSON only, no Markdown, no explanation.

JSON shape:
{"todos":[{"content":"\u4efb\u52a1\u5185\u5bb9","dayOffset":0,"time":"09:30","estimatedMinutes":30}]}
''';
  }

  String _buildGoalStreamingPrompt(
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
        : '无';
    final category = goal.category?.trim().isNotEmpty == true
        ? goal.category!.trim()
        : '未分类';

    return '''
You are a careful long-term goal planning assistant.
Stream the user's BIG GOAL into concrete calendar todos. Return task content in the same language as the user's goal.

Goal title: ${goal.title}
Goal description: $description
Goal category: $category
用户画像:
${_formatProfile(profile)}
Today: ${_formatIsoDate(today)}
Start date: ${_formatIsoDate(baseDate)}
Target date: ${_formatIsoDate(targetDate)}
Plan days: ${maxDays + 1}
Desired task count: ${_describeDesiredCount(desiredCount)}

Rules:
1. Output one todo per line as soon as it is ready.
2. Each line must be a standalone JSON object. Do not wrap lines in an array or Markdown.
3. JSON line shape: {"content":"任务内容","dayOffset":0,"time":null,"estimatedMinutes":30}
4. Every task must be directly related to the goal topic and concrete enough to do that day.
5. If desired task count is AI auto, generate one todo for every calendar day from start date to target date, inclusive. If the user selected a count, generate exactly that many todos and distribute them across dates.
6. dayOffset is an integer from 0 to $maxDays.
7. Do not output generic planning filler.
''';
  }

  String _buildFreeTextRetryPrompt(
    String input, {
    required UserProfileModel? profile,
    required DateTime defaultDate,
    int? desiredCount,
  }) {
    final today = _dateOnly(DateTime.now());
    final baseDate = _dateOnly(defaultDate);

    return '''
You are fixing a failed todo split. Return valid JSON only.

Today: ${_formatIsoDate(today)}
Default date: ${_formatIsoDate(baseDate)}
Desired task count: ${_describeDesiredCount(desiredCount)}
用户画像:
${_formatProfile(profile)}
User input: $input

Critical rules:
1. You must return at least one usable todo.
2. If the input contains more than one action or object, split them into separate todos.
3. Do not return an empty todos array.
4. Do not wrap the result in Markdown.
5. content must contain only the action, without date or time words.
6. If the user mentions a clock time such as "10点钟", "下午3点半", "18:20", or "晚上九点", convert it to 24-hour HH:mm in time.
7. Use this exact JSON shape:
{"todos":[{"content":"待办内容","date":"${_formatIsoDate(baseDate)}","time":null,"estimatedMinutes":30}]}
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
用户画像:
${_formatProfile(profile)}
User input: $input

Required JSON format:
{
  "todos": [
    {
      "content": "待办内容，不包含日期和时间",
      "date": "YYYY-MM-DD",
      "time": "HH:mm 或 HH:mm:ss；没有明确时间则为 null",
      "estimatedMinutes": 30
    }
  ]
}

Rules:
1. This is TODO splitting, not long-term goal splitting. Generate todos for today or the user-specified date only.
2. If the input contains multiple tasks, multiple actions, multiple steps, multiple places, multiple objects, or multiple exact times, split them into separate todos. Do not merge unrelated actions into one todo.
3. Treat list-like text as multiple todos, including items connected by punctuation, spaces, "和", "与", "并", "以及", "然后", "再", "and", "then", or "also".
4. If AI auto is selected, infer the todo count from the actual number of actionable items. If there are multiple actionable items, return at least 2 todos.
5. If the input is truly one simple intent, create one todo.
6. If the user selected a fixed desired task count, try to generate exactly that many todos when the input has enough actionable information. Do not invent unrelated tasks just to fill the count.
7. If the user mentions several exact times, create one todo for each time and preserve the exact time in the matching todo.
8. Use the user profile from the app to adjust task difficulty, tone, timing, and workload. Do not expose profile details in the todo content.
9. Return date as YYYY-MM-DD.
10. If the user mentions an exact time, convert it to 24-hour HH:mm or HH:mm:ss. Examples: "10点钟" -> "10:00", "下午3点半" -> "15:30", "晚上九点" -> "21:00", "18:20" -> "18:20". Otherwise return null.
11. content must be a natural action without date/time words. For "我10点钟要睡觉", content is "睡觉", time is "10:00".
12. Return JSON only, no Markdown, no explanation.

Examples:
Input: 我 10 点钟要睡觉
Output: {"todos":[{"content":"睡觉","date":"${_formatIsoDate(baseDate)}","time":"10:00","estimatedMinutes":30}]}
Input: 上午9点写作业，下午3点半去健身，晚上8点背单词
Output: {"todos":[{"content":"写作业","date":"${_formatIsoDate(baseDate)}","time":"09:00","estimatedMinutes":30},{"content":"去健身","date":"${_formatIsoDate(baseDate)}","time":"15:30","estimatedMinutes":60},{"content":"背单词","date":"${_formatIsoDate(baseDate)}","time":"20:00","estimatedMinutes":30}]}
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
        final fallbackTimeText = _extractTimeFromText(content);
        final rawMinutes = item['estimatedMinutes'];
        final estimatedMinutes = rawMinutes is num
            ? rawMinutes.toInt().clamp(10, 240)
            : 30;

        todos.add(
          GeneratedTodoItem(
            content: content,
            scheduledDate: _combineDateAndTime(
              parsedDate ?? fallbackDate,
              _effectiveTimeText(timeText, fallbackTimeText),
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

  ({List<GeneratedTodoItem> todos, String remaining}) _drainGoalTodoLines(
    String buffer,
    BigGoalModel goal,
    DateTime startDate,
  ) {
    final todos = <GeneratedTodoItem>[];
    var remaining = buffer;
    while (true) {
      final lineEnd = remaining.indexOf('\n');
      if (lineEnd < 0) break;
      final line = remaining.substring(0, lineEnd).trim();
      remaining = remaining.substring(lineEnd + 1);
      if (line.isEmpty) continue;
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(line);
      if (jsonMatch == null) continue;
      try {
        final decoded = jsonDecode(jsonMatch.group(0)!);
        if (decoded is! Map<String, dynamic>) continue;
        final todo = _parseGoalTodoItem(decoded, goal, startDate);
        if (todo != null) todos.add(todo);
      } catch (_) {
        continue;
      }
    }
    return (todos: todos, remaining: remaining);
  }

  GeneratedTodoItem? _parseGoalTodoItem(
    Map<String, dynamic> item,
    BigGoalModel goal,
    DateTime startDate,
  ) {
    final content = item['content']?.toString().trim();
    if (content == null || content.isEmpty) return null;

    final baseDate = _dateOnly(startDate);
    final maxOffset = _dateOnly(
      goal.targetDate,
    ).difference(baseDate).inDays.clamp(1, 3650);
    final rawOffset = item['dayOffset'];
    final rawMinutes = item['estimatedMinutes'];
    final timeText = item['time']?.toString();
    final dayOffset = rawOffset is num
        ? rawOffset.toInt().clamp(0, maxOffset)
        : 0;
    final estimatedMinutes = rawMinutes is num
        ? rawMinutes.toInt().clamp(10, 240)
        : 30;

    return GeneratedTodoItem(
      content: content,
      scheduledDate: _combineDateAndTime(
        baseDate.add(Duration(days: dayOffset)),
        timeText,
      ),
      estimatedMinutes: estimatedMinutes,
    );
  }

  Map<String, dynamic> _decodeTodosJson(String response) {
    final jsonMatch = RegExp(r'\{[\s\S]*"todos"[\s\S]*\}').firstMatch(response);
    final arrayMatch = RegExp(r'\[[\s\S]*\]').firstMatch(response);
    final decoded = jsonDecode(
      jsonMatch?.group(0) ?? arrayMatch?.group(0) ?? response,
    );
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is List) return {'todos': decoded};
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
    final step = (daysUntilTarget / taskCount).ceil().clamp(1, 30);
    final fallbackTime = _extractTimeFromText(
      '${goal.title} ${goal.description ?? ''}',
    );
    final content = goal.title.trim().isEmpty ? '推进这个目标' : goal.title.trim();

    return List.generate(taskCount, (index) {
      final dayOffset = desiredCount == null
          ? index.clamp(0, daysUntilTarget)
          : (index * step).clamp(0, daysUntilTarget);
      return GeneratedTodoItem(
        content: desiredCount == null ? '第${index + 1}天：$content' : content,
        scheduledDate: _combineDateAndTime(
          baseDate.add(Duration(days: dayOffset)),
          fallbackTime,
        ),
        estimatedMinutes: 30,
        isLocalGenerated: true,
      );
    });
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

  static const int _maxGoalPlanTodos = 366;

  String _describeDesiredCount(int? desiredCount) {
    return desiredCount == null
        ? '\u0041\u0049 \u81ea\u52a8\u9009\u62e9'
        : '$desiredCount';
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }

  String _normalizeTodoContent(String content) {
    var normalized = content.trim();
    normalized = normalized.replaceFirst(
      RegExp(r'^第?[一二三四五六七八九十\d]+[步项]?[、.。:：)]*\s*'),
      '',
    );
    normalized = normalized.replaceFirst(
      RegExp(r'^(我选择|我决定|我将要|我要|我需要|我打算|要)\s*'),
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
    if (compactContent.length <= 2) {
      return compactSource.isNotEmpty &&
          !compactSource.contains(compactContent);
    }
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
    if (profile == null) return '- 未读取到用户画像';
    final parts = <String>[
      '- 姓名：${profile.name}',
      if (profile.age != null) '- 年龄：${profile.age}',
      if (profile.occupation?.isNotEmpty == true)
        '- 职业/身份：${profile.occupation}',
      if (profile.region?.isNotEmpty == true) '- 所在地区：${profile.region}',
      if (profile.mbti?.isNotEmpty == true) '- MBTI：${profile.mbti}',
      if (profile.communicationStyle?.isNotEmpty == true)
        '- 沟通风格：${profile.communicationStyle}',
      if (profile.motivationSensitivity?.isNotEmpty == true)
        '- 激励敏感度：${profile.motivationSensitivity}',
      if (profile.bestWorkTime?.isNotEmpty == true)
        '- 最适合的工作时间：${profile.bestWorkTime}',
      if (profile.stressResponse?.isNotEmpty == true)
        '- 压力下的应对偏好：${profile.stressResponse}',
      if (profile.socialPreference?.isNotEmpty == true)
        '- 协作偏好：${profile.socialPreference}',
      if (profile.lifeStatus?.isNotEmpty == true)
        '- 当前生活状态：${profile.lifeStatus}',
      if (profile.challenges?.isNotEmpty == true)
        '- 当前主要挑战：${profile.challenges}',
      if (profile.changeTimeframeMonths != null)
        '- 期望改变周期：${profile.changeTimeframeMonths}个月',
      if (profile.threeChanges?.isNotEmpty == true)
        '- 最想改变的三件事：${profile.threeChanges}',
    ];
    if (parts.isEmpty) return '- 用户画像为空';
    return parts.join('\n');
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

String? _effectiveTimeText(String? primary, String? fallback) {
  final normalizedPrimary = primary?.trim();
  if (normalizedPrimary != null &&
      normalizedPrimary.isNotEmpty &&
      normalizedPrimary.toLowerCase() != 'null') {
    return normalizedPrimary;
  }
  return fallback;
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
    var hour =
        int.tryParse(cnMatch.group(1)!) ??
        _parseChineseNumber(cnMatch.group(1)!);
    final hasHalf = cnMatch.group(2) == '半';
    final minuteText = cnMatch.group(3);
    final secondText = cnMatch.group(4);
    final minute = hasHalf
        ? 30
        : minuteText == null
        ? 0
        : int.tryParse(minuteText) ?? _parseChineseNumber(minuteText) ?? 0;
    final second = secondText == null
        ? 0
        : int.tryParse(secondText) ?? _parseChineseNumber(secondText) ?? 0;
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

int? _parseChineseNumber(String text) {
  final normalized = text.trim();
  if (normalized.isEmpty) return null;
  const digits = {
    '零': 0,
    '〇': 0,
    '一': 1,
    '二': 2,
    '两': 2,
    '三': 3,
    '四': 4,
    '五': 5,
    '六': 6,
    '七': 7,
    '八': 8,
    '九': 9,
  };
  if (digits.containsKey(normalized)) return digits[normalized];
  if (normalized == '十') return 10;
  if (normalized.startsWith('十')) {
    final ones = normalized.substring(1);
    return 10 + (digits[ones] ?? 0);
  }
  final tenIndex = normalized.indexOf('十');
  if (tenIndex > 0) {
    final tens = digits[normalized.substring(0, tenIndex)];
    if (tens == null) return null;
    final onesText = normalized.substring(tenIndex + 1);
    return tens * 10 + (onesText.isEmpty ? 0 : digits[onesText] ?? 0);
  }
  return null;
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
  r'(?:凌晨|早上|上午|中午|下午|晚上)?\s*([零〇一二两三四五六七八九十\d]{1,3})\s*(?:点钟|时钟|点|时)(半|(?:([零〇一二两三四五六七八九十\d]{1,3})\s*分?)?)?(?:([零〇一二两三四五六七八九十\d]{1,3})\s*秒)?',
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

final goalSplitNotifierProvider =
    StateNotifierProvider<GoalSplitNotifier, GoalSplitState>((ref) {
      final apiClient = ref.watch(deepseekApiClientProvider);
      final todoRepository = ref.watch(todoItemRepositoryProvider);
      final profileRepository = ref.watch(userProfileRepositoryProvider);
      return GoalSplitNotifier(apiClient, todoRepository, profileRepository);
    });
