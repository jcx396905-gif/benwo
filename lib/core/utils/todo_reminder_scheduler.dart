import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/todo_item_model.dart';
import 'notification_service.dart';

class TodoReminderScheduler {
  TodoReminderScheduler._();

  static const reminderEnabledKey = 'todo_due_reminders_enabled';

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(reminderEnabledKey) ?? true;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(reminderEnabledKey, value);
  }

  static Future<void> scheduleForTodo(TodoItemModel todo) async {
    if (!await isEnabled()) {
      debugPrint('Todo reminder skipped: reminders disabled.');
      return;
    }
    if (!hasPreciseTime(todo.scheduledDate)) {
      debugPrint('Todo reminder skipped: todo has no precise time.');
      return;
    }
    if (!todo.scheduledDate.isAfter(DateTime.now())) {
      debugPrint(
        'Todo reminder skipped: scheduled time is in the past. '
        'todo=${todo.id}, scheduled=${todo.scheduledDate}',
      );
      return;
    }

    try {
      final notificationService = NotificationService();
      await notificationService.initialize();
      final hasPermission = await notificationService.requestPermissions();
      if (!hasPermission) {
        debugPrint('Todo reminder skipped: notification permission denied.');
        return;
      }

      await notificationService.cancelNotification(_notificationId(todo.id));
      await notificationService.scheduleTodoReminderSafely(
        id: _notificationId(todo.id),
        title: 'BenWo todo reminder',
        body: todo.content,
        scheduledTime: todo.scheduledDate,
        payload: 'todo:${todo.id}',
      );
      debugPrint(
        'Todo reminder scheduled. todo=${todo.id}, '
        'time=${todo.scheduledDate}',
      );
    } catch (e, stackTrace) {
      debugPrint('Todo reminder schedule failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      // Reminder setup must never make todo creation fail.
    }
  }

  static Future<void> cancelForTodo(int todoId) async {
    try {
      final notificationService = NotificationService();
      await notificationService.initialize();
      await notificationService.cancelNotification(_notificationId(todoId));
    } catch (_) {
      // A broken native notification cache should not block todo operations.
    }
  }

  static bool hasPreciseTime(DateTime date) {
    return date.hour != 0 || date.minute != 0 || date.second != 0;
  }

  static int _notificationId(int todoId) => 100000 + todoId;
}
