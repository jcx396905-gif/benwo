import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection.dart';
import '../../data/models/big_goal_model.dart';
import '../../data/repositories/todo_item_repository.dart';

/// Represents a single generated todo item during AI splitting
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

/// State for goal split process
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
    String? errorMessage,
    List<GeneratedTodoItem>? generatedTodos,
    bool? isCompleted,
  }) {
    return GoalSplitState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      generatedTodos: generatedTodos ?? this.generatedTodos,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Goal Split Notifier - Riverpod StateNotifier for AI goal decomposition
class GoalSplitNotifier extends StateNotifier<GoalSplitState> {
  final MinMaxApiClient _apiClient;
  final TodoItemRepository _todoRepository;

  GoalSplitNotifier(
    this._apiClient,
    this._todoRepository,
  ) : super(const GoalSplitState());

  /// Generate todo items for a goal using AI
  Future<bool> generateTodosForGoal(BigGoalModel goal) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Generate todos using AI (or mock data for now)
      final todos = await _generateTodosWithAI(goal);

      state = state.copyWith(
        isLoading: false,
        generatedTodos: todos,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '生成任务失败：${e.toString()}',
      );
      return false;
    }
  }

  /// Generate todos using AI - uses mock data for now
  Future<List<GeneratedTodoItem>> _generateTodosWithAI(BigGoalModel goal) async {
    // Try to use MinMax API first
    try {
      final prompt = _buildSplitPrompt(goal);
      final response = await _apiClient.simplePrompt(prompt);

      if (response.isNotEmpty) {
        return _parseAIResponse(response, goal);
      }
    } catch (e) {
      // Fall back to mock data if API fails
    }

    // Use mock data for demonstration
    return _generateMockTodos(goal);
  }

  /// Build prompt for AI to split goal into todos
  String _buildSplitPrompt(BigGoalModel goal) {
    final daysUntilTarget = goal.targetDate.difference(DateTime.now()).inDays;
    final weeks = (daysUntilTarget / 7).ceil();

    return '''
请将以下大目标拆分为具体的每日任务：

目标：${goal.title}
描述：${goal.description ?? '无'}
目标完成日期：${goal.targetDate.year}年${goal.targetDate.month}月${goal.targetDate.day}日
剩余天数：约$daysUntilTarget 天（约$weeks 周）

请生成具体的每日任务列表，每个任务需要：
1. 任务内容（具体可执行）
2. 预计完成时间（分钟）
3. 建议的执行日期

请以JSON格式返回，格式如下：
{
  "todos": [
    {"content": "任务内容", "dayOffset": 0, "estimatedMinutes": 30},
    ...
  ]
}

只返回JSON，不要有其他文字。
''';
  }

  /// Parse AI response into GeneratedTodoItem list
  List<GeneratedTodoItem> _parseAIResponse(String response, BigGoalModel goal) {
    // Try to extract JSON from response
    try {
      // Find JSON in response
      final jsonMatch = RegExp(r'\{[\s\S]*"todos"[\s\S]*\}').firstMatch(response);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        // Simple JSON parsing - in production, use proper JSON library
        return _parseMockJsonStructure(jsonStr, goal);
      }
    } catch (e) {
      // Fall back to mock
    }

    return _generateMockTodos(goal);
  }

  /// Parse mock JSON structure
  List<GeneratedTodoItem> _parseMockJsonStructure(String jsonStr, BigGoalModel goal) {
    // This is a simplified parser - in production use dart:convert
    final todos = <GeneratedTodoItem>[];
    final todoMatches = RegExp(r'\{"content":\s*"([^"]+)",\s*"dayOffset":\s*(\d+),\s*"estimatedMinutes":\s*(\d+)\}')
        .allMatches(jsonStr);

    final startDate = DateTime.now();

    for (final match in todoMatches) {
      final content = match.group(1)!;
      final dayOffset = int.parse(match.group(2)!);
      final estimatedMinutes = int.parse(match.group(3)!);

      todos.add(GeneratedTodoItem(
        content: content,
        scheduledDate: startDate.add(Duration(days: dayOffset)),
        estimatedMinutes: estimatedMinutes,
      ));
    }

    return todos.isEmpty ? _generateMockTodos(goal) : todos;
  }

  /// Generate mock todos for demonstration
  List<GeneratedTodoItem> _generateMockTodos(BigGoalModel goal) {
    final todos = <GeneratedTodoItem>[];
    final startDate = DateTime.now();
    final daysUntilTarget = goal.targetDate.difference(startDate).inDays;

    // Generate approximately one task per week
    final taskCount = (daysUntilTarget / 7).ceil().clamp(3, 10);

    // Sample task templates based on common goal patterns
    final templates = _getTaskTemplatesForGoal(goal);

    for (var i = 0; i < taskCount; i++) {
      final template = templates[i % templates.length];
      final scheduledDate = startDate.add(Duration(days: (i * 7).clamp(0, daysUntilTarget)));

      todos.add(GeneratedTodoItem(
        content: template['content']!,
        scheduledDate: scheduledDate,
        estimatedMinutes: int.parse(template['minutes']!),
      ));
    }

    return todos;
  }

  /// Get task templates based on goal category
  List<Map<String, String>> _getTaskTemplatesForGoal(BigGoalModel goal) {
    final category = goal.category ?? '个人成长';

    // Templates organized by category
    final templatesByCategory = {
      '学业': [
        {'content': '复习本周学习内容，整理笔记', 'minutes': '45'},
        {'content': '完成课后习题，检验理解程度', 'minutes': '60'},
        {'content': '预习下周课程内容，标记难点', 'minutes': '30'},
        {'content': '阅读相关参考书籍章节', 'minutes': '45'},
        {'content': '整理错题本，分析错误原因', 'minutes': '40'},
        {'content': '与同学讨论学习问题', 'minutes': '30'},
        {'content': '制定下周学习计划', 'minutes': '20'},
      ],
      '职业': [
        {'content': '完成今日主要工作任务', 'minutes': '120'},
        {'content': '学习行业相关新知识', 'minutes': '45'},
        {'content': '整理工作文档，优化流程', 'minutes': '60'},
        {'content': '与同事沟通协作事项', 'minutes': '30'},
        {'content': '反思工作方法，寻找改进点', 'minutes': '30'},
        {'content': '更新工作进度记录', 'minutes': '15'},
      ],
      '健康': [
        {'content': '进行30分钟有氧运动', 'minutes': '45'},
        {'content': '做一组力量训练', 'minutes': '30'},
        {'content': '练习冥想或深呼吸', 'minutes': '15'},
        {'content': '准备健康餐食', 'minutes': '40'},
        {'content': '早睡保证7-8小时睡眠', 'minutes': '10'},
        {'content': '记录饮食和运动情况', 'minutes': '10'},
      ],
      '关系': [
        {'content': '给家人打电话问候', 'minutes': '20'},
        {'content': '安排与朋友见面', 'minutes': '15'},
        {'content': '参加社交活动', 'minutes': '120'},
        {'content': '主动联系久未联系的朋友', 'minutes': '15'},
        {'content': '准备礼物或惊喜', 'minutes': '45'},
        {'content': '倾听并关心他人', 'minutes': '30'},
      ],
      '个人成长': [
        {'content': '阅读书籍30页', 'minutes': '45'},
        {'content': '练习新技能1小时', 'minutes': '60'},
        {'content': '写日记反思今日', 'minutes': '20'},
        {'content': '学习在线课程', 'minutes': '45'},
        {'content': '设定明日目标', 'minutes': '10'},
        {'content': '培养一个新习惯', 'minutes': '15'},
      ],
      '财务': [
        {'content': '记录今日支出', 'minutes': '10'},
        {'content': '分析预算执行情况', 'minutes': '30'},
        {'content': '学习理财知识', 'minutes': '45'},
        {'content': '检查储蓄进度', 'minutes': '15'},
        {'content': '研究投资机会', 'minutes': '45'},
      ],
    };

    // Return category-specific templates or default
    return templatesByCategory[category] ?? templatesByCategory['个人成长']!;
  }

  /// Update a generated todo's content
  void updateTodoContent(int index, String content) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    updatedTodos[index] = updatedTodos[index].copyWith(content: content);
    state = state.copyWith(generatedTodos: updatedTodos);
  }

  /// Update a generated todo's scheduled date
  void updateTodoDate(int index, DateTime date) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    updatedTodos[index] = updatedTodos[index].copyWith(scheduledDate: date);
    state = state.copyWith(generatedTodos: updatedTodos);
  }

  /// Update a generated todo's estimated minutes
  void updateTodoMinutes(int index, int minutes) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    updatedTodos[index] = updatedTodos[index].copyWith(estimatedMinutes: minutes);
    state = state.copyWith(generatedTodos: updatedTodos);
  }

  /// Remove a generated todo
  void removeTodo(int index) {
    if (index < 0 || index >= state.generatedTodos.length) return;

    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    updatedTodos.removeAt(index);
    state = state.copyWith(generatedTodos: updatedTodos);
  }

  /// Add a new generated todo
  void addTodo(GeneratedTodoItem todo) {
    final updatedTodos = List<GeneratedTodoItem>.from(state.generatedTodos);
    updatedTodos.add(todo);
    state = state.copyWith(generatedTodos: updatedTodos);
  }

  /// Confirm all todos (mark as ready to save)
  void confirmAllTodos() {
    final updatedTodos = state.generatedTodos
        .map((todo) => todo.copyWith(isConfirmed: true))
        .toList();
    state = state.copyWith(generatedTodos: updatedTodos);
  }

  /// Save confirmed todos to database
  Future<bool> saveTodosToDatabase(BigGoalModel goal) async {
    final unconfirmedTodos = state.generatedTodos.where((t) => !t.isConfirmed).toList();
    if (unconfirmedTodos.isNotEmpty) {
      state = state.copyWith(
        errorMessage: '请先确认所有任务',
      );
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
          scheduledDate: todo.scheduledDate,
          estimatedMinutes: todo.estimatedMinutes,
          color: goal.color,
        );
      }

      state = state.copyWith(isLoading: false, isCompleted: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '保存失败：${e.toString()}',
      );
      return false;
    }
  }

  /// Clear state and reset
  void reset() {
    state = const GoalSplitState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Goal Split Notifier Provider
final goalSplitNotifierProvider =
    StateNotifierProvider<GoalSplitNotifier, GoalSplitState>((ref) {
  final apiClient = ref.watch(minmaxApiClientProvider);
  final todoRepository = ref.watch(todoItemRepositoryProvider);
  return GoalSplitNotifier(apiClient, todoRepository);
});
