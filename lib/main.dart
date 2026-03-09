import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikitaki/data/http_video_repository.dart';
import 'package:tikitaki/data/settings_repository.dart';
import 'package:tikitaki/data/shared_preferences_favorites_repository.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final settingsRepository = SharedPreferencesSettingsRepository(prefs);
  final baseUrl = await settingsRepository.getBaseUrl();

  final client = http.Client();
  final videoRepository = HttpVideoRepository(client: client, baseUrl: baseUrl);

  final favoritesRepository = SharedPreferencesFavoritesRepository(prefs);

  final videoListViewModel = VideoListViewModel(repository: videoRepository);
  final collectionsViewModel = CollectionsViewModel(
    videoListViewModel: videoListViewModel,
  );
  final favoritesViewModel = FavoritesViewModel(
    favoritesRepository: favoritesRepository,
    videoListViewModel: videoListViewModel,
  );

  // Trigger initial data load.
  videoListViewModel.load();

  runApp(
    TikiTakiApp(
      videoListViewModel: videoListViewModel,
      collectionsViewModel: collectionsViewModel,
      favoritesViewModel: favoritesViewModel,
      settingsRepository: settingsRepository,
      baseUrl: baseUrl,
    ),
  );
}
