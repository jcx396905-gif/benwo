import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'data/datasources/local/isar_database.dart';
import 'application/auth/auth_notifier.dart';
import 'application/onboarding/onboarding_controller.dart';

/// Provider for SharedPreferences instance (defined here for main.dart usage)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Isar database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    IsarDatabase.schemas,
    directory: dir.path,
  );

  // Initialize dependency injection container
  final injectionContainer = InjectionContainer();
  injectionContainer.sharedPreferences = sharedPreferences;
  injectionContainer.isar = isar;
  await injectionContainer.init();

  runApp(
    ProviderScope(
      overrides: [
        // Override injection container provider
        injectionContainerProvider.overrideWithValue(injectionContainer),
        // Override SharedPreferences provider
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        sharedPreferencesAuthProvider.overrideWithValue(sharedPreferences),
        sharedPreferencesOnboardingProvider.overrideWithValue(sharedPreferences),
        // Override Isar database provider
        isarDatabaseProvider.overrideWithValue(isar),
        // Override user repository provider
        userRepositoryProvider.overrideWithValue(UserRepositoryImpl(isar)),
      ],
      child: const BenWoApp(),
    ),
  );
}
