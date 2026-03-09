import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tikitaki/data/favorites_repository.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/data/video_repository.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';
import 'package:tikitaki/features/player/like_button.dart';
import 'package:tikitaki/features/player/player_screen.dart';
import 'package:tikitaki/features/player/player_view_model.dart';
import 'package:tikitaki/features/player/video_progress_bar.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../helpers/fake_video_player_platform.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockVideoRepository extends Mock implements VideoRepository {}

const _testVideos = [
  VideoItem(
    url: '/media/cats/a.mp4',
    name: 'a.mp4',
    collection: 'cats',
    thumbnailUrl: '/media/cats/a.jpg',
  ),
  VideoItem(
    url: '/media/dogs/b.mp4',
    name: 'b.mp4',
    collection: 'dogs',
    thumbnailUrl: '/media/dogs/b.jpg',
  ),
];

void main() {
  late PlayerViewModel playerViewModel;
  late FavoritesViewModel favoritesViewModel;
  late MockFavoritesRepository mockFavoritesRepo;
  late VideoListViewModel videoListViewModel;
  late MockVideoRepository mockVideoRepo;

  setUpAll(() {
    VideoPlayerPlatform.instance = FakeVideoPlayerPlatform();
  });

  setUp(() {
    mockFavoritesRepo = MockFavoritesRepository();
    mockVideoRepo = MockVideoRepository();
    videoListViewModel = VideoListViewModel(repository: mockVideoRepo);
    favoritesViewModel = FavoritesViewModel(
      favoritesRepository: mockFavoritesRepo,
      videoListViewModel: videoListViewModel,
    );
    playerViewModel = PlayerViewModel(videoList: _testVideos, startIndex: 0);

    when(() => mockFavoritesRepo.isFavorite(any())).thenReturn(false);
  });

  tearDown(() {
    favoritesViewModel.dispose();
    playerViewModel.dispose();
    videoListViewModel.dispose();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: PlayerScreen(
        playerViewModel: playerViewModel,
        favoritesViewModel: favoritesViewModel,
        baseUrl: 'https://example.com',
      ),
    );
  }

  group('PlayerScreen', () {
    testWidgets('has no AppBar (fullscreen)', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      check(find.byType(AppBar).evaluate().length).equals(0);
    });

    testWidgets('has a back button overlay', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back);
      check(backButton.evaluate().length).equals(1);
    });

    testWidgets('has a LikeButton overlay', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      check(find.byType(LikeButton).evaluate().length).equals(1);
    });

    testWidgets('has a VideoProgressBar overlay', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      check(find.byType(VideoProgressBar).evaluate().length).equals(1);
    });

    testWidgets('uses Scaffold with black background', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      check(scaffold.backgroundColor).equals(Colors.black);
    });

    testWidgets('uses PageView with vertical scroll', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final pageView = tester.widget<PageView>(find.byType(PageView));
      check(pageView.scrollDirection).equals(Axis.vertical);
    });
  });
}
