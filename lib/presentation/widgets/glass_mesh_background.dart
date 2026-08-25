import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// iOS 26 风格柔和渐变背景: 让 Liquid Glass 卡片有内容可折射/模糊。
/// 叠加 2-3 个大半径径向渐变色斑, 色调取自 app 大地色系, 保持低饱和不抢前景。
class GlassMeshBackground extends StatelessWidget {
  final Widget child;

  const GlassMeshBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: palette.canvas,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.canvas,
            palette.gold.withValues(alpha: 0.06),
            palette.canvas,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _Blob(
              size: 320,
              color: palette.gold.withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            top: 280,
            left: -100,
            child: _Blob(
              size: 360,
              color: palette.terracotta.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: _Blob(
              size: 300,
  color: AppColors.lavender.withValues(alpha: 0.10),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
