import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile_model.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../core/di/injection.dart';

/// Profile State containing all user profile dimensions
class ProfileState {
  final UserProfileModel? profile;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserProfileModel? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Profile Notifier - Riverpod StateNotifier for user profile management
class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserProfileRepository _profileRepository;

  ProfileNotifier(this._profileRepository) : super(const ProfileState());

  /// Load user profile
  Future<bool> loadProfile(int userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final profile = await _profileRepository.getProfileByUserId(userId);
      state = state.copyWith(
        isLoading: false,
        profile: profile,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '加载用户画像失败：${e.toString()}',
      );
      return false;
    }
  }

  /// Update MBTI type
  Future<bool> updateMbti(int userId, String mbti) async {
    return _updateProfile(userId, mbti: mbti);
  }

  /// Update communication style
  Future<bool> updateCommunicationStyle(int userId, String style) async {
    return _updateProfile(userId, communicationStyle: style);
  }

  /// Update motivation sensitivity
  Future<bool> updateMotivationSensitivity(int userId, String sensitivity) async {
    return _updateProfile(userId, motivationSensitivity: sensitivity);
  }

  /// Update best work time
  Future<bool> updateBestWorkTime(int userId, String time) async {
    return _updateProfile(userId, bestWorkTime: time);
  }

  /// Update stress response
  Future<bool> updateStressResponse(int userId, String response) async {
    return _updateProfile(userId, stressResponse: response);
  }

  /// Update social preference
  Future<bool> updateSocialPreference(int userId, String preference) async {
    return _updateProfile(userId, socialPreference: preference);
  }

  /// Update name
  Future<bool> updateName(int userId, String name) async {
    return _updateProfile(userId, name: name);
  }

  /// Update age
  Future<bool> updateAge(int userId, int age) async {
    return _updateProfile(userId, age: age);
  }

  /// Update occupation
  Future<bool> updateOccupation(int userId, String occupation) async {
    return _updateProfile(userId, occupation: occupation);
  }

  /// Update region
  Future<bool> updateRegion(int userId, String region) async {
    return _updateProfile(userId, region: region);
  }

  /// Helper method to update profile fields
  Future<bool> _updateProfile(
    int userId, {
    String? name,
    int? age,
    String? occupation,
    String? region,
    String? mbti,
    String? communicationStyle,
    String? motivationSensitivity,
    String? bestWorkTime,
    String? stressResponse,
    String? socialPreference,
    String? challenges,
    String? lifeStatus,
    int? changeTimeframeMonths,
    String? threeChanges,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final updatedProfile = await _profileRepository.saveProfile(
        userId: userId,
        name: name,
        age: age,
        occupation: occupation,
        region: region,
        mbti: mbti,
        communicationStyle: communicationStyle,
        motivationSensitivity: motivationSensitivity,
        bestWorkTime: bestWorkTime,
        stressResponse: stressResponse,
        socialPreference: socialPreference,
        challenges: challenges,
        lifeStatus: lifeStatus,
        changeTimeframeMonths: changeTimeframeMonths,
        threeChanges: threeChanges,
      );

      state = state.copyWith(
        isLoading: false,
        profile: updatedProfile,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '更新用户画像失败：${e.toString()}',
      );
      return false;
    }
  }

  /// Complete onboarding
  Future<bool> completeOnboarding(int userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _profileRepository.completeOnboarding(userId);
      final profile = await _profileRepository.getProfileByUserId(userId);
      state = state.copyWith(
        isLoading: false,
        profile: profile,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '完成 onboarding 失败：${e.toString()}',
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset state
  void reset() {
    state = const ProfileState();
  }
}

/// Provider for ProfileNotifier
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final profileRepository = ref.watch(userProfileRepositoryProvider);
  return ProfileNotifier(profileRepository);
});

/// Available MBTI types
const List<String> mbtiTypes = [
  'INTJ', 'INTP', 'ENTJ', 'ENTP',
  'INFJ', 'INFP', 'ENFJ', 'ENFP',
  'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
  'ISTP', 'ISFP', 'ESTP', 'ESFP',
];

/// Communication style options
const List<String> communicationStyles = [
  '鼓励型',
  '直接型',
  '分析型',
];

/// Motivation sensitivity options
const List<String> motivationSensitivityLevels = [
  '高',
  '中',
  '低',
];

/// Best work time options
const List<String> bestWorkTimeOptions = [
  '早起型',
  '夜猫型',
  '弹性',
];

/// Stress response options
const List<String> stressResponseOptions = [
  '喜欢被推动',
  '需要缓冲空间',
  '视情况而定',
];

/// Social preference options
const List<String> socialPreferenceOptions = [
  '独立完成',
  '喜欢协作',
  '视任务而定',
];
