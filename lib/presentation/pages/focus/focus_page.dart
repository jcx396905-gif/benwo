import 'dart:async';
import '../../widgets/app_glass_nav_bar.dart';
import '../../widgets/glass_mesh_background.dart';

import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../application/pomodoro/pomodoro_ai_service.dart';
import '../../../application/pomodoro/pomodoro_providers.dart';
import '../../../application/pomodoro/pomodoro_schedule_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/pomodoro_plan_model.dart';
import '../../../data/models/saved_pomodoro_list_model.dart';
import '../../../data/models/pomodoro_session_model.dart';
import '../../../data/models/pomodoro_task_model.dart';

DateTime _focusDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

class _FocusStyle {
  const _FocusStyle(this.context);

  final BuildContext context;

  Color get background => context.palette.canvas;
  Color get paper => context.palette.ceramic;
  Color get raised => context.palette.ceramicRaised;
  Color get ink => context.palette.ink;
  Color get mutedInk => context.palette.mutedInk;
  Color get hintInk => context.palette.hintInk;
  Color get line => context.palette.hairline;
  Color get accent => context.palette.gold;
  Color get warm => context.palette.terracotta;
  Color get danger => Theme.of(context).colorScheme.error;
}

_FocusStyle _focusStyle(BuildContext context) => _FocusStyle(context);

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({super.key});

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage> {
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
    final today = _focusDateOnly(DateTime.now());

    return Scaffold(
      backgroundColor: _focusStyle(context).background,
      appBar: AppBar(
        backgroundColor: _focusStyle(context).background,
        foregroundColor: _focusStyle(context).ink,
        title: const Text('专注'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: _focusStyle(context).ink,
          fontWeight: FontWeight.w800,
        ),
        actions: [
          IconButton(
            tooltip: '已保存番茄列表',
            icon: const Icon(Icons.folder_special_rounded),
            onPressed: () => _showSavedLists(context, ref, today),
          ),
          IconButton(
            tooltip: '刷新今日番茄计划',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(todayPomodoroPlanProvider(today)),
          ),
        ],
      ),
      body: GlassMeshBackground(child: _buildBody(today)),
      bottomNavigationBar: AppGlassNavBar(index: 2),
    );
  }

  Future<void> _showSavedLists(
    BuildContext context,
    WidgetRef ref,
    DateTime today,
  ) async {
    try {
      final plan = await ref.read(todayPomodoroPlanProvider(today).future);
      if (!context.mounted) return;
      unawaited(
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _SavedPomodoroListsSheet(plan: plan),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('打开保存列表失败：$error')));
    }
  }

  Widget _buildBody(DateTime today) {
    final planAsync = ref.watch(todayPomodoroPlanProvider(today));
    return planAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        message: '加载专注计划失败：$error',
        onRetry: () => ref.invalidate(todayPomodoroPlanProvider(today)),
      ),
      data: (plan) => _PlanContent(plan: plan),
    );
  }
}

class _PlanContent extends ConsumerWidget {
  const _PlanContent({required this.plan});

  final PomodoroPlanModel plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(pomodoroTasksProvider(plan.id));
    final sessionsAsync = ref.watch(pomodoroSessionsProvider(plan.id));

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(message: '加载番茄任务失败：$error'),
      data: (tasks) => sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: '加载番茄记录失败：$error'),
        data: (sessions) {
          final schedule = ref
              .watch(pomodoroScheduleServiceProvider)
              .buildSchedule(
                planDate: plan.date,
                tasks: tasks,
                earliestStart: DateTime.now(),
              );
          final scheduledByTaskId = {
            for (final item in schedule.tasks) item.task.id: item,
          };

          return RefreshIndicator(
            onRefresh: () => ref
                .read(pomodoroActionsProvider)
                .importTodos(plan)
                .then((_) => ref.invalidate(pomodoroTasksProvider(plan.id))),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _OverviewCard(
                    plan: plan,
                    tasks: tasks,
                    sessions: sessions,
                    schedule: schedule,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _PlanToolbar(
                    plan: plan,
                    sessions: sessions,
                    onSave: () => _savePlan(context, ref, plan),
                    onHistory: () => _showHistorySheet(context, sessions),
                  ),
                ),
                SliverToBoxAdapter(child: _AiActions(plan: plan)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: Row(
                      children: [
                        Text(
                          '今日番茄任务',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: _focusStyle(context).ink,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${tasks.length}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: _focusStyle(context).mutedInk),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () =>
                              _showAddTaskSheet(context, ref, plan),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('新建'),
                        ),
                      ],
                    ),
                  ),
                ),
                if (tasks.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 36, 16, 120),
                      child: _EmptyFocusState(),
                    ),
                  )
                else
                  SliverReorderableList(
                    itemCount: tasks.length,
                    onReorder: (oldIndex, newIndex) {
                      final targetIndex = newIndex > oldIndex
                          ? newIndex - 1
                          : newIndex;
                      ref
                          .read(pomodoroActionsProvider)
                          .moveTask(
                            tasks: tasks,
                            fromIndex: oldIndex,
                            toIndex: targetIndex,
                          );
                    },
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        key: ValueKey(task.id),
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _TaskCard(
                          task: task,
                          scheduledTask: scheduledByTaskId[task.id],
                          index: index,
                          sessions: sessions,
                        ),
                      );
                    },
                  ),
                const SliverToBoxAdapter(child: _OperationGuide()),
                const SliverToBoxAdapter(child: SizedBox(height: 96)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTaskSheet(
    BuildContext context,
    WidgetRef ref,
    PomodoroPlanModel plan,
  ) {
    final titleController = TextEditingController();
    final minutesController = TextEditingController();
    final timeController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(20),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('新建番茄任务', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              autofocus: true,
              decoration: const InputDecoration(labelText: '任务标题'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '预计专注分钟数'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: '固定开始时间（可选，例如 19:00）',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_rounded),
                label: const Text('保存'),
                onPressed: () async {
                  final title = titleController.text.trim();
                  if (title.isEmpty) return;
                  await ref
                      .read(pomodoroActionsProvider)
                      .addManualTask(
                        plan: plan,
                        title: title,
                        estimatedMinutes: int.tryParse(
                          minutesController.text.trim(),
                        ),
                        scheduledTime: _validTimeOrNull(timeController.text),
                      );
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _savePlan(
    BuildContext context,
    WidgetRef ref,
    PomodoroPlanModel plan,
  ) async {
    final controller = TextEditingController(
      text: DateFormat('M月d日 番茄计划').format(plan.date),
    );
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('保存番茄列表'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '列表名称',
            hintText: '例如：晚自习番茄',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;

    final saved = await ref
        .read(pomodoroActionsProvider)
        .saveCurrentList(plan: plan, name: name);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已保存“${saved.name}”')));
  }

  void _showHistorySheet(
    BuildContext context,
    List<PomodoroSessionModel> sessions,
  ) {
    final completed =
        sessions
            .where((item) => item.status == PomodoroSessionStatus.completed)
            .toList()
          ..sort(
            (a, b) => (b.completedAt ?? b.createdAt).compareTo(
              a.completedAt ?? a.createdAt,
            ),
          );
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _HistorySheet(sessions: completed),
    );
  }

  String? _validTimeOrNull(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;
    final parts = text.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

class _OverviewCard extends ConsumerWidget {
  const _OverviewCard({
    required this.plan,
    required this.tasks,
    required this.sessions,
    required this.schedule,
  });

  final PomodoroPlanModel plan;
  final List<PomodoroTaskModel> tasks;
  final List<PomodoroSessionModel> sessions;
  final PomodoroScheduleResult schedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedSessions = sessions
        .where((item) => item.status == PomodoroSessionStatus.completed)
        .toList();
    final totalSegments = tasks.fold<int>(
      0,
      (sum, task) => sum + task.plannedFocusSegments,
    );
    final focusSeconds = completedSessions.fold<int>(
      0,
      (sum, item) => sum + item.actualFocusSeconds,
    );
    final breakSeconds = completedSessions.fold<int>(
      0,
      (sum, item) => sum + item.actualBreakSeconds,
    );
    final running = _runningSessionOrNull(sessions);
    final runningTask = running == null
        ? null
        : _taskByIdOrNull(tasks: tasks, taskId: running.taskId);

    return _GlassPanel(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今日专注',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _focusStyle(context).ink,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('yyyy年MM月dd日').format(plan.date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _focusStyle(context).mutedInk,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: totalSegments == 0
                  ? 0
                  : (completedSessions.length / totalSegments).clamp(0, 1),
              backgroundColor: _focusStyle(context).line,
              valueColor: AlwaysStoppedAnimation(_focusStyle(context).accent),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _MetricChip(
                icon: Icons.check_circle_rounded,
                label: '已完成 ${completedSessions.length} / $totalSegments',
              ),
              _MetricChip(
                icon: Icons.psychology_rounded,
                label: '专注 ${(focusSeconds / 60).round()} 分钟',
              ),
              _MetricChip(
                icon: Icons.local_cafe_rounded,
                label: '休息 ${(breakSeconds / 60).round()} 分钟',
              ),
            ],
          ),
          if (schedule.hasConflicts) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _focusStyle(context).danger.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _focusStyle(context).danger.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                schedule.conflicts.take(2).join('\n'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _focusStyle(context).danger,
                ),
              ),
            ),
          ],
          if (running != null && runningTask != null) ...[
            const SizedBox(height: 16),
            _RunningSessionPanel(
              session: running,
              task: runningTask,
              planId: plan.id,
            ),
          ] else ...[
            const SizedBox(height: 16),
            Text(
              tasks.isEmpty ? '今天还没有番茄任务。' : '选择一个任务开始专注。',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _focusStyle(context).mutedInk,
              ),
            ),
          ],
        ],
      ),
    );
  }

  PomodoroSessionModel? _runningSessionOrNull(
    List<PomodoroSessionModel> sessions,
  ) {
    for (final session in sessions) {
      switch (session.status) {
        case PomodoroSessionStatus.focusing:
        case PomodoroSessionStatus.focusPaused:
        case PomodoroSessionStatus.resting:
        case PomodoroSessionStatus.restPaused:
          return session;
        case PomodoroSessionStatus.pending:
        case PomodoroSessionStatus.completed:
        case PomodoroSessionStatus.skipped:
        case PomodoroSessionStatus.abandoned:
          break;
      }
    }
    return null;
  }

  PomodoroTaskModel? _taskByIdOrNull({
    required List<PomodoroTaskModel> tasks,
    required int taskId,
  }) {
    for (final task in tasks) {
      if (task.id == taskId) return task;
    }
    return null;
  }
}

class _PlanToolbar extends StatelessWidget {
  const _PlanToolbar({
    required this.plan,
    required this.sessions,
    required this.onSave,
    required this.onHistory,
  });

  final PomodoroPlanModel plan;
  final List<PomodoroSessionModel> sessions;
  final VoidCallback onSave;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _SoftActionButton(
              icon: Icons.save_rounded,
              label: '保存计划',
              onPressed: onSave,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SoftActionButton(
              icon: Icons.history_rounded,
              label: '历史记录',
              onPressed: onHistory,
              badge: sessions
                  .where(
                    (item) => item.status == PomodoroSessionStatus.completed,
                  )
                  .length
                  .toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationGuide extends StatelessWidget {
  const _OperationGuide();

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      color: _focusStyle(context).paper.withValues(alpha: 0.54),
      borderColor: _focusStyle(context).line.withValues(alpha: 0.72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '操作说明',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _focusStyle(context).mutedInk,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const _GuideLine(text: '拖动左侧手柄：调整今日番茄顺序，立即保存到本地。'),
          const _GuideLine(text: '开始当前番茄：进入本地倒计时，只会有一个任务运行。'),
          const _GuideLine(text: '时长：修改这个任务的专注分钟数，并重新拆分番茄。'),
          const _GuideLine(text: '固定：锁定或解除固定开始时间，冲突由本地检测。'),
          const _GuideLine(text: '完成：标记番茄任务完成，并同步关联 Todo。'),
          const _GuideLine(text: '移除：只移出今日专注计划，不删除原 Todo。'),
        ],
      ),
    );
  }
}

class _GuideLine extends StatelessWidget {
  const _GuideLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '· ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _focusStyle(context).warm,
              height: 1.18,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _focusStyle(context).mutedInk,
                height: 1.18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySheet extends StatelessWidget {
  const _HistorySheet({required this.sessions});

  final List<PomodoroSessionModel> sessions;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      radius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded, color: _focusStyle(context).ink),
                const SizedBox(width: 8),
                Text(
                  '专注历史',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _focusStyle(context).ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (sessions.isEmpty)
              Text(
                '还没有完成的番茄记录。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _focusStyle(context).mutedInk,
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: sessions.length,
                  separatorBuilder: (_, _) =>
                      Divider(color: _focusStyle(context).line, height: 1),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final time = session.completedAt ?? session.createdAt;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.check_circle_rounded,
                        color: _focusStyle(context).accent,
                      ),
                      title: Text(
                        '${(session.actualFocusSeconds / 60).round()} 分钟专注',
                        style: TextStyle(color: _focusStyle(context).ink),
                      ),
                      subtitle: Text(
                        DateFormat('MM月dd日 HH:mm').format(time),
                        style: TextStyle(color: _focusStyle(context).mutedInk),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SavedPomodoroListsSheet extends ConsumerWidget {
  const _SavedPomodoroListsSheet({required this.plan});
  final PomodoroPlanModel plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(savedPomodoroListsProvider);
    return _GlassPanel(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      radius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_special_rounded,
                  color: _focusStyle(context).ink,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '已保存番茄列表',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _focusStyle(context).ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '关闭',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '可以追加到今天，也可以替换今天未开始的番茄任务。',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _focusStyle(context).mutedInk,
              ),
            ),
            const SizedBox(height: 14),
            listsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  '加载保存列表失败：$error',
                  style: TextStyle(color: _focusStyle(context).danger),
                ),
              ),
              data: (lists) {
                if (lists.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      '还没有保存的番茄列表。先点击“保存计划”创建一个。',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _focusStyle(context).mutedInk,
                      ),
                    ),
                  );
                }
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.64,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    separatorBuilder: (_, _) =>
                        Divider(color: _focusStyle(context).line, height: 1),
                    itemBuilder: (context, index) {
                      final list = lists[index];
                      return _SavedPomodoroListTile(
                        list: list,
                        onAppend: () =>
                            _useList(context, ref, list, replaceToday: false),
                        onReplace: () =>
                            _useList(context, ref, list, replaceToday: true),
                        onRename: () => _renameList(context, ref, list),
                        onDelete: () => _deleteList(context, ref, list),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _useList(
    BuildContext context,
    WidgetRef ref,
    SavedPomodoroListModel list, {
    required bool replaceToday,
  }) async {
    try {
      final imported = await ref
          .read(pomodoroActionsProvider)
          .addSavedListToPlan(
            plan: plan,
            list: list,
            replaceToday: replaceToday,
          );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            replaceToday
                ? '已用“${list.name}”替换今日未开始任务，共 $imported 个'
                : '已追加“${list.name}”，共 $imported 个',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _renameList(
    BuildContext context,
    WidgetRef ref,
    SavedPomodoroListModel list,
  ) async {
    final controller = TextEditingController(text: list.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重命名番茄列表'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: '列表名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    await ref
        .read(pomodoroActionsProvider)
        .renameSavedList(list: list, name: name);
  }

  Future<void> _deleteList(
    BuildContext context,
    WidgetRef ref,
    SavedPomodoroListModel list,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除番茄列表？'),
        content: Text('“${list.name}”会从本地保存列表中移除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: _focusStyle(context).danger,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(pomodoroActionsProvider).deleteSavedList(list);
  }
}

class _SavedPomodoroListTile extends StatelessWidget {
  const _SavedPomodoroListTile({
    required this.list,
    required this.onAppend,
    required this.onReplace,
    required this.onRename,
    required this.onDelete,
  });

  final SavedPomodoroListModel list;
  final VoidCallback onAppend;
  final VoidCallback onReplace;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final updatedAt = list.updatedAt ?? list.createdAt;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _focusStyle(context).accent.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.timer_rounded,
                  color: _focusStyle(context).ink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _focusStyle(context).ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${list.taskCount} 个任务 · ${list.totalMinutes} 分钟 · ${DateFormat('MM月dd日 HH:mm').format(updatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _focusStyle(context).mutedInk,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TaskActionChip(
                icon: Icons.add_task_rounded,
                label: '追加到今天',
                onPressed: onAppend,
              ),
              _TaskActionChip(
                icon: Icons.swap_horiz_rounded,
                label: '替换今天',
                onPressed: onReplace,
              ),
              _TaskActionChip(
                icon: Icons.edit_rounded,
                label: '重命名',
                onPressed: onRename,
              ),
              _TaskActionChip(
                icon: Icons.delete_outline_rounded,
                label: '删除',
                danger: true,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SoftActionButton extends StatelessWidget {
  const _SoftActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (badge != null) ...[const SizedBox(width: 6), Text('($badge)')],
        ],
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: _focusStyle(context).ink,
        side: BorderSide(color: _focusStyle(context).line),
        backgroundColor: context.palette.ceramicRaised,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }
}

class _RunningSessionPanel extends ConsumerWidget {
  const _RunningSessionPanel({
    required this.session,
    required this.task,
    required this.planId,
  });

  final PomodoroSessionModel session;
  final PomodoroTaskModel task;
  final int planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = _remainingText(session);
    final isPaused =
        session.status == PomodoroSessionStatus.focusPaused ||
        session.status == PomodoroSessionStatus.restPaused;
    final isResting =
        session.status == PomodoroSessionStatus.resting ||
        session.status == PomodoroSessionStatus.restPaused;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _focusStyle(context).raised,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isResting ? Icons.local_cafe_rounded : Icons.timer_rounded,
                color: _focusStyle(context).accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isResting ? '休息中：${task.title}' : '专注中：${task.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            remaining,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: _focusStyle(context).accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => isPaused
                      ? ref.read(pomodoroActionsProvider).resumeSession(session)
                      : ref.read(pomodoroActionsProvider).pauseSession(session),
                  icon: Icon(
                    isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  ),
                  label: Text(isPaused ? '继续' : '暂停'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => isResting
                      ? ref.read(pomodoroActionsProvider).completeBreak(session)
                      : ref
                            .read(pomodoroActionsProvider)
                            .completeFocus(session),
                  icon: const Icon(Icons.check_rounded),
                  label: Text(isResting ? '结束休息' : '完成专注'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => unawaited(
                context.push('/focus/session/$planId/${session.id}'),
              ),
              icon: const Icon(Icons.open_in_full_rounded),
              label: const Text('进入全屏番茄中'),
            ),
          ),
        ],
      ),
    );
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

class _AiActions extends ConsumerWidget {
  const _AiActions({required this.plan});

  final PomodoroPlanModel plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showAiInput(context, ref),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('AI 安排今天'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('已使用本地规则刷新 Todo 导入；AI 重排会先生成预览再保存。'),
                  ),
                );
                ref.read(pomodoroActionsProvider).importTodos(plan);
              },
              icon: const Icon(Icons.route_rounded),
              label: const Text('重新排程'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAiInput(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final input = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI 一句话生成计划'),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '例如：今晚先写数学试卷，再背英语单词，总共两小时',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('生成预览'),
          ),
        ],
      ),
    );
    if (input == null || input.isEmpty || !context.mounted) return;

    try {
      final draft = await showDialog<AiPomodoroPlanDraft>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _AiStreamPlanDialog(input: input),
      );
      if (draft == null) return;
      await ref
          .read(pomodoroActionsProvider)
          .saveAiDraft(plan: plan, draft: draft);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已保存 ${draft.tasks.length} 个 AI 番茄任务')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI 暂时不可用：$error。你仍可使用本地番茄计划。'),
          backgroundColor: _focusStyle(context).danger,
        ),
      );
    }
  }
}

class _AiStreamPlanDialog extends ConsumerStatefulWidget {
  const _AiStreamPlanDialog({required this.input});

  final String input;

  @override
  ConsumerState<_AiStreamPlanDialog> createState() =>
      _AiStreamPlanDialogState();
}

class _AiStreamPlanDialogState extends ConsumerState<_AiStreamPlanDialog> {
  StreamSubscription<String>? _subscription;
  final StringBuffer _buffer = StringBuffer();
  AiPomodoroPlanDraft? _draft;
  String? _error;
  bool _isStreaming = true;

  @override
  void initState() {
    super.initState();
    _startStreaming();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _startStreaming() {
    final service = ref.read(pomodoroAiServiceProvider);
    _subscription = service
        .streamPlanDraftText(widget.input)
        .listen(
          (chunk) {
            if (!mounted) return;
            setState(() => _buffer.write(chunk));
          },
          onError: (Object error) {
            if (!mounted) return;
            setState(() {
              _error = error.toString();
              _isStreaming = false;
            });
          },
          onDone: () {
            if (!mounted) return;
            try {
              final parsed = service.parsePlanDraft(_buffer.toString());
              setState(() {
                _draft = parsed;
                _isStreaming = false;
              });
            } catch (error) {
              setState(() {
                _error = error.toString();
                _isStreaming = false;
              });
            }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: _focusStyle(context).accent),
          const SizedBox(width: 8),
          Expanded(child: Text(_isStreaming ? 'AI 正在生成' : 'AI 计划预览')),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isStreaming) ...[
              _AiGeneratingState(receivedChars: _buffer.length),
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (_error != null) ...[
              Text(
                '校验失败：$_error',
                style: TextStyle(color: _focusStyle(context).danger),
              ),
            ],
            if (draft != null) ...[
              Text(draft.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: draft.tasks.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final task = draft.tasks[index];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(task.title),
                      subtitle: Text(
                        [
                          if (task.estimatedMinutes != null)
                            '${task.estimatedMinutes} 分钟',
                          if (task.scheduledTime != null) task.scheduledTime!,
                          if (task.steps.isNotEmpty) '${task.steps.length} 个步骤',
                        ].join(' · '),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(_isStreaming ? '停止' : '取消'),
        ),
        ElevatedButton(
          onPressed: draft == null ? null : () => Navigator.pop(context, draft),
          child: const Text('确认保存'),
        ),
      ],
    );
  }
}

class _AiGeneratingState extends StatelessWidget {
  const _AiGeneratingState({required this.receivedChars});

  final int receivedChars;

  @override
  Widget build(BuildContext context) {
    final hasStarted = receivedChars > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _focusStyle(context).raised,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasStarted ? '正在整理计划预览' : '正在等待 AI 响应',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  hasStarted
                      ? '已收到 AI 建议，正在转换成可确认的番茄计划。'
                      : 'AI 会返回结构化数据，页面只展示转换后的计划。',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _focusStyle(context).mutedInk,
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

class _TaskCard extends ConsumerWidget {
  const _TaskCard({
    required this.task,
    required this.scheduledTask,
    required this.index,
    required this.sessions,
  });

  final PomodoroTaskModel task;
  final PomodoroScheduledTask? scheduledTask;
  final int index;
  final List<PomodoroSessionModel> sessions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = sessions
        .where(
          (item) =>
              item.taskId == task.id &&
              item.status == PomodoroSessionStatus.completed,
        )
        .length;
    final running = sessions.any(
      (item) =>
          item.taskId == task.id &&
          (item.status == PomodoroSessionStatus.focusing ||
              item.status == PomodoroSessionStatus.focusPaused ||
              item.status == PomodoroSessionStatus.resting ||
              item.status == PomodoroSessionStatus.restPaused),
    );
    final hasActiveSession = sessions.any(
      (item) =>
          item.status == PomodoroSessionStatus.focusing ||
          item.status == PomodoroSessionStatus.focusPaused ||
          item.status == PomodoroSessionStatus.resting ||
          item.status == PomodoroSessionStatus.restPaused,
    );

    return _GlassPanel(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      radius: const BorderRadius.all(Radius.circular(22)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _focusStyle(context).line.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.drag_indicator_rounded,
                color: _focusStyle(context).mutedInk,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: _focusStyle(context).ink,
                              fontWeight: FontWeight.w800,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                      ),
                    ),
                    if (task.isCompleted)
                      Icon(
                        Icons.check_circle_rounded,
                        color: _focusStyle(context).accent,
                      )
                    else if (running)
                      Icon(
                        Icons.timer_rounded,
                        color: _focusStyle(context).accent,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text('已完成 $completed / ${task.plannedFocusSegments} 个番茄'),
                    Text('${task.focusMinutes} 分钟专注'),
                    Text('${task.breakMinutes} 分钟休息'),
                    if (scheduledTask != null)
                      Text(
                        '${_formatTime(scheduledTask!.startAt)}-${_formatTime(scheduledTask!.endAt)}',
                      ),
                    if (task.scheduledTime != null)
                      Text(
                        '${task.scheduledTime} ${task.isTimeLocked ? "固定时间" : ""}',
                      ),
                    if (task.todoId != null) const Text('关联 Todo'),
                    if (scheduledTask?.hasConflict == true)
                      Text(
                        scheduledTask!.conflictReason ?? '时间冲突',
                        style: TextStyle(color: _focusStyle(context).danger),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: task.isCompleted || hasActiveSession
                        ? null
                        : () async {
                            final session = await ref
                                .read(pomodoroActionsProvider)
                                .startTask(task);
                            if (!context.mounted) return;
                            unawaited(
                              context.push(
                                '/focus/session/${task.planId}/${session.id}',
                              ),
                            );
                          },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      running
                          ? '番茄进行中'
                          : hasActiveSession
                          ? '已有番茄进行中'
                          : '开始当前番茄',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _focusStyle(context).accent,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      disabledBackgroundColor: _focusStyle(context).line,
                      disabledForegroundColor: _focusStyle(context).mutedInk,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TaskActionChip(
                      icon: Icons.schedule_rounded,
                      label: '时长',
                      onPressed: () => _showDurationDialog(context, ref),
                    ),
                    _TaskActionChip(
                      icon: task.isTimeLocked
                          ? Icons.lock_rounded
                          : Icons.lock_open_rounded,
                      label: task.isTimeLocked ? '解除固定' : '固定',
                      onPressed: () => _toggleTimeLock(context, ref),
                    ),
                    _TaskActionChip(
                      icon: Icons.task_alt_rounded,
                      label: '完成',
                      onPressed: task.isCompleted || running
                          ? null
                          : () => ref
                                .read(pomodoroActionsProvider)
                                .completeTask(task),
                    ),
                    _TaskActionChip(
                      icon: Icons.remove_circle_outline_rounded,
                      label: '移除',
                      danger: true,
                      onPressed: running
                          ? null
                          : () => ref
                                .read(pomodoroActionsProvider)
                                .removeTask(task),
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

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _toggleTimeLock(BuildContext context, WidgetRef ref) async {
    final actions = ref.read(pomodoroActionsProvider);
    if (task.isTimeLocked) {
      await actions.toggleTimeLock(task);
      return;
    }

    final current = _timeOfDayOrNull(task.scheduledTime);
    final selected = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
      helpText: '选择固定开始时间',
      cancelText: '取消',
      confirmText: '固定',
    );
    if (selected == null) return;

    task.scheduledTime =
        '${selected.hour.toString().padLeft(2, '0')}:'
        '${selected.minute.toString().padLeft(2, '0')}';
    await actions.toggleTimeLock(task);
  }

  TimeOfDay? _timeOfDayOrNull(String? value) {
    if (value == null) return null;
    final parts = value.trim().split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _showDurationDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
      text: (task.estimatedMinutes ?? task.focusMinutes).toString(),
    );
    final minutes = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改专注时长'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '预计专注分钟数'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text.trim())),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (minutes == null || minutes <= 0) return;
    await ref.read(pomodoroActionsProvider).updateTaskDuration(task, minutes);
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _focusStyle(context).raised,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _focusStyle(context).accent),
          const SizedBox(width: 5),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _TaskActionChip extends StatelessWidget {
  const _TaskActionChip({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? _focusStyle(context).danger
        : _focusStyle(context).ink;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        disabledForegroundColor: _focusStyle(
          context,
        ).mutedInk.withValues(alpha: 0.45),
        side: BorderSide(color: color.withValues(alpha: 0.32)),
        backgroundColor: Colors.white.withValues(alpha: 0.28),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _EmptyFocusState extends StatelessWidget {
  const _EmptyFocusState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_outlined,
              size: 72,
              color: _focusStyle(context).hintInk.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text('今天还没有待办', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '可以新建一个空白番茄，或者回到首页给 Todo 设置今天的日期。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _focusStyle(context).mutedInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: _focusStyle(context).danger,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('重试')),
            ],
          ],
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.radius = const BorderRadius.all(Radius.circular(24)),
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: margin,
      padding: padding,
      child: child,
    );
  }
}
