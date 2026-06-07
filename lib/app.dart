import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

/// BenWo App Root Widget
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
    _appRouter = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    final router = _appRouter.router;

    return MaterialApp.router(
      title: 'BenWo - 本我',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', ''),
        Locale('en', ''),
      ],
      routerConfig: router,
    );
  }
}
