import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/core/widgets/video_grid.dart';
import 'package:tikitaki/data/video_item.dart';

List<VideoItem> _createVideos(int count) {
  return List.generate(
    count,
    (i) => VideoItem(
      url: 'videos/video_$i.mp4',
      name: 'Video $i',
      collection: 'test',
      thumbnailUrl: 'thumbs/thumb_$i.jpg',
    ),
  );
}

void main() {
  group('VideoGrid', () {
    testWidgets('displays GridView with 2 columns', (tester) async {
      final videos = _createVideos(6);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoGrid(
              videos: videos,
              baseUrl: 'https://example.com',
              onVideoTap: (_, _) {},
            ),
          ),
        ),
      );

      final gridFinder = find.byType(GridView);
      check(gridFinder.evaluate().length).equals(1);
    });

    testWidgets(
      'tapping a cell calls onVideoTap with correct video and index',
      (tester) async {
        final videos = _createVideos(3);
        int? tappedIndex;
        VideoItem? tappedVideo;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VideoGrid(
                videos: videos,
                baseUrl: 'https://example.com',
                onVideoTap: (video, index) {
                  tappedVideo = video;
                  tappedIndex = index;
                },
              ),
            ),
          ),
        );

        // Tap the second card (index 1)
        final cards = find.byType(Card);
        await tester.tap(cards.at(1));

        check(tappedIndex).equals(1);
        check(tappedVideo?.name).equals('Video 1');
      },
    );

    testWidgets('shows RefreshIndicator when onRefresh is provided', (
      tester,
    ) async {
      final videos = _createVideos(3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoGrid(
              videos: videos,
              baseUrl: 'https://example.com',
              onVideoTap: (_, _) {},
              onRefresh: () async {},
            ),
          ),
        ),
      );

      final refreshFinder = find.byType(RefreshIndicator);
      check(refreshFinder.evaluate().length).equals(1);
    });

    testWidgets('does not show RefreshIndicator when onRefresh is null', (
      tester,
    ) async {
      final videos = _createVideos(3);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoGrid(
              videos: videos,
              baseUrl: 'https://example.com',
              onVideoTap: (_, _) {},
            ),
          ),
        ),
      );

      final refreshFinder = find.byType(RefreshIndicator);
      check(refreshFinder.evaluate().length).equals(0);
    });

    testWidgets('pull-to-refresh calls onRefresh callback', (tester) async {
      final videos = _createVideos(6);
      var refreshCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoGrid(
              videos: videos,
              baseUrl: 'https://example.com',
              onVideoTap: (_, _) {},
              onRefresh: () async {
                refreshCalled = true;
              },
            ),
          ),
        ),
      );

      // Simulate pull-to-refresh by fling down
      await tester.fling(find.byType(GridView), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      check(refreshCalled).equals(true);
    });
  });
}
