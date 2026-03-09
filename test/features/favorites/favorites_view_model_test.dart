import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tikitaki/data/favorites_repository.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/data/video_repository.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockVideoRepository extends Mock implements VideoRepository {}

void main() {
  late MockFavoritesRepository mockFavoritesRepository;
  late MockVideoRepository mockVideoRepository;
  late VideoListViewModel videoListViewModel;
  late FavoritesViewModel favoritesViewModel;

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

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    mockVideoRepository = MockVideoRepository();
    videoListViewModel = VideoListViewModel(repository: mockVideoRepository);
    favoritesViewModel = FavoritesViewModel(
      favoritesRepository: mockFavoritesRepository,
      videoListViewModel: videoListViewModel,
    );
  });

  tearDown(() {
    favoritesViewModel.dispose();
    videoListViewModel.dispose();
  });

  group('FavoritesViewModel', () {
    test('favoriteVideos returns only favorited videos', () async {
      when(() => mockVideoRepository.getVideos())
          .thenAnswer((_) async => [catVideo, dogVideo]);
      when(() => mockFavoritesRepository.getFavoriteVideos(any()))
          .thenReturn([catVideo]);

      await videoListViewModel.load();

      final favorites = favoritesViewModel.favoriteVideos;
      check(favorites.length).equals(1);
      check(favorites[0].url).equals('/media/cats/a.mp4');
    });

    test('favoriteVideos returns empty list when no favorites', () async {
      when(() => mockVideoRepository.getVideos())
          .thenAnswer((_) async => [catVideo, dogVideo]);
      when(() => mockFavoritesRepository.getFavoriteVideos(any()))
          .thenReturn([]);

      await videoListViewModel.load();

      check(favoritesViewModel.favoriteVideos.length).equals(0);
    });

    test('toggle calls repository toggle and notifies listeners', () async {
      when(() => mockFavoritesRepository.toggle(any()))
          .thenAnswer((_) async {});

      var notified = false;
      favoritesViewModel.addListener(() {
        notified = true;
      });

      await favoritesViewModel.toggle('/media/cats/a.mp4');

      verify(() => mockFavoritesRepository.toggle('/media/cats/a.mp4'))
          .called(1);
      check(notified).equals(true);
    });

    test('isFavorite returns correct status from repository', () {
      when(() => mockFavoritesRepository.isFavorite('/media/cats/a.mp4'))
          .thenReturn(true);
      when(() => mockFavoritesRepository.isFavorite('/media/dogs/b.mp4'))
          .thenReturn(false);

      check(favoritesViewModel.isFavorite('/media/cats/a.mp4')).equals(true);
      check(favoritesViewModel.isFavorite('/media/dogs/b.mp4')).equals(false);
    });

    test('notifies listeners when video list changes', () async {
      var notifyCount = 0;
      favoritesViewModel.addListener(() {
        notifyCount++;
      });

      when(() => mockVideoRepository.getVideos())
          .thenAnswer((_) async => [catVideo]);

      await videoListViewModel.load();

      // VideoListViewModel notifies twice (loading + loaded),
      // so FavoritesViewModel should forward those.
      check(notifyCount).isGreaterThan(0);
    });
  });
}
