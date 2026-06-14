import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/onboarding/onboarding_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/goals/goals_list_page.dart';
import '../presentation/pages/goals/goal_detail_page.dart';
import '../presentation/pages/goals/create_goal_page.dart';
import '../presentation/pages/calendar/calendar_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/pages/profile/profile_page.dart';
import '../presentation/pages/not_found_page.dart';
import 'auth_guard.dart';

/// App Router using go_router with auth guard
class AppRouter {
  final GoRouter router;

  AppRouter() : router = _createRouter();

  static int _lastMainRouteIndex = 0;

  static GoRouter _createRouter() {
    return GoRouter(
      initialLocation: AppRoutes.login,
      debugLogDiagnostics: true,
      redirect: (context, state) async {
        // Get SharedPreferences from the provider
        // Note: During redirect, we read SharedPreferences directly
        // because we're outside the widget tree
        final prefs = await _getSharedPreferences();
        if (prefs == null) {
          // If prefs not available yet, don't redirect (will be handled later)
          return null;
        }
        return authRedirect(state, prefs);
      },
      routes: [
        // Auth routes (no guard needed - handled in redirect)
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),

        // Onboarding route (redirected if not authenticated or already completed)
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),

        // Protected routes (require authentication)
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder: (context, state) =>
              _mainTabPage(state: state, index: 0, child: const HomePage()),
        ),
        GoRoute(
          path: AppRoutes.goals,
          name: 'goals',
          pageBuilder: (context, state) => _mainTabPage(
            state: state,
            index: 1,
            child: const GoalsListPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.createGoal,
          name: 'create-goal',
          builder: (context, state) => const CreateGoalPage(),
        ),
        GoRoute(
          path: AppRoutes.goalDetail,
          name: 'goal-detail',
          builder: (context, state) {
            final goalId = state.pathParameters['id']!;
            return GoalDetailPage(goalId: goalId);
          },
        ),
        GoRoute(
          path: AppRoutes.calendar,
          name: 'calendar',
          pageBuilder: (context, state) =>
              _mainTabPage(state: state, index: 2, child: const CalendarPage()),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          pageBuilder: (context, state) =>
              _mainTabPage(state: state, index: 3, child: const SettingsPage()),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),

        // Error page
        GoRoute(
          path: AppRoutes.notFound,
          name: 'not-found',
          builder: (context, state) => const NotFoundPage(),
        ),

        // Redirect unknown paths to not-found
      ],
      errorBuilder: (context, state) => const NotFoundPage(),
    );
  }

  /// Get SharedPreferences instance
  /// This is a workaround to access SharedPreferences during router initialization
  static Future<SharedPreferences?> _getSharedPreferences() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
      return null;
    }
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
