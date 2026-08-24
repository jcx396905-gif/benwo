import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SmartisanGroup extends StatelessWidget {
  const SmartisanGroup({
    required this.children,
    super.key,
    this.title,
    this.footer,
  });

  final String? title;
  final String? footer;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: palette.mutedInk,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.ceramic,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.hairline),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Column(
              children: [
                for (var index = 0; index < children.length; index++) ...[
                  children[index],
                  if (index != children.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: Divider(color: palette.hairline),
                    ),
                ],
              ],
            ),
          ),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Text(
              footer!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: palette.hintInk),
            ),
          ),
      ],
    );
  }
}

class SmartisanRow extends StatelessWidget {
  const SmartisanRow({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStatePropertyAll(
          palette.gold.withValues(alpha: 0.08),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                if (leading != null) ...[
                  SizedBox(width: 28, child: Center(child: leading)),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.bodyLarge),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: palette.mutedInk),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 12), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SmartisanCapsuleButton extends StatefulWidget {
  const SmartisanCapsuleButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.secondary = false,
    this.expanded = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool secondary;
  final bool expanded;

  @override
  State<SmartisanCapsuleButton> createState() => _SmartisanCapsuleButtonState();
}

class _SmartisanCapsuleButtonState extends State<SmartisanCapsuleButton> {
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final enabled = widget.onPressed != null;
    final foreground = widget.secondary
        ? palette.ink
        : Theme.of(context).colorScheme.onPrimary;
    final background = widget.secondary ? palette.ceramic : palette.gold;
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        canRequestFocus: enabled,
        borderRadius: BorderRadius.circular(13),
        onTap: widget.onPressed,
        onFocusChange: (focused) => setState(() => _focused = focused),
        onHighlightChanged: enabled
            ? (pressed) => setState(() => _pressed = pressed)
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
          constraints: const BoxConstraints(minWidth: 44, minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: !enabled
                ? palette.ceramicRaised
                : (_pressed
                      ? Color.lerp(background, palette.ink, 0.08)!
                      : background),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: _focused
                  ? palette.gold
                  : (widget.secondary ? palette.hairline : palette.goldPressed),
              width: _focused ? 2 : 1,
            ),
            boxShadow: _pressed
                ? null
                : [
                    BoxShadow(
                      color: palette.shadow,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 18,
                  color: enabled ? foreground : palette.hintInk,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: enabled ? foreground : palette.hintInk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      child: widget.expanded
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }
}

class SmartisanMechanicalSwitch extends StatelessWidget {
  const SmartisanMechanicalSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      width: 52,
      height: 44,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: palette.gold,
          activeThumbColor: Theme.of(context).colorScheme.onPrimary,
          inactiveTrackColor: palette.ceramicRaised,
          inactiveThumbColor: palette.mutedInk,
          trackOutlineColor: WidgetStatePropertyAll(palette.hairline),
        ),
      ),
    );
  }
}

class SmartisanGlassBottomNavigationBar extends StatelessWidget {
  const SmartisanGlassBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
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
              icon: Icon(Icons.timer_rounded),
              label: '专注',
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
        ),
      ),
    );
  }
}
