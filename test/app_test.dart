import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/app.dart';

void main() {
  group('TikiTakiApp', () {
    testWidgets('renders MaterialApp with dark theme', (tester) async {
      await tester.pumpWidget(const TikiTakiApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      check(materialApp.themeMode).equals(ThemeMode.dark);
      check(materialApp.debugShowCheckedModeBanner).equals(false);
    });

    testWidgets('has bottom navigation bar with 4 tabs', (tester) async {
      await tester.pumpWidget(const TikiTakiApp());
      await tester.pumpAndSettle();

      final navBar = find.byType(NavigationBar);
      check(navBar.evaluate().length).equals(1);

      check(find.text('History').evaluate().isNotEmpty).equals(true);
      check(find.text('Collections').evaluate().isNotEmpty).equals(true);
      check(find.text('Favorites').evaluate().isNotEmpty).equals(true);
      check(find.text('Settings').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('uses dark brightness in theme', (tester) async {
      await tester.pumpWidget(const TikiTakiApp());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(NavigationBar));
      final theme = Theme.of(context);
      check(theme.brightness).equals(Brightness.dark);
    });
  });
}
