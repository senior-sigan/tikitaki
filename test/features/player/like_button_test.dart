import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/features/player/like_button.dart';

void main() {
  group('LikeButton', () {
    testWidgets('shows filled heart icon when favorited', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LikeButton(isFavorite: true, onToggle: _noop),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      check(icon.icon).equals(Icons.favorite);
    });

    testWidgets('shows outlined heart icon when not favorited', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LikeButton(isFavorite: false, onToggle: _noop),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      check(icon.icon).equals(Icons.favorite_border);
    });

    testWidgets('tap calls onToggle callback', (tester) async {
      var toggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LikeButton(
              isFavorite: false,
              onToggle: () => toggled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LikeButton));
      check(toggled).equals(true);
    });
  });
}

void _noop() {}
