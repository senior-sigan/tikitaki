import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/history_screen.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

// Fake ViewModels that extend ChangeNotifier directly.
// This avoids the complexity of mocking addListener/removeListener.

class FakeVideoListViewModel extends ChangeNotifier
    implements VideoListViewModel {
  VideoListState _state = VideoListState.initial;
  List<VideoItem> _videos = const [];
  String? _errorMessage;

  @override
  VideoListState get state => _state;

  @override
  List<VideoItem> get videos => _videos;

  @override
  String? get errorMessage => _errorMessage;

  void setState(VideoListState s) {
    _state = s;
    notifyListeners();
  }

  void setVideos(List<VideoItem> v) {
    _videos = v;
  }

  void setErrorMessage(String? msg) {
    _errorMessage = msg;
  }

  @override
  Future<void> load() async {}

  @override
  Future<void> refresh() async {}
}

class FakeFavoritesViewModel extends ChangeNotifier
    implements FavoritesViewModel {
  final Set<String> _favorites = {};

  @override
  List<VideoItem> get favoriteVideos => [];

  @override
  bool isFavorite(String url) => _favorites.contains(url);

  @override
  Future<void> toggle(String url) async {
    if (_favorites.contains(url)) {
      _favorites.remove(url);
    } else {
      _favorites.add(url);
    }
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
  late FakeVideoListViewModel fakeVideoListVM;
  late FakeFavoritesViewModel fakeFavoritesVM;

  setUp(() {
    fakeVideoListVM = FakeVideoListViewModel();
    fakeFavoritesVM = FakeFavoritesViewModel();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: HistoryScreen(
        videoListViewModel: fakeVideoListVM,
        favoritesViewModel: fakeFavoritesVM,
        baseUrl: 'http://localhost:8080',
      ),
    );
  }

  group('HistoryScreen', () {
    testWidgets('shows CircularProgressIndicator when state is loading', (
      tester,
    ) async {
      fakeVideoListVM.setState(VideoListState.loading);

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows grid of videos when state is loaded', (tester) async {
      fakeVideoListVM.setVideos(_testVideos);
      fakeVideoListVM.setState(VideoListState.loaded);

      await tester.pumpWidget(buildSubject());

      expect(find.byType(GridView), findsOneWidget);
      // Should show video names or thumbnails
      check(tester.widgetList(find.byType(GridView)).length).equals(1);
    });

    testWidgets('shows error message when state is error', (tester) async {
      fakeVideoListVM.setErrorMessage('Network error');
      fakeVideoListVM.setState(VideoListState.error);

      await tester.pumpWidget(buildSubject());

      expect(find.textContaining('Network error'), findsOneWidget);
    });

    testWidgets('rebuilds when view model notifies listeners', (tester) async {
      fakeVideoListVM.setState(VideoListState.loading);
      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      fakeVideoListVM.setVideos(_testVideos);
      fakeVideoListVM.setState(VideoListState.loaded);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
