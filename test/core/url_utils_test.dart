import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/core/url_utils.dart';

void main() {
  group('resolveUrl', () {
    test('joins base url and relative path correctly', () {
      final result = resolveUrl('http://host:8080', '/media/cats/v.mp4');

      check(result).equals('http://host:8080/media/cats/v.mp4');
    });

    test('handles base url with trailing slash', () {
      final result = resolveUrl('http://host:8080/', '/media/cats/v.mp4');

      check(result).equals('http://host:8080/media/cats/v.mp4');
    });

    test('handles relative path without leading slash', () {
      final result = resolveUrl('http://host:8080', 'media/cats/v.mp4');

      check(result).equals('http://host:8080/media/cats/v.mp4');
    });

    test('handles both trailing and leading slashes', () {
      final result = resolveUrl('http://host:8080/', '/media/cats/v.mp4');

      check(result).equals('http://host:8080/media/cats/v.mp4');
    });
  });
}
