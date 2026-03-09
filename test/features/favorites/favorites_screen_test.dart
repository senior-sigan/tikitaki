import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/favorites/favorites_screen.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

class FakeVideoListViewModel extends ChangeNotifier
    implements VideoListViewModel {
  @override
  VideoListState get state => VideoListState.loaded;

  @override
  List<VideoItem> get videos => const [];

  @override
  String? get errorMessage => null;

  @override
  Future<void> load() async {}

  @override
  Future<void> refresh() async {}
}

class FakeFavoritesViewModel extends ChangeNotifier
    implements FavoritesViewModel {
  List<VideoItem> _favoriteVideos = [];

  @override
  List<VideoItem> get favoriteVideos => _favoriteVideos;

  @override
  bool isFavorite(String url) => true;

  @override
  Future<void> toggle(String url) async {}

  void setFavorites(List<VideoItem> videos) {
    _favoriteVideos = videos;
    notifyListeners();
  }
}

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
  late FakeFavoritesViewModel fakeFavoritesVM;

  setUp(() {
    fakeFavoritesVM = FakeFavoritesViewModel();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: FavoritesScreen(
        favoritesViewModel: fakeFavoritesVM,
        baseUrl: 'http://localhost:8080',
      ),
    );
  }

  group('FavoritesScreen', () {
    testWidgets('shows empty state message when no favorites', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.textContaining('No favorites'), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('shows grid of favorite videos when there are favorites', (
      tester,
    ) async {
      fakeFavoritesVM.setFavorites(_testVideos);

      await tester.pumpWidget(buildSubject());

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('rebuilds when favorites change', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.textContaining('No favorites'), findsOneWidget);

      fakeFavoritesVM.setFavorites(_testVideos);
      await tester.pump();

      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
