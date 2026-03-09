import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tikitaki/core/app_router.dart';
import 'package:tikitaki/core/app_theme.dart';

void main() {
  group('appRouter', () {
    late GoRouter router;

    setUp(() {
      router = createAppRouter();
    });

    Widget buildApp() {
      return MaterialApp.router(routerConfig: router, theme: appTheme);
    }

    testWidgets('navigates to / and shows History', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      check(find.text('History').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('navigates to /collections and shows Collections', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      router.go('/collections');
      await tester.pumpAndSettle();

      check(find.text('Collections').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('navigates to /collections/:name and shows collection detail', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      router.go('/collections/my-collection');
      await tester.pumpAndSettle();

      check(
        find.text('Collection: my-collection').evaluate().isNotEmpty,
      ).equals(true);
    });

    testWidgets('navigates to /favorites and shows Favorites', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      router.go('/favorites');
      await tester.pumpAndSettle();

      check(find.text('Favorites').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('navigates to /settings and shows Settings', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      router.go('/settings');
      await tester.pumpAndSettle();

      check(find.text('Settings').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('navigates to /player and shows Player without bottom nav', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      router.go('/player');
      await tester.pumpAndSettle();

      check(find.text('Player').evaluate().isNotEmpty).equals(true);
      // Player route is outside the shell, so no NavigationBar
      check(find.byType(NavigationBar).evaluate().isEmpty).equals(true);
    });

    testWidgets('bottom navigation is visible on shell routes', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      check(find.byType(NavigationBar).evaluate().isNotEmpty).equals(true);
    });
  });
}
