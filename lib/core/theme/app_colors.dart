import 'package:flutter/material.dart';

/// BenWo App Color Palette - Morandi Style
/// 莫兰迪色系 - 温和、友好的视觉风格
class AppColors {
  AppColors._();

  // Primary: Morandi Blue-Green (#7FA99B)
  static const Color primary = Color(0xFF7FA99B);
  static const Color primaryLight = Color(0xFFA8C5BC);
  static const Color primaryDark = Color(0xFF5A8A7C);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary: Warm Orange (#E8A87C)
  static const Color secondary = Color(0xFFE8A87C);
  static const Color secondaryLight = Color(0xFFF2C9A8);
  static const Color secondaryDark = Color(0xFFD48A5C);
  static const Color onSecondary = Color(0xFF3D2E24);

  // Background & Surface
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0EDE8);
  static const Color onBackground = Color(0xFF2D2D2D);
  static const Color onSurface = Color(0xFF2D2D2D);
  static const Color onSurfaceVariant = Color(0xFF6B6B6B);

  // Error
  static const Color error = Color(0xFFD64545);
  static const Color onError = Color(0xFFFFFFFF);

  // Additional Morandi Colors
  static const Color pink = Color(0xFFE8B4B8);
  static const Color dustyRose = Color(0xFFD4A5A5);
  static const Color sage = Color(0xFF9CAF88);
  static const Color lavender = Color(0xFFB4A7C7);
  static const Color beige = Color(0xFFDDD5C7);
  static const Color cream = Color(0xFFF5F0E8);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFF9E9E9E);

  // Border & Divider
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Goal Colors (for different goals)
  static const List<Color> goalColors = [
    Color(0xFF7FA99B), // Primary blue-green
    Color(0xFFE8A87C), // Warm orange
    Color(0xFF9CAF88), // Sage green
    Color(0xFFB4A7C7), // Lavender
    Color(0xFFE8B4B8), // Pink
    Color(0xFFD4A5A5), // Dusty rose
    Color(0xFFDDD5C7), // Beige
    Color(0xFF8FB1C4), // Soft blue
  ];

  // Gradient colors
  static const Color gradientStart = Color(0xFF7FA99B);
  static const Color gradientEnd = Color(0xFFE8A87C);
}
