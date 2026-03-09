import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikitaki/data/shared_preferences_favorites_repository.dart';
import 'package:tikitaki/data/video_item.dart';

void main() {
  group('SharedPreferencesFavoritesRepository', () {
    late SharedPreferencesFavoritesRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repository = SharedPreferencesFavoritesRepository(prefs);
    });

    group('toggle', () {
      test('toggle_addUrl_urlBecomesFavorite', () async {
        const url = 'https://example.com/video1.mp4';

        await repository.toggle(url);

        check(repository.isFavorite(url)).isTrue();
      });

      test('toggle_calledTwice_removesUrl', () async {
        const url = 'https://example.com/video1.mp4';

        await repository.toggle(url);
        await repository.toggle(url);

        check(repository.isFavorite(url)).isFalse();
      });
    });

    group('isFavorite', () {
      test('isFavorite_noFavorites_returnsFalse', () {
        check(repository.isFavorite('https://example.com/none.mp4')).isFalse();
      });

      test('isFavorite_addedUrl_returnsTrue', () async {
        const url = 'https://example.com/video1.mp4';
        await repository.toggle(url);

        check(repository.isFavorite(url)).isTrue();
      });

      test('isFavorite_differentUrl_returnsFalse', () async {
        await repository.toggle('https://example.com/video1.mp4');

        check(
          repository.isFavorite('https://example.com/video2.mp4'),
        ).isFalse();
      });
    });

    group('getAll', () {
      test('getAll_noFavorites_returnsEmptySet', () {
        check(repository.getAll()).isEmpty();
      });

      test('getAll_multipleFavorites_returnsAllUrls', () async {
        const url1 = 'https://example.com/video1.mp4';
        const url2 = 'https://example.com/video2.mp4';
        await repository.toggle(url1);
        await repository.toggle(url2);

        final all = repository.getAll();

        check(all).length.equals(2);
        check(all).contains(url1);
        check(all).contains(url2);
      });
    });

    group('getFavoriteVideos', () {
      test('getFavoriteVideos_noFavorites_returnsEmptyList', () {
        final videos = [
          const VideoItem(
            url: 'https://example.com/video1.mp4',
            name: 'Video 1',
            collection: 'col1',
            thumbnailUrl: 'https://example.com/thumb1.jpg',
          ),
        ];

        check(repository.getFavoriteVideos(videos)).isEmpty();
      });

      test('getFavoriteVideos_withFavorites_returnsOnlyFavorited', () async {
        const url1 = 'https://example.com/video1.mp4';
        const url2 = 'https://example.com/video2.mp4';
        final video1 = const VideoItem(
          url: url1,
          name: 'Video 1',
          collection: 'col1',
          thumbnailUrl: 'https://example.com/thumb1.jpg',
        );
        final video2 = const VideoItem(
          url: url2,
          name: 'Video 2',
          collection: 'col1',
          thumbnailUrl: 'https://example.com/thumb2.jpg',
        );

        await repository.toggle(url1);

        final result = repository.getFavoriteVideos([video1, video2]);

        check(result).length.equals(1);
        check(result.first.url).equals(url1);
      });
    });

    group('persistence', () {
      test('persistence_reloadsFromSharedPreferences', () async {
        const url = 'https://example.com/video1.mp4';
        await repository.toggle(url);

        // Create a new repository from the same SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final newRepository = SharedPreferencesFavoritesRepository(prefs);

        check(newRepository.isFavorite(url)).isTrue();
      });
    });
  });
}
