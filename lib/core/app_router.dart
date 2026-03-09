import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'navigation_shell.dart';

GoRouter createAppRouter() => GoRouter(
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
              builder: (context, state) => const HistoryPlaceholder(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/collections',
              builder: (context, state) => const CollectionsPlaceholder(),
              routes: [
                GoRoute(
                  path: ':name',
                  builder: (context, state) {
                    final name = state.pathParameters['name'] ?? '';
                    return CollectionDetailPlaceholder(name: name);
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
              builder: (context, state) => const FavoritesPlaceholder(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPlaceholder(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) => const PlayerPlaceholder(),
    ),
  ],
);

class HistoryPlaceholder extends StatelessWidget {
  const HistoryPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('History')));
  }
}

class CollectionsPlaceholder extends StatelessWidget {
  const CollectionsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Collections')));
  }
}

class CollectionDetailPlaceholder extends StatelessWidget {
  const CollectionDetailPlaceholder({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Collection: $name')));
  }
}

class FavoritesPlaceholder extends StatelessWidget {
  const FavoritesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Favorites')));
  }
}

class SettingsPlaceholder extends StatelessWidget {
  const SettingsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Settings')));
  }
}

class PlayerPlaceholder extends StatelessWidget {
  const PlayerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Player')));
  }
}
