import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/big_goal_model.dart';
import '../../../data/models/todo_item_model.dart';

final _completedHistoryGoalsProvider =
    StreamProvider.family<List<BigGoalModel>, int>((ref, userId) {
      final goalRepo = ref.watch(bigGoalRepositoryProvider);
      return goalRepo.watchGoalsByUserId(userId);
    });

final _completedHistoryTodosProvider =
    FutureProvider.family<List<TodoItemModel>, int>((ref, userId) {
      final todoRepo = ref.watch(todoItemRepositoryProvider);
      return todoRepo.getCompletedTodos(userId);
    });

class CompletedHistorySheet extends ConsumerWidget {
  const CompletedHistorySheet({super.key});

  static Future<void> show(BuildContext context, int userId) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CompletedHistoryContent(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return _CompletedHistoryContent(userId: authState.userId ?? 0);
  }
}

class _CompletedHistoryContent extends ConsumerStatefulWidget {
  final int userId;

  const _CompletedHistoryContent({required this.userId});

  @override
  ConsumerState<_CompletedHistoryContent> createState() =>
      _CompletedHistoryContentState();
}

class _CompletedHistoryContentState
    extends ConsumerState<_CompletedHistoryContent> {
  int? _selectedGoalId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textHint.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  '已完成历史',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          _buildGoalFilterChips(),
          Expanded(child: _buildCompletedTodosList()),
        ],
      ),
    );
  }

  int get _userId {
    final authState = ref.watch(authNotifierProvider);
    return authState.userId ?? widget.userId;
  }

  Widget _buildGoalFilterChips() {
    final goalsAsync = ref.watch(_completedHistoryGoalsProvider(_userId));

    return goalsAsync.when(
      data: (goals) {
        return SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: _selectedGoalId == null,
                  label: const Text('全部'),
                  onSelected: (_) => setState(() => _selectedGoalId = null),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: _selectedGoalId == -1,
                  label: const Text('个人任务'),
                  onSelected: (selected) =>
                      setState(() => _selectedGoalId = selected ? -1 : null),
                  selectedColor: AppColors.textHint.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.textSecondary,
                ),
              ),
              ...goals.map((goal) {
                final color = _parseColor(goal.color) ?? AppColors.primary;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: _selectedGoalId == goal.id,
                    label: Text(goal.title),
                    onSelected: (selected) => setState(
                      () => _selectedGoalId = selected ? goal.id : null,
                    ),
                    selectedColor: color.withValues(alpha: 0.2),
                    checkmarkColor: color,
                    avatar: _selectedGoalId == goal.id
                        ? null
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 48),
      error: (_, _) => const SizedBox(height: 48),
    );
  }

  Widget _buildCompletedTodosList() {
    final todosAsync = ref.watch(_completedHistoryTodosProvider(_userId));
    final goalsAsync = ref.watch(_completedHistoryGoalsProvider(_userId));

    return todosAsync.when(
      data: (todos) => goalsAsync.when(
        data: (goals) => _buildTodosListContent(todos, goals),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError('加载目标失败：$e'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildError('加载已完成任务失败：$e'),
    );
  }

  Widget _buildTodosListContent(
    List<TodoItemModel> todos,
    List<BigGoalModel> goals,
  ) {
    final goalMap = {for (final goal in goals) goal.id: goal};
    final filteredTodos = switch (_selectedGoalId) {
      null => todos,
      -1 => todos.where((todo) => todo.goalId == null).toList(),
      final goalId => todos.where((todo) => todo.goalId == goalId).toList(),
    };

    if (filteredTodos.isEmpty) {
      return _buildEmptyState();
    }

    final groupedTodos = <DateTime, List<TodoItemModel>>{};
    for (final todo in filteredTodos) {
      final date = _dateOnly(todo.completedAt ?? todo.scheduledDate);
      groupedTodos.putIfAbsent(date, () => []).add(todo);
    }

    final sortedDates = groupedTodos.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dayTodos = groupedTodos[date]!;
        return _buildDateGroup(date, dayTodos, goalMap);
      },
    );
  }

  Widget _buildDateGroup(
    DateTime date,
    List<TodoItemModel> todos,
    Map<int, BigGoalModel> goalMap,
  ) {
    final weekdayStr = _getWeekdayString(date.weekday);
    final dateText = DateFormat('yyyy年MM月dd日').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$weekdayStr $dateText',
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
                  '${todos.length} 个任务',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...todos.map(
          (todo) => _buildCompletedTodoItem(todo, goalMap[todo.goalId]),
        ),
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
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: goalColor.withValues(alpha: isUserCreated ? 0.3 : 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
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
                    if (goal != null) _buildGoalTag(goal, goalColor),
                    if (isUserCreated)
                      _buildMetaChip(
                        icon: Icons.person_rounded,
                        text: '个人任务',
                        color: AppColors.textHint,
                      ),
                    if (todo.isAIGenerated)
                      _buildMetaChip(
                        icon: Icons.auto_awesome_rounded,
                        text: 'AI',
                        color: AppColors.secondary,
                      ),
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            '~${goal.title}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无已完成任务',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            '完成任务后会在这里显示',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayString(int weekday) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
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

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
