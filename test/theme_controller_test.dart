import 'package:benwo/application/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('theme controller defaults to system and persists every mode', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = ThemeController(preferences);

    expect(controller.state, ThemeMode.system);

    await controller.setThemeMode(ThemeMode.dark);
    expect(controller.state, ThemeMode.dark);
    expect(preferences.getString(ThemeController.preferenceKey), 'dark');

    await controller.setThemeMode(ThemeMode.light);
    expect(controller.state, ThemeMode.light);

    await controller.setThemeMode(ThemeMode.system);
    expect(controller.state, ThemeMode.system);
  });

  test('theme controller restores a persisted mode', () async {
    SharedPreferences.setMockInitialValues({
      ThemeController.preferenceKey: 'dark',
    });
    final preferences = await SharedPreferences.getInstance();

    expect(ThemeController(preferences).state, ThemeMode.dark);
  });
}
