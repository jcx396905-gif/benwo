import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/big_goal_model.dart';
import '../../../data/models/todo_item_model.dart';
import '_completed_history_sheet.dart';

/// Calendar Page - Day View (Task 20)
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _dayPageController;
  bool _showCompletedTodos = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _dayPageController = PageController(initialPage: 1000);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dayPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('日历'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showCompletedTodos
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
            onPressed: () {
              setState(() {
                _showCompletedTodos = !_showCompletedTodos;
              });
            },
            tooltip: _showCompletedTodos ? '隐藏已完成' : '显示已完成',
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => CompletedHistorySheet.show(context, ref.read(authNotifierProvider).userId ?? 0),
            tooltip: '已完成历史',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: '日'),
            Tab(text: '周'),
            Tab(text: '月'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Day view - with swipe navigation
          _buildDayViewWithSwipe(),
          // Week view
          _buildWeekView(),
          // Month view
          _buildMonthView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/goals');
              break;
            case 2:
              break; // Already on calendar
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
      ),
    );
  }

  Widget _buildDayViewWithSwipe() {
    return PageView.builder(
      controller: _dayPageController,
      onPageChanged: (index) {
        // Rebuild to update date display when page changes
        setState(() {});
      },
      itemBuilder: (context, index) {
        final daysFromCenter = index - 1000;
        final date = DateTime.now().add(Duration(days: daysFromCenter));
        return _DayViewContent(
          date: date,
          showCompleted: _showCompletedTodos,
        );
      },
    );
  }

  Widget _buildWeekView() {
    return _WeekViewContent(showCompleted: _showCompletedTodos);
  }

  Widget _buildMonthView() {
    return _MonthViewContent(showCompleted: _showCompletedTodos);
  }
}

/// Day View Content Widget
class _DayViewContent extends ConsumerWidget {
  final DateTime date;
  final bool showCompleted;

  const _DayViewContent({
    required this.date,
    required this.showCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.userId;

    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final dateStr = DateFormat('yyyy年MM月dd日').format(date);
    final weekdayStr = _getWeekdayString(date.weekday);
    final isToday = _isSameDay(date, DateTime.now());

    return Column(
      children: [
        // Date header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () {
                      // Navigate to previous day
                      final currentPage =
                          (context.findAncestorStateOfType<_CalendarPageState>()?._dayPageController.page ?? 1000).round();
                      context.findAncestorStateOfType<_CalendarPageState>()?._dayPageController.animateToPage(
                        currentPage - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isToday)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(
                            weekdayStr,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isToday
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateStr,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {
                      // Navigate to next day
                      final currentPage =
                          (context.findAncestorStateOfType<_CalendarPageState>()?._dayPageController.page ?? 1000).round();
                      context.findAncestorStateOfType<_CalendarPageState>()?._dayPageController.animateToPage(
                        currentPage + 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ],
              ),
              if (isToday)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '今天',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
            ],
          ),
        ),

        // To-Do list for this date
        Expanded(
          child: _buildTodoList(context, ref, userId),
        ),
      ],
    );
  }

  Widget _buildTodoList(BuildContext context, WidgetRef ref, int userId) {
    final todosAsync = ref.watch(
      StreamProvider<List<TodoItemModel>>((ref) {
        final todoRepo = ref.watch(todoItemRepositoryProvider);
        return todoRepo.watchTodosByDate(userId, date);
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
        data: (goals) => _buildTodoListContent(context, todos, goals, userId, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, '加载目标失败: $e'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildError(context, '加载待办失败: $e'),
    );
  }

  Widget _buildTodoListContent(
    BuildContext context,
    List<TodoItemModel> todos,
    List<BigGoalModel> goals,
    int userId,
    WidgetRef ref,
  ) {
    final goalMap = {for (final g in goals) g.id: g};

    // Filter todos based on showCompleted
    final filteredTodos = showCompleted
        ? todos
        : todos.where((t) => !t.isCompleted).toList();

    if (filteredTodos.isEmpty) {
      return _buildEmptyState(context);
    }

    // Build goal summary
    final inProgressGoals =
        goals.where((g) => g.status == GoalStatus.inProgress).toList();

    return DragTarget<TodoItemModel>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        _showDatePickerForTodo(context, ref, details.data, userId);
      },
      builder: (context, candidateData, rejectedData) {
        final isDragging = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: isDragging
              ? BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: CustomScrollView(
            slivers: [
              // Goal summary
              if (inProgressGoals.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildGoalSummaryCard(context, inProgressGoals),
                ),

              // Section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        showCompleted ? '所有任务' : '待完成',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${filteredTodos.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (!showCompleted) ...[
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Toggle show completed - this is handled by parent
                          },
                          child: Text(
                            '显示已完成',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Todo list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final todo = filteredTodos[index];
                    final goal = todo.goalId != null ? goalMap[todo.goalId] : null;
                    return _buildTodoItem(context, todo, goal, userId, ref);
                  },
                  childCount: filteredTodos.length,
                ),
              ),

              // Drop zone indicator
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDragging
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDragging
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isDragging ? Icons.calendar_today_rounded : Icons.drag_indicator_rounded,
                        color: isDragging ? AppColors.primary : AppColors.textHint,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isDragging ? '拖放到这里选择新日期' : '长按任务拖动到其他日期',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDragging ? AppColors.primary : AppColors.textHint,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalSummaryCard(BuildContext context, List<BigGoalModel> goals) {
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

  Widget _buildTodoItem(
    BuildContext context,
    TodoItemModel todo,
    BigGoalModel? goal,
    int userId,
    WidgetRef ref,
  ) {
    final goalColor = goal != null
        ? (_parseColor(goal.color) ?? AppColors.primary)
        : AppColors.textSecondary;
    final isUserCreated = todo.goalId == null;

    // Don't allow dragging completed todos
    if (todo.isCompleted) {
      return _buildTodoItemContent(context, todo, goal, goalColor, isUserCreated, ref);
    }

    return LongPressDraggable<TodoItemModel>(
      data: todo,
      delay: const Duration(milliseconds: 200),
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: MediaQuery.of(context).size.width - 64,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: goalColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.drag_indicator_rounded, color: Colors.white70),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  todo.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildTodoItemContent(context, todo, goal, goalColor, isUserCreated, ref),
      ),
      onDragStarted: () {
        // Haptic feedback could be added here
      },
      onDragEnd: (details) {
        // Cleanup if needed
      },
      child: DragTarget<TodoItemModel>(
        onWillAcceptWithDetails: (details) {
          return details.data.id != todo.id;
        },
        onAcceptWithDetails: (details) async {
          // This is when another todo is dropped onto this one
          // We don't support reordering here, just show date picker
        },
        builder: (context, candidateData, rejectedData) {
          return _buildTodoItemContent(context, todo, goal, goalColor, isUserCreated, ref);
        },
      ),
    );
  }

  Widget _buildTodoItemContent(
    BuildContext context,
    TodoItemModel todo,
    BigGoalModel? goal,
    Color goalColor,
    bool isUserCreated,
    WidgetRef ref,
  ) {
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
          onTap: () {
            // Could open detail sheet here
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Goal color indicator
                if (todo.isAIGenerated && goal != null)
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: todo.isCompleted ? goalColor.withValues(alpha: 0.3) : goalColor,
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
                GestureDetector(
                  onTap: () => _showCompleteDialog(context, ref, todo, goal),
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
                              color: todo.isCompleted
                                  ? AppColors.textHint
                                  : AppColors.textPrimary,
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          // Estimated time
                          if (todo.estimatedMinutes != null)
                            _buildMetaChip(
                              context,
                              icon: Icons.schedule_rounded,
                              text: '${todo.estimatedMinutes}分钟',
                            ),

                          // Goal tag
                          if (goal != null)
                            _buildGoalTag(context, goal, goalColor),

                          // User created tag
                          if (isUserCreated)
                            _buildMetaChip(
                              context,
                              icon: Icons.person_rounded,
                              text: '自建',
                              color: AppColors.textHint,
                            ),

                          // AI badge
                          if (todo.isAIGenerated)
                            _buildMetaChip(
                              context,
                              icon: Icons.auto_awesome_rounded,
                              text: 'AI',
                              color: AppColors.secondary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Drag handle indicator
                if (!todo.isCompleted)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.drag_indicator_rounded,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCompleteDialog(
    BuildContext context,
    WidgetRef ref,
    TodoItemModel todo,
    BigGoalModel? goal,
  ) async {
    if (todo.isAIGenerated && goal != null) {
      // Show confirmation dialog for AI-generated todos
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('确认完成'),
          content: const Text('确认完成这个 AI 生成的任务？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确认'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    // Mark as complete
    final todoRepo = ref.read(todoItemRepositoryProvider);
    await todoRepo.completeTodo(todo.id);

    // If this goal's all todos are done, mark goal complete
    if (goal != null) {
      final todos = await todoRepo.getTodosByGoalId(goal.id);
      final allCompleted = todos.every((t) => t.isCompleted || t.id == todo.id);
      if (allCompleted) {
        final goalRepo = ref.read(bigGoalRepositoryProvider);
        final updatedGoal = BigGoalModel()
          ..id = goal.id
          ..userId = goal.userId
          ..title = goal.title
          ..description = goal.description
          ..targetDate = goal.targetDate
          ..status = GoalStatus.completed
          ..color = goal.color
          ..createdAt = goal.createdAt
          ..updatedAt = DateTime.now();
        await goalRepo.updateGoal(updatedGoal);
      }
    }
  }

  Future<void> _showDatePickerForTodo(
    BuildContext context,
    WidgetRef ref,
    TodoItemModel todo,
    int userId,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: todo.scheduledDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (dialogContext, child) {
        return Theme(
          data: Theme.of(dialogContext).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != todo.scheduledDate) {
      // Update todo's scheduled date
      final updatedTodo = TodoItemModel()
        ..id = todo.id
        ..userId = todo.userId
        ..goalId = todo.goalId
        ..content = todo.content
        ..isAIGenerated = todo.isAIGenerated
        ..scheduledDate = picked
        ..isCompleted = todo.isCompleted
        ..estimatedMinutes = todo.estimatedMinutes
        ..color = todo.color
        ..aiConfirmationQuestions = todo.aiConfirmationQuestions
        ..createdAt = todo.createdAt
        ..completedAt = todo.completedAt;

      final todoRepo = ref.read(todoItemRepositoryProvider);
      await todoRepo.updateTodo(updatedTodo);

      // Show success feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '已将任务移动到 ${DateFormat('MM月dd日').format(picked)}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  Widget _buildMetaChip(
    BuildContext context, {
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

  Widget _buildGoalTag(BuildContext context, BigGoalModel goal, Color color) {
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 64,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            showCompleted ? '暂无任务' : '今日无待办',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            showCompleted ? '' : '左右滑动切换日期',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
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
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (dialogContext, child) {
        return Theme(
          data: Theme.of(dialogContext).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final today = DateTime.now();
      final daysDiff = picked.difference(DateTime(today.year, today.month, today.day)).inDays;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctx.findAncestorStateOfType<_CalendarPageState>()?._dayPageController.animateToPage(
          1000 + daysDiff,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _showCompletedHistory(BuildContext context) {
    final userId = ProviderScope.containerOf(context).read(authNotifierProvider).userId ?? 0;
    CompletedHistorySheet.show(context, userId);
  }

  String _getWeekdayString(int weekday) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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

/// Week View Content Widget
class _WeekViewContent extends ConsumerStatefulWidget {
  final bool showCompleted;

  const _WeekViewContent({required this.showCompleted});

  @override
  ConsumerState<_WeekViewContent> createState() => _WeekViewContentState();
}

class _WeekViewContentState extends ConsumerState<_WeekViewContent> {
  late DateTime _weekStart;
  int? _expandedDayIndex;

  @override
  void initState() {
    super.initState();
    // Start week from Monday
    final now = DateTime.now();
    _weekStart = DateTime(now.year, now.month, now.day);
    // Adjust to get Monday of the week
    _weekStart = _weekStart.subtract(Duration(days: _weekStart.weekday - 1));
  }

  void _goToPreviousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
      _expandedDayIndex = null;
    });
  }

  void _goToNextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
      _expandedDayIndex = null;
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      final now = DateTime.now();
      _weekStart = DateTime(now.year, now.month, now.day);
      _weekStart = _weekStart.subtract(Duration(days: _weekStart.weekday - 1));
      _expandedDayIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.userId;

    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Calculate week range
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final dateFormat = DateFormat('M月d日');

    return Column(
      children: [
        // Week navigation header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: _goToPreviousWeek,
              ),
              GestureDetector(
                onTap: _goToCurrentWeek,
                child: Text(
                  '${dateFormat.format(_weekStart)} - ${dateFormat.format(weekEnd)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: _goToNextWeek,
              ),
            ],
          ),
        ),

        // Day headers
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: AppColors.surfaceVariant.withValues(alpha: 0.3),
          child: Row(
            children: List.generate(7, (index) {
              final day = _weekStart.add(Duration(days: index));
              final isToday = _isSameDay(day, DateTime.now());
              return Expanded(
                child: Center(
                  child: Text(
                    _getWeekdayShort(day.weekday),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isToday ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Week days list
        Expanded(
          child: _buildWeekDaysList(context, ref, userId),
        ),
      ],
    );
  }

  Widget _buildWeekDaysList(BuildContext context, WidgetRef ref, int userId) {
    final todosAsync = ref.watch(
      FutureProvider<List<TodoItemModel>>((ref) async {
        final todoRepo = ref.watch(todoItemRepositoryProvider);
        final endDate = _weekStart.add(const Duration(days: 7));
        return todoRepo.getTodosByDateRange(
          userId,
          _weekStart,
          endDate.subtract(const Duration(days: 1)),
        );
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
        data: (goals) => _buildWeekDaysContent(context, todos, goals),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, '加载目标失败: $e'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildError(context, '加载任务失败: $e'),
    );
  }

  Widget _buildWeekDaysContent(
    BuildContext context,
    List<TodoItemModel> todos,
    List<BigGoalModel> goals,
  ) {
    final goalMap = {for (final g in goals) g.id: g};

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 7,
      itemBuilder: (context, index) {
        final day = _weekStart.add(Duration(days: index));
        final dayTodos = todos.where((t) => _isSameDay(t.scheduledDate, day)).toList();
        final filteredTodos = widget.showCompleted
            ? dayTodos
            : dayTodos.where((t) => !t.isCompleted).toList();

        final goalTodos = filteredTodos.where((t) => t.goalId != null).length;
        final userTodos = filteredTodos.where((t) => t.goalId == null).length;
        final isToday = _isSameDay(day, DateTime.now());
        final isExpanded = _expandedDayIndex == index;

        return Column(
          children: [
            // Day header with drag target
            DragTarget<TodoItemModel>(
              onWillAcceptWithDetails: (details) => !_isSameDay(details.data.scheduledDate, day),
              onAcceptWithDetails: (details) {
                _moveTodoToDate(context, details.data, day);
              },
              builder: (context, candidateData, rejectedData) {
                final isDropTarget = candidateData.isNotEmpty;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedDayIndex = isExpanded ? null : index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDropTarget
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : isToday
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDropTarget
                            ? AppColors.primary
                            : isToday ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
                        width: isDropTarget ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Date indicator
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isToday ? AppColors.primary : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isToday ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Day info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isToday ? '今天' : _getWeekdayString(day.weekday),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isToday ? AppColors.primary : AppColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  if (goalTodos > 0) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '$goalTodos个大目标',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: AppColors.primary,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  if (userTodos > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.textHint.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '$userTodos个个人',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ),
                                  if (goalTodos == 0 && userTodos == 0)
                                    Text(
                                      '无任务',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.textHint,
                                          ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Drop indicator or expand indicator
                        if (isDropTarget)
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.primary,
                          )
                        else
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Expanded todos for this day
            if (isExpanded && filteredTodos.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 24, right: 8, bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: filteredTodos.map((todo) {
                    final goal = todo.goalId != null ? goalMap[todo.goalId] : null;
                    return _buildCompactTodoItem(context, todo, goal);
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCompactTodoItem(
    BuildContext context,
    TodoItemModel todo,
    BigGoalModel? goal,
  ) {
    final goalColor = goal != null
        ? (_parseColor(goal.color) ?? AppColors.primary)
        : AppColors.textHint;

    // Don't allow dragging completed todos
    if (todo.isCompleted) {
      return _buildCompactTodoItemContent(context, todo, goal, goalColor);
    }

    return LongPressDraggable<TodoItemModel>(
      data: todo,
      delay: const Duration(milliseconds: 200),
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: goalColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_indicator_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                todo.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildCompactTodoItemContent(context, todo, goal, goalColor),
      ),
      child: _buildCompactTodoItemContent(context, todo, goal, goalColor),
    );
  }

  Widget _buildCompactTodoItemContent(
    BuildContext context,
    TodoItemModel todo,
    BigGoalModel? goal,
    Color goalColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: todo.isCompleted ? goalColor.withValues(alpha: 0.3) : goalColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              todo.content,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: todo.isCompleted ? AppColors.textHint : AppColors.textPrimary,
                    decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                  ),
            ),
          ),
          if (todo.isAIGenerated)
            const Icon(
              Icons.auto_awesome_rounded,
              size: 12,
              color: AppColors.secondary,
            ),
          if (!todo.isCompleted)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(
                Icons.drag_indicator_rounded,
                size: 14,
                color: AppColors.textHint,
              ),
            ),
        ],
      ),
    );
  }

  String _getWeekdayShort(int weekday) {
    const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    return weekdays[weekday - 1];
  }

  String _getWeekdayString(int weekday) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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

  Future<void> _moveTodoToDate(
    BuildContext context,
    TodoItemModel todo,
    DateTime newDate,
  ) async {
    if (_isSameDay(todo.scheduledDate, newDate)) return;

    // Update todo's scheduled date
    final updatedTodo = TodoItemModel()
      ..id = todo.id
      ..userId = todo.userId
      ..goalId = todo.goalId
      ..content = todo.content
      ..isAIGenerated = todo.isAIGenerated
      ..scheduledDate = newDate
      ..isCompleted = todo.isCompleted
      ..estimatedMinutes = todo.estimatedMinutes
      ..color = todo.color
      ..aiConfirmationQuestions = todo.aiConfirmationQuestions
      ..createdAt = todo.createdAt
      ..completedAt = todo.completedAt;

    final todoRepo = ref.read(todoItemRepositoryProvider);
    await todoRepo.updateTodo(updatedTodo);

    // Show success feedback
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '已将任务移动到 ${DateFormat('MM月dd日').format(newDate)}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Widget _buildError(BuildContext context, String message) {
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
}

/// Month View Content Widget
class _MonthViewContent extends ConsumerStatefulWidget {
  final bool showCompleted;

  const _MonthViewContent({required this.showCompleted});

  @override
  ConsumerState<_MonthViewContent> createState() => _MonthViewContentState();
}

class _MonthViewContentState extends ConsumerState<_MonthViewContent> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      _selectedDate = null;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      _selectedDate = null;
    });
  }

  void _goToCurrentMonth() {
    setState(() {
      _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.userId;

    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final monthFormat = DateFormat('yyyy年M月');

    return Column(
      children: [
        // Month navigation header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: _goToPreviousMonth,
              ),
              GestureDetector(
                onTap: _goToCurrentMonth,
                child: Text(
                  monthFormat.format(_currentMonth),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
        ),

        // Week day headers
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: AppColors.surfaceVariant.withValues(alpha: 0.3),
          child: Row(
            children: List.generate(7, (index) {
              return Expanded(
                child: Center(
                  child: Text(
                    _getWeekdayShort(index),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Calendar grid
        Expanded(
          child: _buildCalendarGrid(context, ref, userId),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(BuildContext context, WidgetRef ref, int userId) {
    final todosAsync = ref.watch(
      FutureProvider<List<TodoItemModel>>((ref) async {
        final todoRepo = ref.watch(todoItemRepositoryProvider);
        final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
        final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
        return todoRepo.getTodosByDateRange(userId, firstDay, lastDay);
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
        data: (goals) => _buildCalendarGridContent(context, todos, goals),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(context, '加载目标失败: $e'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildError(context, '加载任务失败: $e'),
    );
  }

  Widget _buildCalendarGridContent(
    BuildContext context,
    List<TodoItemModel> todos,
    List<BigGoalModel> goals,
  ) {
    // Calculate calendar data
    final firstDayWeekday = _currentMonth.weekday;
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final today = DateTime.now();

    // Build calendar cells
    final cells = <Widget>[];

    // Add empty cells for days before the first day of the month
    for (var i = 1; i < firstDayWeekday; i++) {
      cells.add(const SizedBox());
    }

    // Add day cells
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final dayTodos = todos.where((t) => _isSameDay(t.scheduledDate, date)).toList();
      final filteredTodos = widget.showCompleted
          ? dayTodos
          : dayTodos.where((t) => !t.isCompleted).toList();
      final hasGoalTodos = filteredTodos.any((t) => t.goalId != null);
      final hasUserTodos = filteredTodos.any((t) => t.goalId == null);
      final isToday = _isSameDay(date, today);
      final isSelected = _selectedDate != null && _isSameDay(date, _selectedDate!);

      cells.add(
        DragTarget<TodoItemModel>(
          onWillAcceptWithDetails: (details) => !_isSameDay(details.data.scheduledDate, date),
          onAcceptWithDetails: (details) {
            _moveTodoToDate(context, details.data, date);
          },
          builder: (context, candidateData, rejectedData) {
            final isDropTarget = candidateData.isNotEmpty;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = _isSameDay(date, _selectedDate ?? DateTime(2000)) ? null : date;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isDropTarget
                      ? AppColors.primary.withValues(alpha: 0.4)
                      : isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : isToday
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDropTarget
                        ? AppColors.primary
                        : isToday
                            ? AppColors.primary
                            : isSelected
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : Colors.transparent,
                    width: isDropTarget || isToday ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isToday ? AppColors.primary : AppColors.textPrimary,
                            fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                    ),
                    if (filteredTodos.isNotEmpty || isDropTarget) ...[
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isDropTarget)
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 8,
                              color: AppColors.primary,
                            )
                          else ...[
                            if (hasGoalTodos)
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (hasGoalTodos && hasUserTodos)
                              const SizedBox(width: 2),
                            if (hasUserTodos)
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.textHint,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    // If selected date, show todo details
    Widget content;
    if (_selectedDate != null) {
      final selectedDayTodos = todos.where(
        (t) => _isSameDay(t.scheduledDate, _selectedDate!),
      ).toList();
      final filteredTodos = widget.showCompleted
          ? selectedDayTodos
          : selectedDayTodos.where((t) => !t.isCompleted).toList();

      final goalMap = {for (final g in goals) g.id: g};
      final dateStr = DateFormat('M月d日').format(_selectedDate!);
      final weekdayStr = _getWeekdayString(_selectedDate!.weekday);

      content = Column(
        children: [
          // Calendar grid
          Container(
            padding: const EdgeInsets.all(8),
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              children: cells,
            ),
          ),

          // Divider
          Divider(color: AppColors.border.withValues(alpha: 0.5)),

          // Selected date todos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '$weekdayStr $dateStr',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Expanded(
                  child: filteredTodos.isEmpty
                      ? Center(
                          child: Text(
                            '无任务',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textHint,
                                ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            final todo = filteredTodos[index];
                            final goal = todo.goalId != null ? goalMap[todo.goalId] : null;
                            return _buildCompactTodoItem(context, todo, goal);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      content = GridView.count(
        padding: const EdgeInsets.all(8),
        crossAxisCount: 7,
        childAspectRatio: 1,
        children: cells,
      );
    }

    return content;
  }

  Widget _buildCompactTodoItem(
    BuildContext context,
    TodoItemModel todo,
    BigGoalModel? goal,
  ) {
    final goalColor = goal != null
        ? (_parseColor(goal.color) ?? AppColors.primary)
        : AppColors.textHint;

    // Don't allow dragging completed todos
    if (todo.isCompleted) {
      return _buildCompactTodoItemContent(context, todo, goal, goalColor);
    }

    return LongPressDraggable<TodoItemModel>(
      data: todo,
      delay: const Duration(milliseconds: 200),
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: goalColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_indicator_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                todo.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildCompactTodoItemContent(context, todo, goal, goalColor),
      ),
      child: _buildCompactTodoItemContent(context, todo, goal, goalColor),
    );
  }

  Widget _buildCompactTodoItemContent(
    BuildContext context,
    TodoItemModel todo,
    BigGoalModel? goal,
    Color goalColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: todo.isCompleted ? goalColor.withValues(alpha: 0.3) : goalColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              todo.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: todo.isCompleted ? AppColors.textHint : AppColors.textPrimary,
                    decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                  ),
            ),
          ),
          if (todo.isAIGenerated)
            const Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: AppColors.secondary,
            ),
          if (!todo.isCompleted)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(
                Icons.drag_indicator_rounded,
                size: 18,
                color: AppColors.textHint,
              ),
            ),
        ],
      ),
    );
  }

  String _getWeekdayShort(int weekday) {
    // weekday here is 0-6 (Sunday = 0)
    const weekdays = ['日', '一', '二', '三', '四', '五', '六'];
    return weekdays[weekday];
  }

  String _getWeekdayString(int weekday) {
    const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return weekdays[weekday - 1];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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

  Future<void> _moveTodoToDate(
    BuildContext context,
    TodoItemModel todo,
    DateTime newDate,
  ) async {
    if (_isSameDay(todo.scheduledDate, newDate)) return;

    // Update todo's scheduled date
    final updatedTodo = TodoItemModel()
      ..id = todo.id
      ..userId = todo.userId
      ..goalId = todo.goalId
      ..content = todo.content
      ..isAIGenerated = todo.isAIGenerated
      ..scheduledDate = newDate
      ..isCompleted = todo.isCompleted
      ..estimatedMinutes = todo.estimatedMinutes
      ..color = todo.color
      ..aiConfirmationQuestions = todo.aiConfirmationQuestions
      ..createdAt = todo.createdAt
      ..completedAt = todo.completedAt;

    final todoRepo = ref.read(todoItemRepositoryProvider);
    await todoRepo.updateTodo(updatedTodo);

    // Show success feedback
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '已将任务移动到 ${DateFormat('MM月dd日').format(newDate)}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Widget _buildError(BuildContext context, String message) {
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
}
