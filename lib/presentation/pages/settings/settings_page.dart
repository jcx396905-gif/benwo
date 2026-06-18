import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/notification_service.dart';
import '../../../core/utils/todo_reminder_scheduler.dart';
import '../../widgets/liquid_glass.dart';
import '../../widgets/main_bottom_nav_bar.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  static const _pushEnabledKey = 'push_enabled';
  static const _pushFrequencyKey = 'push_frequency';

  final NotificationService _notificationService = NotificationService();
  bool _pushEnabled = true;
  bool _dueRemindersEnabled = true;
  String _pushFrequency = 'daily';
  bool _notificationsInitialized = false;
  int _pomodoroFocusMinutes = 25;
  int _pomodoroShortBreakMinutes = 5;
  int _pomodoroLongBreakMinutes = 20;
  int _pomodoroLongBreakInterval = 4;
  bool _pomodoroAutoStartBreak = false;
  bool _pomodoroAutoStartNextFocus = false;
  bool _pomodoroSoundEnabled = true;
  bool _pomodoroVibrationEnabled = true;
  bool _pomodoroNotificationsEnabled = true;
  bool _pomodoroKeepScreenOn = false;
  bool _pomodoroAutoCompleteTodo = false;
  bool _pomodoroAiEstimateEnabled = false;
  bool _pomodoroWeeklyReviewEnabled = false;
  int _authorTapCount = 0;
  bool _showAuthorEgg = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    try {
      await _notificationService.initialize();
      final hasPermission = await _notificationService.requestPermissions();
      if (!mounted) return;
      setState(() => _notificationsInitialized = hasPermission);
    } catch (_) {
      if (!mounted) return;
      setState(() => _notificationsInitialized = false);
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = int.tryParse(prefs.getString(AppConstants.keyUserId) ?? '');
    final userSettings = userId == null
        ? null
        : await ref
              .read(userSettingsRepositoryProvider)
              .getSettingsByUserId(userId);
    if (!mounted) return;
    setState(() {
      _pushEnabled = prefs.getBool(_pushEnabledKey) ?? true;
      _dueRemindersEnabled =
          prefs.getBool(TodoReminderScheduler.reminderEnabledKey) ?? true;
      _pushFrequency = prefs.getString(_pushFrequencyKey) ?? 'daily';
      if (userSettings != null) {
        _pomodoroFocusMinutes = userSettings.pomodoroFocusMinutes;
        _pomodoroShortBreakMinutes = userSettings.pomodoroShortBreakMinutes;
        _pomodoroLongBreakMinutes = userSettings.pomodoroLongBreakMinutes;
        _pomodoroLongBreakInterval = userSettings.pomodoroLongBreakInterval;
        _pomodoroAutoStartBreak = userSettings.pomodoroAutoStartBreak;
        _pomodoroAutoStartNextFocus = userSettings.pomodoroAutoStartNextFocus;
        _pomodoroSoundEnabled = userSettings.pomodoroSoundEnabled;
        _pomodoroVibrationEnabled = userSettings.pomodoroVibrationEnabled;
        _pomodoroNotificationsEnabled =
            userSettings.pomodoroNotificationsEnabled;
        _pomodoroKeepScreenOn = userSettings.pomodoroKeepScreenOn;
        _pomodoroAutoCompleteTodo = userSettings.pomodoroAutoCompleteTodo;
        _pomodoroAiEstimateEnabled = userSettings.pomodoroAiEstimateEnabled;
        _pomodoroWeeklyReviewEnabled = userSettings.pomodoroWeeklyReviewEnabled;
      }
    });
  }

  Future<void> _savePushEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushEnabledKey, value);
    if (!mounted) return;
    setState(() => _pushEnabled = value);

    if (!value) {
      await _notificationService.cancelAllNotifications();
    }
  }

  Future<void> _saveDueRemindersEnabled(bool value) async {
    await TodoReminderScheduler.setEnabled(value);
    if (!mounted) return;
    setState(() => _dueRemindersEnabled = value);
  }

  Future<void> _savePushFrequency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pushFrequencyKey, value);
    if (!mounted) return;
    setState(() => _pushFrequency = value);
  }

  Future<void> _savePomodoroSettings({
    int? focusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? longBreakInterval,
    bool? autoStartBreak,
    bool? autoStartNextFocus,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    bool? keepScreenOn,
    bool? autoCompleteTodo,
    bool? aiEstimateEnabled,
    bool? weeklyReviewEnabled,
  }) async {
    final userId = ref.read(authNotifierProvider).userId;
    if (userId == null) return;
    final repo = ref.read(userSettingsRepositoryProvider);
    final settings = await repo.getSettingsByUserId(userId);
    if (settings == null) {
      await repo.createSettings(userId: userId);
    }
    await repo.updatePomodoroSettings(
      userId,
      focusMinutes: focusMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      longBreakInterval: longBreakInterval,
      autoStartBreak: autoStartBreak,
      autoStartNextFocus: autoStartNextFocus,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      notificationsEnabled: notificationsEnabled,
      keepScreenOn: keepScreenOn,
      autoCompleteTodo: autoCompleteTodo,
      aiEstimateEnabled: aiEstimateEnabled,
      weeklyReviewEnabled: weeklyReviewEnabled,
    );
    if (!mounted) return;
    setState(() {
      if (focusMinutes != null) {
        _pomodoroFocusMinutes = focusMinutes;
      }
      if (shortBreakMinutes != null) {
        _pomodoroShortBreakMinutes = shortBreakMinutes;
      }
      if (longBreakMinutes != null) {
        _pomodoroLongBreakMinutes = longBreakMinutes;
      }
      if (longBreakInterval != null) {
        _pomodoroLongBreakInterval = longBreakInterval;
      }
      if (autoStartBreak != null) {
        _pomodoroAutoStartBreak = autoStartBreak;
      }
      if (autoStartNextFocus != null) {
        _pomodoroAutoStartNextFocus = autoStartNextFocus;
      }
      if (soundEnabled != null) {
        _pomodoroSoundEnabled = soundEnabled;
      }
      if (vibrationEnabled != null) {
        _pomodoroVibrationEnabled = vibrationEnabled;
      }
      if (notificationsEnabled != null) {
        _pomodoroNotificationsEnabled = notificationsEnabled;
      }
      if (keepScreenOn != null) {
        _pomodoroKeepScreenOn = keepScreenOn;
      }
      if (autoCompleteTodo != null) {
        _pomodoroAutoCompleteTodo = autoCompleteTodo;
      }
      if (aiEstimateEnabled != null) {
        _pomodoroAiEstimateEnabled = aiEstimateEnabled;
      }
      if (weeklyReviewEnabled != null) {
        _pomodoroWeeklyReviewEnabled = weeklyReviewEnabled;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('设置')),
      body: LiquidGlassBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            _buildSettingsHeader(context),
            _buildAccountAndProfileSection(context),
            _buildPomodoroSection(context),
            _buildNotificationsSection(context),
            _buildAiAndDataSection(context),
            _buildAboutSection(context),
            _buildDangerSection(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildSettingsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: LiquidGlassPanel(
        padding: const EdgeInsets.all(22),
        borderRadius: BorderRadius.circular(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _iconBox(Icons.tune_rounded, AppColors.primaryDark),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '偏好与账户',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '本地优先运行，AI 功能按需启用。',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                const _StatusPill(
                  icon: Icons.verified_rounded,
                  label: '版本 ${AppConstants.appVersion}',
                ),
                _StatusPill(
                  icon: _notificationsInitialized
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_off_rounded,
                  label: _notificationsInitialized ? '通知可用' : '通知未授权',
                ),
                const _StatusPill(icon: Icons.storage_rounded, label: '数据在本地'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return _buildSection(
      context,
      title: '通知',
      subtitle: '系统通知、待办到点提醒和推送频率。',
      child: Column(
        children: [
          _settingsSwitchTile(
            icon: Icons.notifications_rounded,
            title: const Text('推送通知'),
            subtitle: Text(
              _notificationsInitialized ? '接收任务提醒和激励推送' : '通知权限未开启或初始化失败',
            ),
            value: _pushEnabled,
            onChanged: _notificationsInitialized ? _savePushEnabled : null,
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.alarm_rounded,
            title: const Text('到点提醒'),
            subtitle: const Text('待办设置精准时间后，到点自动提醒'),
            value: _dueRemindersEnabled,
            onChanged: _saveDueRemindersEnabled,
          ),
          if (_pushEnabled) ...[
            const Divider(height: 1),
            _settingsTile(
              icon: Icons.schedule_send_rounded,
              title: const Text('推送频率'),
              subtitle: Text(_getFrequencyText(_pushFrequency)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _showFrequencyPicker,
            ),
            const Divider(height: 1),
            _settingsTile(
              icon: Icons.do_not_disturb_on_rounded,
              title: const Text('免打扰时段'),
              subtitle: const Text('当前版本请在系统设置中管理通知'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _showQuietHoursDialog,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPomodoroSection(BuildContext context) {
    return _buildSection(
      context,
      title: '专注与番茄',
      subtitle: '所有倒计时和拆分规则仍在本地计算。',
      child: Column(
        children: [
          _numberSettingTile(
            icon: Icons.timer_rounded,
            title: '专注时长',
            value: _pomodoroFocusMinutes,
            unit: '分钟',
            min: 1,
            max: 180,
            onChanged: (value) => _savePomodoroSettings(focusMinutes: value),
          ),
          const Divider(height: 1),
          _numberSettingTile(
            icon: Icons.local_cafe_rounded,
            title: '短休息',
            value: _pomodoroShortBreakMinutes,
            unit: '分钟',
            min: 0,
            max: 60,
            onChanged: (value) =>
                _savePomodoroSettings(shortBreakMinutes: value),
          ),
          const Divider(height: 1),
          _numberSettingTile(
            icon: Icons.weekend_rounded,
            title: '长休息',
            value: _pomodoroLongBreakMinutes,
            unit: '分钟',
            min: 0,
            max: 120,
            onChanged: (value) =>
                _savePomodoroSettings(longBreakMinutes: value),
          ),
          const Divider(height: 1),
          _numberSettingTile(
            icon: Icons.repeat_rounded,
            title: '长休息间隔',
            value: _pomodoroLongBreakInterval,
            unit: '个番茄',
            min: 1,
            max: 12,
            onChanged: (value) =>
                _savePomodoroSettings(longBreakInterval: value),
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.coffee_rounded,
            title: const Text('自动开始休息'),
            subtitle: const Text('专注结束后自动进入休息阶段'),
            value: _pomodoroAutoStartBreak,
            onChanged: (value) => _savePomodoroSettings(autoStartBreak: value),
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.skip_next_rounded,
            title: const Text('自动开始下一轮'),
            subtitle: const Text('休息结束后自动开始下一个专注阶段'),
            value: _pomodoroAutoStartNextFocus,
            onChanged: (value) =>
                _savePomodoroSettings(autoStartNextFocus: value),
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.notifications_rounded,
            title: const Text('番茄通知'),
            subtitle: const Text('专注和休息阶段结束时提醒'),
            value: _pomodoroNotificationsEnabled,
            onChanged: (value) =>
                _savePomodoroSettings(notificationsEnabled: value),
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.volume_up_rounded,
            iconColor: AppColors.secondaryDark,
            title: const Text('声音提醒'),
            value: _pomodoroSoundEnabled,
            onChanged: (value) => _savePomodoroSettings(soundEnabled: value),
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.vibration_rounded,
            iconColor: AppColors.secondaryDark,
            title: const Text('振动提醒'),
            value: _pomodoroVibrationEnabled,
            onChanged: (value) =>
                _savePomodoroSettings(vibrationEnabled: value),
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.screen_lock_portrait_rounded,
            iconColor: AppColors.primaryDark,
            title: const Text('保持屏幕常亮'),
            value: _pomodoroKeepScreenOn,
            onChanged: (value) => _savePomodoroSettings(keepScreenOn: value),
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.task_alt_rounded,
            iconColor: AppColors.primaryDark,
            title: const Text('全部番茄完成后同步 Todo'),
            subtitle: const Text('当前任务所有专注阶段完成后，可手动确认同步'),
            value: _pomodoroAutoCompleteTodo,
            onChanged: (value) =>
                _savePomodoroSettings(autoCompleteTodo: value),
          ),
        ],
      ),
    );
  }

  Widget _numberSettingTile({
    required IconData icon,
    required String title,
    required int value,
    required String unit,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return _settingsTile(
      icon: icon,
      title: Text(title),
      subtitle: Text('当前：$value $unit'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value $unit',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
      onTap: () => _showNumberSettingDialog(
        title: title,
        value: value,
        unit: unit,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _showNumberSettingDialog({
    required String title,
    required int value,
    required String unit,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) async {
    final controller = TextEditingController(text: value.toString());
    final picked = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: unit,
            helperText: '范围：$min-$max',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text.trim());
              if (parsed == null || parsed < min || parsed > max) return;
              Navigator.pop(context, parsed);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (picked != null) onChanged(picked);
  }

  Widget _buildAccountAndProfileSection(BuildContext context) {
    return _buildSection(
      context,
      title: '账号与画像',
      subtitle: '管理登录状态和个性化偏好。',
      child: Column(
        children: [
          _settingsTile(
            icon: Icons.person_rounded,
            title: const Text('用户画像'),
            subtitle: const Text('MBTI、沟通偏好、最佳工作时间等'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/profile'),
          ),
          const Divider(height: 1),
          _settingsTile(
            icon: Icons.lock_outline_rounded,
            iconColor: AppColors.textSecondary,
            title: const Text('修改密码'),
            subtitle: const Text('当前版本暂不支持直接修改密码'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showChangePasswordDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildAiAndDataSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'AI 与数据',
      subtitle: 'AI 只处理需要理解和总结的内容，本地规则保持离线可用。',
      child: Column(
        children: [
          _settingsSwitchTile(
            icon: Icons.auto_awesome_rounded,
            iconColor: AppColors.primaryDark,
            title: const Text('AI 自动估算时间'),
            subtitle: const Text('AI 会以流式预览形式展示，确认后才保存'),
            value: _pomodoroAiEstimateEnabled,
            onChanged: (value) =>
                _savePomodoroSettings(aiEstimateEnabled: value),
          ),
          const Divider(height: 1),
          _settingsSwitchTile(
            icon: Icons.summarize_rounded,
            iconColor: AppColors.primaryDark,
            title: const Text('每周 AI 复盘'),
            subtitle: const Text('数据不足时仅显示基础统计'),
            value: _pomodoroWeeklyReviewEnabled,
            onChanged: (value) =>
                _savePomodoroSettings(weeklyReviewEnabled: value),
          ),
          const Divider(height: 1),
          _settingsTile(
            icon: Icons.auto_awesome_rounded,
            title: const Text('AI 服务'),
            subtitle: const Text('DeepSeek API'),
            trailing: Text(
              ApiConstants.deepseekModel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: _showApiInfoDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      context,
      title: '应用与关于',
      subtitle: '版本、作者、协议和隐私说明。',
      child: Column(
        children: [
          _settingsTile(
            iconWidget: _benwoIconBox(),
            title: const Text('版本'),
            trailing: Text(
              AppConstants.appVersion,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const Divider(height: 1),
          _settingsTile(
            icon: Icons.person_pin_rounded,
            iconColor: AppColors.textSecondary,
            title: const Text('作者'),
            subtitle: _showAuthorEgg
                ? const Text(
                    '感谢使用 BenWo',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
            trailing: Text(
              'JCX',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            onTap: _handleAuthorTap,
          ),
          const Divider(height: 1),
          _settingsTile(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.textSecondary,
            title: const Text('关于 BenWo'),
            subtitle: const Text('应用信息、作者与 AI 配置'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showAboutDialog,
          ),
          const Divider(height: 1),
          _settingsTile(
            icon: Icons.description_outlined,
            iconColor: AppColors.textSecondary,
            title: const Text('用户协议'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showUserAgreement,
          ),
          const Divider(height: 1),
          _settingsTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: AppColors.textSecondary,
            title: const Text('隐私政策'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showPrivacyPolicy,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerSection(BuildContext context) {
    return _buildSection(
      context,
      title: '危险操作',
      subtitle: '退出只会结束当前登录，不会删除本地计划。',
      child: _settingsTile(
        icon: Icons.logout_rounded,
        iconColor: AppColors.error,
        title: const Text(
          '退出登录',
          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w800),
        ),
        subtitle: const Text('回到登录页，保留本机数据'),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          LiquidGlassPanel(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(24),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required Widget title,
    IconData? icon,
    Widget? iconWidget,
    Color iconColor = AppColors.primaryDark,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      minVerticalPadding: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: iconWidget ?? _iconBox(icon!, iconColor),
      title: DefaultTextStyle.merge(
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        child: title,
      ),
      subtitle: subtitle == null
          ? null
          : DefaultTextStyle.merge(
              style: const TextStyle(color: AppColors.textSecondary),
              child: subtitle,
            ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _settingsSwitchTile({
    required IconData icon,
    required Widget title,
    required bool value,
    required ValueChanged<bool>? onChanged,
    Color iconColor = AppColors.primaryDark,
    Widget? subtitle,
  }) {
    return SwitchListTile(
      secondary: _iconBox(icon, iconColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: DefaultTextStyle.merge(
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        child: title,
      ),
      subtitle: subtitle == null
          ? null
          : DefaultTextStyle.merge(
              style: const TextStyle(color: AppColors.textSecondary),
              child: subtitle,
            ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
    );
  }

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _benwoIconBox() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00796B), Color(0xFF4285F4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 24),
          Positioned(
            right: 7,
            bottom: 7,
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFFFFD54F),
              size: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAuthorTap() {
    if (_showAuthorEgg) return;

    setState(() {
      _authorTapCount += 1;
      _showAuthorEgg = _authorTapCount >= 5;
    });

    if (_showAuthorEgg) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('感谢使用 BenWo')));
    }
  }

  String _getFrequencyText(String frequency) {
    switch (frequency) {
      case 'twice':
        return '每天两次';
      case 'morning':
        return '仅早上';
      case 'evening':
        return '仅晚上';
      case 'daily':
      default:
        return '每天一次';
    }
  }

  void _showFrequencyPicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('推送频率', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...['daily', 'twice', 'morning', 'evening'].map(
              (freq) => ListTile(
                title: Text(_getFrequencyText(freq)),
                trailing: freq == _pushFrequency
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  _savePushFrequency(freq);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuietHoursDialog() {
    _showTextDialog(
      title: '免打扰时段',
      body: '当前版本暂不支持在应用内设置免打扰时段，请在 Android 系统设置中管理通知。',
    );
  }

  void _showChangePasswordDialog() {
    _showTextDialog(title: '修改密码', body: '当前版本暂不支持直接修改密码。后续可以在账号模块补充密码修改流程。');
  }

  void _showLogoutDialog(BuildContext pageContext) {
    showDialog<void>(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出当前账号吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authNotifierProvider.notifier).logout();
              if (pageContext.mounted) {
                pageContext.go('/login');
              }
            },
            child: const Text('退出', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showApiInfoDialog() {
    _showTextDialog(
      title: 'AI 服务',
      body:
          '当前 AI 服务：DeepSeek API\n'
          '接口格式：OpenAI Chat Completions\n'
          'Base URL：https://api.deepseek.com\n'
          '模型：${ApiConstants.deepseekModel}\n\n'
          'AI 目标拆解会请求 JSON 输出。如果网络、额度或密钥异常，应用会自动回退到本地任务模板，避免页面卡死。',
    );
  }

  void _showAboutDialog() {
    _showTextDialog(
      title: '关于 BenWo',
      body:
          'BenWo - 本我\n\n'
          '作者：JCX\n'
          '版本：${AppConstants.appVersion}\n'
          'AI：DeepSeek ${ApiConstants.deepseekModel}\n\n'
          'BenWo 用于管理长期目标、今日任务、日历计划和个人画像。数据默认存储在本机，仅在使用 AI 目标拆解时发送必要目标文本到 DeepSeek API。',
    );
  }

  void _showUserAgreement() {
    _showTextDialog(
      title: '用户协议',
      body:
          'BenWo 用户协议\n\n'
          '欢迎使用 BenWo。本应用用于目标管理、每日任务安排、日历计划和个人画像整理。\n\n'
          '1. 请妥善保管账号和本机数据。\n'
          '2. AI 目标拆解仅作为辅助建议，最终计划请以你的真实情况为准。\n'
          '3. 应用优先使用本地存储，卸载应用或清除数据可能导致本地记录丢失。\n'
          '4. 作者：JCX。',
    );
  }

  void _showPrivacyPolicy() {
    _showTextDialog(
      title: '隐私政策',
      body:
          'BenWo 隐私政策\n\n'
          '我们重视你的隐私和数据安全。\n\n'
          '1. 账号、目标、任务、画像和设置数据默认存储在本地设备。\n'
          '2. 仅在使用 AI 目标拆解时，目标标题、描述和日期等必要文本会发送至 DeepSeek API。\n'
          '3. 应用不会主动收集你的数据用于商业用途。\n'
          '4. 如果 DeepSeek API 请求失败，应用会使用本地模板生成任务，避免影响主流程。',
    );
  }

  void _showTextDialog({required String title, required String body}) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return const MainBottomNavBar(currentIndex: 4);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.66),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primaryDark),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
