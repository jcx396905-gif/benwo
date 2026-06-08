import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'core/utils/notification_service.dart';
import 'core/utils/todo_reminder_scheduler.dart';
import 'data/datasources/local/isar_database.dart';
import 'data/models/todo_item_model.dart';
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
  final isar = await Isar.open(IsarDatabase.schemas, directory: dir.path);

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
        sharedPreferencesOnboardingProvider.overrideWithValue(
          sharedPreferences,
        ),
        // Override Isar database provider
        isarDatabaseProvider.overrideWithValue(isar),
        // Override user repository provider
        userRepositoryProvider.overrideWithValue(UserRepositoryImpl(isar)),
      ],
      child: const BenWoApp(),
    ),
  );

  unawaited(_rescheduleExistingTodoReminders(sharedPreferences, isar));
  unawaited(_runNotificationSmokeTest());
}

Future<void> _runNotificationSmokeTest() async {
  const enabled = bool.fromEnvironment('BENWO_NOTIFICATION_SMOKE_TEST');
  if (!enabled) return;

  final notificationService = NotificationService();
  await notificationService.initialize();
  final hasPermission = await notificationService.requestPermissions();
  if (!hasPermission) {
    debugPrint('Notification smoke test skipped: permission denied.');
    return;
  }

  final scheduledTime = DateTime.now().add(const Duration(seconds: 60));
  await notificationService.scheduleTodoReminderSafely(
    id: 999999,
    title: 'BenWo notification test',
    body: 'Smoke test reminder fired on this device.',
    scheduledTime: scheduledTime,
    payload: 'notification_smoke_test',
  );
  debugPrint('Notification smoke test scheduled: $scheduledTime');
}

Future<void> _rescheduleExistingTodoReminders(
  SharedPreferences _,
  Isar isar,
) async {
  final todos = await isar.todoItemModels
      .filter()
      .isCompletedEqualTo(false)
      .findAll();
  var scheduledCount = 0;
  for (final todo in todos) {
    if (!TodoReminderScheduler.hasPreciseTime(todo.scheduledDate)) continue;
    if (!todo.scheduledDate.isAfter(DateTime.now())) continue;
    await TodoReminderScheduler.scheduleForTodo(todo);
    scheduledCount++;
  }

  debugPrint('Startup todo reminder reschedule finished: $scheduledCount');
}
