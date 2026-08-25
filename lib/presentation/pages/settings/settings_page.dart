import 'package:flutter/material.dart';
import '../../widgets/glass_mesh_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/theme/theme_controller.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/notification_service.dart';
import '../../../core/utils/todo_reminder_scheduler.dart';
import '../../widgets/apple_components.dart';
import '../../widgets/liquid_glass.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  static const _pushEnabledKey = 'push_enabled';
  static const _pushFrequencyKey = 'push_frequency';

  final NotificationService _notifications = NotificationService();
  bool _pushEnabled = true;
  bool _dueRemindersEnabled = true;
  String _pushFrequency = 'daily';
  bool _notificationsAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notifications.initialize();
      final available = await _notifications.requestPermissions();
      if (mounted) setState(() => _notificationsAvailable = available);
    } catch (_) {
      if (mounted) setState(() => _notificationsAvailable = false);
    }
  }

  Future<void> _loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _pushEnabled = preferences.getBool(_pushEnabledKey) ?? true;
      _dueRemindersEnabled =
          preferences.getBool(TodoReminderScheduler.reminderEnabledKey) ?? true;
      _pushFrequency = preferences.getString(_pushFrequencyKey) ?? 'daily';
    });
  }

  Future<void> _setPushEnabled(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_pushEnabledKey, value);
    if (!value) await _notifications.cancelAllNotifications();
    if (mounted) setState(() => _pushEnabled = value);
  }

  Future<void> _setDueReminders(bool value) async {
    await TodoReminderScheduler.setEnabled(value);
    if (mounted) setState(() => _dueRemindersEnabled = value);
  }

  Future<void> _setFrequency(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_pushFrequencyKey, value);
    if (mounted) setState(() => _pushFrequency = value);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.transparent,
      ),
      body: GlassMeshBackground(
        child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          AppleSection(
            title: '外观',
            footer: '默认跟随系统，切换后立即生效。',
            children: [
              AppleRow(
                title: '主题',
                value: _themeModeLabel(themeMode),
                icon: Icons.contrast_rounded,
                iconColor: colorScheme.primary,
                onTap: _showThemePicker,
              ),
            ],
          ),
          AppleSection(
            title: 'AI 个性化',
            footer: '三项偏好仅随 AI 目标拆解发送；番茄 AI 只发送当次计划描述。',
            children: [
              AppleRow(
                title: '沟通、时间与任务节奏',
                subtitle: '随时编辑或全部清空',
                icon: Icons.auto_awesome_rounded,
                iconColor: colorScheme.primary,
                onTap: () => context.push('/profile'),
              ),
            ],
          ),
          AppleSection(
            title: '通知',
            children: [
              AppleRow(
                title: '推送通知',
                subtitle: _notificationsAvailable ? '接收任务提醒' : '系统通知权限尚未开启',
                icon: Icons.notifications_none_rounded,
                iconColor: colorScheme.tertiary,
                trailing: Switch.adaptive(
                  value: _pushEnabled,
                  onChanged: _notificationsAvailable ? _setPushEnabled : null,
                ),
              ),
              AppleRow(
                title: '到点提醒',
                subtitle: '为设有精确时间的待办安排提醒',
                icon: Icons.alarm_rounded,
                iconColor: colorScheme.tertiary,
                trailing: Switch.adaptive(
                  value: _dueRemindersEnabled,
                  onChanged: _setDueReminders,
                ),
              ),
              AppleRow(
                title: '推送频率',
                value: _frequencyLabel(_pushFrequency),
                icon: Icons.schedule_send_rounded,
                iconColor: colorScheme.tertiary,
                onTap: _showFrequencyPicker,
              ),
            ],
          ),
          AppleSection(
            title: '关于',
            children: [
              AppleRow(
                title: '本我',
                subtitle: '版本 ${AppConstants.appVersion} · 单用户本地模式',
                icon: Icons.psychology_alt_rounded,
                iconColor: colorScheme.primary,
                onTap: _showAbout,
              ),
              AppleRow(
                title: 'AI 服务说明',
                value: ApiConstants.deepseekModel,
                icon: Icons.hub_outlined,
                onTap: _showAiService,
              ),
              AppleRow(
                title: '用户协议',
                icon: Icons.description_outlined,
                onTap: _showAgreement,
              ),
              AppleRow(
                title: '隐私政策',
                icon: Icons.privacy_tip_outlined,
                onTap: _showPrivacy,
              ),
            ],
          ),
        ],
      ),
      ),
      bottomNavigationBar: GlassTabBar.bottom(
        selectedIndex: 4,
        showIndicator: false,
        glowOpacity: 0,
        onTabSelected: (index) {
          const routes = [
            '/home',
            '/goals',
            '/focus',
            '/calendar',
            '/settings',
          ];
          if (index != 4) context.go(routes[index]);
        },
        tabs: [
          const GlassTab(icon: Icon(Icons.home_rounded), label: '首页'),
          const GlassTab(icon: Icon(Icons.flag_rounded), label: '目标'),
          const GlassTab(icon: Icon(Icons.timer_rounded), label: '专注'),
          const GlassTab(icon: Icon(Icons.calendar_month_rounded), label: '日历'),
          const GlassTab(icon: Icon(Icons.settings_rounded), label: '设置'),
        ],
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => '跟随系统',
    ThemeMode.light => '亮色',
    ThemeMode.dark => '暗色',
  };

  String _frequencyLabel(String value) => switch (value) {
    'twice' => '每天两次',
    'morning' => '仅早上',
    'evening' => '仅晚上',
    _ => '每天一次',
  };

  void _showThemePicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: AppleSection(
            title: '选择主题',
            children: ThemeMode.values.map((mode) {
              final selected = ref.read(themeControllerProvider) == mode;
              return AppleRow(
                title: _themeModeLabel(mode),
                trailing: selected ? const Icon(Icons.check_rounded) : null,
                onTap: () async {
                  await ref
                      .read(themeControllerProvider.notifier)
                      .setThemeMode(mode);
                  if (context.mounted) Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showFrequencyPicker() {
    const values = ['daily', 'twice', 'morning', 'evening'];
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: AppleSection(
            title: '推送频率',
            children: values
                .map(
                  (value) => AppleRow(
                    title: _frequencyLabel(value),
                    trailing: value == _pushFrequency
                        ? const Icon(Icons.check_rounded)
                        : null,
                    onTap: () async {
                      await _setFrequency(value);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showAbout() => _showText(
    '关于本我',
    '本我是一款无账户、单用户的本地目标与任务工具。目标、待办、画像和设置都存储在当前设备。卸载或清除应用数据会使记录丢失。',
  );

  void _showAiService() => _showText(
    'AI 服务说明',
    '目标拆解使用 DeepSeek ${ApiConstants.deepseekModel}。请求会包含目标文本，以及你已填写的沟通风格、最佳工作时间、任务节奏；未填写的偏好不会发送。番茄 AI 规划只发送当次输入的计划描述。请求失败时会回退到本地任务模板。',
  );

  void _showAgreement() => _showText(
    '用户协议',
    '本应用用于目标管理、任务安排与个人效率辅助。AI 拆解结果仅供参考，请根据真实情况决定是否采用。应用不提供账户或云端同步，请自行妥善管理本机数据。',
  );

  void _showPrivacy() => _showText(
    '隐私政策',
    '本应用不创建账户。目标、待办、画像、番茄记录和设置默认仅存储在本机。主动使用 AI 目标拆解时，目标文本与已填写的三项画像偏好会发送至 DeepSeek API；画像为空时不会附加画像内容。主动使用番茄 AI 规划时，只发送当次输入的计划描述。',
  );

  void _showText(String title, String body) {
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
}
