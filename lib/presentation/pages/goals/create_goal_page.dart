import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Create Goal Page - AI-guided goal creation interface
class CreateGoalPage extends ConsumerStatefulWidget {
  const CreateGoalPage({super.key});

  @override
  ConsumerState<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends ConsumerState<CreateGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedTimeframe;
  DateTime? _customTargetDate;
  bool _isLoading = false;
  String? _errorMessage;

  // Color options for goal
  final List<Map<String, String>> _colorOptions = [
    {'name': '墨黑', 'color': '#1A1A1A'},
    {'name': '灰褐', 'color': '#A89F90'},
    {'name': '中灰', 'color': '#8F8F8B'},
    {'name': '浅卡其', 'color': '#E9E1D2'},
    {'name': '深褐灰', 'color': '#625B52'},
    {'name': '米线', 'color': '#D7CCBC'},
    {'name': '米白', 'color': '#F8F6F1'},
    {'name': '浅米', 'color': '#DDD6C8'},
  ];

  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedCategory = AppConstants.goalCategories.first;
    _selectedColor = _colorOptions.first['color'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime _calculateTargetDate(String? timeframe) {
    final now = DateTime.now();
    if (timeframe == '自定义' && _customTargetDate != null) {
      return _customTargetDate!;
    }
    switch (timeframe) {
      case '1个月':
        return DateTime(now.year, now.month + 1, now.day);
      case '3个月':
        return DateTime(now.year, now.month + 3, now.day);
      case '半年':
        return DateTime(now.year, now.month + 6, now.day);
      case '一年':
        return DateTime(now.year + 1, now.month, now.day);
      case '更长时间':
        return DateTime(now.year + 2, now.month, now.day);
      default:
        return DateTime(now.year, now.month + 3, now.day);
    }
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTimeframe == null) {
      setState(() {
        _errorMessage = '请选择目标时间';
      });
      return;
    }

    if (_selectedTimeframe == '自定义' && _customTargetDate == null) {
      setState(() {
        _errorMessage = '请选择自定义完成日期';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bigGoalRepo = ref.read(bigGoalRepositoryProvider);
      final targetDate = _calculateTargetDate(_selectedTimeframe);

      await bigGoalRepo.createGoal(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        targetDate: targetDate,
        color: _selectedColor,
        category: _selectedCategory,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('目标创建成功！'),
            backgroundColor: context.palette.gold,
          ),
        );
        context.go('/goals');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '创建目标失败: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _showCustomCategoryDialog() async {
    final controller = TextEditingController(text: _selectedCategory);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('自定义目标类型'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '目标类型',
            hintText: '例如：副业、家庭、作品集',
          ),
          maxLength: 12,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建目标'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/goals'),
        ),
      ),
      body: Container(
        color: context.palette.canvas,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.palette.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.lightbulb_outline_rounded,
                          color: context.palette.gold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI 目标设定',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '设定一个清晰的目标，让 AI 帮你拆解成每日任务',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: context.palette.mutedInk),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Goal Title
                Text(
                  '目标标题',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: context.palette.ink),
                  decoration: InputDecoration(
                    hintText: '例如：学会游泳、减肥10斤、升职加薪',
                    hintStyle: TextStyle(color: context.palette.hintInk),
                    filled: true,
                    fillColor: context.palette.ceramicRaised,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.palette.hairline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.palette.gold,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入目标标题';
                    }
                    if (value.trim().length > AppConstants.maxGoalTitleLength) {
                      return '目标标题不能超过${AppConstants.maxGoalTitleLength}个字符';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Goal Description
                Text(
                  '目标描述（可选）',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: TextStyle(color: context.palette.ink),
                  decoration: InputDecoration(
                    hintText: '详细描述你的目标，越具体越好...',
                    hintStyle: TextStyle(color: context.palette.hintInk),
                    filled: true,
                    fillColor: context.palette.ceramicRaised,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.palette.hairline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.palette.gold,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Goal Category
                Text(
                  '目标分类',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [...AppConstants.goalCategories, '自定义'].map((
                    category,
                  ) {
                    final isCustomCategory =
                        category == '自定义' &&
                        !AppConstants.goalCategories.contains(
                          _selectedCategory,
                        );
                    final isSelected =
                        _selectedCategory == category || isCustomCategory;
                    return GestureDetector(
                      onTap: () async {
                        if (category == '自定义') {
                          final customCategory =
                              await _showCustomCategoryDialog();
                          if (customCategory == null ||
                              customCategory.isEmpty) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = customCategory;
                          });
                          return;
                        }
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: AnimatedContainer(
                        duration: AppConstants.shortAnimation,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.palette.gold
                              : context.palette.ceramicRaised.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? context.palette.gold
                                : context.palette.hairline.withValues(alpha: 0.6),
                          ),
                          backgroundBlendMode: isSelected ? null : BlendMode.luminosity,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: context.palette.gold.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          isCustomCategory ? _selectedCategory! : category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : context.palette.mutedInk,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Goal Timeframe
                Text(
                  '预计完成时间',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [...AppConstants.changeTimeframes, '自定义'].map((
                    timeframe,
                  ) {
                    final isSelected = _selectedTimeframe == timeframe;
                    return GestureDetector(
                      onTap: () async {
                        if (timeframe == '自定义') {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                _customTargetDate ??
                                DateTime.now().add(const Duration(days: 90)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3650),
                            ),
                          );
                          if (picked == null) return;
                          setState(() {
                            _selectedTimeframe = timeframe;
                            _customTargetDate = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                            );
                          });
                          return;
                        }
                        setState(() {
                          _selectedTimeframe = timeframe;
                          _customTargetDate = null;
                        });
                      },
                      child: AnimatedContainer(
                        duration: AppConstants.shortAnimation,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.palette.terracotta
                              : context.palette.ceramicRaised.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? context.palette.terracotta
                                : context.palette.hairline.withValues(alpha: 0.6),
                          ),
                          backgroundBlendMode: isSelected ? null : BlendMode.luminosity,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: context.palette.terracotta
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          timeframe == '自定义' && _customTargetDate != null
                              ? '自定义：${_formatDate(_customTargetDate!)}'
                              : timeframe,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : context.palette.mutedInk,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Goal Color
                Text(
                  '目标颜色',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _colorOptions.map((colorOption) {
                    final isSelected = _selectedColor == colorOption['color'];
                    final color = Color(
                      int.parse(
                        colorOption['color']!.replaceFirst('#', '0xFF'),
                      ),
                    );
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = colorOption['color'];
                        });
                      },
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: AppConstants.shortAnimation,
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? context.palette.ink
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            colorOption['name']!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isSelected
                                      ? context.palette.gold
                                      : context.palette.mutedInk,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Save Button
                if (_isLoading)
                  const SizedBox(
                    width: 52,
                    height: 52,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  GlassButton(
                        label: '创建目标',
                        icon: const Icon(Icons.flag_rounded),
                        onTap: _saveGoal,
                      ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
