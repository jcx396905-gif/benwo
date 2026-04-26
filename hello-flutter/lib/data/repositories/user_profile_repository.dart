import '../models/user_profile_model.dart';

/// Repository interface for UserProfile operations
abstract class UserProfileRepository {
  /// Create or update user profile
  Future<UserProfileModel> saveProfile({
    required int userId,
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
    bool? hasCompletedOnboarding,
  });

  /// Get profile by user ID
  Future<UserProfileModel?> getProfileByUserId(int userId);

  /// Watch profile by user ID for changes
  Stream<UserProfileModel?> watchProfileByUserId(int userId);

  /// Update onboarding status
  Future<void> completeOnboarding(int userId);

  /// Delete profile
  Future<void> deleteProfile(int userId);
}
