import 'package:flutter/material.dart';
import 'package:tikitaki/core/widgets/video_thumbnail.dart';

class NextVideoPreview extends StatelessWidget {
  const NextVideoPreview({
    super.key,
    required this.pageController,
    required this.nextThumbnailUrl,
    required this.currentIndex,
  });

  final PageController pageController;
  final String nextThumbnailUrl;
  final int currentIndex;

  static const double peekHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        var dragProgress = 0.0;

        if (pageController.hasClients && pageController.page != null) {
          dragProgress = (pageController.page! - currentIndex).clamp(0.0, 1.0);
        }

        return Opacity(
          opacity: dragProgress,
          child: Transform.translate(
            offset: Offset(0, peekHeight * (1 - dragProgress)),
            child: child,
          ),
        );
      },
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: SizedBox(
          height: peekHeight,
          width: double.infinity,
          child: VideoThumbnail(thumbnailUrl: nextThumbnailUrl),
        ),
      ),
    );
  }
}
