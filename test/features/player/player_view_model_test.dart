import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/player/player_view_model.dart';

void main() {
  const catVideo = VideoItem(
    url: '/media/cats/a.mp4',
    name: 'a.mp4',
    collection: 'cats',
    thumbnailUrl: '/media/cats/a.jpg',
  );
  const dogVideo = VideoItem(
    url: '/media/dogs/b.mp4',
    name: 'b.mp4',
    collection: 'dogs',
    thumbnailUrl: '/media/dogs/b.jpg',
  );
  const zebraVideo = VideoItem(
    url: '/media/zebras/c.mp4',
    name: 'c.mp4',
    collection: 'zebras',
    thumbnailUrl: '/media/zebras/c.jpg',
  );

  final allVideos = [catVideo, dogVideo, zebraVideo];

  group('PlayerViewModel', () {
    test('init with videoList and startIndex returns correct currentVideo', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 1,
      );

      check(viewModel.currentVideo.url).equals('/media/dogs/b.mp4');
      check(viewModel.currentIndex).equals(1);
    });

    test('videoList returns the provided list', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 0,
      );

      check(viewModel.videoList.length).equals(3);
    });

    test('next goes to next video', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 0,
      );

      viewModel.next();

      check(viewModel.currentIndex).equals(1);
      check(viewModel.currentVideo.url).equals('/media/dogs/b.mp4');
    });

    test('next stays on last video when already at end', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 2,
      );

      viewModel.next();

      check(viewModel.currentIndex).equals(2);
      check(viewModel.currentVideo.url).equals('/media/zebras/c.mp4');
    });

    test('previous goes to previous video', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 2,
      );

      viewModel.previous();

      check(viewModel.currentIndex).equals(1);
      check(viewModel.currentVideo.url).equals('/media/dogs/b.mp4');
    });

    test('previous stays on first video when already at start', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 0,
      );

      viewModel.previous();

      check(viewModel.currentIndex).equals(0);
      check(viewModel.currentVideo.url).equals('/media/cats/a.mp4');
    });

    test('hasNext returns true when not at last video', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 0,
      );

      check(viewModel.hasNext).equals(true);
    });

    test('hasNext returns false when at last video', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 2,
      );

      check(viewModel.hasNext).equals(false);
    });

    test('hasPrevious returns true when not at first video', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 1,
      );

      check(viewModel.hasPrevious).equals(true);
    });

    test('hasPrevious returns false when at first video', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 0,
      );

      check(viewModel.hasPrevious).equals(false);
    });

    test('next notifies listeners', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 0,
      );

      var notified = false;
      viewModel.addListener(() {
        notified = true;
      });

      viewModel.next();

      check(notified).equals(true);
    });

    test('previous notifies listeners', () {
      final viewModel = PlayerViewModel(
        videoList: allVideos,
        startIndex: 2,
      );

      var notified = false;
      viewModel.addListener(() {
        notified = true;
      });

      viewModel.previous();

      check(notified).equals(true);
    });

    test('collection-only list limits navigation to that collection', () {
      final catVideos = [
        catVideo,
        const VideoItem(
          url: '/media/cats/d.mp4',
          name: 'd.mp4',
          collection: 'cats',
          thumbnailUrl: '/media/cats/d.jpg',
        ),
      ];

      final viewModel = PlayerViewModel(
        videoList: catVideos,
        startIndex: 0,
      );

      viewModel.next();
      check(viewModel.currentIndex).equals(1);

      viewModel.next();
      check(viewModel.currentIndex).equals(1);
      check(viewModel.videoList.length).equals(2);
    });
  });
}
