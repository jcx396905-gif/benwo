import 'dart:ui' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Notification Service for local push notifications
/// Handles todo reminders and AI encouragement notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz_data.initializeTimeZones();

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to specific page based on payload
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return false;
  }

  /// Schedule a todo reminder notification
  Future<void> scheduleTodoReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'todo_reminder',
      '任务提醒',
      channelDescription: '待办任务的提醒通知',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF7FA99B),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule AI encouragement notification
  Future<void> scheduleAiEncouragement({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'ai_encouragement',
      'AI 激励',
      channelDescription: 'AI 主动鼓励和提醒通知',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFFE8A87C),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule daily morning reminder
  Future<void> scheduleMorningReminder({
    required int id,
    required int hour,
    required int minute,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await scheduleTodoReminder(
      id: id,
      title: '早安！',
      body: '新的一天开始了，今天有什么目标要完成吗？',
      scheduledTime: scheduledDate,
      payload: 'home',
    );
  }

  /// Schedule daily evening reminder
  Future<void> scheduleEveningReminder({
    required int id,
    required int hour,
    required int minute,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await scheduleTodoReminder(
      id: id,
      title: '晚安提醒',
      body: '今天的目标完成得怎么样？明天继续加油！',
      scheduledTime: scheduledDate,
      payload: 'calendar',
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notifications.pendingNotificationRequests();
  }

  /// Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'general',
      'General',
      channelDescription: 'General notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }
}

/// Push frequency enum
enum PushFrequency {
  daily,
  twiceDaily,
  custom,
}

/// Push settings model
class PushSettings {
  final bool enabled;
  final PushFrequency frequency;
  final String? morningTime;
  final String? afternoonTime;
  final String? eveningTime;
  final String? quietHoursStart;
  final String? quietHoursEnd;

  const PushSettings({
    this.enabled = true,
    this.frequency = PushFrequency.daily,
    this.morningTime,
    this.afternoonTime,
    this.eveningTime,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  PushSettings copyWith({
    bool? enabled,
    PushFrequency? frequency,
    String? morningTime,
    String? afternoonTime,
    String? eveningTime,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return PushSettings(
      enabled: enabled ?? this.enabled,
      frequency: frequency ?? this.frequency,
      morningTime: morningTime ?? this.morningTime,
      afternoonTime: afternoonTime ?? this.afternoonTime,
      eveningTime: eveningTime ?? this.eveningTime,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}

/// Push Settings Repository for local storage
class PushSettingsRepository {
  static const _keyPushEnabled = 'push_enabled';
  static const _keyPushFrequency = 'push_frequency';
  static const _keyMorningTime = 'morning_time';
  static const _keyAfternoonTime = 'afternoon_time';
  static const _keyEveningTime = 'evening_time';
  static const _keyQuietHoursStart = 'quiet_hours_start';
  static const _keyQuietHoursEnd = 'quiet_hours_end';

  final SharedPreferences _prefs;

  PushSettingsRepository(this._prefs);

  /// Get current push settings
  PushSettings getSettings() {
    return PushSettings(
      enabled: _prefs.getBool(_keyPushEnabled) ?? true,
      frequency: PushFrequency.values[_prefs.getInt(_keyPushFrequency) ?? 0],
      morningTime: _prefs.getString(_keyMorningTime) ?? '09:00',
      afternoonTime: _prefs.getString(_keyAfternoonTime) ?? '14:00',
      eveningTime: _prefs.getString(_keyEveningTime) ?? '19:00',
      quietHoursStart: _prefs.getString(_keyQuietHoursStart),
      quietHoursEnd: _prefs.getString(_keyQuietHoursEnd),
    );
  }

  /// Save push settings
  Future<void> saveSettings(PushSettings settings) async {
    await _prefs.setBool(_keyPushEnabled, settings.enabled);
    await _prefs.setInt(_keyPushFrequency, settings.frequency.index);
    if (settings.morningTime != null) {
      await _prefs.setString(_keyMorningTime, settings.morningTime!);
    }
    if (settings.afternoonTime != null) {
      await _prefs.setString(_keyAfternoonTime, settings.afternoonTime!);
    }
    if (settings.eveningTime != null) {
      await _prefs.setString(_keyEveningTime, settings.eveningTime!);
    }
    if (settings.quietHoursStart != null) {
      await _prefs.setString(_keyQuietHoursStart, settings.quietHoursStart!);
    }
    if (settings.quietHoursEnd != null) {
      await _prefs.setString(_keyQuietHoursEnd, settings.quietHoursEnd!);
    }
  }

  /// Update push enabled
  Future<void> updateEnabled(bool enabled) async {
    await _prefs.setBool(_keyPushEnabled, enabled);
  }

  /// Update push frequency
  Future<void> updateFrequency(PushFrequency frequency) async {
    await _prefs.setInt(_keyPushFrequency, frequency.index);
  }
}
