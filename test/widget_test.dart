import 'package:benwo/app.dart';
import 'package:benwo/application/onboarding/onboarding_controller.dart';
import 'package:benwo/application/theme/theme_controller.dart';
import 'package:benwo/data/models/user_profile_model.dart';
import 'package:benwo/data/repositories/user_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('BenWo app builds the first-launch onboarding', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = _FakeProfileRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesThemeProvider.overrideWithValue(preferences),
          themeControllerProvider.overrideWith(
            (ref) => ThemeController(preferences),
          ),
          onboardingControllerProvider.overrideWith(
            (ref) => OnboardingController(preferences, repository),
          ),
        ],
        child: const BenWoApp(),
      ),
    );
    await tester.pump();

    expect(find.text('让本我更懂你的节奏'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeProfileRepository implements UserProfileRepository {
  @override
  Future<void> clearProfile() async {}

  @override
  Future<UserProfileModel?> getProfile() async => null;

  @override
  Future<UserProfileModel> saveProfile({
    String? communicationStyle,
    String? bestWorkTime,
    String? taskPace,
  }) async => UserProfileModel()
    ..communicationStyle = communicationStyle
    ..bestWorkTime = bestWorkTime
    ..taskPace = taskPace
    ..createdAt = DateTime(2026, 7, 20);

  @override
  Stream<UserProfileModel?> watchProfile() => Stream.value(null);
}
