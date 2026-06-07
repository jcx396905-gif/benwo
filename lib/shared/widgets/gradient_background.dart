import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Gradient Background Widget that follows theme colors
class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool showGradient;

  const GradientBackground({
    super.key,
    required this.child,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showGradient) {
      return Container(
        color: AppColors.background,
        child: child,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
          stops: [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}

/// Animated Gradient Background that pulses subtly
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  AppColors.gradientStart,
                  AppColors.gradientEnd,
                  _animation.value * 0.3,
                )!,
                Color.lerp(
                  AppColors.gradientEnd,
                  AppColors.gradientStart,
                  _animation.value * 0.3,
                )!,
              ],
              stops: [
                0.0 + (_animation.value * 0.1),
                1.0 - (_animation.value * 0.1),
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Soft Gradient Card Background
class GradientCardBackground extends StatelessWidget {
  final Widget child;
  final Color? primaryColor;
  final double opacity;

  const GradientCardBackground({
    super.key,
    required this.child,
    this.primaryColor,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: opacity * 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
