import 'package:shared_preferences/shared_preferences.dart';

typedef StartupAction = Future<void> Function();

class SingleUserBootstrap {
  SingleUserBootstrap({
    required this.preferences,
    required this.resetDatabase,
    required this.cancelNotifications,
  });

  static const resetMarkerKey = 'single_user_reset_v1_done';
  static const notificationCleanupMarkerKey =
      'single_user_notification_cleanup_v1_done';
  static const onboardingHandledKey = 'profile_onboarding_handled';

  static const _legacyKeys = <String>{
    'access_token',
    'refresh_token',
    'user_id',
    'is_first_launch',
    'has_completed_onboarding',
    'push_enabled',
    'push_frequency',
    'morning_time',
    'afternoon_time',
    'evening_time',
    'quiet_hours_start',
    'quiet_hours_end',
    'todo_due_reminders_enabled',
    'theme_mode',
    onboardingHandledKey,
  };

  final SharedPreferences preferences;
  final StartupAction resetDatabase;
  final StartupAction cancelNotifications;

  Future<bool> resetIfNeeded() async {
    var didReset = false;
    if (!(preferences.getBool(resetMarkerKey) ?? false)) {
      await resetDatabase();
      for (final key in _legacyKeys) {
        await preferences.remove(key);
      }
      final marked = await preferences.setBool(resetMarkerKey, true);
      if (!marked) {
        throw StateError('Could not persist the single-user reset marker.');
      }
      didReset = true;
    }

    if (!(preferences.getBool(notificationCleanupMarkerKey) ?? false)) {
      try {
        await cancelNotifications();
        final marked = await preferences.setBool(
          notificationCleanupMarkerKey,
          true,
        );
        if (!marked) {
          throw StateError(
            'Could not persist the notification cleanup marker.',
          );
        }
      } catch (_) {
        // Notification plugins can be unavailable during desktop tests or
        // early platform startup. Keep this marker unset so cleanup retries
        // next launch without ever repeating the destructive database reset.
      }
    }

    return didReset;
  }
}
