import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../application/goal/goal_completion_notifier.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/big_goal_model.dart';
import '../../../data/models/todo_item_model.dart';

/// Home Page - Today's To-Do List (Task 13)
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.userId;

    // Get today's date
    final today = DateTime.now();
    final dateStr = DateFormat('yyyy年MM月dd日').format(today);
    final weekdayStr = _getWeekdayString(today.weekday);

    // Listen for goal completion to show celebration
    ref.listen<GoalCompletionState>(goalCompletionNotifierProvider, (previous, next) {
      if (next.justCompleted && next.completedGoal != null) {
        _showGoalCompletionCelebration(context, next.completedGoal!);
        // Reset after showing celebration
        Future.delayed(const Duration(milliseconds: 100), () {
          ref.read(goalCompletionNotifierProvider.notifier).resetCelebration();
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              '今日',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '$weekdayStr $dateStr',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded),
            onPressed: () => context.go('/calendar'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(userId, today),
      floatingActionButton: FloatingActionButton(
        onPressed: userId != null ? () => _showAddTodoDialog(context, userId) : null,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBody(int userId, DateTime today) {
    // Watch today's todos
    final todosAsync = ref.watch(
      StreamProvider<List<TodoItemModel>>((ref) {
        final todoRepo = ref.watch(todoItemRepositoryProvider);
        return todoRepo.watchTodosByDate(userId, today);
      }),
    );

    // Watch user's goals
    final goalsAsync = ref.watch(
      StreamProvider<List<BigGoalModel>>((ref) {
        final goalRepo = ref.watch(bigGoalRepositoryProvider);
        return goalRepo.watchGoalsByUserId(userId);
      }),
    );

    return todosAsync.when(
      data: (todos) => goalsAsync.when(
        data: (goals) => _buildTodoList(todos, goals, userId, today),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError('加载目标失败: $e'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildError('加载待办失败: $e'),
    );
  }

  Widget _buildTodoList(
    List<TodoItemModel> todos,
    List<BigGoalModel> goals,
    int userId,
    DateTime today,
  ) {
    // Create a map of goalId to goal for quick lookup
    final goalMap = {for (final g in goals) g.id: g};

    // Sort todos: AI-generated first (by goal), then user-created
    final sortedTodos = List<TodoItemModel>.from(todos)
      ..sort((a, b) {
        // AI-generated todos come first
        if (a.isAIGenerated && !b.isAIGenerated) return -1;
        if (!a.isAIGenerated && b.isAIGenerated) return 1;
        // Within same type, sort by goalId (null goalId = user-created at end)
        if (a.goalId != null && b.goalId != null) {
          return a.goalId!.compareTo(b.goalId!);
        }
        if (a.goalId != null) return -1;
        if (b.goalId != null) return 1;
        return 0;
      });

    if (sortedTodos.isEmpty) {
      return _buildEmptyState();
    }

    // Build goal summary
    final inProgressGoals =
        goals.where((g) => g.status == GoalStatus.inProgress).toList();

    return RefreshIndicator(
      onRefresh: () async {
        // Force refresh by invalidating the providers
        ref.invalidate(todoItemRepositoryProvider);
        ref.invalidate(bigGoalRepositoryProvider);
      },
      child: CustomScrollView(
        slivers: [
          // Goal summary card
          if (inProgressGoals.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildGoalSummaryCard(inProgressGoals),
            ),

          // Section header: Today's tasks
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    '今日任务',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${sortedTodos.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Todo list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final todo = sortedTodos[index];
                final goal = todo.goalId != null ? goalMap[todo.goalId] : null;
                return _buildTodoItem(todo, goal, userId);
              },
              childCount: sortedTodos.length,
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSummaryCard(List<BigGoalModel> goals) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '进行中的目标',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goals.take(3).map((goal) {
              final color = _parseColor(goal.color) ?? AppColors.primary;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      goal.title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (goals.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '+${goals.length - 3} 更多目标',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(TodoItemModel todo, BigGoalModel? goal, int userId) {
    final goalColor = goal != null
        ? (_parseColor(goal.color) ?? AppColors.primary)
        : AppColors.textSecondary;
    final isUserCreated = todo.goalId == null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: todo.isCompleted
            ? AppColors.surfaceVariant.withValues(alpha: 0.5)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: todo.isCompleted
              ? AppColors.border.withValues(alpha: 0.5)
              : AppColors.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTodoDetailSheet(todo, goal, userId),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI indicator or user indicator
                if (todo.isAIGenerated && goal != null)
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: goalColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else if (isUserCreated)
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else
                  const SizedBox(width: 4),

                const SizedBox(width: 12),

                // Checkbox
                _buildCheckbox(todo, userId),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Todo content
                      Text(
                        todo.content,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: todo.isCompleted
                                      ? AppColors.textHint
                                      : AppColors.textPrimary,
                                  decoration: todo.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                      ),
                      const SizedBox(height: 4),

                      // Meta info row
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          // Estimated time
                          if (todo.estimatedMinutes != null)
                            _buildMetaChip(
                              icon: Icons.schedule_rounded,
                              text: '${todo.estimatedMinutes}分钟',
                            ),

                          // Goal tag
                          if (goal != null)
                            _buildGoalTag(goal, goalColor),

                          // User created tag
                          if (isUserCreated)
                            _buildMetaChip(
                              icon: Icons.person_rounded,
                              text: '自建',
                              color: AppColors.textHint,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // More button for all todos (edit/delete)
                IconButton(
                  onPressed: () => _showTodoDetailSheet(todo, goal, userId),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: todo.isCompleted
                        ? AppColors.textHint
                        : AppColors.textSecondary,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(TodoItemModel todo, int userId) {
    return GestureDetector(
      onTap: todo.isCompleted
          ? null
          : todo.isAIGenerated
              ? () => _showAIConfirmDialog(todo)
              : () => _toggleTodoComplete(todo),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: todo.isCompleted ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: todo.isCompleted
                ? AppColors.primary
                : AppColors.border,
            width: 2,
          ),
        ),
        child: todo.isCompleted
            ? const Icon(
                Icons.check_rounded,
                size: 16,
                color: Colors.white,
              )
            : null,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 80,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '今日暂无任务',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击下方 + 按钮添加新的待办事项',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/goals'),
            icon: const Icon(Icons.flag_rounded),
            label: const Text('查看目标'),
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
            size: 64,
            color: AppColors.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              ref.invalidate(todoItemRepositoryProvider);
              ref.invalidate(bigGoalRepositoryProvider);
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            break; // Already on home
          case 1:
            context.go('/goals');
            break;
          case 2:
            context.go('/calendar');
            break;
          case 3:
            context.go('/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag_rounded),
          label: '目标',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: '日历',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: '设置',
        ),
      ],
    );
  }

  Future<void> _toggleTodoComplete(TodoItemModel todo) async {
    final todoRepo = ref.read(todoItemRepositoryProvider);
    if (todo.isCompleted) {
      await todoRepo.uncompleteTodo(todo.id);
    } else {
      await todoRepo.completeTodo(todo.id);
      // Check if goal should be auto-completed after marking todo complete
      if (todo.goalId != null) {
        final userId = todo.userId;
        // Delay slightly to allow the todo state to update first
        Future.delayed(const Duration(milliseconds: 100), () {
          ref
              .read(goalCompletionNotifierProvider.notifier)
              .checkAndCompleteGoal(todo.goalId!, userId);
        });
      }
    }
  }

  void _showAIConfirmDialog(TodoItemModel todo) {
    // Reflection questions for AI-generated todos
    final questions = [
      '你认真思考过这个问题了吗？',
      '这个问题对你的目标有多重要？',
      '你是真心想完成这件事吗？',
    ];
    int confirmedIndex = 0;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                todo.isAIGenerated ? Icons.psychology_rounded : Icons.check_rounded,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              const Text('确认完成'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${todo.content}"',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 16),
              if (todo.isAIGenerated) ...[
                Text(
                  '完成前请思考以下问题：',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 12),
                ...questions.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final q = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          idx <= confirmedIndex
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 20,
                          color: idx <= confirmedIndex
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            q,
                            style: TextStyle(
                              color: idx <= confirmedIndex
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
                            ),
                          ),
                        ),
                        if (idx == confirmedIndex && idx < questions.length - 1)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                confirmedIndex++;
                              });
                            },
                            icon: const Icon(Icons.arrow_forward_rounded),
                            iconSize: 18,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  );
                }),
                if (confirmedIndex < questions.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '请依次确认以上问题',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textHint,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
              ] else ...[
                Text(
                  '确定要完成这个任务吗？',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: todo.isAIGenerated
                  ? confirmedIndex >= questions.length - 1
                      ? () {
                          Navigator.pop(context);
                          _toggleTodoComplete(todo);
                        }
                      : null
                  : () {
                      Navigator.pop(context);
                      _toggleTodoComplete(todo);
                    },
              child: const Text('确认完成'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTodoDetailSheet(
    TodoItemModel todo,
    BigGoalModel? currentGoal,
    int userId,
  ) {
    final contentController = TextEditingController(text: todo.content);
    final timeController = TextEditingController(
      text: todo.estimatedMinutes?.toString() ?? '',
    );
    int? selectedGoalId = todo.goalId;

    // Get user's goals for dropdown
    final goals = ref.read(
      StreamProvider<List<BigGoalModel>>((ref) {
        return ref.watch(bigGoalRepositoryProvider).watchGoalsByUserId(userId);
      }),
    ).valueOrNull ?? [];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      todo.isAIGenerated
                          ? Icons.psychology_rounded
                          : Icons.edit_rounded,
                      color: todo.isAIGenerated
                          ? AppColors.secondary
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '待办详情',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // AI badge if applicable
                if (todo.isAIGenerated)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'AI 生成',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.secondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Content input
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '待办内容',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 2,
                  enabled: !todo.isCompleted,
                ),
                const SizedBox(height: 16),

                // Goal dropdown
                DropdownButtonFormField<int?>(
                  value: selectedGoalId,
                  decoration: InputDecoration(
                    labelText: '关联目标',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('无目标'),
                    ),
                    ...goals
                        .where((g) => g.status == GoalStatus.inProgress)
                        .map((g) => DropdownMenuItem<int?>(
                              value: g.id,
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _parseColor(g.color) ??
                                          AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(g.title),
                                ],
                              ),
                            )),
                  ],
                  onChanged: todo.isCompleted
                      ? null
                      : (value) {
                          setState(() {
                            selectedGoalId = value;
                          });
                        },
                ),
                const SizedBox(height: 16),

                // Estimated time
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: '预计完成时间（分钟）',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !todo.isCompleted,
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    // Delete button
                    if (!todo.isCompleted)
                      OutlinedButton.icon(
                        onPressed: () => _confirmDeleteTodo(todo),
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('删除'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                      ),
                    const Spacer(),

                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    const SizedBox(width: 8),

                    // Save/Complete button
                    if (todo.isCompleted)
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('已完成'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textHint,
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () async {
                          final content = contentController.text.trim();
                          if (content.isEmpty) return;

                          final estimatedMinutes =
                              int.tryParse(timeController.text.trim());

                          // Create updated todo model
                          final updatedTodo = TodoItemModel()
                            ..id = todo.id
                            ..userId = todo.userId
                            ..content = content
                            ..goalId = selectedGoalId
                            ..isAIGenerated = todo.isAIGenerated
                            ..scheduledDate = todo.scheduledDate
                            ..isCompleted = todo.isCompleted
                            ..estimatedMinutes = estimatedMinutes
                            ..color = todo.color
                            ..aiConfirmationQuestions = todo.aiConfirmationQuestions
                            ..createdAt = todo.createdAt
                            ..completedAt = todo.completedAt;

                          final todoRepo =
                              ref.read(todoItemRepositoryProvider);
                          await todoRepo.updateTodo(updatedTodo);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('保存'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteTodo(TodoItemModel todo) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除待办'),
        content: Text('确定要删除"${todo.content}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              final todoRepo = ref.read(todoItemRepositoryProvider);
              await todoRepo.deleteTodo(todo.id);
              if (context.mounted) {
                Navigator.pop(context); // Close bottom sheet
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, int userId) {
    final contentController = TextEditingController();
    final timeController = TextEditingController();
    int? selectedGoalId;

    // Get user's goals for dropdown
    final goals = ref.read(
      StreamProvider<List<BigGoalModel>>((ref) {
        return ref.watch(bigGoalRepositoryProvider).watchGoalsByUserId(userId);
      }),
    ).valueOrNull ?? [];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      '添加待办',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Content input
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '待办内容',
                    hintText: '输入待办事项...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 2,
                  autofocus: true,
                ),
                const SizedBox(height: 16),

                // Goal dropdown
                DropdownButtonFormField<int?>(
                  initialValue: selectedGoalId,
                  decoration: InputDecoration(
                    labelText: '关联目标（可选）',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('无目标（用户自建）'),
                    ),
                    ...goals
                        .where((g) => g.status == GoalStatus.inProgress)
                        .map((g) => DropdownMenuItem<int?>(
                              value: g.id,
                              child: Text(g.title),
                            )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGoalId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Estimated time
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: '预计完成时间（分钟）',
                    hintText: '例如：30',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // Add button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final content = contentController.text.trim();
                      if (content.isEmpty) return;

                      final estimatedMinutes =
                          int.tryParse(timeController.text.trim());

                      final todoRepo = ref.read(todoItemRepositoryProvider);
                      await todoRepo.createTodo(
                        userId: userId,
                        content: content,
                        goalId: selectedGoalId,
                        isAIGenerated: false,
                        estimatedMinutes: estimatedMinutes,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('添加'),
                  ),
                ),
              ],
            ),
          ),
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

  /// Show goal completion celebration dialog
  void _showGoalCompletionCelebration(BuildContext context, BigGoalModel completedGoal) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _HomeGoalCompletionDialog(completedGoal: completedGoal),
    );
  }
}

/// Goal Completion Celebration Dialog (simplified version for home page)
class _HomeGoalCompletionDialog extends StatefulWidget {
  final BigGoalModel completedGoal;

  const _HomeGoalCompletionDialog({required this.completedGoal});

  @override
  State<_HomeGoalCompletionDialog> createState() =>
      _HomeGoalCompletionDialogState();
}

class _HomeGoalCompletionDialogState
    extends State<_HomeGoalCompletionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _categoryEmoji {
    switch (widget.completedGoal.category) {
      case '学业':
        return '📚';
      case '职业':
        return '💼';
      case '健康':
        return '💪';
      case '关系':
        return '💕';
      case '个人成长':
        return '🌱';
      case '财务':
        return '💰';
      default:
        return '🎯';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.sage.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated success icon
              ScaleTransition(
                scale: _checkAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.sage,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sage.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Congratulations text
              Text(
                '🎉 恭喜达成目标！',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.sage,
                    ),
              ),

              const SizedBox(height: 16),

              // Goal title
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.sage.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.sage.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _categoryEmoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.completedGoal.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Completion time
              if (widget.completedGoal.completedAt != null)
                Text(
                  '完成时间：${widget.completedGoal.completedAt!.year}年'
                  '${widget.completedGoal.completedAt!.month}月'
                  '${widget.completedGoal.completedAt!.day}日',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),

              const SizedBox(height: 24),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sage,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('太棒了！继续加油 💪'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
