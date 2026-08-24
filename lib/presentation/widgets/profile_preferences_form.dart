import 'package:flutter/material.dart';

import '../../application/profile/profile_notifier.dart';
import '../../core/theme/app_colors.dart';
import 'smartisan_components.dart';

class ProfilePreferencesForm extends StatelessWidget {
  const ProfilePreferencesForm({
    required this.communicationStyle,
    required this.bestWorkTime,
    required this.taskPace,
    required this.onCommunicationStyleChanged,
    required this.onBestWorkTimeChanged,
    required this.onTaskPaceChanged,
    super.key,
  });

  final String? communicationStyle;
  final String? bestWorkTime;
  final String? taskPace;
  final ValueChanged<String?> onCommunicationStyleChanged;
  final ValueChanged<String?> onBestWorkTimeChanged;
  final ValueChanged<String?> onTaskPaceChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PreferenceGroup(
          title: '沟通风格',
          subtitle: 'AI 拆解任务时采用的表达方式',
          icon: Icons.chat_bubble_outline_rounded,
          values: communicationStyles,
          selected: communicationStyle,
          onChanged: onCommunicationStyleChanged,
        ),
        const SizedBox(height: 18),
        _PreferenceGroup(
          title: '最佳工作时间',
          subtitle: '帮助安排更合适的任务时段',
          icon: Icons.schedule_rounded,
          values: bestWorkTimeOptions,
          selected: bestWorkTime,
          onChanged: onBestWorkTimeChanged,
        ),
        const SizedBox(height: 18),
        _PreferenceGroup(
          title: '任务节奏',
          subtitle: '决定任务拆分的颗粒度与推进力度',
          icon: Icons.tune_rounded,
          values: taskPaceOptions,
          selected: taskPace,
          onChanged: onTaskPaceChanged,
        ),
      ],
    );
  }
}

class _PreferenceGroup extends StatelessWidget {
  const _PreferenceGroup({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> values;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SmartisanGroup(
      title: title,
      footer: subtitle,
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: palette.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: palette.gold, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: values.map((value) {
                    final isSelected = selected == value;
                    return Semantics(
                      selected: isSelected,
                      button: true,
                      child: ChoiceChip(
                        label: Text(value),
                        selected: isSelected,
                        showCheckmark: true,
                        checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                        selectedColor: palette.gold,
                        backgroundColor: palette.ceramicRaised,
                        side: BorderSide(
                          color: isSelected
                              ? palette.goldPressed
                              : palette.hairline,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : palette.ink,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => onChanged(isSelected ? null : value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
