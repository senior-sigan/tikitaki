import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/data/video_item.dart';

void main() {
  group('VideoItem', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'url': '/media/cats/funny.mp4',
        'name': 'funny.mp4',
        'collection': 'cats',
        'thumbnail_url': '/media/cats/funny.jpg',
      };

      final item = VideoItem.fromJson(json);

      check(item.url).equals('/media/cats/funny.mp4');
      check(item.name).equals('funny.mp4');
      check(item.collection).equals('cats');
      check(item.thumbnailUrl).equals('/media/cats/funny.jpg');
    });

    test('fromJson handles different values', () {
      final json = {
        'url': '/media/dogs/bark.mp4',
        'name': 'bark.mp4',
        'collection': 'dogs',
        'thumbnail_url': '/media/dogs/bark.jpg',
      };

      final item = VideoItem.fromJson(json);

      check(item.url).equals('/media/dogs/bark.mp4');
      check(item.name).equals('bark.mp4');
      check(item.collection).equals('dogs');
      check(item.thumbnailUrl).equals('/media/dogs/bark.jpg');
    });
  });
}
