import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tikitaki/core/app_router.dart';
import 'package:tikitaki/core/app_theme.dart';
import 'package:tikitaki/data/favorites_repository.dart';
import 'package:tikitaki/data/settings_repository.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/data/video_repository.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../helpers/fake_video_player_platform.dart';

class MockVideoRepository extends Mock implements VideoRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  group('appRouter', () {
    late GoRouter router;
    late VideoListViewModel videoListVM;
    late CollectionsViewModel collectionsVM;
    late FavoritesViewModel favoritesVM;
    late MockVideoRepository mockVideoRepo;
    late MockFavoritesRepository mockFavoritesRepo;
    late MockSettingsRepository mockSettingsRepo;

    setUpAll(() {
      VideoPlayerPlatform.instance = FakeVideoPlayerPlatform();
    });

    setUp(() {
      mockVideoRepo = MockVideoRepository();
      mockFavoritesRepo = MockFavoritesRepository();
      mockSettingsRepo = MockSettingsRepository();

      when(() => mockFavoritesRepo.isFavorite(any())).thenReturn(false);
      when(
        () => mockFavoritesRepo.getFavoriteVideos(any()),
      ).thenReturn(const <VideoItem>[]);
      when(() => mockFavoritesRepo.getAll()).thenReturn(const <String>{});
      when(
        () => mockSettingsRepo.getBaseUrl(),
      ).thenAnswer((_) async => 'http://localhost:8080');
      when(() => mockSettingsRepo.setBaseUrl(any())).thenAnswer((_) async {});

      videoListVM = VideoListViewModel(repository: mockVideoRepo);
      collectionsVM = CollectionsViewModel(videoListViewModel: videoListVM);
      favoritesVM = FavoritesViewModel(
        favoritesRepository: mockFavoritesRepo,
        videoListViewModel: videoListVM,
      );

      router = createAppRouter(
        videoListViewModel: videoListVM,
        collectionsViewModel: collectionsVM,
        favoritesViewModel: favoritesVM,
        settingsRepository: mockSettingsRepo,
        baseUrl: 'http://localhost:8080',
      );
    });

    tearDown(() {
      favoritesVM.dispose();
      collectionsVM.dispose();
      videoListVM.dispose();
    });

    Widget buildApp() {
      return MaterialApp.router(routerConfig: router, theme: appTheme);
    }

    testWidgets('navigates to / and shows History', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      check(find.text('History').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('navigates to /collections and shows Collections', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      router.go('/collections');
      await tester.pump();

      check(find.text('Collections').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('navigates to /collections/:name and shows collection detail', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      router.go('/collections/my-collection');
      await tester.pump();

      check(find.text('my-collection').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('navigates to /favorites and shows Favorites', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      router.go('/favorites');
      await tester.pump();

      check(find.text('Favorites').evaluate().isNotEmpty).equals(true);
    });

    testWidgets('navigates to /settings and shows Settings', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      router.go('/settings');
      await tester.pumpAndSettle();

      check(find.text('Settings').evaluate().isNotEmpty).equals(true);
    });

    testWidgets(
      'navigates to /player without data and shows fallback message',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pump();

        router.go('/player');
        await tester.pump();
        await tester.pump();

        check(
          find.text('No video data provided').evaluate().isNotEmpty,
        ).equals(true);
      },
    );

    testWidgets('bottom navigation is visible on shell routes', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      check(find.byType(NavigationBar).evaluate().isNotEmpty).equals(true);
    });
  });
}
