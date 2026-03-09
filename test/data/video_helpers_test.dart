import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/data/video_helpers.dart';
import 'package:tikitaki/data/video_item.dart';

void main() {
  final catVideo1 = VideoItem(
    url: '/media/cats/a.mp4',
    name: 'a.mp4',
    collection: 'cats',
    thumbnailUrl: '/media/cats/a.jpg',
  );
  final catVideo2 = VideoItem(
    url: '/media/cats/b.mp4',
    name: 'b.mp4',
    collection: 'cats',
    thumbnailUrl: '/media/cats/b.jpg',
  );
  final dogVideo = VideoItem(
    url: '/media/dogs/c.mp4',
    name: 'c.mp4',
    collection: 'dogs',
    thumbnailUrl: '/media/dogs/c.jpg',
  );
  final zebraVideo = VideoItem(
    url: '/media/zebras/d.mp4',
    name: 'd.mp4',
    collection: 'zebras',
    thumbnailUrl: '/media/zebras/d.jpg',
  );

  group('sortByCollection', () {
    test('sorts video items by collection field alphabetically', () {
      final videos = [zebraVideo, dogVideo, catVideo1];

      final sorted = sortByCollection(videos);

      check(sorted[0].collection).equals('cats');
      check(sorted[1].collection).equals('dogs');
      check(sorted[2].collection).equals('zebras');
    });

    test('does not mutate original list', () {
      final videos = [dogVideo, catVideo1];

      sortByCollection(videos);

      check(videos[0].collection).equals('dogs');
    });
  });

  group('groupByCollection', () {
    test('groups video items by collection field', () {
      final videos = [catVideo1, dogVideo, catVideo2];

      final grouped = groupByCollection(videos);

      check(grouped.keys.length).equals(2);
      check(grouped['cats']?.length).equals(2);
      check(grouped['dogs']?.length).equals(1);
    });

    test('returns empty map for empty list', () {
      final grouped = groupByCollection([]);

      check(grouped.keys.length).equals(0);
    });
  });

  group('getCollectionPreviews', () {
    test('returns first video item for each collection', () {
      final videos = [catVideo1, catVideo2, dogVideo];

      final previews = getCollectionPreviews(videos);

      check(previews.length).equals(2);
      check(previews[0].url).equals('/media/cats/a.mp4');
      check(previews[1].url).equals('/media/dogs/c.mp4');
    });

    test('returns empty list for empty input', () {
      final previews = getCollectionPreviews([]);

      check(previews.length).equals(0);
    });
  });
}
