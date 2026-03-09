import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/data/video_repository.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

class MockVideoRepository extends Mock implements VideoRepository {}

void main() {
  late MockVideoRepository mockRepository;
  late VideoListViewModel viewModel;

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
  const zebraVideo = VideoItem(
    url: '/media/zebras/c.mp4',
    name: 'c.mp4',
    collection: 'zebras',
    thumbnailUrl: '/media/zebras/c.jpg',
  );

  setUp(() {
    mockRepository = MockVideoRepository();
    viewModel = VideoListViewModel(repository: mockRepository);
  });

  group('VideoListViewModel', () {
    test('initial state is initial with empty videos', () {
      check(viewModel.state).equals(VideoListState.initial);
      check(viewModel.videos.length).equals(0);
      check(viewModel.errorMessage).isNull();
    });

    test('load transitions from initial to loading to loaded', () async {
      final states = <VideoListState>[];
      viewModel.addListener(() {
        states.add(viewModel.state);
      });

      when(() => mockRepository.getVideos())
          .thenAnswer((_) async => [catVideo, dogVideo]);

      await viewModel.load();

      check(states).deepEquals([VideoListState.loading, VideoListState.loaded]);
      check(viewModel.videos.length).equals(2);
    });

    test('load transitions from initial to loading to error on failure',
        () async {
      final states = <VideoListState>[];
      viewModel.addListener(() {
        states.add(viewModel.state);
      });

      when(() => mockRepository.getVideos())
          .thenThrow(Exception('Network error'));

      await viewModel.load();

      check(states).deepEquals([VideoListState.loading, VideoListState.error]);
      check(viewModel.errorMessage).equals('Exception: Network error');
    });

    test('videos getter returns list sorted by collection', () async {
      when(() => mockRepository.getVideos())
          .thenAnswer((_) async => [zebraVideo, catVideo, dogVideo]);

      await viewModel.load();

      check(viewModel.videos[0].collection).equals('cats');
      check(viewModel.videos[1].collection).equals('dogs');
      check(viewModel.videos[2].collection).equals('zebras');
    });

    test('refresh reloads data from repository', () async {
      when(() => mockRepository.getVideos())
          .thenAnswer((_) async => [catVideo]);

      await viewModel.load();
      check(viewModel.videos.length).equals(1);

      when(() => mockRepository.getVideos())
          .thenAnswer((_) async => [catVideo, dogVideo]);

      await viewModel.refresh();
      check(viewModel.videos.length).equals(2);
    });

    test('refresh calls repository getVideos', () async {
      when(() => mockRepository.getVideos())
          .thenAnswer((_) async => [catVideo]);

      await viewModel.refresh();

      verify(() => mockRepository.getVideos()).called(1);
    });
  });
}
