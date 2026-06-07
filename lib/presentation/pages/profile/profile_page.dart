import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../application/auth/auth_notifier.dart';
import '../../../application/profile/profile_notifier.dart';
import '../../../data/models/user_profile_model.dart';

/// Profile Page - Multi-dimensional User Profile
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(authNotifierProvider).userId;
      if (userId != null) {
        ref.read(profileNotifierProvider.notifier).loadProfile(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('用户画像'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/settings'),
        ),
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Info Card
                  _buildBasicInfoCard(profileState),
                  const SizedBox(height: 16),

                  // Personality Section
                  _buildSectionTitle('性格与偏好'),
                  _buildMbtiCard(profileState),
                  const SizedBox(height: 8),
                  _buildCommunicationCard(profileState),
                  const SizedBox(height: 16),

                  // Work Style Section
                  _buildSectionTitle('工作风格'),
                  _buildMotivationCard(profileState),
                  const SizedBox(height: 8),
                  _buildWorkTimeCard(profileState),
                  const SizedBox(height: 16),

                  // Social Section
                  _buildSectionTitle('社交与压力'),
                  _buildStressCard(profileState),
                  const SizedBox(height: 8),
                  _buildSocialCard(profileState),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildBasicInfoCard(ProfileState state) {
    final profile = state.profile;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.name ?? '未设置',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getBasicInfoText(profile),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildBasicInfoChip(Icons.cake_rounded, profile?.age != null ? '${profile!.age}岁' : '未设置'),
                const SizedBox(width: 8),
                _buildBasicInfoChip(Icons.work_rounded, profile?.occupation ?? '未设置'),
                const SizedBox(width: 8),
                _buildBasicInfoChip(Icons.location_on_rounded, profile?.region ?? '未设置'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getBasicInfoText(UserProfileModel? profile) {
    final parts = <String>[];
    if (profile?.age != null) parts.add('${profile!.age}岁');
    if (profile?.occupation != null) parts.add(profile!.occupation!);
    if (profile?.region != null) parts.add(profile!.region!);
    return parts.isEmpty ? '点击编辑基本信息' : parts.join(' · ');
  }

  Widget _buildBasicInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMbtiCard(ProfileState state) {
    final profile = state.profile;
    return _buildSelectionCard(
      icon: Icons.psychology_rounded,
      iconColor: AppColors.secondary,
      title: 'MBTI 类型',
      subtitle: profile?.mbti ?? '点击选择',
      onTap: () => _showMbtiPicker(),
    );
  }

  Widget _buildCommunicationCard(ProfileState state) {
    final profile = state.profile;
    return _buildSelectionCard(
      icon: Icons.chat_bubble_outline_rounded,
      iconColor: AppColors.primary,
      title: '沟通偏好',
      subtitle: profile?.communicationStyle ?? '点击选择',
      onTap: () => _showCommunicationPicker(),
    );
  }

  Widget _buildMotivationCard(ProfileState state) {
    final profile = state.profile;
    return _buildSelectionCard(
      icon: Icons.trending_up_rounded,
      iconColor: AppColors.sage,
      title: '激励敏感度',
      subtitle: profile?.motivationSensitivity ?? '点击选择',
      onTap: () => _showMotivationPicker(),
    );
  }

  Widget _buildWorkTimeCard(ProfileState state) {
    final profile = state.profile;
    return _buildSelectionCard(
      icon: Icons.schedule_rounded,
      iconColor: AppColors.lavender,
      title: '最佳工作时间',
      subtitle: profile?.bestWorkTime ?? '点击选择',
      onTap: () => _showWorkTimePicker(),
    );
  }

  Widget _buildStressCard(ProfileState state) {
    final profile = state.profile;
    return _buildSelectionCard(
      icon: Icons.bolt_rounded,
      iconColor: AppColors.dustyRose,
      title: '压力反应',
      subtitle: profile?.stressResponse ?? '点击选择',
      onTap: () => _showStressPicker(),
    );
  }

  Widget _buildSocialCard(ProfileState state) {
    final profile = state.profile;
    return _buildSelectionCard(
      icon: Icons.people_outline_rounded,
      iconColor: AppColors.beige,
      title: '社交偏好',
      subtitle: profile?.socialPreference ?? '点击选择',
      onTap: () => _showSocialPicker(),
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subtitle == '点击选择' ? AppColors.textHint : AppColors.textSecondary),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }

  void _showMbtiPicker() {
    final userId = ref.read(authNotifierProvider).userId;
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => _MbtiPickerSheet(
        currentValue: ref.read(profileNotifierProvider).profile?.mbti,
        onSelected: (value) {
          ref.read(profileNotifierProvider.notifier).updateMbti(userId, value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCommunicationPicker() {
    final userId = ref.read(authNotifierProvider).userId;
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => _OptionPickerSheet(
        title: '沟通偏好',
        options: communicationStyles,
        currentValue: ref.read(profileNotifierProvider).profile?.communicationStyle,
        onSelected: (value) {
          ref.read(profileNotifierProvider.notifier).updateCommunicationStyle(userId, value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showMotivationPicker() {
    final userId = ref.read(authNotifierProvider).userId;
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => _OptionPickerSheet(
        title: '激励敏感度',
        options: motivationSensitivityLevels,
        currentValue: ref.read(profileNotifierProvider).profile?.motivationSensitivity,
        onSelected: (value) {
          ref.read(profileNotifierProvider.notifier).updateMotivationSensitivity(userId, value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showWorkTimePicker() {
    final userId = ref.read(authNotifierProvider).userId;
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => _OptionPickerSheet(
        title: '最佳工作时间',
        options: bestWorkTimeOptions,
        currentValue: ref.read(profileNotifierProvider).profile?.bestWorkTime,
        onSelected: (value) {
          ref.read(profileNotifierProvider.notifier).updateBestWorkTime(userId, value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showStressPicker() {
    final userId = ref.read(authNotifierProvider).userId;
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => _OptionPickerSheet(
        title: '压力反应',
        options: stressResponseOptions,
        currentValue: ref.read(profileNotifierProvider).profile?.stressResponse,
        onSelected: (value) {
          ref.read(profileNotifierProvider.notifier).updateStressResponse(userId, value);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSocialPicker() {
    final userId = ref.read(authNotifierProvider).userId;
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => _OptionPickerSheet(
        title: '社交偏好',
        options: socialPreferenceOptions,
        currentValue: ref.read(profileNotifierProvider).profile?.socialPreference,
        onSelected: (value) {
          ref.read(profileNotifierProvider.notifier).updateSocialPreference(userId, value);
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// MBTI Picker Sheet
class _MbtiPickerSheet extends StatelessWidget {
  final String? currentValue;
  final ValueChanged<String> onSelected;

  const _MbtiPickerSheet({this.currentValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textHint.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('选择 MBTI 类型', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'MBTI 可以帮助我们更好地了解你的性格特点',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: mbtiTypes.length,
              itemBuilder: (context, index) {
                final type = mbtiTypes[index];
                final isSelected = type == currentValue;
                return InkWell(
                  onTap: () => onSelected(type),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Option Picker Sheet
class _OptionPickerSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? currentValue;
  final ValueChanged<String> onSelected;

  const _OptionPickerSheet({
    required this.title,
    required this.options,
    this.currentValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textHint.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...options.map((option) => ListTile(
                title: Text(option),
                trailing: option == currentValue
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => onSelected(option),
              )),
        ],
      ),
    );
  }
}
