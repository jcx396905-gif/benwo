import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesThemeProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController(this._preferences)
    : super(_decode(_preferences.getString(preferenceKey)));

  static const preferenceKey = 'theme_mode';

  final SharedPreferences _preferences;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _preferences.setString(preferenceKey, mode.name);
  }

  static ThemeMode _decode(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>((ref) {
      return ThemeController(ref.watch(sharedPreferencesThemeProvider));
    });
