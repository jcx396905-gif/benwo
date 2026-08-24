import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/profile/profile_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/profile_preferences_form.dart';
import '../../widgets/smartisan_components.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? _communicationStyle;
  String? _bestWorkTime;
  String? _taskPace;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadProfile);
  }

  Future<void> _loadProfile() async {
    await ref.read(profileNotifierProvider.notifier).loadProfile();
    if (!mounted) return;
    final profile = ref.read(profileNotifierProvider).profile;
    setState(() {
      _communicationStyle = profile?.communicationStyle;
      _bestWorkTime = profile?.bestWorkTime;
      _taskPace = profile?.taskPace;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(title: const Text('AI 个性化')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Text(
                  '只保留真正影响任务拆解的偏好。所有字段都可选，选中项再次点击即可清空。',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: palette.mutedInk),
                ),
                const SizedBox(height: 22),
                if (!_loaded)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  ProfilePreferencesForm(
                    communicationStyle: _communicationStyle,
                    bestWorkTime: _bestWorkTime,
                    taskPace: _taskPace,
                    onCommunicationStyleChanged: (value) =>
                        setState(() => _communicationStyle = value),
                    onBestWorkTimeChanged: (value) =>
                        setState(() => _bestWorkTime = value),
                    onTaskPaceChanged: (value) =>
                        setState(() => _taskPace = value),
                  ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                SmartisanCapsuleButton(
                  label: state.isLoading ? '正在保存…' : '保存偏好',
                  icon: Icons.check_rounded,
                  expanded: true,
                  onPressed: state.isLoading || !_loaded
                      ? null
                      : () async {
                          final saved = await ref
                              .read(profileNotifierProvider.notifier)
                              .savePreferences(
                                communicationStyle: _communicationStyle,
                                bestWorkTime: _bestWorkTime,
                                taskPace: _taskPace,
                              );
                          if (!context.mounted || !saved) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('个性化偏好已保存')),
                          );
                        },
                ),
                const SizedBox(height: 10),
                SmartisanCapsuleButton(
                  label: '清空全部偏好',
                  secondary: true,
                  expanded: true,
                  onPressed: state.isLoading || !_loaded
                      ? null
                      : _clearPreferences,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _clearPreferences() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空个性化偏好？'),
        content: const Text('之后 AI 拆解不会附加任何画像信息。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final cleared = await ref
        .read(profileNotifierProvider.notifier)
        .clearPreferences();
    if (!mounted || !cleared) return;
    setState(() {
      _communicationStyle = null;
      _bestWorkTime = null;
      _taskPace = null;
    });
  }
}
