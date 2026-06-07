import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Skeleton Loader Widget
/// A placeholder shimmer effect for loading states
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16.0,
    this.borderRadius = 8.0,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? AppColors.border;
    final highlightColor = widget.highlightColor ?? AppColors.surfaceVariant;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton List Item
class SkeletonListItem extends StatelessWidget {
  final double height;
  final double borderRadius;
  final EdgeInsets? margin;

  const SkeletonListItem({
    super.key,
    this.height = 72.0,
    this.borderRadius = 12.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          // Leading skeleton (avatar or icon placeholder)
          SkeletonLoader(
            width: 40,
            height: 40,
            borderRadius: 8,
          ),
          const SizedBox(width: 12),
          // Content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(
                  height: 16,
                  borderRadius: 4,
                ),
                const SizedBox(height: 8),
                SkeletonLoader(
                  height: 12,
                  width: 120,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Trailing skeleton (checkbox or chevron)
          SkeletonLoader(
            width: 24,
            height: 24,
            borderRadius: 6,
          ),
        ],
      ),
    );
  }
}

/// Skeleton Card
class SkeletonCard extends StatelessWidget {
  final double height;
  final EdgeInsets? margin;

  const SkeletonCard({
    super.key,
    this.height = 100.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonLoader(
                width: 32,
                height: 32,
                borderRadius: 8,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                      height: 16,
                      width: double.infinity,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 8),
                    SkeletonLoader(
                      height: 12,
                      width: 100,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SkeletonLoader(
            height: 12,
            borderRadius: 4,
          ),
          const SizedBox(height: 8),
          SkeletonLoader(
            height: 12,
            width: 200,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}

/// Skeleton Text Lines
class SkeletonTextLines extends StatelessWidget {
  final int lineCount;
  final double lineHeight;
  final double spacing;
  final bool showLastLineShort;

  const SkeletonTextLines({
    super.key,
    this.lineCount = 3,
    this.lineHeight = 14.0,
    this.spacing = 8.0,
    this.showLastLineShort = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lineCount, (index) {
        final isLast = index == lineCount - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: SkeletonLoader(
            height: lineHeight,
            width: isLast && showLastLineShort ? 150 : double.infinity,
            borderRadius: 4,
          ),
        );
      }),
    );
  }
}

/// Goal Card Skeleton
class SkeletonGoalCard extends StatelessWidget {
  const SkeletonGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonLoader(
                width: 48,
                height: 48,
                borderRadius: 12,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                      height: 18,
                      width: double.infinity,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 8),
                    SkeletonLoader(
                      height: 14,
                      width: 150,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SkeletonLoader(
            height: 8,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}
