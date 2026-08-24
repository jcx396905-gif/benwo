import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../core/theme/app_colors.dart';

/// BenWo 液态玻璃适配层。
/// 直接复用 liquid_glass_widgets 原生组件；这里只保留少量页面别名，
/// 方便旧代码迁移，不新增自定义玻璃实现。
export 'package:liquid_glass_widgets/liquid_glass_widgets.dart'
    show
        GlassCard,
        GlassButton,
        GlassIconButton,
        GlassSwitch,
        GlassTextField,
        GlassScaffold,
        GlassAppBar,
        GlassTabBar,
        GlassSegment;

/// 页面背景容器：纯宣纸底色，无渐变。
class LiquidGlassBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const LiquidGlassBackground({
    required this.child,
    super.key,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Padding(padding: padding, child: child),
    );
  }
}

/// 面板别名 → 原生 [GlassCard]。
class LiquidGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const LiquidGlassPanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final card = GlassCard(padding: padding, child: child);
    if (borderRadius == null) return card;
    return ClipRRect(borderRadius: borderRadius!, child: card);
  }
}

/// 图标按钮别名 → 原生 [GlassIconButton]。
class LiquidGlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;

  const LiquidGlassIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return GlassIconButton(icon: Icon(icon), onPressed: onPressed);
  }
}

/// 大图标（登录/注册页头部装饰）。
class LiquidGlassIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const LiquidGlassIcon({required this.icon, super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: AppColors.primary, size: size);
  }
}

/// 玻璃胶囊标签。
class LiquidGlassChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const LiquidGlassChip({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x66FFFBF3),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xBFFFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
