import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../core/utils/auth_utils.dart';
import '../../data/repositories/user_repository.dart';

/// Authentication state enum
enum AuthStatus {
  /// Initial state, checking authentication
  unknown,
  /// User is authenticated
  authenticated,
  /// User is not authenticated
  unauthenticated,
  /// Authentication error occurred
  error,
}

/// Authentication state class
class AuthState {
  final AuthStatus status;
  final int? userId;
  final String? email;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.userId,
    this.email,
    this.errorMessage,
    this.isLoading = false,
  });

  /// Create a copy with updated fields
  AuthState copyWith({
    AuthStatus? status,
    int? userId,
    String? email,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Check if user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Check if user is unauthenticated
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// Check if state is unknown (initial)
  bool get isUnknown => status == AuthStatus.unknown;

  /// Check if there's an error
  bool get hasError => status == AuthStatus.error;

  /// Create initial unknown state
  factory AuthState.unknown() => const AuthState(status: AuthStatus.unknown);

  /// Create authenticated state
  factory AuthState.authenticated({
    required int userId,
    String? email,
  }) =>
      AuthState(
        status: AuthStatus.authenticated,
        userId: userId,
        email: email,
      );

  /// Create unauthenticated state
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  /// Create error state
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  /// Create loading state (preserves current user info if authenticated)
  factory AuthState.loading(AuthState currentState) => currentState.copyWith(
        isLoading: true,
      );
}

/// SharedPreferences provider
/// This should be overridden in ProviderScope with the actual instance
final sharedPreferencesAuthProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Auth Notifier - manages authentication state using Riverpod
/// Handles login, register, logout, and auto-login functionality
class AuthNotifier extends StateNotifier<AuthState> {
  final SharedPreferences _prefs;
  final UserRepository _userRepository;

  AuthNotifier(this._prefs, this._userRepository) : super(AuthState.unknown()) {
    // Check for existing session on initialization
    _checkExistingSession();
  }

  /// Check if user has an existing valid session
  Future<void> _checkExistingSession() async {
    try {
      final token = _prefs.getString(AppConstants.keyAccessToken);
      final userIdStr = _prefs.getString(AppConstants.keyUserId);

      if (token != null && token.isNotEmpty && userIdStr != null) {
        final userId = int.tryParse(userIdStr);
        if (userId != null) {
          // Verify user still exists in database
          final user = await _userRepository.getUserById(userId);
          if (user != null) {
            state = AuthState.authenticated(
              userId: user.id,
              email: user.email,
            );
            return;
          }
        }
      }

      // No valid session found
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading(state);

    try {
      final passwordHash = AuthUtils.hashPassword(password);

      final user = await _userRepository.login(
        email: email,
        passwordHash: passwordHash,
      );

      if (user != null) {
        // Save session to SharedPreferences
        await _prefs.setString(AppConstants.keyAccessToken, 'session_${user.id}');
        await _prefs.setString(AppConstants.keyUserId, user.id.toString());

        state = AuthState.authenticated(
          userId: user.id,
          email: user.email,
        );
        return true;
      } else {
        state = AuthState.error('邮箱或密码错误，请重试');
        return false;
      }
    } catch (e) {
      state = AuthState.error('登录失败：${e.toString()}');
      return false;
    }
  }

  /// Register a new user
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading(state);

    try {
      // Check if email already exists
      final existingUser = await _userRepository.getUserByEmail(email);
      if (existingUser != null) {
        state = AuthState.error('该邮箱已被注册，请直接登录');
        return false;
      }

      final passwordHash = AuthUtils.hashPassword(password);

      // Create new user
      final user = await _userRepository.createUser(
        email: email,
        passwordHash: passwordHash,
      );

      // Auto-login after successful registration
      await _prefs.setString(AppConstants.keyAccessToken, 'session_${user.id}');
      await _prefs.setString(AppConstants.keyUserId, user.id.toString());

      state = AuthState.authenticated(
        userId: user.id,
        email: user.email,
      );
      return true;
    } catch (e) {
      state = AuthState.error('注册失败：${e.toString()}');
      return false;
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    state = AuthState.loading(state);

    try {
      // Clear session from SharedPreferences
      await _prefs.remove(AppConstants.keyAccessToken);
      await _prefs.remove(AppConstants.keyUserId);
      await _prefs.remove(AppConstants.keyHasCompletedOnboarding);

      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('退出登录失败：${e.toString()}');
    }
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    try {
      await _prefs.setBool(AppConstants.keyHasCompletedOnboarding, true);
    } catch (e) {
      // Silent fail for onboarding completion
    }
  }

  /// Check if onboarding is completed
  bool get hasCompletedOnboarding {
    return _prefs.getBool(AppConstants.keyHasCompletedOnboarding) ?? false;
  }

  /// Clear error state
  void clearError() {
    if (state.hasError) {
      state = AuthState.unauthenticated();
    }
  }

  /// Get current user ID
  int? get currentUserId => state.userId;

  /// Get current user email
  String? get currentUserEmail => state.email;
}

/// Provider for AuthNotifier
/// Requires SharedPreferences to be provided via override
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final prefs = ref.watch(sharedPreferencesAuthProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthNotifier(prefs, userRepository);
});

/// Provider to check if user is authenticated (boolean)
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.isAuthenticated;
});

/// Provider to check if onboarding is completed
final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesAuthProvider);
  return prefs.getBool(AppConstants.keyHasCompletedOnboarding) ?? false;
});

/// Provider for current user ID
final currentUserIdProvider = Provider<int?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.userId;
});
