import 'package:flutter/material.dart';
import 'package:tikitaki/core/url_utils.dart';
import 'package:tikitaki/core/widgets/video_thumbnail.dart';
import 'package:tikitaki/data/video_item.dart';

class VideoGrid extends StatelessWidget {
  const VideoGrid({
    super.key,
    required this.videos,
    required this.baseUrl,
    this.onVideoTap,
    this.onRefresh,
  });

  final List<VideoItem> videos;
  final String baseUrl;
  final void Function(VideoItem video, int index)? onVideoTap;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final grid = GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 3 / 4,
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

    final refresh = onRefresh;
    if (refresh != null) {
      return RefreshIndicator(onRefresh: refresh, child: grid);
    }
    return grid;
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
            Expanded(child: VideoThumbnail(thumbnailUrl: thumbnailUrl)),
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
