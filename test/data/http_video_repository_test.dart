import 'dart:convert';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tikitaki/data/http_video_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late HttpVideoRepository repository;

  setUp(() {
    mockClient = MockHttpClient();
    repository = HttpVideoRepository(
      client: mockClient,
      baseUrl: 'http://localhost:8080',
    );
  });

  group('HttpVideoRepository', () {
    test('getVideos makes GET to baseUrl/api and parses response', () async {
      final responseBody = jsonEncode({
        'items': [
          {
            'url': '/media/cats/funny.mp4',
            'name': 'funny.mp4',
            'collection': 'cats',
            'thumbnail_url': '/media/cats/funny.jpg',
          },
        ],
      });

      when(
        () => mockClient.get(Uri.parse('http://localhost:8080/api')),
      ).thenAnswer((_) async => http.Response(responseBody, 200));

      final videos = await repository.getVideos();

      check(videos.length).equals(1);
      check(videos[0].url).equals('/media/cats/funny.mp4');
      check(videos[0].name).equals('funny.mp4');
      check(videos[0].collection).equals('cats');
      check(videos[0].thumbnailUrl).equals('/media/cats/funny.jpg');

      verify(
        () => mockClient.get(Uri.parse('http://localhost:8080/api')),
      ).called(1);
    });

    test('getVideos throws exception on non-200 status code', () async {
      when(
        () => mockClient.get(Uri.parse('http://localhost:8080/api')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      await check(repository.getVideos()).throws<Exception>();
    });

    test('getVideos throws exception on network error', () async {
      when(
        () => mockClient.get(Uri.parse('http://localhost:8080/api')),
      ).thenThrow(Exception('Network error'));

      await check(repository.getVideos()).throws<Exception>();
    });
  });
}
