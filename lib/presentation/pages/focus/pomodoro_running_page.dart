import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../application/pomodoro/pomodoro_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/pomodoro_session_model.dart';
import '../../../data/models/pomodoro_task_model.dart';
import '../../widgets/liquid_glass.dart';

class PomodoroRunningPage extends ConsumerStatefulWidget {
  const PomodoroRunningPage({
    required this.planId,
    required this.sessionId,
    super.key,
  });

  final int planId;
  final int sessionId;

  @override
  ConsumerState<PomodoroRunningPage> createState() =>
      _PomodoroRunningPageState();
}

class _PomodoroRunningPageState extends ConsumerState<PomodoroRunningPage> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(pomodoroSessionsProvider(widget.planId));
    final tasksAsync = ref.watch(pomodoroTasksProvider(widget.planId));

    return Scaffold(
      backgroundColor: context.palette.canvas,
      body: LiquidGlassBackground(
        child: SafeArea(
          child: sessionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _EndedState(message: '加载番茄状态失败：$error'),
            data: (sessions) => tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _EndedState(message: '加载任务失败：$error'),
              data: (tasks) => _buildContent(sessions, tasks),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    List<PomodoroSessionModel> sessions,
    List<PomodoroTaskModel> tasks,
  ) {
    final session = sessions
        .where((item) => item.id == widget.sessionId)
        .firstOrNull;
    if (session == null) {
      return const _EndedState(message: '这一轮番茄已经结束');
    }

    final task = tasks.where((item) => item.id == session.taskId).firstOrNull;
    if (task == null) {
      return const _EndedState(message: '找不到当前番茄任务');
    }

    if (!_isActive(session.status)) {
      if (session.status == PomodoroSessionStatus.completed) {
        final nextTask = _nextRunnableTask(
          task: task,
          tasks: tasks,
          sessions: sessions,
        );
        return _CompletionChoiceState(
          task: task,
          nextTask: nextTask,
          onReturn: () => context.go('/focus'),
          onStartNext: nextTask == null ? null : () => _startNext(nextTask),
        );
      }
      return const _EndedState(message: '这一轮番茄已经结束');
    }

    final completedForTask = sessions
        .where(
          (item) =>
              item.taskId == task.id &&
              item.status == PomodoroSessionStatus.completed,
        )
        .length;
    final isResting =
        session.status == PomodoroSessionStatus.resting ||
        session.status == PomodoroSessionStatus.restPaused;
    final isPaused =
        session.status == PomodoroSessionStatus.focusPaused ||
        session.status == PomodoroSessionStatus.restPaused;
    final nextInfo = _nextInfo(
      session: session,
      task: task,
      tasks: tasks,
      completedForTask: completedForTask,
      isResting: isResting,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () => context.go('/focus'),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                label: const Text('退出'),
              ),
              const Spacer(),
              Text(
                isResting ? '休息中' : '番茄中',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.palette.ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: '返回专注',
                onPressed: () => context.go('/focus'),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
            child: _HeroTimerPanel(
              session: session,
              task: task,
              isResting: isResting,
              isPaused: isPaused,
              completedForTask: completedForTask,
              remainingText: _remainingText(session),
            ),
          ),
        ),
        Expanded(
          flex: 11,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: _LowerInfoPanel(
              session: session,
              task: task,
              isResting: isResting,
              isPaused: isPaused,
              completedForTask: completedForTask,
              nextInfo: nextInfo,
              onPauseResume: () => isPaused
                  ? ref.read(pomodoroActionsProvider).resumeSession(session)
                  : ref.read(pomodoroActionsProvider).pauseSession(session),
              onComplete: () => isResting
                  ? ref.read(pomodoroActionsProvider).completeBreak(session)
                  : ref.read(pomodoroActionsProvider).completeFocus(session),
              onExit: () => context.go('/focus'),
              onAbandon: () => _confirmAbandon(session),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startNext(PomodoroTaskModel task) async {
    final session = await ref.read(pomodoroActionsProvider).startTask(task);
    if (!mounted) return;
    context.go('/focus/session/${task.planId}/${session.id}');
  }

  Future<void> _confirmAbandon(PomodoroSessionModel session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('放弃本轮？'),
        content: const Text('这会停止当前倒计时，并取消本轮通知。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '放弃本轮',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref.read(pomodoroActionsProvider).abandonSession(session);
    if (mounted) context.go('/focus');
  }

  _NextInfo _nextInfo({
    required PomodoroSessionModel session,
    required PomodoroTaskModel task,
    required List<PomodoroTaskModel> tasks,
    required int completedForTask,
    required bool isResting,
  }) {
    if (!isResting && session.breakMinutes > 0) {
      return _NextInfo(
        title: '下一个：休息 ${session.breakMinutes} 分钟',
        subtitle: '完成当前专注后进入短休息或长休息。',
        icon: Icons.local_cafe_rounded,
      );
    }

    final taskHasMoreFocus = completedForTask < task.plannedFocusSegments;
    if (isResting && taskHasMoreFocus) {
      return _NextInfo(
        title: '下一个番茄：${task.title}',
        subtitle: '${task.focusMinutes} 分钟专注',
        icon: Icons.timer_rounded,
      );
    }

    final nextTask =
        tasks.where((item) => !item.isCompleted && item.id != task.id).toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    if (nextTask.isNotEmpty) {
      return _NextInfo(
        title: '下一个番茄：${nextTask.first.title}',
        subtitle: '${nextTask.first.focusMinutes} 分钟专注',
        icon: Icons.next_plan_rounded,
      );
    }

    return const _NextInfo(
      title: '今日番茄已排到最后',
      subtitle: '完成后可以回到专注列表保存和复盘。',
      icon: Icons.flag_rounded,
    );
  }

  PomodoroTaskModel? _nextRunnableTask({
    required PomodoroTaskModel task,
    required List<PomodoroTaskModel> tasks,
    required List<PomodoroSessionModel> sessions,
  }) {
    final completedForTask = sessions
        .where(
          (item) =>
              item.taskId == task.id &&
              item.status == PomodoroSessionStatus.completed,
        )
        .length;
    if (!task.isCompleted && completedForTask < task.plannedFocusSegments) {
      return task;
    }
    final nextTasks =
        tasks.where((item) => !item.isCompleted && item.id != task.id).toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return nextTasks.firstOrNull;
  }

  bool _isActive(PomodoroSessionStatus status) {
    return status == PomodoroSessionStatus.focusing ||
        status == PomodoroSessionStatus.focusPaused ||
        status == PomodoroSessionStatus.resting ||
        status == PomodoroSessionStatus.restPaused;
  }

  String _remainingText(PomodoroSessionModel session) {
    if (session.pausedRemainingSeconds != null) {
      return _formatSeconds(session.pausedRemainingSeconds!);
    }
    final target = session.targetEndAt;
    if (target == null) return '00:00';
    final seconds = target.difference(DateTime.now()).inSeconds;
    return _formatSeconds(seconds < 0 ? 0 : seconds);
  }

  String _formatSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${rest.toString().padLeft(2, '0')}';
  }
}

class _HeroTimerPanel extends StatelessWidget {
  const _HeroTimerPanel({
    required this.session,
    required this.task,
    required this.isResting,
    required this.isPaused,
    required this.completedForTask,
    required this.remainingText,
  });

  final PomodoroSessionModel session;
  final PomodoroTaskModel task;
  final bool isResting;
  final bool isPaused;
  final int completedForTask;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    final status = isPaused ? '已暂停' : (isResting ? '休息中' : '专注中');
    return LiquidGlassPanel(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      borderRadius: BorderRadius.circular(34),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: context.palette.gold,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: context.palette.ink,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 22),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              remainingText,
              style: TextStyle(
                color: context.palette.ink,
                fontSize: 76,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '第 ${session.sessionIndex + 1} 轮 · 已完成 $completedForTask / ${task.plannedFocusSegments} 个番茄',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.palette.mutedInk,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LowerInfoPanel extends StatelessWidget {
  const _LowerInfoPanel({
    required this.session,
    required this.task,
    required this.isResting,
    required this.isPaused,
    required this.completedForTask,
    required this.nextInfo,
    required this.onPauseResume,
    required this.onComplete,
    required this.onExit,
    required this.onAbandon,
  });

  final PomodoroSessionModel session;
  final PomodoroTaskModel task;
  final bool isResting;
  final bool isPaused;
  final int completedForTask;
  final _NextInfo nextInfo;
  final VoidCallback onPauseResume;
  final VoidCallback onComplete;
  final VoidCallback onExit;
  final VoidCallback onAbandon;

  @override
  Widget build(BuildContext context) {
    final target = session.targetEndAt;
    final endText = target == null
        ? '--:--'
        : DateFormat('HH:mm').format(target);
    final remainingFocus = (task.plannedFocusSegments - completedForTask).clamp(
      0,
      task.plannedFocusSegments,
    );

    return LiquidGlassPanel(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      borderRadius: BorderRadius.circular(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NextCard(info: nextInfo),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.flag_rounded,
                label: '剩余 $remainingFocus 个',
              ),
              _InfoChip(icon: Icons.schedule_rounded, label: '预计 $endText'),
              _InfoChip(
                icon: Icons.coffee_rounded,
                label: isResting
                    ? '休息 ${session.breakMinutes} 分钟'
                    : '专注 ${session.focusMinutes} 分钟',
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPauseResume,
                  icon: Icon(
                    isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  ),
                  label: Text(isPaused ? '继续' : '暂停'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(isResting ? '结束休息' : '完成专注'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onExit,
                  icon: const Icon(Icons.keyboard_return_rounded),
                  label: const Text('退出全屏'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: onAbandon,
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('放弃本轮'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextCard extends StatelessWidget {
  const _NextCard({required this.info});

  final _NextInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.palette.ceramic.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.palette.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.palette.gold.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(info.icon, color: context.palette.goldPressed),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.palette.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  info.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.mutedInk,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: context.palette.ceramicRaised.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: context.palette.mutedInk),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.palette.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionChoiceState extends StatelessWidget {
  const _CompletionChoiceState({
    required this.task,
    required this.nextTask,
    required this.onReturn,
    required this.onStartNext,
  });

  final PomodoroTaskModel task;
  final PomodoroTaskModel? nextTask;
  final VoidCallback onReturn;
  final VoidCallback? onStartNext;

  @override
  Widget build(BuildContext context) {
    final next = nextTask;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      child: Column(
        children: [
          Expanded(
            child: LiquidGlassPanel(
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
              borderRadius: BorderRadius.circular(34),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: context.palette.goldPressed,
                    size: 62,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '当前番茄已完成',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: context.palette.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.palette.mutedInk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          LiquidGlassPanel(
            padding: const EdgeInsets.all(18),
            borderRadius: BorderRadius.circular(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _NextCard(
                  info: _NextInfo(
                    title: next == null ? '今日番茄已完成' : '下一个番茄：${next.title}',
                    subtitle: next == null
                        ? '可以返回专注列表查看保存和历史记录。'
                        : '${next.focusMinutes} 分钟专注',
                    icon: next == null
                        ? Icons.flag_rounded
                        : Icons.next_plan_rounded,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReturn,
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('返回专注'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onStartNext,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('开始下一个番茄'),
                      ),
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
}

class _EndedState extends StatelessWidget {
  const _EndedState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LiquidGlassPanel(
          padding: const EdgeInsets.all(22),
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: context.palette.goldPressed,
                size: 54,
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.palette.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.go('/focus'),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('返回专注'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextInfo {
  const _NextInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
