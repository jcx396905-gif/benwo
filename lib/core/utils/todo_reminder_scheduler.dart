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
    if (!await isEnabled()) return;
    if (!hasPreciseTime(todo.scheduledDate)) return;
    if (!todo.scheduledDate.isAfter(DateTime.now())) return;

    final notificationService = NotificationService();
    await notificationService.initialize();
    final hasPermission = await notificationService.requestPermissions();
    if (!hasPermission) return;

    await notificationService.cancelNotification(_notificationId(todo.id));
    await notificationService.scheduleTodoReminder(
      id: _notificationId(todo.id),
      title: '待办提醒',
      body: todo.content,
      scheduledTime: todo.scheduledDate,
      payload: 'todo:${todo.id}',
    );
  }

  static Future<void> cancelForTodo(int todoId) async {
    final notificationService = NotificationService();
    await notificationService.initialize();
    await notificationService.cancelNotification(_notificationId(todoId));
  }

  static bool hasPreciseTime(DateTime date) {
    return date.hour != 0 || date.minute != 0 || date.second != 0;
  }

  static int _notificationId(int todoId) => 100000 + todoId;
}
