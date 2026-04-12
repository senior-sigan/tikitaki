import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/collections/collection_detail_screen.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
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

class FakeCollectionsViewModel extends ChangeNotifier
    implements CollectionsViewModel {
  Map<String, List<VideoItem>> _collections = {};

  @override
  Map<String, List<VideoItem>> get collections => _collections;

  @override
  List<({String name, VideoItem preview})> get collectionPreviews => [];

  @override
  CollectionSortOrder get sortOrder => CollectionSortOrder.apiOrder;

  @override
  void setSortOrder(CollectionSortOrder value) {}

  void setCollections(Map<String, List<VideoItem>> c) {
    _collections = c;
    notifyListeners();
  }
}

class FakeFavoritesViewModel extends ChangeNotifier
    implements FavoritesViewModel {
  @override
  List<VideoItem> get favoriteVideos => [];

  @override
  bool isFavorite(String url) => false;

  @override
  Future<void> toggle(String url) async {}
}

const _catVideos = [
  VideoItem(
    url: '/media/cats/a.mp4',
    name: 'a.mp4',
    collection: 'cats',
    thumbnailUrl: '/media/cats/a.jpg',
  ),
  VideoItem(
    url: '/media/cats/b.mp4',
    name: 'b.mp4',
    collection: 'cats',
    thumbnailUrl: '/media/cats/b.jpg',
  ),
];

void main() {
  late FakeCollectionsViewModel fakeCollectionsVM;
  late FakeFavoritesViewModel fakeFavoritesVM;

  setUp(() {
    fakeCollectionsVM = FakeCollectionsViewModel();
    fakeFavoritesVM = FakeFavoritesViewModel();
  });

  Widget buildSubject({String collectionName = 'cats'}) {
    return MaterialApp(
      home: CollectionDetailScreen(
        collectionName: collectionName,
        collectionsViewModel: fakeCollectionsVM,
        favoritesViewModel: fakeFavoritesVM,
        baseUrl: 'http://localhost:8080',
      ),
    );
  }

  group('CollectionDetailScreen', () {
    testWidgets('shows collection name in AppBar', (tester) async {
      fakeCollectionsVM.setCollections({'cats': _catVideos});

      await tester.pumpWidget(buildSubject());

      expect(find.text('cats'), findsOneWidget);
    });

    testWidgets('shows grid of videos for that collection only', (
      tester,
    ) async {
      fakeCollectionsVM.setCollections({'cats': _catVideos});

      await tester.pumpWidget(buildSubject());

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('shows empty state when collection not found', (tester) async {
      fakeCollectionsVM.setCollections({});

      await tester.pumpWidget(buildSubject(collectionName: 'unknown'));

      expect(find.byType(GridView), findsNothing);
      expect(find.textContaining('No videos'), findsOneWidget);
    });
  });
}
