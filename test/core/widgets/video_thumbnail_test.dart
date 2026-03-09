import 'package:cached_network_image/cached_network_image.dart';
import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/core/widgets/video_thumbnail.dart';

void main() {
  group('VideoThumbnail', () {
    testWidgets('displays CachedNetworkImage with the passed thumbnail URL',
        (tester) async {
      const url = 'https://example.com/thumb.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoThumbnail(thumbnailUrl: url),
          ),
        ),
      );

      final finder = find.byType(CachedNetworkImage);
      check(finder.evaluate().length).equals(1);

      final widget = tester.widget<CachedNetworkImage>(finder);
      check(widget.imageUrl).equals(url);
    });
  });
}
