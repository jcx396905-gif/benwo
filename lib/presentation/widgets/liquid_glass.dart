import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _MaterialLightField(),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

class LiquidGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double blur;
  final Color color;
  final Color borderColor;

  const LiquidGlassPanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.blur = 22,
    this.color = const Color(0x46FFFFFF),
    this.borderColor = const Color(0x44FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 26,
                offset: Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(color: const Color(0x18FFFFFF)),
                  ),
                ),
              ),
              Padding(padding: padding, child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class LiquidGlassChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const LiquidGlassChip({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      borderRadius: BorderRadius.circular(999),
      blur: 16,
      color: const Color(0x24FFFFFF),
      borderColor: const Color(0x40FFFFFF),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 16),
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

class LiquidGlassIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const LiquidGlassIcon({required this.icon, super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.58,
          shadows: const [
            Shadow(color: Colors.white, blurRadius: 12),
            Shadow(color: AppColors.primary, blurRadius: 24),
          ],
        ),
      ),
    );
  }
}

class LiquidGlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;

  const LiquidGlassIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
    this.size = 48,
    this.iconSize = 26,
  });

  @override
  State<LiquidGlassIconButton> createState() => _LiquidGlassIconButtonState();
}

class _LiquidGlassIconButtonState extends State<LiquidGlassIconButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTapUp: enabled
          ? (_) {
              _setPressed(false);
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _pressed ? const Color(0x36FFFFFF) : const Color(0x22FFFFFF),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x24FFFFFF)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: _pressed ? 0.30 : 0.12),
                blurRadius: _pressed ? 22 : 14,
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: enabled ? Colors.white : AppColors.textHint,
            shadows: enabled
                ? const [
                    Shadow(color: Colors.white70, blurRadius: 12),
                    Shadow(color: AppColors.primary, blurRadius: 18),
                  ]
                : null,
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      child: widget.tooltip == null
          ? button
          : Tooltip(message: widget.tooltip, child: button),
    );
  }
}

class _MaterialLightField extends StatelessWidget {
  const _MaterialLightField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MaterialLightFieldPainter());
  }
}

class _MaterialLightFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()..color = AppColors.background;
    canvas.drawRect(Offset.zero & size, basePaint);

    final beams = [
      (dx: 0.16, width: 58.0, alpha: 0.10),
      (dx: 0.43, width: 74.0, alpha: 0.14),
      (dx: 0.77, width: 52.0, alpha: 0.08),
    ];

    for (final beam in beams) {
      final rect = Rect.fromLTWH(
        size.width * beam.dx - beam.width / 2,
        -size.height * 0.1,
        beam.width,
        size.height * 1.2,
      );
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: beam.alpha),
            AppColors.primary.withValues(alpha: beam.alpha * 0.8),
            Colors.white.withValues(alpha: 0),
          ],
          stops: const [0, 0.34, 0.62, 1],
        ).createShader(rect)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(beam.width)),
        paint,
      );
    }

    final washPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.18),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.18, size.height * 0.18),
              radius: size.width * 0.7,
            ),
          );
    canvas.drawRect(Offset.zero & size, washPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
