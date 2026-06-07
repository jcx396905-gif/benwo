import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../data/repositories/big_goal_repository.dart';

/// Onboarding step data for Step 1
class OnboardingStep1Data {
  final String name;
  final int? age;
  final String occupation;
  final String region;

  const OnboardingStep1Data({
    this.name = '',
    this.age,
    this.occupation = '',
    this.region = '',
  });

  OnboardingStep1Data copyWith({
    String? name,
    int? age,
    String? occupation,
    String? region,
  }) {
    return OnboardingStep1Data(
      name: name ?? this.name,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      region: region ?? this.region,
    );
  }

  bool get isValid =>
      name.isNotEmpty &&
      age != null &&
      age! > 0 &&
      age! < 150 &&
      occupation.isNotEmpty &&
      region.isNotEmpty;
}

/// Onboarding state
class OnboardingState {
  final int currentStep;
  final OnboardingStep1Data step1Data;
  final List<String> selectedChallenges;
  final String lifeStatus;
  final List<String> desiredChanges;
  final String changeTimeframe;
  final bool isLoading;
  final String? errorMessage;

  const OnboardingState({
    this.currentStep = 1,
    this.step1Data = const OnboardingStep1Data(),
    this.selectedChallenges = const [],
    this.lifeStatus = '',
    this.desiredChanges = const [],
    this.changeTimeframe = '',
    this.isLoading = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    int? currentStep,
    OnboardingStep1Data? step1Data,
    List<String>? selectedChallenges,
    String? lifeStatus,
    List<String>? desiredChanges,
    String? changeTimeframe,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      step1Data: step1Data ?? this.step1Data,
      selectedChallenges: selectedChallenges ?? this.selectedChallenges,
      lifeStatus: lifeStatus ?? this.lifeStatus,
      desiredChanges: desiredChanges ?? this.desiredChanges,
      changeTimeframe: changeTimeframe ?? this.changeTimeframe,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  int get totalSteps => AppConstants.onboardingTotalSteps;

  bool get canProceedFromStep1 => step1Data.isValid;
}

/// Onboarding Controller - Riverpod StateNotifier for managing onboarding flow
class OnboardingController extends StateNotifier<OnboardingState> {
  final SharedPreferences _prefs;
  final UserProfileRepository _userProfileRepository;
  final BigGoalRepository _bigGoalRepository;

  OnboardingController(
    this._prefs,
    this._userProfileRepository,
    this._bigGoalRepository,
  ) : super(const OnboardingState());

  /// Update Step 1 data
  void updateStep1Name(String name) {
    state = state.copyWith(
      step1Data: state.step1Data.copyWith(name: name),
    );
  }

  void updateStep1Age(int? age) {
    state = state.copyWith(
      step1Data: state.step1Data.copyWith(age: age),
    );
  }

  void updateStep1Occupation(String occupation) {
    state = state.copyWith(
      step1Data: state.step1Data.copyWith(occupation: occupation),
    );
  }

  void updateStep1Region(String region) {
    state = state.copyWith(
      step1Data: state.step1Data.copyWith(region: region),
    );
  }

  /// Move to next step
  void nextStep() {
    if (state.currentStep < state.totalSteps) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  /// Move to previous step
  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Go to specific step
  void goToStep(int step) {
    if (step >= 1 && step <= state.totalSteps) {
      state = state.copyWith(currentStep: step);
    }
  }

  /// Update selected challenges (Step 2)
  void updateSelectedChallenges(List<String> challenges) {
    state = state.copyWith(selectedChallenges: challenges);
  }

  /// Toggle a challenge selection
  void toggleChallenge(String challenge) {
    final currentChallenges = List<String>.from(state.selectedChallenges);
    if (currentChallenges.contains(challenge)) {
      currentChallenges.remove(challenge);
    } else {
      currentChallenges.add(challenge);
    }
    state = state.copyWith(selectedChallenges: currentChallenges);
  }

  /// Update life status (Step 2)
  void updateLifeStatus(String status) {
    state = state.copyWith(lifeStatus: status);
  }

  /// Update desired changes (Step 3)
  void updateDesiredChanges(List<String> changes) {
    state = state.copyWith(desiredChanges: changes);
  }

  /// Update change timeframe (Step 3)
  void updateChangeTimeframe(String timeframe) {
    state = state.copyWith(changeTimeframe: timeframe);
  }

  /// Complete onboarding and save profile
  Future<bool> completeOnboarding() async {
    if (state.currentStep != state.totalSteps) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userIdStr = _prefs.getString(AppConstants.keyUserId);
      if (userIdStr == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '用户未登录',
        );
        return false;
      }

      final userId = int.tryParse(userIdStr);
      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '无效的用户ID',
        );
        return false;
      }

      // Create user profile with Step 1 data
      // Challenges and desiredChanges are stored as comma-separated strings
      final challengesString = state.selectedChallenges.join(',');
      final threeChangesString = state.desiredChanges.join(',');

      await _userProfileRepository.saveProfile(
        userId: userId,
        name: state.step1Data.name,
        age: state.step1Data.age,
        occupation: state.step1Data.occupation,
        region: state.step1Data.region,
        lifeStatus: state.lifeStatus,
        challenges: challengesString,
        changeTimeframeMonths: _parseTimeframeToMonths(state.changeTimeframe),
        threeChanges: threeChangesString,
        hasCompletedOnboarding: true,
      );

      await _prefs.setBool(AppConstants.keyHasCompletedOnboarding, true);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '保存失败：${e.toString()}',
      );
      return false;
    }
  }

  /// Complete onboarding with a BigGoal
  Future<bool> completeOnboardingWithGoal({
    required String goalTitle,
    required String goalDescription,
  }) async {
    if (state.currentStep != state.totalSteps) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userIdStr = _prefs.getString(AppConstants.keyUserId);
      if (userIdStr == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '用户未登录',
        );
        return false;
      }

      final userId = int.tryParse(userIdStr);
      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '无效的用户ID',
        );
        return false;
      }

      // Create user profile with Step 1 data
      final challengesString = state.selectedChallenges.join(',');
      final threeChangesString = state.desiredChanges.join(',');

      await _userProfileRepository.saveProfile(
        userId: userId,
        name: state.step1Data.name,
        age: state.step1Data.age,
        occupation: state.step1Data.occupation,
        region: state.step1Data.region,
        lifeStatus: state.lifeStatus,
        challenges: challengesString,
        changeTimeframeMonths: _parseTimeframeToMonths(state.changeTimeframe),
        threeChanges: threeChangesString,
        hasCompletedOnboarding: true,
      );

      // Calculate target date based on timeframe
      final targetDate = _calculateTargetDate(state.changeTimeframe);

      // Create the BigGoal
      await _bigGoalRepository.createGoal(
        userId: userId,
        title: goalTitle.isNotEmpty ? goalTitle : '我的成长目标',
        description: goalDescription,
        targetDate: targetDate,
        color: AppConstants.defaultGoalColor,
        category: _inferCategory(state),
        aiSummary: '基于用户期望：${threeChangesString}',
      );

      await _prefs.setBool(AppConstants.keyHasCompletedOnboarding, true);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '保存失败：${e.toString()}',
      );
      return false;
    }
  }

  /// Calculate target date based on timeframe string
  DateTime _calculateTargetDate(String timeframe) {
    final months = _parseTimeframeToMonths(timeframe);
    if (months == null) {
      // Default to 3 months from now
      return DateTime.now().add(const Duration(days: 90));
    }
    return DateTime.now().add(Duration(days: months * 30));
  }

  /// Infer goal category based on user's input
  String _inferCategory(OnboardingState state) {
    // Check if any desired changes relate to specific categories
    final changesText = state.desiredChanges.join(' ').toLowerCase();

    if (changesText.contains('英语') ||
        changesText.contains('学习') ||
        changesText.contains('考试') ||
        changesText.contains('学业')) {
      return '学业';
    }
    if (changesText.contains('工作') ||
        changesText.contains('职业') ||
        changesText.contains('事业')) {
      return '职业';
    }
    if (changesText.contains('健康') ||
        changesText.contains('运动') ||
        changesText.contains('健身') ||
        changesText.contains('减肥')) {
      return '健康';
    }
    if (changesText.contains('关系') ||
        changesText.contains('朋友') ||
        changesText.contains('社交')) {
      return '关系';
    }
    if (changesText.contains('钱') ||
        changesText.contains('财务') ||
        changesText.contains('投资')) {
      return '财务';
    }
    // Default to personal growth
    return '个人成长';
  }

  /// Parse timeframe string to months
  int? _parseTimeframeToMonths(String timeframe) {
    if (timeframe.isEmpty) return null;

    // Extract number from timeframe like "3个月" or "半年"
    final numberMatch = RegExp(r'(\d+)').firstMatch(timeframe);
    if (numberMatch != null) {
      return int.tryParse(numberMatch.group(1)!);
    }

    // Handle "半年" (half year = 6 months)
    if (timeframe.contains('半年')) return 6;

    // Handle "一年" (one year = 12 months)
    if (timeframe.contains('一年')) return 12;

    return null;
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset onboarding state
  void reset() {
    state = const OnboardingState();
  }
}

/// Provider for SharedPreferences (used in onboarding)
final sharedPreferencesOnboardingProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Onboarding Controller Provider
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  final prefs = ref.watch(sharedPreferencesOnboardingProvider);
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final bigGoalRepository = ref.watch(bigGoalRepositoryProvider);
  return OnboardingController(prefs, userProfileRepository, bigGoalRepository);
});
