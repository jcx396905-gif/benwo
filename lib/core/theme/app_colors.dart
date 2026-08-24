import 'package:flutter/material.dart';

class BenWoPalette extends ThemeExtension<BenWoPalette> {
  const BenWoPalette({
    required this.canvas,
    required this.ceramic,
    required this.ceramicRaised,
    required this.ink,
    required this.mutedInk,
    required this.hintInk,
    required this.hairline,
    required this.gold,
    required this.goldPressed,
    required this.terracotta,
    required this.glass,
    required this.glassBorder,
    required this.shadow,
  });

  final Color canvas;
  final Color ceramic;
  final Color ceramicRaised;
  final Color ink;
  final Color mutedInk;
  final Color hintInk;
  final Color hairline;
  final Color gold;
  final Color goldPressed;
  final Color terracotta;
  final Color glass;
  final Color glassBorder;
  final Color shadow;

  static const light = BenWoPalette(
    canvas: Color(0xFFF4EFE5),
    ceramic: Color(0xFFFFFBF3),
    ceramicRaised: Color(0xFFECE3D4),
    ink: Color(0xFF27231F),
    mutedInk: Color(0xFF625B52),
    hintInk: Color(0xFF887F73),
    hairline: Color(0xFFD7CCBC),
    gold: Color(0xFF9A621C),
    goldPressed: Color(0xFF774811),
    terracotta: Color(0xFFA95F43),
    glass: Color(0xC9FFF9EF),
    glassBorder: Color(0xBFFFFFFF),
    shadow: Color(0x332D251D),
  );

  static const dark = BenWoPalette(
    canvas: Color(0xFF1F1A17),
    ceramic: Color(0xFF2B2521),
    ceramicRaised: Color(0xFF37302A),
    ink: Color(0xFFF1E8D9),
    mutedInk: Color(0xFFC9BDAC),
    hintInk: Color(0xFF9D9182),
    hairline: Color(0xFF51473E),
    gold: Color(0xFFD5A252),
    goldPressed: Color(0xFFB98538),
    terracotta: Color(0xFFD18465),
    glass: Color(0xD12A2420),
    glassBorder: Color(0x4DFFF3E1),
    shadow: Color(0x99000000),
  );

  @override
  BenWoPalette copyWith({
    Color? canvas,
    Color? ceramic,
    Color? ceramicRaised,
    Color? ink,
    Color? mutedInk,
    Color? hintInk,
    Color? hairline,
    Color? gold,
    Color? goldPressed,
    Color? terracotta,
    Color? glass,
    Color? glassBorder,
    Color? shadow,
  }) => BenWoPalette(
    canvas: canvas ?? this.canvas,
    ceramic: ceramic ?? this.ceramic,
    ceramicRaised: ceramicRaised ?? this.ceramicRaised,
    ink: ink ?? this.ink,
    mutedInk: mutedInk ?? this.mutedInk,
    hintInk: hintInk ?? this.hintInk,
    hairline: hairline ?? this.hairline,
    gold: gold ?? this.gold,
    goldPressed: goldPressed ?? this.goldPressed,
    terracotta: terracotta ?? this.terracotta,
    glass: glass ?? this.glass,
    glassBorder: glassBorder ?? this.glassBorder,
    shadow: shadow ?? this.shadow,
  );

  @override
  BenWoPalette lerp(covariant BenWoPalette? other, double t) {
    if (other == null) return this;
    return BenWoPalette(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      ceramic: Color.lerp(ceramic, other.ceramic, t)!,
      ceramicRaised: Color.lerp(ceramicRaised, other.ceramicRaised, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      mutedInk: Color.lerp(mutedInk, other.mutedInk, t)!,
      hintInk: Color.lerp(hintInk, other.hintInk, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldPressed: Color.lerp(goldPressed, other.goldPressed, t)!,
      terracotta: Color.lerp(terracotta, other.terracotta, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension BenWoThemeContext on BuildContext {
  BenWoPalette get palette =>
      Theme.of(this).extension<BenWoPalette>() ?? BenWoPalette.light;
}

/// Compatibility colors for older feature widgets while they consume the new
/// semantic theme through Material components.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF9A621C);
  static const primaryLight = Color(0xFFE8CE9D);
  static const primaryDark = Color(0xFF774811);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFA95F43);
  static const secondaryLight = Color(0xFFE7C0AE);
  static const secondaryDark = Color(0xFF7C402C);
  static const onSecondary = Color(0xFFFFFFFF);
  static const background = Color(0xFFF4EFE5);
  static const surface = Color(0xFFFFFBF3);
  static const surfaceVariant = Color(0xFFECE3D4);
  static const onBackground = Color(0xFF27231F);
  static const onSurface = Color(0xFF27231F);
  static const onSurfaceVariant = Color(0xFF625B52);
  static const error = Color(0xFFB64A42);
  static const onError = Color(0xFFFFFFFF);
  static const pink = Color(0xFFB87878);
  static const dustyRose = Color(0xFF9B6B64);
  static const bronze = Color(0xFF9A713E);
  static const lavender = Color(0xFF8B7E9D);
  static const beige = Color(0xFFD8C7AE);
  static const cream = Color(0xFFF7EEDC);
  static const textPrimary = Color(0xFF27231F);
  static const textSecondary = Color(0xFF625B52);
  static const textHint = Color(0xFF887F73);
  static const border = Color(0xFFD7CCBC);
  static const divider = Color(0xFFE0D6C8);

  static const goalColors = <Color>[
    Color(0xFF9A621C),
    Color(0xFFA95F43),
    Color(0xFFA4673E),
    Color(0xFF768899),
    Color(0xFF8B7E9D),
    Color(0xFF9B6B64),
    Color(0xFF6E5142),
    Color(0xFFC5A66B),
  ];
}
