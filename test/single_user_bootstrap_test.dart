import 'package:benwo/core/startup/single_user_bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('first single-user launch resets legacy data exactly once', () async {
    SharedPreferences.setMockInitialValues({
      'access_token': 'legacy-token',
      'refresh_token': 'legacy-refresh',
      'user_id': '42',
      'has_completed_onboarding': true,
      'push_enabled': false,
      'theme_mode': 'dark',
    });
    final preferences = await SharedPreferences.getInstance();
    var databaseResetCount = 0;
    var notificationCancelCount = 0;
    final bootstrap = SingleUserBootstrap(
      preferences: preferences,
      resetDatabase: () async => databaseResetCount++,
      cancelNotifications: () async => notificationCancelCount++,
    );

    final didReset = await bootstrap.resetIfNeeded();
    final secondReset = await bootstrap.resetIfNeeded();

    expect(didReset, isTrue);
    expect(secondReset, isFalse);
    expect(databaseResetCount, 1);
    expect(notificationCancelCount, 1);
    expect(preferences.getString('access_token'), isNull);
    expect(preferences.getString('user_id'), isNull);
    expect(preferences.getBool('has_completed_onboarding'), isNull);
    expect(preferences.getString('theme_mode'), isNull);
    expect(preferences.getBool(SingleUserBootstrap.resetMarkerKey), isTrue);
    expect(
      preferences.getBool(SingleUserBootstrap.notificationCleanupMarkerKey),
      isTrue,
    );
  });

  test('completed single-user reset never deletes current data', () async {
    SharedPreferences.setMockInitialValues({
      SingleUserBootstrap.resetMarkerKey: true,
      SingleUserBootstrap.notificationCleanupMarkerKey: true,
      'profile_onboarding_handled': true,
      'theme_mode': 'light',
    });
    final preferences = await SharedPreferences.getInstance();
    var resetCalled = false;
    final bootstrap = SingleUserBootstrap(
      preferences: preferences,
      resetDatabase: () async => resetCalled = true,
      cancelNotifications: () async {},
    );

    expect(await bootstrap.resetIfNeeded(), isFalse);
    expect(resetCalled, isFalse);
    expect(preferences.getBool('profile_onboarding_handled'), isTrue);
    expect(preferences.getString('theme_mode'), 'light');
  });

  test(
    'notification cleanup retries without repeating destructive reset',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      var databaseResetCount = 0;
      var notificationCancelCount = 0;
      final bootstrap = SingleUserBootstrap(
        preferences: preferences,
        resetDatabase: () async => databaseResetCount++,
        cancelNotifications: () async {
          notificationCancelCount++;
          if (notificationCancelCount == 1) {
            throw StateError('plugin unavailable');
          }
        },
      );

      expect(await bootstrap.resetIfNeeded(), isTrue);
      expect(await bootstrap.resetIfNeeded(), isFalse);

      expect(databaseResetCount, 1);
      expect(notificationCancelCount, 2);
      expect(preferences.getBool(SingleUserBootstrap.resetMarkerKey), isTrue);
      expect(
        preferences.getBool(SingleUserBootstrap.notificationCleanupMarkerKey),
        isTrue,
      );
    },
  );
}
