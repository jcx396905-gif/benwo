import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'application/onboarding/onboarding_controller.dart';
import 'application/theme/theme_controller.dart';
import 'core/di/injection.dart';
import 'core/startup/single_user_bootstrap.dart';
import 'core/utils/notification_service.dart';
import 'core/utils/todo_reminder_scheduler.dart';
import 'data/datasources/local/isar_database.dart';
import 'data/models/todo_item_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final directory = await getApplicationDocumentsDirectory();
  var isar = await Isar.open(IsarDatabase.schemas, directory: directory.path);

  final bootstrap = SingleUserBootstrap(
    preferences: preferences,
    resetDatabase: () async {
      await isar.close(deleteFromDisk: true);
      isar = await Isar.open(IsarDatabase.schemas, directory: directory.path);
    },
    cancelNotifications: () async {
      final notifications = NotificationService();
      await notifications.initialize();
      await notifications.cancelAllNotifications();
    },
  );
  await bootstrap.resetIfNeeded();

  final injectionContainer = InjectionContainer()
    ..sharedPreferences = preferences
    ..isar = isar;
  await injectionContainer.init();

  runApp(
    ProviderScope(
      overrides: [
        injectionContainerProvider.overrideWithValue(injectionContainer),
        sharedPreferencesOnboardingProvider.overrideWithValue(preferences),
        sharedPreferencesThemeProvider.overrideWithValue(preferences),
        isarDatabaseProvider.overrideWithValue(isar),
      ],
      child: LiquidGlassWidgets.wrap(
        adaptiveQuality: true,
        child: const BenWoApp(),
      ),
    ),
  );

  unawaited(_rescheduleExistingTodoReminders(isar));
  unawaited(_runNotificationSmokeTest());
}

Future<void> _runNotificationSmokeTest() async {
  const enabled = bool.fromEnvironment('BENWO_NOTIFICATION_SMOKE_TEST');
  if (!enabled) return;

  final notificationService = NotificationService();
  await notificationService.initialize();
  final hasPermission = await notificationService.requestPermissions();
  if (!hasPermission) return;

  await notificationService.scheduleTodoReminderSafely(
    id: 999999,
    title: 'BenWo notification test',
    body: 'Smoke test reminder fired on this device.',
    scheduledTime: DateTime.now().add(const Duration(seconds: 60)),
    payload: 'notification_smoke_test',
  );
}

Future<void> _rescheduleExistingTodoReminders(Isar isar) async {
  final todos = await isar.todoItemModels
      .filter()
      .isCompletedEqualTo(false)
      .findAll();
  for (final todo in todos) {
    if (!TodoReminderScheduler.hasPreciseTime(todo.scheduledDate)) continue;
    if (!todo.scheduledDate.isAfter(DateTime.now())) continue;
    await TodoReminderScheduler.scheduleForTodo(todo);
  }
}
