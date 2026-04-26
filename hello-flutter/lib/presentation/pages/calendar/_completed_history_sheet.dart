import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/big_goal_model.dart';
import '../../../data/models/todo_item_model.dart';
import '../../../core/di/injection.dart';
import '../../../application/auth/auth_notifier.dart';

/// Completed Todos History Sheet
class CompletedHistorySheet extends ConsumerWidget {
  const CompletedHistorySheet({super.key});

  static Future<void> show(BuildContext context, int userId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CompletedHistoryContent(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: _CompletedHistoryContent(userId: 0),
    );
  }
}

class _CompletedHistoryContent extends ConsumerStatefulWidget {
  final int userId;

  const _CompletedHistoryContent({required this.userId});

  @override
  ConsumerState<_CompletedHistoryContent> createState() => _CompletedHistoryContentState();
}

class _CompletedHistoryContentState extends ConsumerState<_CompletedHistoryContent> {
  int? _selectedGoalId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textHint.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.history_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '已完成任务',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),

        // Goal filter chips
        _buildGoalFilterChips(),

        // Completed todos list
        Expanded(
          child: _buildCompletedTodosList(),
        ),
      ],
    );
  }

  Widget _buildGoalFilterChips() {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.userId ?? 0;

    final goalsAsync = ref.watch(
      StreamProvider<List<BigGoalModel>>((ref) {
        final goalRepo = ref.watch(bigGoalRepositoryProvider);
        return goalRepo.watchGoalsByUserId(userId);
      }),
    );

    return goalsAsync.when(
      data: (goals) {
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // All filter chip
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: _selectedGoalId == null,
                  label: const Text('全部'),
                  onSelected: (selected) {
                    setState(() {
                      _selectedGoalId = null;
                    });
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                ),
              ),
              // User created filter chip
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: _selectedGoalId == -1,
                  label: const Text('个人任务'),
                  onSelected: (selected) {
                    setState(() {
                      _selectedGoalId = selected ? -1 : null;
                    });
                  },
                  selectedColor: AppColors.textHint.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.textSecondary,
                ),
              ),
              // Goal filter chips
              ...goals.map((goal) {
                final color = _parseColor(goal.color) ?? AppColors.primary;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: _selectedGoalId == goal.id,
                    label: Text(goal.title),
                    onSelected: (selected) {
                      setState(() {
                        _selectedGoalId = selected ? goal.id : null;
                      });
                    },
                    selectedColor: color.withValues(alpha: 0.2),
                    checkmarkColor: color,
                    avatar: _selectedGoalId != goal.id
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 48),
      error: (_, __) => const SizedBox(height: 48),
    );
  }

  Widget _buildCompletedTodosList() {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.userId ?? 0;

    final todosAsync = ref.watch(
      FutureProvider<List<TodoItemModel>>((ref) async {
        final todoRepo = ref.watch(todoItemRepositoryProvider);
        return todoRepo.getCompletedTodos(userId);
      }),
    );

    final goalsAsync = ref.watch(
      StreamProvider<List<BigGoalModel>>((ref) {
        final goalRepo = ref.watch(bigGoalRepositoryProvider);
        return goalRepo.watchGoalsByUserId(userId);
      }),
    );

    return todosAsync.when(
      data: (todos) => goalsAsync.when(
        data: (goals) => _buildTodosListContent(todos, goals),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError('加载目标失败: $e'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildError('加载已完成任务失败: $e'),
    );
  }

  Widget _buildTodosListContent(List<TodoItemModel> todos, List<BigGoalModel> goals) {
    final goalMap = {for (final g in goals) g.id: g};

    // Filter todos based on selected goal
    List<TodoItemModel> filteredTodos;
    if (_selectedGoalId == null) {
      filteredTodos = todos;
    } else if (_selectedGoalId == -1) {
      // User created todos (no goal)
      filteredTodos = todos.where((t) => t.goalId == null).toList();
    } else {
      filteredTodos = todos.where((t) => t.goalId == _selectedGoalId).toList();
    }

    if (filteredTodos.isEmpty) {
      return _buildEmptyState();
    }

    // Group todos by date
    final groupedTodos = <String, List<TodoItemModel>>{};
    for (final todo in filteredTodos) {
      final dateKey = DateFormat('yyyy年MM月dd日').format(todo.completedAt ?? todo.scheduledDate);
      groupedTodos.putIfAbsent(dateKey, () => []).add(todo);
    }

    final sortedKeys = groupedTodos.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final dateKey = sortedKeys[index];
        final dayTodos = groupedTodos[dateKey]!;
        return _buildDateGroup(dateKey, dayTodos, goalMap);
      },
    );
  }

  Widget _buildDateGroup(String dateKey, List<TodoItemModel> todos, Map<int, BigGoalModel> goalMap) {
    // Parse the date key to get weekday
    final dateFormat = DateFormat('yyyy年MM月dd日');
    final date = dateFormat.parse(dateKey);
    final weekdayStr = _getWeekdayString(date.weekday);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$weekdayStr $dateKey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${todos.length}个任务',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ],
          ),
        ),

        // Todos for this date
        ...todos.map((todo) => _buildCompletedTodoItem(todo, goalMap[todo.goalId])),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCompletedTodoItem(TodoItemModel todo, BigGoalModel? goal) {
    final goalColor = goal != null
        ? (_parseColor(goal.color) ?? AppColors.primary)
        : AppColors.textHint;
    final isUserCreated = todo.goalId == null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Goal color indicator
          if (!isUserCreated)
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: goalColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            )
          else
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.textHint.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          const SizedBox(width: 12),

          // Completed check icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.textHint.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 16,
              color: AppColors.textHint,
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textHint,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    // Goal tag
                    if (goal != null)
                      _buildGoalTag(goal, goalColor),

                    // User created tag
                    if (isUserCreated)
                      _buildMetaChip(
                        icon: Icons.person_rounded,
                        text: '个人任务',
                        color: AppColors.textHint,
                      ),

                    // AI badge
                    if (todo.isAIGenerated)
                      _buildMetaChip(
                        icon: Icons.auto_awesome_rounded,
                        text: 'AI',
                        color: AppColors.secondary,
                      ),

                    // Completed time
                    if (todo.completedAt != null)
                      _buildMetaChip(
                        icon: Icons.access_time_rounded,
                        text: DateFormat('HH:mm').format(todo.completedAt!),
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalTag(BigGoalModel goal, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '~${goal.title}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: chipColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: chipColor,
              ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 64,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无已完成的任务',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '完成任务后会显示在这里',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getWeekdayString(int weekday) {
    const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return weekdays[weekday - 1];
  }

  Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      final hex = colorStr.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}
