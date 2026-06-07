import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection.dart';
import '../../data/models/big_goal_model.dart';
import '../../data/repositories/todo_item_repository.dart';

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
  GoalSplitNotifier(this._apiClient, this._todoRepository)
    : super(const GoalSplitState());

  final DeepSeekApiClient _apiClient;
  final TodoItemRepository _todoRepository;

  Future<bool> generateTodosForGoal(BigGoalModel goal) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      generatedTodos: const [],
      isCompleted: false,
    );

    try {
      final todos = await _generateTodosWithAI(goal);
      state = state.copyWith(isLoading: false, generatedTodos: todos);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '生成任务失败：$e');
      return false;
    }
  }

  Future<List<GeneratedTodoItem>> _generateTodosWithAI(
    BigGoalModel goal,
  ) async {
    try {
      final response = await _apiClient.simplePrompt(
        _buildSplitPrompt(goal),
        jsonMode: true,
      );

      if (response.trim().isNotEmpty) {
        final parsed = _parseAIResponse(response, goal);
        if (parsed.isNotEmpty) {
          return parsed;
        }
      }
    } catch (_) {
      // Keep the core flow usable when network, quota, or the API key fails.
    }

    return _generateLocalTodos(goal);
  }

  String _buildSplitPrompt(BigGoalModel goal) {
    final today = _dateOnly(DateTime.now());
    final targetDate = _dateOnly(goal.targetDate);
    final daysUntilTarget = targetDate.difference(today).inDays.clamp(1, 3650);
    final weeks = (daysUntilTarget / 7).ceil();
    final description = goal.description?.trim().isEmpty == false
        ? goal.description!.trim()
        : '无';
    final category = goal.category?.trim().isEmpty == false
        ? goal.category!.trim()
        : '未分类';

    return '''
你是一个严谨的目标拆解助手。请把用户的大目标拆成具体、可执行、适合放进日历的任务。

目标标题：${goal.title}
目标描述：$description
目标分类：$category
目标完成日期：${targetDate.year}-${targetDate.month}-${targetDate.day}
剩余时间：约 $daysUntilTarget 天，约 $weeks 周

要求：
1. 生成 3 到 10 个任务。
2. 每个任务必须具体、可执行，避免空泛口号。
3. dayOffset 表示从今天开始第几天执行，必须是整数，最小 0，不能超过 $daysUntilTarget。
4. estimatedMinutes 必须是整数，建议 10 到 180。
5. 只返回 JSON，不要 Markdown，不要解释文字。

JSON 格式必须严格如下：
{
  "todos": [
    {
      "content": "任务内容",
      "dayOffset": 0,
      "estimatedMinutes": 30
    }
  ]
}
''';
  }

  List<GeneratedTodoItem> _parseAIResponse(String response, BigGoalModel goal) {
    try {
      final jsonMatch = RegExp(
        r'\{[\s\S]*"todos"[\s\S]*\}',
      ).firstMatch(response);
      final decoded = jsonDecode(jsonMatch?.group(0) ?? response);
      if (decoded is! Map<String, dynamic>) return const [];

      final todosJson = decoded['todos'];
      if (todosJson is! List) return const [];

      final today = _dateOnly(DateTime.now());
      final maxOffset = _dateOnly(
        goal.targetDate,
      ).difference(today).inDays.clamp(1, 3650);
      final todos = <GeneratedTodoItem>[];

      for (final item in todosJson) {
        if (item is! Map<String, dynamic>) continue;

        final content = item['content']?.toString().trim();
        if (content == null || content.isEmpty) continue;

        final rawOffset = item['dayOffset'];
        final rawMinutes = item['estimatedMinutes'];
        final dayOffset = rawOffset is num
            ? rawOffset.toInt().clamp(0, maxOffset)
            : 0;
        final estimatedMinutes = rawMinutes is num
            ? rawMinutes.toInt().clamp(10, 240)
            : 30;

        todos.add(
          GeneratedTodoItem(
            content: content,
            scheduledDate: today.add(Duration(days: dayOffset)),
            estimatedMinutes: estimatedMinutes,
          ),
        );
      }

      return todos.take(20).toList();
    } catch (_) {
      return const [];
    }
  }

  List<GeneratedTodoItem> _generateLocalTodos(BigGoalModel goal) {
    final today = _dateOnly(DateTime.now());
    final daysUntilTarget = _dateOnly(
      goal.targetDate,
    ).difference(today).inDays.clamp(1, 3650);
    final taskCount = (daysUntilTarget / 7).ceil().clamp(3, 10);
    final templates = _getTaskTemplatesForGoal(goal);

    return List.generate(taskCount, (index) {
      final template = templates[index % templates.length];
      final dayOffset = (index * 7).clamp(0, daysUntilTarget);
      return GeneratedTodoItem(
        content: template.content,
        scheduledDate: today.add(Duration(days: dayOffset)),
        estimatedMinutes: template.estimatedMinutes,
      );
    });
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
    updatedTodos[index] = updatedTodos[index].copyWith(
      scheduledDate: _dateOnly(date),
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
        await _todoRepository.createTodo(
          userId: goal.userId,
          content: todo.content,
          goalId: goal.id,
          isAIGenerated: true,
          scheduledDate: _dateOnly(todo.scheduledDate),
          estimatedMinutes: todo.estimatedMinutes,
          color: goal.color,
        );
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
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

class _TodoTemplate {
  final String content;
  final int estimatedMinutes;

  const _TodoTemplate(this.content, this.estimatedMinutes);
}

final goalSplitNotifierProvider =
    StateNotifierProvider<GoalSplitNotifier, GoalSplitState>((ref) {
      final apiClient = ref.watch(deepseekApiClientProvider);
      final todoRepository = ref.watch(todoItemRepositoryProvider);
      return GoalSplitNotifier(apiClient, todoRepository);
    });
