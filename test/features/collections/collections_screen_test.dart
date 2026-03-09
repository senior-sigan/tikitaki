import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/collections/collections_screen.dart';
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
  List<({String name, VideoItem preview})> _previews = [];

  @override
  Map<String, List<VideoItem>> get collections => {};

  @override
  List<({String name, VideoItem preview})> get collectionPreviews => _previews;

  void setPreviews(List<({String name, VideoItem preview})> p) {
    _previews = p;
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

const _catVideo = VideoItem(
  url: '/media/cats/a.mp4',
  name: 'a.mp4',
  collection: 'cats',
  thumbnailUrl: '/media/cats/a.jpg',
);

const _dogVideo = VideoItem(
  url: '/media/dogs/b.mp4',
  name: 'b.mp4',
  collection: 'dogs',
  thumbnailUrl: '/media/dogs/b.jpg',
);

void main() {
  late FakeCollectionsViewModel fakeCollectionsVM;

  setUp(() {
    fakeCollectionsVM = FakeCollectionsViewModel();
  });

  Widget buildSubject({void Function(String)? onCollectionTap}) {
    return MaterialApp(
      home: CollectionsScreen(
        collectionsViewModel: fakeCollectionsVM,
        baseUrl: 'http://localhost:8080',
        onCollectionTap: onCollectionTap,
      ),
    );
  }

  group('CollectionsScreen', () {
    testWidgets('shows grid of collections with name and preview thumbnail', (
      tester,
    ) async {
      fakeCollectionsVM.setPreviews([
        (name: 'cats', preview: _catVideo),
        (name: 'dogs', preview: _dogVideo),
      ]);

      await tester.pumpWidget(buildSubject());

      expect(find.text('cats'), findsOneWidget);
      expect(find.text('dogs'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('tapping a collection calls onCollectionTap', (tester) async {
      String? tappedCollection;

      fakeCollectionsVM.setPreviews([(name: 'cats', preview: _catVideo)]);

      await tester.pumpWidget(
        buildSubject(
          onCollectionTap: (name) {
            tappedCollection = name;
          },
        ),
      );

      await tester.tap(find.text('cats'));
      await tester.pumpAndSettle();

      check(tappedCollection).equals('cats');
    });

    testWidgets('shows empty state when no collections', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byType(GridView), findsNothing);
    });
  });
}
