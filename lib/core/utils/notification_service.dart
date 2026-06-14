import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Notification Service for local push notifications
/// Handles todo reminders and AI encouragement notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const _todoReminderChannelId = 'todo_due_reminder_v2';
  static const _todoReminderChannelName = 'BenWo todo reminders';
  static const _todoReminderChannelDescription =
      'Show a notification when a todo reaches its precise time.';

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static const MethodChannel _notificationCacheChannel = MethodChannel(
    'benwo/notification_cache',
  );
  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz_data.initializeTimeZones();

    // Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

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
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final ios = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
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

  Future<bool> canScheduleExactNotifications() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return true;
    return await android.canScheduleExactNotifications() ?? true;
  }

  /// Schedule a todo reminder notification
  Future<void> scheduleTodoReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _todoReminderChannelId,
      _todoReminderChannelName,
      channelDescription: _todoReminderChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF7FA99B),
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.reminder,
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

    await _scheduleWithCacheRepair(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      details: details,
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
    const androidDetails = AndroidNotificationDetails(
      'ai_encouragement',
      'AI encouragement',
      channelDescription: 'AI encouragement and reminder notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFE8A87C),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _scheduleWithCacheRepair(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      details: details,
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
      title: 'Good morning',
      body: 'A new day has started. What goals do you want to finish today?',
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
      title: '閺呮艾鐣ㄩ幓鎰板晪',
      body: 'How did today go? Keep going tomorrow.',
      scheduledTime: scheduledDate,
      payload: 'calendar',
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
    } on PlatformException catch (e) {
      if (!_isBrokenScheduledNotificationCache(e)) rethrow;
      await _clearScheduledNotificationsCache();
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
    } on PlatformException catch (e) {
      if (!_isBrokenScheduledNotificationCache(e)) rethrow;
      await _clearScheduledNotificationsCache();
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notifications.pendingNotificationRequests();
  }

  Future<void> _scheduleWithCacheRepair({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required NotificationDetails details,
    String? payload,
  }) async {
    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } on PlatformException catch (e) {
      if (!_isBrokenScheduledNotificationCache(e)) rethrow;
      await _clearScheduledNotificationsCache();
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }
  }

  Future<void> _scheduleInexactAllowWhileIdle({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required NotificationDetails details,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> scheduleTodoReminderSafely({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _todoReminderChannelId,
      _todoReminderChannelName,
      channelDescription: _todoReminderChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF7FA99B),
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.reminder,
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

    try {
      await _scheduleWithCacheRepair(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        details: details,
        payload: payload,
      );
    } on PlatformException catch (e, stackTrace) {
      final message = '${e.code} ${e.message} ${e.details}';
      if (!message.contains('exact_alarms_not_permitted')) rethrow;
      debugPrint(
        'Exact todo reminder denied; falling back to inexact reminder: $message',
      );
      debugPrintStack(stackTrace: stackTrace);
      await _scheduleInexactAllowWhileIdle(
        id: id,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
        details: details,
        payload: payload,
      );
    }
  }

  bool _isBrokenScheduledNotificationCache(PlatformException e) {
    final message = '${e.message} ${e.details}';
    return message.contains('Missing type parameter');
  }

  Future<void> _clearScheduledNotificationsCache() async {
    try {
      await _notificationCacheChannel.invokeMethod<bool>(
        'clearScheduledNotificationsCache',
      );
    } catch (_) {
      // The app can still save the todo even if old native cache cleanup fails.
    }
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
enum PushFrequency { daily, twiceDaily, custom }

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
