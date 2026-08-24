import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/theme/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'routes/app_router.dart';

class BenWoApp extends ConsumerStatefulWidget {
  const BenWoApp({super.key});

  @override
  ConsumerState<BenWoApp> createState() => _BenWoAppState();
}

class _BenWoAppState extends ConsumerState<BenWoApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      preferences: ref.read(sharedPreferencesThemeProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '本我',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeControllerProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh'), Locale('en')],
      routerConfig: _appRouter.router,
    );
  }
}
