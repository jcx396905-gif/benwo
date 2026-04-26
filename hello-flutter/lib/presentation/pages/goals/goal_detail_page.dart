import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../application/goal/goal_completion_notifier.dart';
import '../../../application/goal/goal_split_notifier.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/big_goal_model.dart';
import '../../../data/models/todo_item_model.dart';

/// Goal Detail Page - displays goal details and associated todos
class GoalDetailPage extends ConsumerStatefulWidget {
  final String goalId;

  const GoalDetailPage({
    super.key,
    required this.goalId,
  });

  @override
  ConsumerState<GoalDetailPage> createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends ConsumerState<GoalDetailPage> {
  int? _goalIdInt;

  @override
  void initState() {
    super.initState();
    _goalIdInt = int.tryParse(widget.goalId);
  }

  @override
  Widget build(BuildContext context) {
    if (_goalIdInt == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('目标详情'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go('/goals'),
          ),
        ),
        body: const Center(child: Text('无效的目标ID')),
      );
    }

    final goalAsync = ref.watch(_watchGoalProvider(_goalIdInt!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('目标详情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/goals'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _confirmDeleteGoal(context),
          ),
        ],
      ),
      body: Container(
        color: AppColors.background,
        child: goalAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('加载失败: $error')),
          data: (goal) {
            if (goal == null) {
              return const Center(child: Text('目标不存在'));
            }
            return _GoalDetailContent(
              goal: goal,
              onSplitWithAI: () => _showAISplitDialog(context, ref, goal),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteGoal(BuildContext context) async {
    if (_goalIdInt == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除目标'),
        content: const Text(
          '确定要删除这个目标吗？\n删除后将同时删除该目标下的所有任务。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final goalRepo = ref.read(bigGoalRepositoryProvider);
        final todoRepo = ref.read(todoItemRepositoryProvider);

        // Delete associated todos first
        await todoRepo.deleteTodosByGoalId(_goalIdInt!);
        // Delete the goal
        await goalRepo.deleteGoal(_goalIdInt!);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('目标已删除'),
              backgroundColor: AppColors.primary,
            ),
          );
          context.go('/goals');
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('删除失败: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _showAISplitDialog(
    BuildContext context,
    WidgetRef ref,
    BigGoalModel goal,
  ) async {
    final splitNotifier = ref.read(goalSplitNotifierProvider.notifier);

    // Reset state first
    splitNotifier.reset();

    // Show loading dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('AI 正在分析目标并生成任务...'),
          ],
        ),
      ),
    );

    // Generate todos
    final success = await splitNotifier.generateTodosForGoal(goal);

    // Close loading dialog
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (!success) {
      final errorMessage = ref.read(goalSplitNotifierProvider).errorMessage;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? '生成任务失败'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Show confirmation dialog
    if (context.mounted) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _AISplitConfirmationSheet(goal: goal),
      );
    }
  }
}

final _watchGoalProvider = StreamProvider.family<BigGoalModel?, int>(
  (ref, goalId) {
    final repo = ref.watch(bigGoalRepositoryProvider);
    return repo.watchGoalById(goalId);
  },
);

final _watchGoalTodosProvider =
    StreamProvider.family<List<TodoItemModel>, ({int goalId, int userId})>(
  (ref, params) {
    final repo = ref.watch(todoItemRepositoryProvider);
    return repo.watchTodosByUserId(params.userId).map((todos) =>
        todos.where((todo) => todo.goalId == params.goalId).toList());
  },
);

class _GoalDetailContent extends ConsumerWidget {
  final BigGoalModel goal;
  final VoidCallback onSplitWithAI;

  const _GoalDetailContent({
    required this.goal,
    required this.onSplitWithAI,
  });

  Color get _goalColor {
    if (goal.color != null && goal.color!.isNotEmpty) {
      try {
        final hex = goal.color!.replaceFirst('#', '');
        return Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }
    return AppColors.primary;
  }

  String get _statusText {
    switch (goal.status) {
      case GoalStatus.inProgress:
        return '进行中';
      case GoalStatus.completed:
        return '已完成';
      case GoalStatus.abandoned:
        return '已放弃';
    }
  }

  Color get _statusColor {
    switch (goal.status) {
      case GoalStatus.inProgress:
        return AppColors.primary;
      case GoalStatus.completed:
        return AppColors.sage;
      case GoalStatus.abandoned:
        return AppColors.textHint;
    }
  }

  String get _categoryEmoji {
    switch (goal.category) {
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
      case '其他':
        return '🎯';
      default:
        return '🎯';
    }
  }

  String get _formattedTargetDate {
    return '${goal.targetDate.year}年${goal.targetDate.month}月${goal.targetDate.day}日';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(_watchGoalTodosProvider((goalId: goal.id, userId: goal.userId)));

    // Watch for goal completion state and show celebration
    ref.listen<GoalCompletionState>(goalCompletionNotifierProvider, (previous, next) {
      if (next.justCompleted && next.completedGoal != null) {
        _showGoalCompletionCelebration(context, next.completedGoal!);
        // Reset after showing celebration
        Future.delayed(const Duration(milliseconds: 100), () {
          ref.read(goalCompletionNotifierProvider.notifier).resetCelebration();
        });
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal Header Card
          Card(
            elevation: 4,
            shadowColor: _goalColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: _goalColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _goalColor.withOpacity(0.1),
                    _goalColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _goalColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _goalColor.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _categoryEmoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          goal.title,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  if (goal.description != null &&
                      goal.description!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      goal.description!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        icon: Icons.flag_rounded,
                        label: _statusText,
                        color: _statusColor,
                      ),
                      if (goal.category != null)
                        _buildInfoChip(
                          icon: Icons.category_rounded,
                          label: goal.category!,
                          color: AppColors.textSecondary,
                        ),
                      _buildInfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: _formattedTargetDate,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  if (goal.aiSummary != null && goal.aiSummary!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 16,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'AI 解读',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            goal.aiSummary!,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Progress Section
          todosAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (todos) {
              final completedCount = todos.where((t) => t.isCompleted).length;
              final totalCount = todos.length;
              final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '目标进度',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '$completedCount / $totalCount 任务',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(_goalColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).toInt()}% 完成',
                    style: TextStyle(
                      fontSize: 12,
                      color: _goalColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Todos Section
          Text(
            '相关任务',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          todosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('加载失败: $error')),
            data: (todos) {
              if (todos.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt_rounded,
                        size: 48,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '暂无任务',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'AI 将会为目标生成任务',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: onSplitWithAI,
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: const Text('AI 拆分任务'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return _TodoItemCard(
                    todo: todo,
                    goalColor: _goalColor,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Show goal completion celebration dialog with animation
  void _showGoalCompletionCelebration(BuildContext context, BigGoalModel completedGoal) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _GoalCompletionCelebrationDialog(completedGoal: completedGoal),
    );
  }
}

/// Goal completion celebration dialog with animation
class _GoalCompletionCelebrationDialog extends StatefulWidget {
  final BigGoalModel completedGoal;

  const _GoalCompletionCelebrationDialog({required this.completedGoal});

  @override
  State<_GoalCompletionCelebrationDialog> createState() => _GoalCompletionCelebrationDialogState();
}

class _GoalCompletionCelebrationDialogState extends State<_GoalCompletionCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );

    _confettiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Confetti animation
              ...List.generate(20, (index) {
                final angle = (index / 20) * 2 * 3.14159;
                final distance = 150 * _confettiAnimation.value;
                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 10 + distance * cos(angle),
                  top: MediaQuery.of(context).size.height / 2 - 10 + distance * sin(angle),
                  child: Opacity(
                    opacity: 1 - _confettiAnimation.value,
                    child: Transform.scale(
                      scale: _confettiAnimation.value * 0.5 + 0.5,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getConfettiColor(index),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              // Main dialog card
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildCelebrationCard(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getConfettiColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.sage,
      AppColors.pink,
      AppColors.lavender,
      AppColors.dustyRose,
    ];
    return colors[index % colors.length];
  }

  Widget _buildCelebrationCard(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.sage.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
        border: Border.all(
          color: AppColors.sage.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Celebration icon with glow effect
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.sage.withOpacity(0.15),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.sage.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.celebration_rounded,
              size: 48,
              color: AppColors.sage,
            ),
          ),
          const SizedBox(height: 20),
          // Congratulations text
          Text(
            '🎉 恭喜达成目标！',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.sage,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Goal title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.sage.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.completedGoal.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          // Completion message
          Text(
            '你已完成所有任务！\n继续加油，保持这个势头！',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // OK button
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
              child: const Text(
                '太棒了！',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoItemCard extends StatelessWidget {
  final TodoItemModel todo;
  final Color goalColor;

  const _TodoItemCard({
    required this.todo,
    required this.goalColor,
  });

  String get _formattedDate {
    return '${todo.scheduledDate.month}/${todo.scheduledDate.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: todo.isCompleted
                    ? AppColors.textHint
                    : (todo.isAIGenerated ? goalColor : AppColors.textSecondary),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.content,
                    style: TextStyle(
                      fontSize: 14,
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                      color: todo.isCompleted
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (todo.isAIGenerated) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: goalColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'AI',
                            style: TextStyle(
                              fontSize: 10,
                              color: goalColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      if (todo.estimatedMinutes != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.timer_outlined,
                          size: 12,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${todo.estimatedMinutes}分钟',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (todo.isCompleted)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.sage,
                size: 24,
              )
            else
              Icon(
                Icons.radio_button_unchecked_rounded,
                color: AppColors.border,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// AI Split Confirmation Sheet - shows generated todos for user review
class _AISplitConfirmationSheet extends ConsumerStatefulWidget {
  final BigGoalModel goal;

  const _AISplitConfirmationSheet({required this.goal});

  @override
  ConsumerState<_AISplitConfirmationSheet> createState() =>
      _AISplitConfirmationSheetState();
}

class _AISplitConfirmationSheetState
    extends ConsumerState<_AISplitConfirmationSheet> {
  final Map<int, TextEditingController> _contentControllers = {};
  final Map<int, TextEditingController> _minutesControllers = {};

  @override
  void dispose() {
    for (final controller in _contentControllers.values) {
      controller.dispose();
    }
    for (final controller in _minutesControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splitState = ref.watch(goalSplitNotifierProvider);
    final splitNotifier = ref.read(goalSplitNotifierProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI 任务拆解',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '共 ${splitState.generatedTodos.length} 个任务',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Error message
          if (splitState.errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      splitState.errorMessage!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                  IconButton(
                    onPressed: () => splitNotifier.clearError(),
                    icon: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
            ),

          // Todo list
          Expanded(
            child: splitState.generatedTodos.isEmpty
                ? const Center(child: Text('暂无生成的任务'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: splitState.generatedTodos.length,
                    itemBuilder: (context, index) {
                      final todo = splitState.generatedTodos[index];
                      return _GeneratedTodoCard(
                        todo: todo,
                        index: index,
                        goalColor: _getGoalColor(),
                        onContentChanged: (content) {
                          splitNotifier.updateTodoContent(index, content);
                        },
                        onDateChanged: (date) {
                          splitNotifier.updateTodoDate(index, date);
                        },
                        onMinutesChanged: (minutes) {
                          splitNotifier.updateTodoMinutes(index, minutes);
                        },
                        onRemove: () {
                          splitNotifier.removeTodo(index);
                        },
                      );
                    },
                  ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        splitNotifier.addTodo(GeneratedTodoItem(
                          content: '新任务',
                          scheduledDate: DateTime.now(),
                          estimatedMinutes: 30,
                        ));
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('添加任务'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: splitState.isLoading
                          ? null
                          : () async {
                              splitNotifier.confirmAllTodos();
                              final success = await splitNotifier
                                  .saveTodosToDatabase(widget.goal);
                              if (success && context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('任务已生成并保存'),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: splitState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('确认保存'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGoalColor() {
    if (widget.goal.color != null && widget.goal.color!.isNotEmpty) {
      try {
        final hex = widget.goal.color!.replaceFirst('#', '');
        return Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }
    return AppColors.primary;
  }
}

/// Card for a single generated todo with edit capability
class _GeneratedTodoCard extends StatelessWidget {
  final GeneratedTodoItem todo;
  final int index;
  final Color goalColor;
  final ValueChanged<String> onContentChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onMinutesChanged;
  final VoidCallback onRemove;

  const _GeneratedTodoCard({
    required this.todo,
    required this.index,
    required this.goalColor,
    required this.onContentChanged,
    required this.onDateChanged,
    required this.onMinutesChanged,
    required this.onRemove,
  });

  String get _formattedDate {
    return '${todo.scheduledDate.month}月${todo.scheduledDate.day}日';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: goalColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: goalColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: goalColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '任务 ${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: goalColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                  iconSize: 20,
                  color: AppColors.error,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Content input
            TextFormField(
              initialValue: todo.content,
              decoration: InputDecoration(
                labelText: '任务内容',
                hintText: '输入任务描述',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 2,
              onChanged: onContentChanged,
            ),

            const SizedBox(height: 12),

            // Date and duration row
            Row(
              children: [
                // Date picker
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: todo.scheduledDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        onDateChanged(date);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formattedDate,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Duration input
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            initialValue: todo.estimatedMinutes.toString(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final minutes = int.tryParse(value);
                              if (minutes != null && minutes > 0) {
                                onMinutesChanged(minutes);
                              }
                            },
                          ),
                        ),
                        const Text(
                          '分钟',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
