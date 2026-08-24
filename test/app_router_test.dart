import 'package:flutter_test/flutter_test.dart';
import 'package:benwo/routes/app_router.dart';

void main() {
  test('first launch opens profile onboarding', () {
    expect(
      AppRouter.initialLocationFor(onboardingHandled: false),
      '/onboarding',
    );
  });

  test('handled onboarding opens home', () {
    expect(AppRouter.initialLocationFor(onboardingHandled: true), '/home');
  });

  test('legacy authentication routes are not public routes anymore', () {
    expect(AppRoutes.values, isNot(contains('/login')));
    expect(AppRoutes.values, isNot(contains('/register')));
  });

  test('pomodoro focus routes are public single-user routes', () {
    expect(AppRoutes.values, contains('/focus'));
    expect(AppRoutes.values, contains('/focus/session/:planId/:sessionId'));
  });
}
