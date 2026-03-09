import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/features/player/scrub_gesture_detector.dart';

void main() {
  group('ScrubGestureDetector', () {
    testWidgets('long_press_triggers_onScrubStart_callback', (tester) async {
      var started = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrubGestureDetector(
              onScrubStart: () => started = true,
              onScrubUpdate: (_) {},
              onScrubEnd: () {},
              child: const SizedBox(width: 400, height: 600),
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(ScrubGestureDetector));
      check(started).equals(true);
    });

    testWidgets(
      'horizontal_drag_during_long_press_triggers_onScrubUpdate_with_correct_fraction',
      (tester) async {
        final fractions = <double>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ScrubGestureDetector(
                onScrubStart: () {},
                onScrubUpdate: (f) => fractions.add(f),
                onScrubEnd: () {},
                child: const SizedBox.expand(),
              ),
            ),
          ),
        );

        final center = tester.getCenter(find.byType(ScrubGestureDetector));
        final gesture = await tester.startGesture(center);
        // Wait for long press to be recognized
        await tester.pump(const Duration(milliseconds: 600));
        // Drag horizontally
        await gesture.moveBy(const Offset(100, 0));
        await tester.pump();
        await gesture.up();
        await tester.pump();

        check(fractions).isNotEmpty();
        // 100 pixels of drag; fraction = 100 / screenWidth
        final screenWidth =
            tester.view.physicalSize.width / tester.view.devicePixelRatio;
        final expected = 100.0 / screenWidth;
        check(fractions.last).isCloseTo(expected, 0.01);
      },
    );

    testWidgets('releasing_long_press_triggers_onScrubEnd_callback', (
      tester,
    ) async {
      var ended = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrubGestureDetector(
              onScrubStart: () {},
              onScrubUpdate: (_) {},
              onScrubEnd: () => ended = true,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );

      final center = tester.getCenter(find.byType(ScrubGestureDetector));
      final gesture = await tester.startGesture(center);
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.up();
      await tester.pump();

      check(ended).equals(true);
    });
  });
}
