import 'dart:convert';

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

  const TimeOfDayLike(this.hour, this.minute);
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
      state = state.copyWith(isLoading: false, errorMessage: '生成任务失败：$e');
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
      final response = await _apiClient.simplePrompt(
        _buildFreeTextPrompt(
          trimmedInput,
          profile: await _loadProfile(userId),
          desiredCount: desiredCount,
          defaultDate: defaultDate,
        ),
        jsonMode: true,
      );
      final parsed = _parseFreeTextResponse(response, defaultDate);
      if (parsed.isNotEmpty) {
        return _limitTodos(parsed, desiredCount);
      }
    } catch (_) {
      // Keep the add flow usable when the network/API is unavailable.
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
      final response = await _apiClient.simplePrompt(
        _buildGoalPrompt(
          goal,
          profile: await _loadProfile(goal.userId),
          desiredCount: desiredCount,
          startDate: startDate,
        ),
        jsonMode: true,
      );
      final parsed = _parseGoalResponse(response, goal, startDate);
      if (parsed.isNotEmpty) {
        return _limitTodos(parsed, desiredCount);
      }
    } catch (_) {
      // Local fallback keeps basic goal splitting available.
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
        : '无';
    final category = goal.category?.trim().isNotEmpty == true
        ? goal.category!.trim()
        : '未分类';

    return '''
你是一个严谨的目标拆分助手。请把用户的大目标拆成具体、可执行、适合放进日历的任务。
目标标题：${goal.title}
目标描述：$description
目标分类：$category
用户画像：${_formatProfile(profile)}
今天日期：${_formatIsoDate(today)}
拆分起始日期：${_formatIsoDate(baseDate)}
目标完成日期：${_formatIsoDate(targetDate)}
期望任务数量：${_describeDesiredCount(desiredCount)}

要求：
1. 如果给定了期望数量，请生成接近该数量的任务；如果是 AI 自动选择，请根据目标复杂度生成 3 到 10 个任务。
2. 每个任务必须具体、可执行，避免空泛口号。
3. dayOffset 表示从“拆分起始日期”开始第几天执行，必须是整数，最小 0，最大 $maxDays。
4. estimatedMinutes 必须是整数，建议 10 到 180。
5. 如果任务适合安排到具体几点几分，请返回 time，格式为 HH:mm；不确定则返回 null。
6. 拆分时请参考用户画像，让任务粒度、提醒时间和表达方式更贴合用户。
7. 只返回 JSON，不要 Markdown，不要解释文字。

JSON 格式：
{
  "todos": [
    {
      "content": "任务内容",
      "dayOffset": 0,
      "time": "09:30",
      "estimatedMinutes": 30
    }
  ]
}
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
你是一个待办拆分助手。请把用户输入的一段话拆成当天或未来日期的待办任务，并尽量识别自然语言日期。
今天日期：${_formatIsoDate(today)}
默认安排日期：${_formatIsoDate(baseDate)}
期望任务数量：${_describeDesiredCount(desiredCount)}
用户画像：${_formatProfile(profile)}
用户输入：$input

要求：
1. 如果给定了期望数量，请生成接近该数量的待办；如果是 AI 自动选择，请根据输入复杂度生成 2 到 10 个待办。
2. 如果用户提到“今天、明天、后天、周几、具体日期”，请把任务安排到对应日期；无法判断日期时使用默认安排日期。
3. 每个任务给出 date，格式为 YYYY-MM-DD。
4. 如果用户提到具体时间（例如 09:30、下午3点、18点20分、几分几秒），请给出 time，格式 HH:mm；没有明确时间则返回 null。
5. 每个任务给出 estimatedMinutes，建议 10 到 180。
6. 请参考用户画像做个性化拆分和时间安排。
7. 只返回 JSON，不要 Markdown，不要解释文字。

JSON 格式：
{
  "todos": [
    {
      "content": "待办内容",
      "date": "${_formatIsoDate(baseDate)}",
      "time": "09:30",
      "estimatedMinutes": 30
    }
  ]
}
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

      return todos.take(20).toList();
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
    final taskCount = _resolveDesiredCount(desiredCount, fallback: 6);
    final templates = _getTaskTemplatesForGoal(goal);
    final step = (daysUntilTarget / taskCount).ceil().clamp(1, 30);

    return List.generate(taskCount, (index) {
      final template = templates[index % templates.length];
      final dayOffset = (index * step).clamp(0, daysUntilTarget);
      return GeneratedTodoItem(
        content: template.content,
        scheduledDate: baseDate.add(Duration(days: dayOffset)),
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
        .split(RegExp(r'[\n，,。；;、]+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    final fallbackParts = parts.isEmpty ? [input] : parts;
    final taskCount = _resolveDesiredCount(
      desiredCount,
      fallback: fallbackParts.length.clamp(2, 6),
    );

    return List.generate(taskCount, (index) {
      final raw = fallbackParts[index % fallbackParts.length];
      final content = fallbackParts.length == 1 && taskCount > 1
          ? '$raw - 第 ${index + 1} 步'
          : raw;
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

  List<GeneratedTodoItem> _limitTodos(
    List<GeneratedTodoItem> todos,
    int? desiredCount,
  ) {
    final limit = desiredCount?.clamp(1, 20);
    return limit == null ? todos.take(20).toList() : todos.take(limit).toList();
  }

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

    if (_containsAny(text, ['学习', '考试', '课程', '读书', '英语', '数学'])) {
      return const [
        _TodoTemplate('整理当前学习资料并列出重点', 30),
        _TodoTemplate('完成一组练习题并记录错题', 60),
        _TodoTemplate('复盘本周学习内容', 45),
        _TodoTemplate('预习下一阶段内容', 30),
      ];
    }

    if (_containsAny(text, ['健康', '运动', '减脂', '健身', '跑步'])) {
      return const [
        _TodoTemplate('完成 30 分钟有氧运动', 45),
        _TodoTemplate('完成一组力量训练', 30),
        _TodoTemplate('记录饮食和饮水情况', 10),
        _TodoTemplate('提前准备一份健康餐', 40),
      ];
    }

    if (_containsAny(text, ['工作', '职业', '项目', '技能', '开发', '代码'])) {
      return const [
        _TodoTemplate('明确本阶段最重要的交付物', 30),
        _TodoTemplate('完成一个关键工作任务', 90),
        _TodoTemplate('复盘流程并记录改进点', 30),
        _TodoTemplate('学习一个相关行业知识点', 45),
      ];
    }

    if (_containsAny(text, ['财务', '存钱', '理财', '预算'])) {
      return const [
        _TodoTemplate('记录今日收入和支出', 10),
        _TodoTemplate('检查预算执行情况', 30),
        _TodoTemplate('整理一个可削减的开支项', 20),
        _TodoTemplate('学习一个理财知识点', 45),
      ];
    }

    return const [
      _TodoTemplate('把目标拆成三个可执行的小步骤', 30),
      _TodoTemplate('完成今天的最小可行动作', 30),
      _TodoTemplate('记录进展和遇到的阻碍', 20),
      _TodoTemplate('调整下一步计划', 20),
    ];
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
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
      state = state.copyWith(errorMessage: '没有可保存的任务。');
      return false;
    }

    final hasUnconfirmedTodos = state.generatedTodos.any(
      (todo) => !todo.isConfirmed,
    );
    if (hasUnconfirmedTodos) {
      state = state.copyWith(errorMessage: '请先确认所有任务。');
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
      state = state.copyWith(isLoading: false, errorMessage: '保存失败：$e');
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
    if (profile == null) return '暂无画像';
    final parts = <String>[
      '姓名:${profile.name}',
      if (profile.age != null) '年龄:${profile.age}',
      if (profile.occupation?.isNotEmpty == true) '职业:${profile.occupation}',
      if (profile.mbti?.isNotEmpty == true) 'MBTI:${profile.mbti}',
      if (profile.communicationStyle?.isNotEmpty == true)
        '沟通偏好:${profile.communicationStyle}',
      if (profile.motivationSensitivity?.isNotEmpty == true)
        '激励敏感度:${profile.motivationSensitivity}',
      if (profile.bestWorkTime?.isNotEmpty == true)
        '最佳工作时间:${profile.bestWorkTime}',
      if (profile.stressResponse?.isNotEmpty == true)
        '压力反应:${profile.stressResponse}',
      if (profile.socialPreference?.isNotEmpty == true)
        '协作偏好:${profile.socialPreference}',
      if (profile.lifeStatus?.isNotEmpty == true) '生活状态:${profile.lifeStatus}',
      if (profile.challenges?.isNotEmpty == true) '挑战:${profile.challenges}',
      if (profile.threeChanges?.isNotEmpty == true)
        '想改变:${profile.threeChanges}',
    ];
    return parts.join('；');
  }
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _combineDateAndTime(DateTime date, String? timeText) {
  final time = _parseTimeText(timeText);
  if (time == null) return date;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

TimeOfDayLike? _parseTimeText(String? raw) {
  if (raw == null) return null;
  final text = raw.trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;

  final colonMatch = RegExp(r'(\d{1,2})[:：](\d{1,2})').firstMatch(text);
  if (colonMatch != null) {
    final hour = int.tryParse(colonMatch.group(1)!);
    final minute = int.tryParse(colonMatch.group(2)!);
    return _validTime(hour, minute);
  }

  final cnMatch = RegExp(
    r'(\d{1,2})\s*(?:点|時|时)(?:(\d{1,2})\s*分?)?',
  ).firstMatch(text);
  if (cnMatch != null) {
    var hour = int.tryParse(cnMatch.group(1)!);
    final minute = int.tryParse(cnMatch.group(2) ?? '0') ?? 0;
    if ((text.contains('下午') || text.contains('晚上')) &&
        hour != null &&
        hour < 12) {
      hour += 12;
    }
    if (text.contains('中午') && hour != null && hour < 11) {
      hour += 12;
    }
    return _validTime(hour, minute);
  }

  return null;
}

TimeOfDayLike? _validTime(int? hour, int? minute) {
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  return TimeOfDayLike(hour, minute);
}

String? _extractTimeFromText(String text) {
  final colonMatch = RegExp(r'\d{1,2}[:：]\d{1,2}').firstMatch(text);
  if (colonMatch != null) return colonMatch.group(0);
  final cnMatch = RegExp(
    r'(?:上午|中午|下午|晚上|早上)?\s*\d{1,2}\s*(?:点|時|时)(?:\d{1,2}\s*分?)?',
  ).firstMatch(text);
  return cnMatch?.group(0);
}

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
