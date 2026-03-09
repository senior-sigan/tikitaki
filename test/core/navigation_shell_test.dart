import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tikitaki/core/app_theme.dart';
import 'package:tikitaki/core/navigation_shell.dart';

void main() {
  group('NavigationShell', () {
    late GoRouter router;

    setUp(() {
      router = GoRouter(
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
                    builder: (context, state) =>
                        const Scaffold(body: Center(child: Text('History'))),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/collections',
                    builder: (context, state) => const Scaffold(
                      body: Center(child: Text('Collections')),
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/favorites',
                    builder: (context, state) =>
                        const Scaffold(body: Center(child: Text('Favorites'))),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/settings',
                    builder: (context, state) =>
                        const Scaffold(body: Center(child: Text('Settings'))),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });

    Widget buildApp() {
      return MaterialApp.router(routerConfig: router, theme: appTheme);
    }

    testWidgets('displays floating toolbar with 4 icon buttons', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final iconButtons = find.byType(IconButton);
      check(iconButtons.evaluate().length).equals(4);
    });

    testWidgets('displays correct icons', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      check(find.byIcon(Icons.history).evaluate().isNotEmpty).equals(true);
      check(find.byIcon(Icons.collections).evaluate().isNotEmpty).equals(true);
      check(find.byIcon(Icons.favorite).evaluate().isNotEmpty).equals(true);
      check(find.byIcon(Icons.settings).evaluate().isNotEmpty).equals(true);
    });

    testWidgets('tapping Collections icon shows Collections screen', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Initially shows History
      check(find.text('History').evaluate().isNotEmpty).equals(true);

      // Tap Collections icon
      await tester.tap(find.byIcon(Icons.collections));
      await tester.pumpAndSettle();

      // Now Collections screen is visible
      check(find.text('Collections').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('tapping Favorites icon shows Favorites screen', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      check(find.text('Favorites').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('tapping Settings icon shows Settings screen', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      check(find.text('Settings').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('toolbar has no text labels', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // No NavigationBar or NavigationDestination widgets
      check(find.byType(NavigationBar).evaluate().isEmpty).equals(true);
    });
  });
}
