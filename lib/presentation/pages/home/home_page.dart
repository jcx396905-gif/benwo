import 'dart:async';
import '../../widgets/app_glass_nav_bar.dart';
import '../../widgets/glass_mesh_background.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../application/goal/goal_completion_notifier.dart';
import '../../../application/goal/goal_split_notifier.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/todo_reminder_scheduler.dart';
import '../../../data/models/big_goal_model.dart';
import '../../../data/models/todo_item_model.dart';

DateTime _homeDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

final _homeTodosProvider = StreamProvider.family<List<TodoItemModel>, DateTime>(
  (ref, date) {
    final todoRepo = ref.watch(todoItemRepositoryProvider);
    return todoRepo
        .watchTodosByDate(date)
        .map((todos) => todos.where((todo) => !todo.isCompleted).toList());
  },
);

final _homeGoalsProvider = StreamProvider<List<BigGoalModel>>((ref) {
  final goalRepo = ref.watch(bigGoalRepositoryProvider);
  return goalRepo.watchGoals();
});

/// Home Page - Today's To-Do List (Task 13)
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Get today's date
    final today = _homeDateOnly(DateTime.now());
    final dateStr = DateFormat('yyyy年MM月dd日').format(today);
    final weekdayStr = _getWeekdayString(today.weekday);

    // Listen for goal completion to show celebration
    ref.listen<GoalCompletionState>(goalCompletionNotifierProvider, (
      previous,
      next,
    ) {
      if (next.justCompleted && next.completedGoal != null) {
        _showGoalCompletionCelebration(context, next.completedGoal!);
        // Reset after showing celebration
        Future.delayed(const Duration(milliseconds: 100), () {
          ref.read(goalCompletionNotifierProvider.notifier).resetCelebration();
        });
      }
    });

    return Scaffold(
      backgroundColor: context.palette.canvas,
      appBar: AppBar(
        title: Column(
          children: [
            Text('今日', style: Theme.of(context).textTheme.titleMedium),
            Text(
              '$weekdayStr $dateStr',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: context.palette.mutedInk),
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
      extendBody: true,
      body: GlassMeshBackground(child: _buildBody(today)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        backgroundColor: context.palette.gold,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBody(DateTime today) {
    final todosAsync = ref.watch(_homeTodosProvider(today));
    final goalsAsync = ref.watch(_homeGoalsProvider);

    return todosAsync.when(
      data: (todos) => goalsAsync.when(
        data: (goals) => _buildTodoList(todos, goals, today),
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
    final inProgressGoals = goals
        .where((g) => g.status == GoalStatus.inProgress)
        .toList();

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
            SliverToBoxAdapter(child: _buildGoalSummaryCard(inProgressGoals)),

          // Section header: Today's tasks
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text('今日任务', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: context.palette.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${sortedTodos.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.gold,
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
            delegate: SliverChildBuilderDelegate((context, index) {
              final todo = sortedTodos[index];
              final goal = todo.goalId != null ? goalMap[todo.goalId] : null;
              return _buildTodoItem(todo, goal);
            }, childCount: sortedTodos.length),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildGoalSummaryCard(List<BigGoalModel> goals) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.canvas,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.gold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_rounded, color: context.palette.gold, size: 20),
              const SizedBox(width: 8),
              Text(
                '进行中的目标',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: context.palette.gold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: goals.take(3).map((goal) {
              final color = _parseColor(goal.color) ?? context.palette.gold;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
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
                        color: context.palette.ink,
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
                  color: context.palette.mutedInk,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(TodoItemModel todo, BigGoalModel? goal) {
    final goalColor = goal != null
        ? (_parseColor(goal.color) ?? context.palette.gold)
        : context.palette.mutedInk;
    final isUserCreated = todo.goalId == null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: todo.isCompleted
            ? context.palette.ceramicRaised.withValues(alpha: 0.5)
            : context.palette.ceramic,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: todo.isCompleted
              ? context.palette.hairline.withValues(alpha: 0.5)
              : context.palette.hairline,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTodoDetailSheet(todo, goal),
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
                      color: context.palette.hintInk.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else
                  const SizedBox(width: 4),

                const SizedBox(width: 12),

                // Checkbox
                _buildCheckbox(todo),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Todo content
                      Text(
                        todo.content,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: todo.isCompleted
                              ? context.palette.hintInk
                              : context.palette.ink,
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
                          if (TodoReminderScheduler.hasPreciseTime(
                            todo.scheduledDate,
                          ))
                            _buildMetaChip(
                              icon: Icons.access_time_rounded,
                              text: _formatPreciseTodoTime(todo.scheduledDate),
                            ),

                          // Estimated duration
                          if (todo.estimatedMinutes != null)
                            _buildMetaChip(
                              icon: Icons.schedule_rounded,
                              text: '${todo.estimatedMinutes}分钟',
                            ),

                          // Goal tag
                          if (goal != null) _buildGoalTag(goal, goalColor),

                          // User created tag
                          if (isUserCreated)
                            _buildMetaChip(
                              icon: Icons.person_rounded,
                              text: '自建',
                              color: context.palette.hintInk,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // More button for all todos (edit/delete)
                IconButton(
                  onPressed: () => _showTodoDetailSheet(todo, goal),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: todo.isCompleted
                        ? context.palette.hintInk
                        : context.palette.mutedInk,
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

  Widget _buildCheckbox(TodoItemModel todo) {
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
          color: todo.isCompleted ? context.palette.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: todo.isCompleted
                ? context.palette.gold
                : context.palette.hairline,
            width: 2,
          ),
        ),
        child: todo.isCompleted
            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    final chipColor = color ?? context.palette.mutedInk;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: chipColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: chipColor),
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            '~${goal.title}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: context.palette.ink),
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
            color: context.palette.hintInk.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '今日暂无任务',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: context.palette.mutedInk,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击下方 + 按钮添加新的待办事项',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.palette.hintInk),
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
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
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
return AppGlassNavBar(index: 0);
  }

  Future<void> _toggleTodoComplete(TodoItemModel todo) async {
    final todoRepo = ref.read(todoItemRepositoryProvider);
    if (todo.isCompleted) {
      await todoRepo.uncompleteTodo(todo.id);
      await TodoReminderScheduler.scheduleForTodo(todo);
    } else {
      await todoRepo.completeTodo(todo.id);
      await TodoReminderScheduler.cancelForTodo(todo.id);
      // Check if goal should be auto-completed after marking todo complete
      if (todo.goalId != null) {
        // Delay slightly to allow the todo state to update first
        Future.delayed(const Duration(milliseconds: 100), () {
          ref
              .read(goalCompletionNotifierProvider.notifier)
              .checkAndCompleteGoal(todo.goalId!);
        });
      }
    }
  }

  void _showAIConfirmDialog(TodoItemModel todo) {
    // Reflection questions for AI-generated todos
    final questions = ['你认真思考过这个问题了吗？', '这个问题对你的目标有多重要？', '你是真心想完成这件事吗？'];
    int confirmedIndex = 0;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                todo.isAIGenerated
                    ? Icons.psychology_rounded
                    : Icons.check_rounded,
                color: context.palette.terracotta,
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
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              if (todo.isAIGenerated) ...[
                Text(
                  '完成前请思考以下问题：',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.palette.mutedInk,
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
                              ? context.palette.gold
                              : context.palette.hintInk,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            q,
                            style: TextStyle(
                              color: idx <= confirmedIndex
                                  ? context.palette.ink
                                  : context.palette.hintInk,
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
                            color: context.palette.gold,
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
                        color: context.palette.hintInk,
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

  void _showTodoDetailSheet(TodoItemModel todo, BigGoalModel? currentGoal) {
    final contentController = TextEditingController(text: todo.content);
    final timeController = TextEditingController(
      text: todo.estimatedMinutes?.toString() ?? '',
    );
    int? selectedGoalId = todo.goalId;

    // Get user's goals for dropdown
    final goals = ref.read(_homeGoalsProvider).valueOrNull ?? [];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: context.palette.ceramic.withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: BorderSide(
                color: context.palette.hairline.withValues(alpha: 0.6),
              ),
            ),
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
                          ? context.palette.terracotta
                          : context.palette.gold,
                    ),
                    const SizedBox(width: 8),
                    Text('待办详情', style: Theme.of(context).textTheme.titleLarge),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.palette.terracotta.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: context.palette.terracotta,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'AI 生成',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: context.palette.terracotta),
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
                  initialValue: selectedGoalId,
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
                        .map(
                          (g) => DropdownMenuItem<int?>(
                            value: g.id,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color:
                                        _parseColor(g.color) ??
                                        context.palette.gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(g.title),
                              ],
                            ),
                          ),
                        ),
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
                          foregroundColor: Theme.of(context).colorScheme.error,
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
                          backgroundColor: context.palette.hintInk,
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () async {
                          final content = contentController.text.trim();
                          if (content.isEmpty) return;

                          final estimatedMinutes = int.tryParse(
                            timeController.text.trim(),
                          );

                          // Create updated todo model
                          final updatedTodo = TodoItemModel()
                            ..id = todo.id
                            ..content = content
                            ..goalId = selectedGoalId
                            ..isAIGenerated = todo.isAIGenerated
                            ..scheduledDate = todo.scheduledDate
                            ..isCompleted = todo.isCompleted
                            ..estimatedMinutes = estimatedMinutes
                            ..color = todo.color
                            ..aiConfirmationQuestions =
                                todo.aiConfirmationQuestions
                            ..createdAt = todo.createdAt
                            ..completedAt = todo.completedAt;

                          final todoRepo = ref.read(todoItemRepositoryProvider);
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
    final sheetContext = context;
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
              final todoRepo = ref.read(todoItemRepositoryProvider);
              await todoRepo.deleteTodo(todo.id);
              await TodoReminderScheduler.cancelForTodo(todo.id);
              if (context.mounted) {
                Navigator.of(context).pop(); // Close dialog
              }
              if (sheetContext.mounted) {
                Navigator.of(sheetContext).pop(); // Close bottom sheet
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final contentController = TextEditingController();
    final timeController = TextEditingController();
    int? selectedGoalId;
    bool useAISplit = false;
    int? desiredCount;
    DateTime selectedDate = _homeDateOnly(DateTime.now());
    TimeOfDay? selectedExactTime;
    bool isSaving = false;

    final goals = ref.read(_homeGoalsProvider).valueOrNull ?? [];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: context.palette.ceramic.withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: BorderSide(
                color: context.palette.hairline.withValues(alpha: 0.6),
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '添加待办',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: isSaving
                            ? null
                            : () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: useAISplit ? '输入要拆分的事情' : '待办内容',
                      hintText: useAISplit
                          ? '例如：今天要整理房间、写周报，明天复习英语'
                          : '输入待办事项...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: useAISplit ? 4 : 2,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.auto_awesome_rounded),
                    title: const Text('AI 拆分'),
                    subtitle: const Text('把一段话自动拆成多个待办，并按日期安排'),
                    value: useAISplit,
                    onChanged: isSaving
                        ? null
                        : (value) {
                            setState(() {
                              useAISplit = value;
                            });
                          },
                  ),
                  if (useAISplit) ...[
                    const SizedBox(height: 8),
                    Text('选择数量', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('AI 自动选择'),
                          selected: desiredCount == null,
                          onSelected: isSaving
                              ? null
                              : (_) => setState(() => desiredCount = null),
                        ),
                        ...[3, 5, 8, 10].map((count) {
                          return ChoiceChip(
                            label: Text('$count 个'),
                            selected: desiredCount == count,
                            onSelected: isSaving
                                ? null
                                : (_) {
                                    setState(() {
                                      desiredCount = count;
                                    });
                                  },
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_rounded),
                    title: Text(useAISplit ? '默认安排日期' : '选择时间'),
                    subtitle: Text(
                      selectedExactTime == null
                          ? _formatHomeDate(selectedDate)
                          : '${_formatHomeDate(selectedDate)} ${_formatTimeOfDay(selectedExactTime!)}',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: isSaving
                        ? null
                        : () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 1),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = _homeDateOnly(picked);
                              });
                            }
                          },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.schedule_rounded),
                    title: const Text('精准完成时间'),
                    subtitle: Text(
                      selectedExactTime == null
                          ? '未设置具体几点几分'
                          : _formatTimeOfDay(selectedExactTime!),
                    ),
                    value: selectedExactTime != null,
                    onChanged: isSaving
                        ? null
                        : (value) async {
                            if (!value) {
                              setState(() => selectedExactTime = null);
                              return;
                            }
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedExactTime ?? TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() => selectedExactTime = picked);
                            }
                          },
                  ),
                  const SizedBox(height: 16),
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
                        child: Text('无目标'),
                      ),
                      ...goals
                          .where((g) => g.status == GoalStatus.inProgress)
                          .map(
                            (g) => DropdownMenuItem<int?>(
                              value: g.id,
                              child: Text(g.title),
                            ),
                          ),
                    ],
                    onChanged: isSaving
                        ? null
                        : (value) {
                            setState(() {
                              selectedGoalId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: useAISplit ? '默认每项分钟数（可选）' : '预计完成时间（分钟）',
                      hintText: '例如：30',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              final content = contentController.text.trim();
                              if (content.isEmpty) return;

                              final estimatedMinutes = int.tryParse(
                                timeController.text.trim(),
                              );

                              setState(() {
                                isSaving = true;
                              });

                              try {
                                final todoRepo = ref.read(
                                  todoItemRepositoryProvider,
                                );
                                if (useAISplit) {
                                  final generatedTodos = await ref
                                      .read(goalSplitNotifierProvider.notifier)
                                      .generateTodosFromText(
                                        input: content,
                                        desiredCount: desiredCount,
                                        defaultDate: selectedDate,
                                      );
                                  if (generatedTodos.isEmpty) {
                                    throw const AiSplitException(
                                      'AI 没有生成可用待办，请把要拆分的事情写得更具体。',
                                    );
                                  }

                                  for (final todo in generatedTodos) {
                                    final scheduledDate = _applyFallbackTime(
                                      todo.scheduledDate,
                                      selectedExactTime,
                                    );
                                    final savedTodo = await todoRepo.createTodo(
                                      content: todo.content,
                                      goalId: selectedGoalId,
                                      isAIGenerated: true,
                                      scheduledDate: scheduledDate,
                                      estimatedMinutes:
                                          estimatedMinutes ??
                                          todo.estimatedMinutes,
                                    );
                                    await TodoReminderScheduler.scheduleForTodo(
                                      savedTodo,
                                    );
                                  }

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '已生成 ${generatedTodos.length} 个 AI 待办',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  final scheduledDate = _applyFallbackTime(
                                    selectedDate,
                                    selectedExactTime,
                                  );
                                  final savedTodo = await todoRepo.createTodo(
                                    content: content,
                                    goalId: selectedGoalId,
                                    isAIGenerated: false,
                                    scheduledDate: scheduledDate,
                                    estimatedMinutes: estimatedMinutes,
                                  );
                                  await TodoReminderScheduler.scheduleForTodo(
                                    savedTodo,
                                  );
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                setState(() {
                                  isSaving = false;
                                });
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '添加失败：${_formatAddTodoError(e)}',
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  );
                                }
                              }
                            },
                      child: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(useAISplit ? 'AI 拆分并添加' : '添加'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatHomeDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatAddTodoError(Object error) {
    if (error is TimeoutException) {
      return 'AI 响应超时，请稍后重试或减少一次输入的内容。';
    }
    if (error is AiSplitException) {
      return error.message;
    }
    final text = error.toString();
    if (text.contains('SocketException') ||
        text.contains('connection') ||
        text.contains('Network')) {
      return '网络不可用，已无法连接 AI 服务。';
    }
    return text.replaceFirst('Exception: ', '');
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatPreciseTodoTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    if (date.second == 0) return '$hour:$minute';
    final second = date.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  DateTime _applyFallbackTime(DateTime date, TimeOfDay? fallbackTime) {
    if (TodoReminderScheduler.hasPreciseTime(date) || fallbackTime == null) {
      return date;
    }
    return DateTime(
      date.year,
      date.month,
      date.day,
      fallbackTime.hour,
      fallbackTime.minute,
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
  void _showGoalCompletionCelebration(
    BuildContext context,
    BigGoalModel completedGoal,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _HomeGoalCompletionDialog(completedGoal: completedGoal),
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

class _HomeGoalCompletionDialogState extends State<_HomeGoalCompletionDialog>
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

  IconData get _categoryIcon {
    switch (widget.completedGoal.category) {
      case '学业':
        return Icons.school_rounded;
      case '职业':
        return Icons.work_rounded;
      case '健康':
        return Icons.favorite_rounded;
      case '关系':
        return Icons.people_rounded;
      case '个人成长':
        return Icons.self_improvement_rounded;
      case '财务':
        return Icons.savings_rounded;
      default:
        return Icons.flag_rounded;
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
            color: context.palette.ceramic,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: context.palette.goldPressed.withValues(alpha: 0.3),
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
                    color: context.palette.goldPressed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.palette.goldPressed.withValues(
                          alpha: 0.4,
                        ),
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
                '恭喜达成目标！',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.palette.goldPressed,
                ),
              ),

              const SizedBox(height: 16),

              // Goal title
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: context.palette.goldPressed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.palette.goldPressed.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _categoryIcon,
                      size: 20,
                      color: context.palette.goldPressed,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.completedGoal.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.palette.ink,
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
                    color: context.palette.mutedInk,
                  ),
                ),

              const SizedBox(height: 24),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.palette.goldPressed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('太棒了！继续加油'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
