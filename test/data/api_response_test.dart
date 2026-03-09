import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/data/api_response.dart';

void main() {
  group('ApiResponse', () {
    test('fromJson parses items list correctly', () {
      final json = {
        'items': [
          {
            'url': '/media/cats/funny.mp4',
            'name': 'funny.mp4',
            'collection': 'cats',
            'thumbnail_url': '/media/cats/funny.jpg',
          },
          {
            'url': '/media/dogs/bark.mp4',
            'name': 'bark.mp4',
            'collection': 'dogs',
            'thumbnail_url': '/media/dogs/bark.jpg',
          },
        ],
      };

      final response = ApiResponse.fromJson(json);

      check(response.items.length).equals(2);
      check(response.items[0].url).equals('/media/cats/funny.mp4');
      check(response.items[0].collection).equals('cats');
      check(response.items[1].url).equals('/media/dogs/bark.mp4');
      check(response.items[1].collection).equals('dogs');
    });

    test('fromJson parses empty items list', () {
      final json = {'items': <Map<String, dynamic>>[]};

      final response = ApiResponse.fromJson(json);

      check(response.items.length).equals(0);
    });
  });
}
