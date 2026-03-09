import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/data/video_repository.dart';
import 'package:tikitaki/features/collections/collections_view_model.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

class MockVideoRepository extends Mock implements VideoRepository {}

void main() {
  late MockVideoRepository mockRepository;
  late VideoListViewModel videoListViewModel;
  late CollectionsViewModel collectionsViewModel;

  const catVideo1 = VideoItem(
    url: '/media/cats/a.mp4',
    name: 'a.mp4',
    collection: 'cats',
    thumbnailUrl: '/media/cats/a.jpg',
  );
  const catVideo2 = VideoItem(
    url: '/media/cats/b.mp4',
    name: 'b.mp4',
    collection: 'cats',
    thumbnailUrl: '/media/cats/b.jpg',
  );
  const dogVideo = VideoItem(
    url: '/media/dogs/c.mp4',
    name: 'c.mp4',
    collection: 'dogs',
    thumbnailUrl: '/media/dogs/c.jpg',
  );

  setUp(() {
    mockRepository = MockVideoRepository();
    videoListViewModel = VideoListViewModel(repository: mockRepository);
    collectionsViewModel =
        CollectionsViewModel(videoListViewModel: videoListViewModel);
  });

  tearDown(() {
    collectionsViewModel.dispose();
    videoListViewModel.dispose();
  });

  group('CollectionsViewModel', () {
    test('collections returns grouped videos from loaded data', () async {
      when(() => mockRepository.getVideos())
          .thenAnswer((_) async => [catVideo1, catVideo2, dogVideo]);

      await videoListViewModel.load();

      final collections = collectionsViewModel.collections;
      check(collections.keys.length).equals(2);
      check(collections['cats']?.length).equals(2);
      check(collections['dogs']?.length).equals(1);
    });

    test('collections returns empty map when no videos loaded', () {
      final collections = collectionsViewModel.collections;
      check(collections.keys.length).equals(0);
    });

    test('collectionPreviews returns name and first video per collection',
        () async {
      when(() => mockRepository.getVideos())
          .thenAnswer((_) async => [catVideo1, catVideo2, dogVideo]);

      await videoListViewModel.load();

      final previews = collectionsViewModel.collectionPreviews;
      check(previews.length).equals(2);
      check(previews[0].name).equals('cats');
      check(previews[0].preview.url).equals('/media/cats/a.mp4');
      check(previews[1].name).equals('dogs');
      check(previews[1].preview.url).equals('/media/dogs/c.mp4');
    });

    test('notifies listeners when video list changes', () async {
      var notified = false;
      collectionsViewModel.addListener(() {
        notified = true;
      });

      when(() => mockRepository.getVideos())
          .thenAnswer((_) async => [catVideo1]);

      await videoListViewModel.load();

      check(notified).equals(true);
    });
  });
}
