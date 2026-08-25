import 'package:flutter/material.dart';

/// iOS 26 风格 mesh 渐变背景: 让 Liquid Glass 卡片有内容可折射/模糊。
class GlassMeshBackground extends StatelessWidget {
  final Widget child;

  const GlassMeshBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8DCC8),
            Color(0xFFF2E6D8),
            Color(0xFFE5D9CF),
            Color(0xFFEDDFC9),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -60,
            right: -40,
            child: _Blob(size: 380, color: const Color(0xFFD9A441), alpha: 0.45),
          ),
          const Positioned(
            top: 300,
            left: -120,
            child: _Blob(size: 420, color: const Color(0xFFC96F4A), alpha: 0.38),
          ),
          const Positioned(
            bottom: -80,
            right: -80,
            child: _Blob(size: 400, color: const Color(0xFF8B7E9D), alpha: 0.32),
          ),
          const Positioned(
            bottom: 180,
            left: 60,
            child: _Blob(size: 260, color: const Color(0xFFC5A66B), alpha: 0.35),
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
  final double alpha;

  const _Blob({required this.size, required this.color, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
