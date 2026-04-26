import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/onboarding/onboarding_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

/// Onboarding Page - Multi-step wizard (Tasks 9-12)
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingNotifier = ref.read(onboardingControllerProvider.notifier);

    // Listen for onboarding completion
    ref.listen<OnboardingState>(onboardingControllerProvider, (previous, next) {
      if (next.isLoading == false && previous?.isLoading == true) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator and close button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Close/Exit button
                    IconButton(
                      onPressed: () => _showExitDialog(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                    const Spacer(),
                    // Step indicator
                    Text(
                      '${onboardingState.currentStep}/${onboardingState.totalSteps}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildProgressBar(onboardingState.currentStep, onboardingState.totalSteps),
              ),

              const SizedBox(height: 24),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Controlled programmatically
                  onPageChanged: (index) {
                    onboardingNotifier.goToStep(index + 1);
                  },
                  children: [
                    // Step 1: 我是谁
                    _buildStep1(onboardingState, onboardingNotifier),
                    // Step 2: 我的现状
                    _buildStep2(onboardingState, onboardingNotifier),
                    // Step 3: 我想要什么
                    _buildStep3(onboardingState, onboardingNotifier),
                    // Step 4: AI分析确认
                    _buildStep4(onboardingState, onboardingNotifier),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int currentStep, int totalSteps) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep - 1;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isCompleted || isCurrent
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStep1(OnboardingState state, OnboardingController notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step title
          const Text(
            '第一步：我是谁',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '告诉我们一些关于您的基础信息',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),

          // Name field
          _buildInputCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '您的姓名',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  onChanged: notifier.updateStep1Name,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: '请输入您的姓名',
                    hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Age and Occupation row
          Row(
            children: [
              // Age field
              Expanded(
                child: _buildInputCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '年龄',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _ageController,
                        onChanged: (value) {
                          notifier.updateStep1Age(int.tryParse(value));
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '年龄',
                          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Occupation dropdown
              Expanded(
                child: _buildInputCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '职业',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.step1Data.occupation.isEmpty
                              ? null
                              : state.step1Data.occupation,
                          hint: Text(
                            '选择职业',
                            style: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                          ),
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          items: AppConstants.occupations.map((occupation) {
                            return DropdownMenuItem<String>(
                              value: occupation,
                              child: Text(
                                occupation,
                                style: const TextStyle(color: AppColors.textPrimary),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              notifier.updateStep1Occupation(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Region field
          _buildInputCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '所在地区',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _regionController,
                  onChanged: notifier.updateStep1Region,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: '如：北京市、上海市',
                    hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Next button
          SizedBox(
            width: double.infinity,
            child: AnimatedElevatedButton(
              onPressed: state.canProceedFromStep1
                  ? () => _goToNextStep(state.currentStep)
                  : null,
              child: const Text('下一步'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(OnboardingState state, OnboardingController notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step title
          const Text(
            '第二步：我的现状',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '您目前面临哪些挑战？（可多选）',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Challenges multi-select
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.challenges.map((challenge) {
              final isSelected = state.selectedChallenges.contains(challenge);
              return GestureDetector(
                onTap: () => notifier.toggleChallenge(challenge),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.textSecondary.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    challenge,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Life status selection
          const Text(
            '您目前的生活状态是？',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          ...AppConstants.lifeStatuses.map((status) {
            final isSelected = state.lifeStatus == status;
            return GestureDetector(
              onTap: () => notifier.updateLifeStatus(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.textSecondary.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      _getLifeStatusIcon(status),
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      status,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 32),

          // Navigation buttons
          Row(
            children: [
              // Back button
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goToPreviousStep(state.currentStep),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('上一步'),
                ),
              ),
              const SizedBox(width: 16),
              // Next button
              Expanded(
                flex: 2,
                child: AnimatedElevatedButton(
                  onPressed: state.selectedChallenges.isNotEmpty &&
                          state.lifeStatus.isNotEmpty
                      ? () => _goToNextStep(state.currentStep)
                      : null,
                  child: const Text('下一步'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getLifeStatusIcon(String status) {
    switch (status) {
      case '学生':
        return Icons.school_rounded;
      case '在职':
        return Icons.work_rounded;
      case '自由职业':
        return Icons.laptop_mac_rounded;
      case '退休':
        return Icons.self_improvement_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  Widget _buildInputCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildStep3(OnboardingState state, OnboardingController notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step title
          const Text(
            '第三步：我想要什么',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '您最想改变的三个方面是什么？',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Three input fields for desired changes
          ...List.generate(3, (index) {
            final labels = ['第一个改变', '第二个改变', '第三个改变'];
            final hints = [
              '例如：提高英语水平',
              '例如：养成早起习惯',
              '例如：增加运动时间',
            ];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInputCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labels[index],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      onChanged: (value) {
                        final changes = List<String>.from(state.desiredChanges);
                        // Ensure list has at least 3 elements
                        while (changes.length < 3) {
                          changes.add('');
                        }
                        changes[index] = value;
                        notifier.updateDesiredChanges(changes);
                      },
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: hints[index],
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Timeframe selection
          const Text(
            '您希望在多长时间内实现这些改变？',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppConstants.changeTimeframes.map((timeframe) {
              final isSelected = state.changeTimeframe == timeframe;
              return GestureDetector(
                onTap: () => notifier.updateChangeTimeframe(timeframe),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.textSecondary.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    timeframe,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Navigation buttons
          Row(
            children: [
              // Back button
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goToPreviousStep(state.currentStep),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('上一步'),
                ),
              ),
              const SizedBox(width: 16),
              // Next button
              Expanded(
                flex: 2,
                child: AnimatedElevatedButton(
                  onPressed: _canProceedFromStep3(state)
                      ? () => _goToNextStep(state.currentStep)
                      : null,
                  child: const Text('下一步'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _canProceedFromStep3(OnboardingState state) {
    // Need at least one non-empty desired change and a timeframe selected
    final hasAtLeastOneChange = state.desiredChanges
        .where((c) => c.trim().isNotEmpty)
        .isNotEmpty;
    return hasAtLeastOneChange && state.changeTimeframe.isNotEmpty;
  }

  Widget _buildStep4(OnboardingState state, OnboardingController notifier) {
    // Generate AI summary based on user's inputs from Steps 1-3
    final aiSummary = _generateAISummary(state);
    // Generate suggested goal from user's desired changes
    final suggestedGoalTitle = state.desiredChanges.isNotEmpty && state.desiredChanges[0].isNotEmpty
        ? state.desiredChanges[0]
        : '我的成长目标';
    final suggestedGoalDescription = _generateGoalDescription(state);

    // Controllers for editable goal
    final goalTitleController = TextEditingController(text: suggestedGoalTitle);
    final goalDescController = TextEditingController(text: suggestedGoalDescription);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step title
          const Text(
            '第四步：AI 分析确认',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI 已经理解了您的目标和期望',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // AI Summary Card
          _buildInputCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'AI 的理解',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  aiSummary,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Suggested Goal Card
          _buildInputCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.flag_rounded,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '建议的大目标',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Editable goal title
                const Text(
                  '目标标题',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: goalTitleController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: '输入目标标题',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 16),
                // Editable goal description
                const Text(
                  '目标描述',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: goalDescController,
                  maxLines: 3,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: '描述您的目标',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 12),
                // Target date info
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '预计完成时间：${state.changeTimeframe}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Note about MBTI
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary.withOpacity(0.8),
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'MBTI 等性格维度可以在设置中后续完善，AI 会根据您的使用习惯持续优化建议',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Navigation buttons
          Row(
            children: [
              // Back button
              Expanded(
                child: OutlinedButton(
                  onPressed: state.isLoading
                      ? null
                      : () => _goToPreviousStep(state.currentStep),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('上一步'),
                ),
              ),
              const SizedBox(width: 16),
              // Confirm and Complete button
              Expanded(
                flex: 2,
                child: state.isLoading
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          final success = await notifier.completeOnboardingWithGoal(
                            goalTitle: goalTitleController.text.trim(),
                            goalDescription: goalDescController.text.trim(),
                          );
                          if (success && context.mounted) {
                            // Navigate to home
                            context.go('/home');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.secondaryLight, AppColors.secondary],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '确认并完成',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),

          // Error message
          if (state.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _generateAISummary(OnboardingState state) {
    final name = state.step1Data.name.isNotEmpty ? state.step1Data.name : '朋友';
    final occupation = state.step1Data.occupation.isNotEmpty ? state.step1Data.occupation : '未知';
    final challenges = state.selectedChallenges.isNotEmpty
        ? state.selectedChallenges.join('、')
        : '暂未选择';
    final changes = state.desiredChanges.where((c) => c.isNotEmpty).toList();
    final timeframe = state.changeTimeframe.isNotEmpty ? state.changeTimeframe : '待定';

    final changesText = changes.isNotEmpty
        ? changes.map((c) => '「$c」').join('、')
        : '待定';

    return '你好，$name！\n\n'
        '作为一名$occupation，你目前面临的主要挑战包括：$challenges。\n\n'
        '你希望通过在$timeframe内实现以下改变：$changesText。\n\n'
        '基于这些信息，AI 将为您生成每日待办事项，帮助您逐步达成目标。';
  }

  String _generateGoalDescription(OnboardingState state) {
    final changes = state.desiredChanges.where((c) => c.isNotEmpty).toList();
    final timeframe = state.changeTimeframe.isNotEmpty ? state.changeTimeframe : '一段时间内';

    if (changes.isEmpty) {
      return '在$timeframe内完成个人成长目标';
    }

    final firstChange = changes[0];
    final otherChanges = changes.length > 1
        ? '以及${changes.sublist(1).map((c) => '「$c」').join('、')}'
        : '';

    return '在$timeframe内，努力达成$firstChange$otherChanges。'
        '通过每日坚持完成任务，逐步实现自我提升。';
  }

  void _goToNextStep(int currentStep) {
    if (currentStep < AppConstants.onboardingTotalSteps) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      ref.read(onboardingControllerProvider.notifier).nextStep();
    }
  }

  void _goToPreviousStep(int currentStep) {
    if (currentStep > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      ref.read(onboardingControllerProvider.notifier).previousStep();
    }
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出 Onboarding?'),
        content: const Text('您的进度将不会被保存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(onboardingControllerProvider.notifier).reset();
              context.go('/login');
            },
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}

/// Animated elevated button with gradient background
class AnimatedElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const AnimatedElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<AnimatedElevatedButton> createState() => _AnimatedElevatedButtonState();
}

class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [AppColors.secondaryLight, AppColors.secondary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey.shade400,
                    Colors.grey.shade500,
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
