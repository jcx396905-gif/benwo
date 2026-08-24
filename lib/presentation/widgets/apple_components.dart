import 'package:flutter/material.dart';

/// iOS 设置页风格组件（HIG: inset grouped list）。
class AppleSection extends StatelessWidget {
  const AppleSection({
    required this.title,
    required this.children,
    this.footer,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 7),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.secondary,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Material(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 56),
                  children[i],
                ],
              ],
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 7),
              child: Text(
                footer!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AppleRow extends StatelessWidget {
  const AppleRow({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.value,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: icon == null
          ? null
          : Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: (iconColor ?? theme.colorScheme.primary).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor ?? theme.colorScheme.primary),
            ),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: subtitle == null ? null : Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
      trailing: trailing ??
          (value != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(value!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right_rounded, color: theme.colorScheme.outline.withValues(alpha: 0.6), size: 22),
                  ],
                )
              : (onTap != null
                  ? Icon(Icons.chevron_right_rounded, color: theme.colorScheme.outline.withValues(alpha: 0.6), size: 22)
                  : null)),
      onTap: onTap,
    );
  }
}
