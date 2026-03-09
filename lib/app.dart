import 'package:flutter/material.dart';

import 'core/app_router.dart';
import 'core/app_theme.dart';

class TikiTakiApp extends StatefulWidget {
  const TikiTakiApp({super.key});

  @override
  State<TikiTakiApp> createState() => _TikiTakiAppState();
}

class _TikiTakiAppState extends State<TikiTakiApp> {
  late final _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      darkTheme: appTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
