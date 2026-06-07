import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/big_goal_model.dart';

class GoalsListPage extends ConsumerWidget {
  const GoalsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的目标'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ColoredBox(
        color: AppColors.background,
        child: _buildBody(context, authState, userId),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: userId == null ? null : () => context.go('/goals/create'),
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBody(BuildContext context, AuthState authState, int? userId) {
    if (authState.isUnknown || authState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/login');
        }
      });
      return const _AuthRequiredMessage();
    }

    return _GoalsListContent(userId: userId);
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
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
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '首页'),
        BottomNavigationBarItem(icon: Icon(Icons.flag_rounded), label: '目标'),
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
}

class _GoalsListContent extends ConsumerWidget {
  const _GoalsListContent({required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(_watchGoalsProvider(userId));

    return goalsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorMessage(
        message: '加载目标失败：$error',
        onRetry: () => ref.invalidate(_watchGoalsProvider(userId)),
      ),
      data: (goals) {
        if (goals.isEmpty) {
          return _EmptyGoalsState(onCreate: () => context.go('/goals/create'));
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(_watchGoalsProvider(userId)),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
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
          SnackBar(content: Text('删除失败：$e'), backgroundColor: AppColors.error),
        );
      }
    }
  }
}

final _watchGoalsProvider = StreamProvider.family<List<BigGoalModel>, int>((
  ref,
  userId,
) {
  final repo = ref.watch(bigGoalRepositoryProvider);
  return repo.watchGoalsByUserId(userId);
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
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                    color: AppColors.error,
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
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              Row(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(goal.targetDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(_statusText(goal.status)),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
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
            Icon(Icons.flag_outlined, size: 80, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text('暂无目标', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '创建你的第一个目标吧',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('创建目标'),
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
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
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

class _AuthRequiredMessage extends StatelessWidget {
  const _AuthRequiredMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '登录状态已失效，请重新登录。',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
