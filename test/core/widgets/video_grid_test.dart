import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/core/widgets/video_grid.dart';
import 'package:tikitaki/core/widgets/video_thumbnail.dart';
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
    testWidgets('displays GridView with 3 columns', (tester) async {
      final videos = _createVideos(6);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoGrid(
              videos: videos,
              baseUrl: 'https://example.com',
              onVideoTap: (_) {},
            ),
          ),
        ),
      );

      final gridFinder = find.byType(GridView);
      check(gridFinder.evaluate().length).equals(1);
    });

    testWidgets('tapping a cell calls onVideoTap with correct index', (
      tester,
    ) async {
      final videos = _createVideos(3);
      int? tappedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoGrid(
              videos: videos,
              baseUrl: 'https://example.com',
              onVideoTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      // Tap the second thumbnail (index 1)
      final thumbnails = find.byType(VideoThumbnail);
      await tester.tap(thumbnails.at(1));

      check(tappedIndex).equals(1);
    });

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
              onVideoTap: (_) {},
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
              onVideoTap: (_) {},
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
              onVideoTap: (_) {},
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
