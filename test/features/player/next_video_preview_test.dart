import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/core/widgets/video_thumbnail.dart';
import 'package:tikitaki/features/player/next_video_preview.dart';

void main() {
  group('NextVideoPreview', () {
    testWidgets('renders VideoThumbnail with correct URL', (tester) async {
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

      final thumbnail = tester.widget<VideoThumbnail>(
        find.byType(VideoThumbnail),
      );
      check(thumbnail.thumbnailUrl).equals('https://example.com/thumb.jpg');
    });

    testWidgets('renders Opacity widget', (tester) async {
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

      check(find.byType(Opacity).evaluate().length).isGreaterThan(0);
    });

    testWidgets('renders Transform widget', (tester) async {
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

      check(find.byType(Transform).evaluate().length).isGreaterThan(0);
    });

    testWidgets('is hidden (opacity 0) when pageController has no clients', (
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

      // When the PageController has no clients (not attached to a PageView),
      // the widget should default to opacity 0 (hidden).
      // Note: In this test setup the controller IS attached via the build,
      // but .page returns null before the first frame, so we check initial state.
      // We need a controller that truly has no clients — use a separate one
      // not attached to any scrollable.
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

      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      check(opacity.opacity).equals(0.0);
    });

    testWidgets(
      'wraps content in Container with black54 background and rounded top corners',
      (tester) async {
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
      },
    );
  });
}
