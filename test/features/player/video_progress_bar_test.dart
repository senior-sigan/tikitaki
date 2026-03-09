import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/features/player/video_progress_bar.dart';

void main() {
  group('VideoProgressBar', () {
    testWidgets('shows LinearProgressIndicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoProgressBar(
              position: Duration(seconds: 5),
              duration: Duration(seconds: 10),
            ),
          ),
        ),
      );

      check(find.byType(LinearProgressIndicator).evaluate().length).equals(1);
    });

    testWidgets('progress value reflects position over duration ratio', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoProgressBar(
              position: Duration(seconds: 3),
              duration: Duration(seconds: 10),
            ),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      check(indicator.value).isNotNull().isCloseTo(0.3, 0.001);
    });

    testWidgets('progress is zero when duration is zero', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoProgressBar(
              position: Duration.zero,
              duration: Duration.zero,
            ),
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      check(indicator.value).isNotNull().equals(0.0);
    });
  });
}
