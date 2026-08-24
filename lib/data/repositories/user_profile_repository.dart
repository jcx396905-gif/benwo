import '../models/user_profile_model.dart';

abstract class UserProfileRepository {
  Future<UserProfileModel> saveProfile({
    String? communicationStyle,
    String? bestWorkTime,
    String? taskPace,
  });

  Future<UserProfileModel?> getProfile();

  Stream<UserProfileModel?> watchProfile();

  Future<void> clearProfile();
}
