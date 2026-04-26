import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/isar_database.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../data/repositories/big_goal_repository.dart';
import '../../data/repositories/todo_item_repository.dart';
import '../../data/repositories/user_settings_repository.dart';
import '../constants/api_constants.dart';

/// Dependency Injection Container for BenWo App
/// Centralizes all service locators using Riverpod providers
///
/// Usage:
/// - Access providers via: ref.watch(injectionContainerProvider)
/// - Or use specific providers directly

/// Main injection container that holds all dependencies
class InjectionContainer {
  InjectionContainer();

  /// SharedPreferences instance (set via sharedPreferences= setter)
  SharedPreferences? _sharedPreferences;

  /// Isar database instance (set via isar= setter)
  Isar? _isar;

  /// Dio HTTP client for MinMax API
  late Dio dio;

  /// Set SharedPreferences instance (called from main.dart)
  set sharedPreferences(SharedPreferences prefs) {
    _sharedPreferences = prefs;
  }

  /// Set Isar database instance (called from main.dart)
  set isar(Isar db) {
    _isar = db;
  }

  /// Get SharedPreferences instance
  SharedPreferences get sharedPreferences {
    if (_sharedPreferences == null) {
      throw StateError('SharedPreferences not set. Call init() first.');
    }
    return _sharedPreferences!;
  }

  /// Get Isar database instance
  Isar get isar {
    if (_isar == null) {
      throw StateError('Isar database not set. Call init() first.');
    }
    return _isar!;
  }

  /// Initialize all dependencies
  Future<void> init() async {
    // Initialize Dio for MinMax API
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.minmaxApiUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: ApiConstants.minmaxHeaders,
      ),
    );

    // Add interceptors for logging and error handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request in debug mode
          // ignore: avoid_print
          print('[Dio] Request: ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print('[Dio] Response: ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (error, handler) {
          // ignore: avoid_print
          print('[Dio] Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }
}

/// Provider for the injection container
final injectionContainerProvider = Provider<InjectionContainer>((ref) {
  throw UnimplementedError('InjectionContainer not initialized. Call init() in main.dart');
});

/// Provider for Isar database instance
final isarDatabaseProvider = Provider<Isar>((ref) {
  final container = ref.watch(injectionContainerProvider);
  return container.isar;
});

/// Provider for Dio HTTP client (MinMax API)
final dioProvider = Provider<Dio>((ref) {
  final container = ref.watch(injectionContainerProvider);
  return container.dio;
});

/// Provider for MinMax API client (higher-level API client)
final minmaxApiClientProvider = Provider<MinMaxApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return MinMaxApiClient(dio);
});

/// MinMax API Client wrapper
/// Provides a clean interface for AI-related operations
class MinMaxApiClient {
  final Dio _dio;

  MinMaxApiClient(this._dio);

  Dio get client => _dio;

  /// Send a chat completion request
  /// [messages] - List of chat messages
  /// [model] - Model to use (defaults to ApiConstants.minmaxModel)
  Future<Response<dynamic>> chatCompletion({
    required List<Map<String, String>> messages,
    String? model,
  }) async {
    return _dio.post<dynamic>(
      '/chat/completions',
      data: {
        'model': model ?? ApiConstants.minmaxModel,
        'messages': messages,
      },
    );
  }

  /// Send a simple text prompt and get completion
  Future<String> simplePrompt(String prompt) async {
    final response = await chatCompletion(
      messages: [
        {'role': 'user', 'content': prompt},
      ],
    );

    // Extract content from response
    final choices = response.data?['choices'] as List<dynamic>?;
    if (choices != null && choices.isNotEmpty) {
      return choices[0]['message']['content'] as String? ?? '';
    }
    return '';
  }
}

/// Repository provider factory pattern
/// Usage: ref.watch(repositoryProvider(RepositoryType))
///
/// Example:
/// final userRepositoryProvider = repositoryProvider<UserRepository>();
/// final userRepo = ref.watch(userRepositoryProvider);

typedef RepositoryFactory<T> = T Function(Ref ref);

final _repositoryFactories = <Type, RepositoryFactory<dynamic>>{};

Provider<T> repositoryProvider<T>() {
  return Provider<T>((ref) {
    final factory = _repositoryFactories[T];
    if (factory == null) {
      throw Exception('Repository factory not registered for type: $T');
    }
    return factory(ref) as T;
  });
}

/// Register a repository factory
/// Call this in main.dart after DI initialization
void registerRepository<T>(RepositoryFactory<T> factory) {
  _repositoryFactories[T] = factory;
}

// ============================================================================
// Repository Providers
// ============================================================================

/// User Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final isar = ref.watch(isarDatabaseProvider);
  return UserRepositoryImpl(isar);
});

/// User Profile Repository Provider
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final isar = ref.watch(isarDatabaseProvider);
  return UserProfileRepositoryImpl(isar);
});

/// Big Goal Repository Provider
final bigGoalRepositoryProvider = Provider<BigGoalRepository>((ref) {
  final isar = ref.watch(isarDatabaseProvider);
  return BigGoalRepositoryImpl(isar);
});

/// Todo Item Repository Provider
final todoItemRepositoryProvider = Provider<TodoItemRepository>((ref) {
  final isar = ref.watch(isarDatabaseProvider);
  return TodoItemRepositoryImpl(isar);
});

/// User Settings Repository Provider
final userSettingsRepositoryProvider = Provider<UserSettingsRepository>((ref) {
  final isar = ref.watch(isarDatabaseProvider);
  return UserSettingsRepositoryImpl(isar);
});
