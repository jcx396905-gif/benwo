import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesGuardProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Provider to check if user is authenticated
final isAuthenticatedGuardProvider = FutureProvider<bool>((ref) async {
  final prefs = ref.watch(sharedPreferencesGuardProvider);
  final token = prefs.getString(AppConstants.keyAccessToken);
  return token != null && token.isNotEmpty;
});

/// Provider for current user ID
final currentUserIdGuardProvider = FutureProvider<String?>((ref) async {
  final prefs = ref.watch(sharedPreferencesGuardProvider);
  return prefs.getString(AppConstants.keyUserId);
});

/// Provider to check if user has completed onboarding
final hasCompletedOnboardingGuardProvider = FutureProvider<bool>((ref) async {
  final prefs = ref.watch(sharedPreferencesGuardProvider);
  return prefs.getBool(AppConstants.keyHasCompletedOnboarding) ?? false;
});

/// Route paths
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String goals = '/goals';
  static const String goalDetail = '/goals/:id';
  static const String createGoal = '/goals/create';
  static const String calendar = '/calendar';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String notFound = '/not-found';
}

/// Auth redirect helper - checks authentication and returns redirect path if needed
/// Returns null if no redirect is needed
Future<String?> authRedirect(
  GoRouterState state,
  SharedPreferences prefs,
) async {
  final currentPath = state.uri.path;
  final token = prefs.getString(AppConstants.keyAccessToken);
  final userId = prefs.getString(AppConstants.keyUserId);
  final isAuthenticated =
      token != null && token.isNotEmpty && userId != null && userId.isNotEmpty;
  final hasCompletedOnboarding =
      prefs.getBool(AppConstants.keyHasCompletedOnboarding) ?? false;

  // Public routes that don't require authentication
  final publicRoutes = [
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.notFound,
  ];

  if (publicRoutes.contains(currentPath)) {
    if (isAuthenticated &&
        (currentPath == AppRoutes.login || currentPath == AppRoutes.register)) {
      return hasCompletedOnboarding ? AppRoutes.home : AppRoutes.onboarding;
    }
    return null;
  }

  if (!isAuthenticated) {
    return AppRoutes.login;
  }

  if (!hasCompletedOnboarding && currentPath != AppRoutes.onboarding) {
    return AppRoutes.onboarding;
  }

  if (hasCompletedOnboarding && currentPath == AppRoutes.onboarding) {
    return AppRoutes.home;
  }

  return null;
}
