import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/auth/auth_notifier.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/notification_service.dart';

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
  String _pushFrequency = 'daily';
  bool _notificationsInitialized = false;

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
    if (!mounted) return;
    setState(() {
      _pushEnabled = prefs.getBool(_pushEnabledKey) ?? true;
      _pushFrequency = prefs.getString(_pushFrequencyKey) ?? 'daily';
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

  Future<void> _savePushFrequency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pushFrequencyKey, value);
    if (!mounted) return;
    setState(() => _pushFrequency = value);
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
          _buildNotificationsSection(context),
          _buildProfileSection(context),
          _buildAccountSection(context),
          _buildAboutSection(context),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return _buildSection(
      context,
      title: '通知设置',
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('推送通知'),
            subtitle: Text(
              _notificationsInitialized ? '接收任务提醒和激励推送' : '通知权限未开启或初始化失败',
            ),
            value: _pushEnabled,
            onChanged: _notificationsInitialized ? _savePushEnabled : null,
            activeThumbColor: AppColors.primary,
          ),
          if (_pushEnabled) ...[
            const Divider(height: 1),
            ListTile(
              title: const Text('推送频率'),
              subtitle: Text(_getFrequencyText(_pushFrequency)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _showFrequencyPicker,
            ),
            const Divider(height: 1),
            ListTile(
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

  Widget _buildProfileSection(BuildContext context) {
    return _buildSection(
      context,
      title: '用户画像',
      child: ListTile(
        leading: _iconBox(Icons.person_rounded, AppColors.primary),
        title: const Text('查看和编辑画像'),
        subtitle: const Text('MBTI、沟通偏好、最佳工作时间等'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push('/profile'),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSection(
      context,
      title: '账号',
      child: Column(
        children: [
          ListTile(
            leading: _iconBox(
              Icons.lock_outline_rounded,
              AppColors.textSecondary,
            ),
            title: const Text('修改密码'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showChangePasswordDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: _iconBox(Icons.logout_rounded, AppColors.error),
            title: Text('退出登录', style: TextStyle(color: AppColors.error)),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      context,
      title: '关于',
      child: Column(
        children: [
          ListTile(
            leading: _iconBox(
              Icons.info_outline_rounded,
              AppColors.textSecondary,
            ),
            title: const Text('版本'),
            trailing: Text(
              '1.0.0',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: _iconBox(
              Icons.person_pin_rounded,
              AppColors.textSecondary,
            ),
            title: const Text('作者'),
            trailing: Text(
              'JCX',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: _iconBox(Icons.auto_awesome_rounded, AppColors.primary),
            title: const Text('AI 服务'),
            subtitle: const Text('DeepSeek API'),
            trailing: Text(
              ApiConstants.deepseekModel,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            onTap: _showApiInfoDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: _iconBox(
              Icons.info_outline_rounded,
              AppColors.textSecondary,
            ),
            title: const Text('关于 BenWo'),
            subtitle: const Text('应用信息、作者与 AI 配置'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showAboutDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: _iconBox(
              Icons.description_outlined,
              AppColors.textSecondary,
            ),
            title: const Text('用户协议'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showUserAgreement,
          ),
          const Divider(height: 1),
          ListTile(
            leading: _iconBox(
              Icons.privacy_tip_outlined,
              AppColors.textSecondary,
            ),
            title: const Text('隐私政策'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showPrivacyPolicy,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: child,
        ),
      ],
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
            child: Text('退出', style: TextStyle(color: AppColors.error)),
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
          '版本：1.0.0\n'
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
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '首页'),
        BottomNavigationBarItem(icon: Icon(Icons.flag_rounded), label: '目标'),
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
