import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// 全局液态玻璃底部导航 (GlassTabBar.bottom)
/// [index] 当前页: 0首页 1目标 2专注 3日历 4设置
class AppGlassNavBar extends StatelessWidget {
  final int index;

  const AppGlassNavBar({required this.index, super.key});

  static const _routes = ['/home', '/goals', '/focus', '/calendar', '/settings'];

  @override
  Widget build(BuildContext context) {
    return GlassTabBar.bottom(
      selectedIndex: index,
      showIndicator: false,
      glowOpacity: 0,
      onTabSelected: (i) {
        if (i != index) context.go(_routes[i]);
      },
      tabs: const [
        GlassTab(icon: Icon(Icons.home_rounded), label: '首页'),
        GlassTab(icon: Icon(Icons.flag_rounded), label: '目标'),
        GlassTab(icon: Icon(Icons.timer_rounded), label: '专注'),
        GlassTab(icon: Icon(Icons.calendar_month_rounded), label: '日历'),
        GlassTab(icon: Icon(Icons.settings_rounded), label: '设置'),
      ],
    );
  }
}
