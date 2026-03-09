import 'package:flutter/material.dart';
import 'package:tikitaki/core/url_utils.dart';
import 'package:tikitaki/data/video_item.dart';

class VideoGrid extends StatelessWidget {
  const VideoGrid({
    required this.videos,
    required this.baseUrl,
    this.onVideoTap,
    super.key,
  });

  final List<VideoItem> videos;
  final String baseUrl;
  final void Function(VideoItem video, int index)? onVideoTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _VideoGridTile(
          video: video,
          baseUrl: baseUrl,
          onTap: () => onVideoTap?.call(video, index),
        );
      },
    );
  }
}

class _VideoGridTile extends StatelessWidget {
  const _VideoGridTile({
    required this.video,
    required this.baseUrl,
    this.onTap,
  });

  final VideoItem video;
  final String baseUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = resolveUrl(baseUrl, video.thumbnailUrl);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                video.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
