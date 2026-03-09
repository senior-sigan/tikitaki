import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tikitaki/data/settings_repository.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/collections/collection_detail_screen.dart';
import 'package:tikitaki/features/collections/collections_screen.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
import 'package:tikitaki/features/favorites/favorites_screen.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/history_screen.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';
import 'package:tikitaki/features/player/player_screen.dart';
import 'package:tikitaki/features/player/player_view_model.dart';
import 'package:tikitaki/features/settings/settings_screen.dart';

import 'navigation_shell.dart';

GoRouter createAppRouter({
  required VideoListViewModel videoListViewModel,
  required CollectionsViewModel collectionsViewModel,
  required FavoritesViewModel favoritesViewModel,
  required SettingsRepository settingsRepository,
  required String baseUrl,
}) => GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => HistoryScreen(
                videoListViewModel: videoListViewModel,
                favoritesViewModel: favoritesViewModel,
                baseUrl: baseUrl,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/collections',
              builder: (context, state) => CollectionsScreen(
                collectionsViewModel: collectionsViewModel,
                baseUrl: baseUrl,
              ),
              routes: [
                GoRoute(
                  path: ':name',
                  builder: (context, state) {
                    final name = state.pathParameters['name'] ?? '';
                    return CollectionDetailScreen(
                      collectionName: name,
                      collectionsViewModel: collectionsViewModel,
                      favoritesViewModel: favoritesViewModel,
                      baseUrl: baseUrl,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => FavoritesScreen(
                favoritesViewModel: favoritesViewModel,
                baseUrl: baseUrl,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) =>
                  SettingsScreen(settingsRepository: settingsRepository),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is PlayerRouteData) {
          return PlayerScreen(
            playerViewModel: PlayerViewModel(
              videoList: extra.videos,
              startIndex: extra.startIndex,
            ),
            favoritesViewModel: favoritesViewModel,
            baseUrl: baseUrl,
          );
        }
        return const Scaffold(
          body: Center(child: Text('No video data provided')),
        );
      },
    ),
  ],
);

class PlayerRouteData {
  const PlayerRouteData({required this.videos, required this.startIndex});

  final List<VideoItem> videos;
  final int startIndex;
}
