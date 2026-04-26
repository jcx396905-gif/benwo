import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../application/auth/auth_notifier.dart';
import '../../../core/utils/notification_service.dart';

/// Settings Page - Task 26
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _pushEnabled = true;
  String _pushFrequency = 'daily';
  final NotificationService _notificationService = NotificationService();
  bool _notificationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await _notificationService.initialize();
    final hasPermission = await _notificationService.requestPermissions();
    if (mounted) {
      setState(() {
        _notificationsInitialized = hasPermission;
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushEnabled = prefs.getBool('push_enabled') ?? true;
      _pushFrequency = prefs.getString('push_frequency') ?? 'daily';
    });
  }

  Future<void> _savePushEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_enabled', value);
    setState(() {
      _pushEnabled = value;
    });

    if (!value) {
      await _notificationService.cancelAllNotifications();
    }
  }

  Future<void> _savePushFrequency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('push_frequency', value);
    setState(() {
      _pushFrequency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('设置'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Push notifications section
          _buildSectionHeader(context, '通知设置'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('推送通知'),
                  subtitle: Text(
                    _notificationsInitialized
                        ? '接收任务提醒和激励推送'
                        : '点击开启通知权限',
                  ),
                  value: _pushEnabled,
                  onChanged: _notificationsInitialized
                      ? (value) => _savePushEnabled(value)
                      : null,
                  activeColor: AppColors.primary,
                ),
                if (_dividerVisible(_pushEnabled)) const Divider(height: 1),
                if (_pushEnabled) ...[
                  ListTile(
                    title: const Text('推送频率'),
                    subtitle: Text(_getFrequencyText(_pushFrequency)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showFrequencyPicker(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('免打扰时段'),
                    subtitle: const Text('设置静音时间段'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showQuietHoursDialog(),
                  ),
                ],
              ],
            ),
          ),

          // User profile section
          _buildSectionHeader(context, '用户画像'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.primary),
              ),
              title: const Text('查看和编辑画像'),
              subtitle: const Text('MBTI、沟通偏好，最佳工作时间等'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/profile'),
            ),
          ),

          // Account section
          _buildSectionHeader(context, '账号'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
                  ),
                  title: const Text('修改密码'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showChangePasswordDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                    ),
                  ),
                  title: Text(
                    '退出登录',
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),

          // About section
          _buildSectionHeader(context, '关于'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.info_outline_rounded, color: AppColors.textSecondary),
                  ),
                  title: const Text('版本'),
                  trailing: Text(
                    '1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.description_outlined, color: AppColors.textSecondary),
                  ),
                  title: const Text('用户协议'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showUserAgreement(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.privacy_tip_outlined, color: AppColors.textSecondary),
                  ),
                  title: const Text('隐私政策'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showPrivacyPolicy(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }

  bool _dividerVisible(bool pushEnabled) {
    return pushEnabled;
  }

  String _getFrequencyText(String frequency) {
    switch (frequency) {
      case 'daily':
        return '每天';
      case 'twice':
        return '每天两次';
      case 'morning':
        return '仅早上';
      case 'evening':
        return '仅晚上';
      default:
        return '每天';
    }
  }

  void _showFrequencyPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textHint.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text('推送频率', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...['daily', 'twice', 'morning', 'evening'].map((freq) => ListTile(
                  title: Text(_getFrequencyText(freq)),
                  trailing: freq == _pushFrequency
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    _savePushFrequency(freq);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showQuietHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('免打扰时段'),
        content: const Text('免打扰时段功能开发中...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('好的'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改密码'),
        content: const Text('密码修改功能开发中...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('好的'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Text(
              '退出',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserAgreement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('用户协议'),
        content: const SingleChildScrollView(
          child: Text(
            'BenWo 用户协议\n\n'
            '欢迎使用 BenWo 应用...\n\n'
            '（协议内容开发中）',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('隐私政策'),
        content: const SingleChildScrollView(
          child: Text(
            'BenWo 隐私政策\n\n'
            '我们非常重视您的隐私...\n\n'
            '（政策内容开发中）',
          ),
        ),
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
    return BottomNavigationBar(
      currentIndex: 3,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/goals');
            break;
          case 2:
            context.go('/calendar');
            break;
          case 3:
            break; // Already on settings
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag_rounded),
          label: '目标',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_rounded),
          label: '日历',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: '设置',
        ),
      ],
    );
  }
}
