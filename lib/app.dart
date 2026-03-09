import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tikitaki/data/settings_repository.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

import 'core/app_router.dart';
import 'core/app_theme.dart';

class TikiTakiApp extends StatefulWidget {
  const TikiTakiApp({
    required this.videoListViewModel,
    required this.collectionsViewModel,
    required this.favoritesViewModel,
    required this.settingsRepository,
    required this.baseUrl,
    super.key,
  });

  final VideoListViewModel videoListViewModel;
  final CollectionsViewModel collectionsViewModel;
  final FavoritesViewModel favoritesViewModel;
  final SettingsRepository settingsRepository;
  final String baseUrl;

  @override
  State<TikiTakiApp> createState() => _TikiTakiAppState();
}

class _TikiTakiAppState extends State<TikiTakiApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(
      videoListViewModel: widget.videoListViewModel,
      collectionsViewModel: widget.collectionsViewModel,
      favoritesViewModel: widget.favoritesViewModel,
      settingsRepository: widget.settingsRepository,
      baseUrl: widget.baseUrl,
    );
  }

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
