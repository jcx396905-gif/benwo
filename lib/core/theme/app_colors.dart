import 'package:flutter/material.dart';

/// BenWo App Color Palette - warm paper + readable liquid glass surfaces.
class AppColors {
  AppColors._();

  // Primary: calm sage teal.
  static const Color primary = Color(0xFF8FBFB0);
  static const Color primaryLight = Color(0xFFCFE4DD);
  static const Color primaryDark = Color(0xFF4F7F72);
  static const Color onPrimary = Color(0xFF20352F);

  // Secondary: warm amber accent.
  static const Color secondary = Color(0xFFD8A85F);
  static const Color secondaryLight = Color(0xFFF4DDB5);
  static const Color secondaryDark = Color(0xFF9A6C2E);
  static const Color onSecondary = Color(0xFF21170D);

  // Background & Surface.
  static const Color background = Color(0xFFF6EFE4);
  static const Color surface = Color(0xFFFFFAF0);
  static const Color surfaceVariant = Color(0xFFF0E5D5);
  static const Color onBackground = Color(0xFF3D352C);
  static const Color onSurface = Color(0xFF3D352C);
  static const Color onSurfaceVariant = Color(0xFF766A5D);

  // Error
  static const Color error = Color(0xFFB7604B);
  static const Color onError = Color(0xFFFFFFFF);

  // Additional Morandi Colors
  static const Color pink = Color(0xFFE8B4B8);
  static const Color dustyRose = Color(0xFFD4A5A5);
  static const Color sage = Color(0xFFA9C9A6);
  static const Color lavender = Color(0xFFC4B8DF);
  static const Color beige = Color(0xFFE0D6C8);
  static const Color cream = Color(0xFFF6EFE4);

  // Text Colors
  static const Color textPrimary = Color(0xFF3D352C);
  static const Color textSecondary = Color(0xFF766A5D);
  static const Color textHint = Color(0xFF9C9082);

  // Border & Divider
  static const Color border = Color(0xFFE5D8C6);
  static const Color divider = Color(0xFFE8DCCB);

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

  // Kept for compatibility. UI should use glass/paper backgrounds, not strong gradients.
  static const Color gradientStart = background;
  static const Color gradientEnd = background;
}
