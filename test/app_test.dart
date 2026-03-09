import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tikitaki/app.dart';
import 'package:tikitaki/data/favorites_repository.dart';
import 'package:tikitaki/data/settings_repository.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/data/video_repository.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

class MockVideoRepository extends Mock implements VideoRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late VideoListViewModel videoListViewModel;
  late CollectionsViewModel collectionsViewModel;
  late FavoritesViewModel favoritesViewModel;
  late MockVideoRepository mockVideoRepo;
  late MockFavoritesRepository mockFavoritesRepo;
  late MockSettingsRepository mockSettingsRepo;

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

    videoListViewModel = VideoListViewModel(repository: mockVideoRepo);
    collectionsViewModel = CollectionsViewModel(
      videoListViewModel: videoListViewModel,
    );
    favoritesViewModel = FavoritesViewModel(
      favoritesRepository: mockFavoritesRepo,
      videoListViewModel: videoListViewModel,
    );
  });

  tearDown(() {
    favoritesViewModel.dispose();
    collectionsViewModel.dispose();
    videoListViewModel.dispose();
  });

  Widget buildSubject() {
    return TikiTakiApp(
      videoListViewModel: videoListViewModel,
      collectionsViewModel: collectionsViewModel,
      favoritesViewModel: favoritesViewModel,
      settingsRepository: mockSettingsRepo,
      baseUrl: 'http://localhost:8080',
    );
  }

  group('TikiTakiApp', () {
    testWidgets('renders MaterialApp with dark theme', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      check(materialApp.themeMode).equals(ThemeMode.dark);
      check(materialApp.debugShowCheckedModeBanner).equals(false);
    });

    testWidgets('has floating toolbar with 4 icon buttons', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final iconButtons = find.byType(IconButton);
      check(iconButtons.evaluate().length).equals(4);

      check(find.byIcon(Icons.history).evaluate().isNotEmpty).equals(true);
      check(find.byIcon(Icons.collections).evaluate().isNotEmpty).equals(true);
      check(find.byIcon(Icons.favorite).evaluate().isNotEmpty).equals(true);
      check(find.byIcon(Icons.settings).evaluate().isNotEmpty).equals(true);
    });

    testWidgets('uses dark brightness in theme', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final context = tester.element(find.byType(IconButton).first);
      final theme = Theme.of(context);
      check(theme.brightness).equals(Brightness.dark);
    });

    testWidgets('shows History screen on initial route', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // History screen shows SliverAppBar with "History" title
      expect(find.byType(SliverAppBar), findsOneWidget);
      // The History text appears in the SliverAppBar
      check(find.text('History').evaluate().length).isGreaterOrEqual(1);
    });
  });
}
