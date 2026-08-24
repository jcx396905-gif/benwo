import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/startup/single_user_bootstrap.dart';
import '../presentation/pages/calendar/calendar_page.dart';
import '../presentation/pages/goals/create_goal_page.dart';
import '../presentation/pages/goals/goal_detail_page.dart';
import '../presentation/pages/goals/goals_list_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/focus/focus_page.dart';
import '../presentation/pages/focus/pomodoro_running_page.dart';
import '../presentation/pages/not_found_page.dart';
import '../presentation/pages/onboarding/onboarding_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/settings/settings_page.dart';

class AppRoutes {
  AppRoutes._();

  static const onboarding = '/onboarding';
  static const home = '/home';
  static const goals = '/goals';
  static const goalDetail = '/goals/:id';
  static const createGoal = '/goals/create';
  static const calendar = '/calendar';
  static const focus = '/focus';
  static const focusSession = '/focus/session/:planId/:sessionId';
  static const settings = '/settings';
  static const profile = '/profile';
  static const notFound = '/not-found';

  static const values = <String>{
    onboarding,
    home,
    goals,
    goalDetail,
    createGoal,
    calendar,
    focus,
    focusSession,
    settings,
    profile,
    notFound,
  };
}

class AppRouter {
  AppRouter({required SharedPreferences preferences})
    : router = _createRouter(preferences: preferences);

  final GoRouter router;
  static int _lastMainRouteIndex = 0;

  static String initialLocationFor({required bool onboardingHandled}) =>
      onboardingHandled ? AppRoutes.home : AppRoutes.onboarding;

  static GoRouter _createRouter({required SharedPreferences preferences}) {
    bool onboardingHandled() =>
        preferences.getBool(SingleUserBootstrap.onboardingHandledKey) ?? false;

    return GoRouter(
      initialLocation: initialLocationFor(
        onboardingHandled: onboardingHandled(),
      ),
      redirect: (context, state) {
        final handled = onboardingHandled();
        final isOnboarding = state.uri.path == AppRoutes.onboarding;
        if (!handled && !isOnboarding) return AppRoutes.onboarding;
        if (handled && isOnboarding) return AppRoutes.home;
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) =>
              _mainTabPage(state: state, index: 0, child: const HomePage()),
        ),
        GoRoute(
          path: AppRoutes.goals,
          pageBuilder: (context, state) => _mainTabPage(
            state: state,
            index: 1,
            child: const GoalsListPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.createGoal,
          builder: (context, state) => const CreateGoalPage(),
        ),
        GoRoute(
          path: AppRoutes.goalDetail,
          builder: (context, state) =>
              GoalDetailPage(goalId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.focus,
          pageBuilder: (context, state) =>
              _mainTabPage(state: state, index: 2, child: const FocusPage()),
        ),
        GoRoute(
          path: AppRoutes.focusSession,
          builder: (context, state) => PomodoroRunningPage(
            planId: int.parse(state.pathParameters['planId']!),
            sessionId: int.parse(state.pathParameters['sessionId']!),
          ),
        ),
        GoRoute(
          path: AppRoutes.calendar,
          pageBuilder: (context, state) =>
              _mainTabPage(state: state, index: 3, child: const CalendarPage()),
        ),
        GoRoute(
          path: AppRoutes.settings,
          pageBuilder: (context, state) =>
              _mainTabPage(state: state, index: 4, child: const SettingsPage()),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.notFound,
          builder: (context, state) => const NotFoundPage(),
        ),
      ],
      errorBuilder: (context, state) => const NotFoundPage(),
    );
  }

  static CustomTransitionPage<void> _mainTabPage({
    required GoRouterState state,
    required int index,
    required Widget child,
  }) {
    final previousIndex = _lastMainRouteIndex;
    _lastMainRouteIndex = index;
    final direction = index >= previousIndex ? 1.0 : -1.0;

    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 240),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(direction, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
