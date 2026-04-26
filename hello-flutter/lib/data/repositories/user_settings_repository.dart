import '../models/user_settings_model.dart';

/// Repository interface for UserSettings operations
abstract class UserSettingsRepository {
  /// Create default settings for a user
  Future<UserSettingsModel> createSettings({
    required int userId,
  });

  /// Get settings by user ID
  Future<UserSettingsModel?> getSettingsByUserId(int userId);

  /// Update settings
  Future<void> updateSettings(UserSettingsModel settings);

  /// Update push notification enabled
  Future<void> updatePushEnabled(int userId, bool enabled);

  /// Update push frequency
  Future<void> updatePushFrequency(int userId, PushFrequency frequency);

  /// Update quiet hours
  Future<void> updateQuietHours(
    int userId, {
    String? startTime,
    String? endTime,
  });

  /// Update theme preference
  Future<void> updateThemePreference(int userId, String themeMode);

  /// Delete settings
  Future<void> deleteSettings(int userId);

  /// Watch settings by user ID
  Stream<UserSettingsModel?> watchSettingsByUserId(int userId);
}
