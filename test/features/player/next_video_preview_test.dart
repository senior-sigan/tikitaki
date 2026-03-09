import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/core/widgets/video_thumbnail.dart';
import 'package:tikitaki/features/player/next_video_preview.dart';

void main() {
  group('NextVideoPreview', () {
    testWidgets('renders VideoThumbnail with correct URL when dragging', (
      tester,
    ) async {
      final controller = PageController();
      addTearDown(controller.dispose);

      // Wrap in a PageView so the controller has clients and a non-zero page.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: Stack(
                children: [
                  PageView(
                    controller: controller,
                    scrollDirection: Axis.vertical,
                    children: [
                      const SizedBox.expand(),
                      const SizedBox.expand(),
                    ],
                  ),
                  NextVideoPreview(
                    pageController: controller,
                    nextThumbnailUrl: 'https://example.com/thumb.jpg',
                    currentIndex: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Simulate a partial drag to get non-zero dragProgress.
      final gesture = await tester.startGesture(const Offset(200, 300));
      await gesture.moveBy(const Offset(0, -100));
      await tester.pump();

      final thumbnail = tester.widget<VideoThumbnail>(
        find.byType(VideoThumbnail),
      );
      check(thumbnail.thumbnailUrl).equals('https://example.com/thumb.jpg');

      await gesture.cancel();
      await tester.pumpAndSettle();
    });

    testWidgets('returns SizedBox.shrink when dragProgress is zero', (
      tester,
    ) async {
      final controller = PageController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NextVideoPreview(
              pageController: controller,
              nextThumbnailUrl: 'https://example.com/thumb.jpg',
              currentIndex: 0,
            ),
          ),
        ),
      );

      // At rest, the widget should return SizedBox.shrink (no Opacity, no child).
      check(find.byType(Opacity).evaluate().length).equals(0);
      check(find.byType(VideoThumbnail).evaluate().length).equals(0);
    });

    testWidgets('renders Opacity and Transform widgets when dragging', (
      tester,
    ) async {
      final controller = PageController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: Stack(
                children: [
                  PageView(
                    controller: controller,
                    scrollDirection: Axis.vertical,
                    children: [
                      const SizedBox.expand(),
                      const SizedBox.expand(),
                    ],
                  ),
                  NextVideoPreview(
                    pageController: controller,
                    nextThumbnailUrl: 'https://example.com/thumb.jpg',
                    currentIndex: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Simulate a partial drag to get non-zero dragProgress.
      final gesture = await tester.startGesture(const Offset(200, 300));
      await gesture.moveBy(const Offset(0, -100));
      await tester.pump();

      check(find.byType(Opacity).evaluate().length).isGreaterThan(0);
      check(find.byType(Transform).evaluate().length).isGreaterThan(0);

      await gesture.cancel();
      await tester.pumpAndSettle();
    });

    testWidgets('renders SizedBox.shrink when pageController has no clients', (
      tester,
    ) async {
      final detachedController = PageController();
      addTearDown(detachedController.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NextVideoPreview(
              pageController: detachedController,
              nextThumbnailUrl: 'https://example.com/thumb.jpg',
              currentIndex: 0,
            ),
          ),
        ),
      );

      // When dragProgress is 0, the widget returns SizedBox.shrink
      // instead of rendering an invisible Opacity(0.0) tree.
      check(find.byType(Opacity).evaluate().length).equals(0);
      check(find.byType(VideoThumbnail).evaluate().length).equals(0);
    });

    testWidgets(
      'wraps content in DecoratedBox with black54 background and rounded top corners when dragging',
      (tester) async {
        final controller = PageController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 600,
                child: Stack(
                  children: [
                    PageView(
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      children: [
                        const SizedBox.expand(),
                        const SizedBox.expand(),
                      ],
                    ),
                    NextVideoPreview(
                      pageController: controller,
                      nextThumbnailUrl: 'https://example.com/thumb.jpg',
                      currentIndex: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Simulate a partial drag to reveal the preview.
        final gesture = await tester.startGesture(const Offset(200, 300));
        await gesture.moveBy(const Offset(0, -100));
        await tester.pump();

        final container = tester.widget<DecoratedBox>(
          find.byType(DecoratedBox).first,
        );
        final decoration = container.decoration as BoxDecoration;
        check(decoration.color).equals(Colors.black54);
        check(decoration.borderRadius).equals(
          const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        );

        await gesture.cancel();
        await tester.pumpAndSettle();
      },
    );
  });
}
