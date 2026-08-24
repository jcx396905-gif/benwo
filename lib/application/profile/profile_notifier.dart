import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/repositories/user_profile_repository.dart';

const communicationStyles = ['温和鼓励', '直接简洁', '分析清晰'];
const bestWorkTimeOptions = ['清晨', '白天', '夜晚', '时间不固定'];
const taskPaceOptions = ['轻松小步', '均衡推进', '强力推动'];

class ProfileState {
  const ProfileState({this.profile, this.isLoading = false, this.errorMessage});

  final UserProfileModel? profile;
  final bool isLoading;
  final String? errorMessage;

  ProfileState copyWith({
    Object? profile = _profileUnchanged,
    bool? isLoading,
    Object? errorMessage = _profileUnchanged,
  }) {
    return ProfileState(
      profile: identical(profile, _profileUnchanged)
          ? this.profile
          : profile as UserProfileModel?,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _profileUnchanged)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _profileUnchanged = Object();

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._repository) : super(const ProfileState());

  final UserProfileRepository _repository;

  Future<bool> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _repository.getProfile();
      state = state.copyWith(isLoading: false, profile: profile);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '加载 AI 个性化偏好失败：$error',
      );
      return false;
    }
  }

  Future<bool> savePreferences({
    String? communicationStyle,
    String? bestWorkTime,
    String? taskPace,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profile = await _repository.saveProfile(
        communicationStyle: communicationStyle,
        bestWorkTime: bestWorkTime,
        taskPace: taskPace,
      );
      state = state.copyWith(isLoading: false, profile: profile);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '保存 AI 个性化偏好失败：$error',
      );
      return false;
    }
  }

  Future<bool> clearPreferences() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.clearProfile();
      state = const ProfileState();
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '清空 AI 个性化偏好失败：$error',
      );
      return false;
    }
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      return ProfileNotifier(ref.watch(userProfileRepositoryProvider));
    });
