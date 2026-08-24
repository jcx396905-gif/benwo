import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection.dart';
import '../../core/startup/single_user_bootstrap.dart';
import '../../data/repositories/user_profile_repository.dart';

class OnboardingState {
  const OnboardingState({
    this.communicationStyle,
    this.bestWorkTime,
    this.taskPace,
    this.isLoading = false,
    this.errorMessage,
  });

  final String? communicationStyle;
  final String? bestWorkTime;
  final String? taskPace;
  final bool isLoading;
  final String? errorMessage;

  OnboardingState copyWith({
    Object? communicationStyle = _unchanged,
    Object? bestWorkTime = _unchanged,
    Object? taskPace = _unchanged,
    bool? isLoading,
    Object? errorMessage = _unchanged,
  }) {
    return OnboardingState(
      communicationStyle: identical(communicationStyle, _unchanged)
          ? this.communicationStyle
          : communicationStyle as String?,
      bestWorkTime: identical(bestWorkTime, _unchanged)
          ? this.bestWorkTime
          : bestWorkTime as String?,
      taskPace: identical(taskPace, _unchanged)
          ? this.taskPace
          : taskPace as String?,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _unchanged)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _unchanged = Object();

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._preferences, this._profileRepository)
    : super(const OnboardingState());

  final SharedPreferences _preferences;
  final UserProfileRepository _profileRepository;

  void updateCommunicationStyle(String? value) {
    state = state.copyWith(communicationStyle: value, errorMessage: null);
  }

  void updateBestWorkTime(String? value) {
    state = state.copyWith(bestWorkTime: value, errorMessage: null);
  }

  void updateTaskPace(String? value) {
    state = state.copyWith(taskPace: value, errorMessage: null);
  }

  Future<bool> saveProfileAndFinish() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _profileRepository.saveProfile(
        communicationStyle: state.communicationStyle,
        bestWorkTime: state.bestWorkTime,
        taskPace: state.taskPace,
      );
      await _markHandled();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '保存失败，请稍后重试：$error',
      );
      return false;
    }
  }

  Future<bool> skip() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _markHandled();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '无法跳过引导，请稍后重试：$error',
      );
      return false;
    }
  }

  Future<void> _markHandled() {
    return _preferences.setBool(SingleUserBootstrap.onboardingHandledKey, true);
  }
}

final sharedPreferencesOnboardingProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
      return OnboardingController(
        ref.watch(sharedPreferencesOnboardingProvider),
        ref.watch(userProfileRepositoryProvider),
      );
    });
