import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/big_goal_model.dart';
import '../../widgets/smartisan_components.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class GoalsListPage extends ConsumerWidget {
  const GoalsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的目标'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ColoredBox(
        color: context.palette.canvas,
        child: const _GoalsListContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/goals/create'),
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return SmartisanGlassBottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            break;
          case 2:
            context.go('/focus');
            break;
          case 3:
            context.go('/calendar');
            break;
          case 4:
            context.go('/settings');
            break;
        }
      },
    );
  }
}

class _GoalsListContent extends ConsumerWidget {
  const _GoalsListContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(_watchGoalsProvider);

    return goalsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorMessage(
        message: '加载目标失败：$error',
        onRetry: () => ref.invalidate(_watchGoalsProvider),
      ),
      data: (goals) {
        if (goals.isEmpty) {
          return _EmptyGoalsState(onCreate: () => context.go('/goals/create'));
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(_watchGoalsProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final goal = goals[index];
              return _GoalCard(
                goal: goal,
                onTap: () => context.go('/goals/${goal.id}'),
                onDelete: () => _confirmDelete(context, ref, goal),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    BigGoalModel goal,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除目标'),
        content: Text('确定要删除目标"${goal.title}"吗？\n删除后会同时删除这个目标下的所有任务。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final goalRepo = ref.read(bigGoalRepositoryProvider);
      final todoRepo = ref.read(todoItemRepositoryProvider);
      await todoRepo.deleteTodosByGoalId(goal.id);
      await goalRepo.deleteGoal(goal.id);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('目标"${goal.title}"已删除')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败：$e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

final _watchGoalsProvider = StreamProvider<List<BigGoalModel>>((ref) {
  final repo = ref.watch(bigGoalRepositoryProvider);
  return repo.watchGoals();
});

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.onTap,
    required this.onDelete,
  });

  final BigGoalModel goal;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      goal.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: '删除',
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: Theme.of(context).colorScheme.error,
                    onPressed: onDelete,
                  ),
                ],
              ),
              if (goal.description != null && goal.description!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  goal.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.palette.mutedInk,
                  ),
                ),
              ],
              Row(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 16,
                    color: context.palette.mutedInk,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(goal.targetDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.palette.mutedInk,
                    ),
                  ),
                  const Spacer(),
                  GlassChip(
                    label: _statusText(goal.status),
                    icon: const Icon(
                      Icons.flag_rounded,
                      size: 14,
                      color: Color(0xFF8B6F47),
                    ),
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }

  String _statusText(GoalStatus status) {
    switch (status) {
      case GoalStatus.inProgress:
        return '进行中';
      case GoalStatus.completed:
        return '已完成';
      case GoalStatus.abandoned:
        return '已放弃';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _EmptyGoalsState extends StatelessWidget {
  const _EmptyGoalsState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 80, color: context.palette.hintInk),
            const SizedBox(height: 16),
            Text('暂无目标', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '创建你的第一个目标吧',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.palette.mutedInk),
            ),
            const SizedBox(height: 24),
            GlassButton(
              label: '创建目标',
              icon: const Icon(Icons.add_rounded),
              onTap: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: context.palette.mutedInk),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}
