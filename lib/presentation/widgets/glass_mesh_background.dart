import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// 纯米色背景。
class GlassMeshBackground extends StatelessWidget {
  final Widget child;

  const GlassMeshBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: child,
    );
  }
}
