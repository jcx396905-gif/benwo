import 'package:flutter/material.dart';

/// BenWo App Color Palette - Solid Material + liquid glass surfaces.
class AppColors {
  AppColors._();

  // Primary: calm teal on a solid MD-style base.
  static const Color primary = Color(0xFF8FBFB0);
  static const Color primaryLight = Color(0xFFCFE4DD);
  static const Color primaryDark = Color(0xFF4F7F72);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary: warm amber accent.
  static const Color secondary = Color(0xFFE8B57B);
  static const Color secondaryLight = Color(0xFFF3D6B2);
  static const Color secondaryDark = Color(0xFFB87E43);
  static const Color onSecondary = Color(0xFF21170D);

  // Background & Surface
  static const Color background = Color(0xFF101714);
  static const Color surface = Color(0xFF1B2420);
  static const Color surfaceVariant = Color(0xFF24312C);
  static const Color onBackground = Color(0xFFF4F7F5);
  static const Color onSurface = Color(0xFFF4F7F5);
  static const Color onSurfaceVariant = Color(0xFFC4CDC8);

  // Error
  static const Color error = Color(0xFFFF8A80);
  static const Color onError = Color(0xFFFFFFFF);

  // Additional Morandi Colors
  static const Color pink = Color(0xFFE8B4B8);
  static const Color dustyRose = Color(0xFFD4A5A5);
  static const Color sage = Color(0xFFA9C9A6);
  static const Color lavender = Color(0xFFC4B8DF);
  static const Color beige = Color(0xFFE0D6C8);
  static const Color cream = Color(0xFFF6EFE4);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE0E8E4);
  static const Color textHint = Color(0xFFB4C0BA);

  // Border & Divider
  static const Color border = Color(0xFF405049);
  static const Color divider = Color(0xFF2D3A35);

  // Goal Colors (for different goals)
  static const List<Color> goalColors = [
    Color(0xFF8FBFB0), // Primary blue-green
    Color(0xFFE8B57B), // Warm amber
    Color(0xFFA9C9A6), // Sage green
    Color(0xFFC4B8DF), // Lavender
    Color(0xFFE8B4B8), // Pink
    Color(0xFFD4A5A5), // Dusty rose
    Color(0xFFDDD5C7), // Beige
    Color(0xFF8FB1C4), // Soft blue
  ];

  // Kept for compatibility. UI should use solid backgrounds, not gradients.
  static const Color gradientStart = background;
  static const Color gradientEnd = background;
}
