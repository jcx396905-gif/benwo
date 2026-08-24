import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/onboarding/onboarding_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/profile_preferences_form.dart';
import '../../widgets/smartisan_components.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.ceramic,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: palette.hairline),
                    boxShadow: [
                      BoxShadow(
                        color: palette.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.auto_awesome_rounded, color: palette.gold),
                ),
                const SizedBox(height: 20),
                Text(
                  '让本我更懂你的节奏',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  '三项偏好都可以不选，只用于优化 AI 任务拆解。你也可以直接跳过，稍后在设置中填写。',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: palette.mutedInk),
                ),
                const SizedBox(height: 28),
                ProfilePreferencesForm(
                  communicationStyle: state.communicationStyle,
                  bestWorkTime: state.bestWorkTime,
                  taskPace: state.taskPace,
                  onCommunicationStyleChanged:
                      controller.updateCommunicationStyle,
                  onBestWorkTimeChanged: controller.updateBestWorkTime,
                  onTaskPaceChanged: controller.updateTaskPace,
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                SmartisanCapsuleButton(
                  label: state.isLoading ? '正在保存…' : '保存并开始',
                  icon: Icons.arrow_forward_rounded,
                  expanded: true,
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          final saved = await controller.saveProfileAndFinish();
                          if (saved && context.mounted) context.go('/home');
                        },
                ),
                const SizedBox(height: 10),
                SmartisanCapsuleButton(
                  label: '暂时跳过',
                  secondary: true,
                  expanded: true,
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          final skipped = await controller.skip();
                          if (skipped && context.mounted) context.go('/home');
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
