import 'dart:io';

import 'package:benwo/application/theme/theme_controller.dart';
import 'package:benwo/core/theme/app_colors.dart';
import 'package:benwo/core/theme/app_theme.dart';
import 'package:benwo/presentation/pages/settings/settings_page.dart';
import 'package:benwo/presentation/widgets/smartisan_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('focus feature uses the active semantic palette', () {
    final source = File(
      'lib/presentation/pages/focus/focus_page.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('AppColors.')));
  });

  test('running timer status uses the theme on-primary contrast color', () {
    final source = File(
      'lib/presentation/pages/focus/pomodoro_running_page.dart',
    ).readAsStringSync();

    expect(source, contains('color: Theme.of(context).colorScheme.onPrimary'));
  });

  test('light and dark themes expose distinct semantic beige palettes', () {
    final light = AppTheme.lightTheme.extension<BenWoPalette>()!;
    final dark = AppTheme.darkTheme.extension<BenWoPalette>()!;

    expect(AppTheme.lightTheme.brightness, Brightness.light);
    expect(AppTheme.darkTheme.brightness, Brightness.dark);
    expect(light.canvas, isNot(dark.canvas));
    expect(light.ceramic, isNot(dark.ceramic));
    expect(_contrast(light.ink, light.canvas), greaterThanOrEqualTo(4.5));
    expect(_contrast(light.mutedInk, light.canvas), greaterThanOrEqualTo(4.5));
    expect(_contrast(dark.ink, dark.canvas), greaterThanOrEqualTo(4.5));
    expect(_contrast(dark.mutedInk, dark.canvas), greaterThanOrEqualTo(4.5));
    expect(
      _contrast(
        AppTheme.lightTheme.colorScheme.onPrimary,
        AppTheme.lightTheme.colorScheme.primary,
      ),
      greaterThanOrEqualTo(4.5),
    );

    for (final color in AppColors.goalColors) {
      final hsl = HSLColor.fromColor(color);
      expect(
        hsl.hue < 70 || hsl.hue > 170 || hsl.saturation < 0.08,
        isTrue,
        reason: 'goal palette must not contain green hues: $color',
      );
    }
  });

  testWidgets(
    'settings has theme and profile controls but no account actions',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            themeControllerProvider.overrideWith(
              (ref) => ThemeController(preferences),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SettingsPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('主题'), findsOneWidget);
      expect(find.text('AI 个性化'), findsOneWidget);
      expect(find.text('账号'), findsNothing);
      expect(find.text('修改密码'), findsNothing);
      expect(find.text('退出登录'), findsNothing);
    },
  );

  testWidgets('Smartisan button keeps a minimum 44 point touch target', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: SmartisanCapsuleButton(label: '继续', onPressed: () {}),
          ),
        ),
      ),
    );

    final size = tester.getSize(find.byType(SmartisanCapsuleButton));
    expect(size.width, greaterThanOrEqualTo(44));
    expect(size.height, greaterThanOrEqualTo(44));
  });

  testWidgets('Smartisan button can be focused and activated by keyboard', (
    tester,
  ) async {
    var activated = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SmartisanCapsuleButton(
            label: '继续',
            onPressed: () => activated = true,
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus, isNotNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(activated, isTrue);
  });

  testWidgets('main navigation restores the focus destination', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          bottomNavigationBar: SmartisanGlassBottomNavigationBar(
            currentIndex: 2,
            onTap: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('目标'), findsOneWidget);
    expect(find.text('专注'), findsOneWidget);
    expect(find.text('日历'), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
  });
}

double _contrast(Color foreground, Color background) {
  final first = foreground.computeLuminance();
  final second = background.computeLuminance();
  final lighter = first > second ? first : second;
  final darker = first > second ? second : first;
  return (lighter + 0.05) / (darker + 0.05);
}
