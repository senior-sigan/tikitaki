import 'package:flutter/material.dart';
import 'package:tikitaki/core/url_utils.dart';
import 'package:tikitaki/core/widgets/video_thumbnail.dart';
import 'package:tikitaki/data/video_item.dart';

class VideoGrid extends StatelessWidget {
  const VideoGrid({
    super.key,
    required this.videos,
    required this.baseUrl,
    required this.onVideoTap,
    this.onRefresh,
  });

  final List<VideoItem> videos;
  final String baseUrl;
  final ValueChanged<int> onVideoTap;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final grid = GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
      ),
      itemCount: videos.length,
      itemBuilder: _buildCell,
    );

    final refresh = onRefresh;
    if (refresh != null) {
      return RefreshIndicator(onRefresh: refresh, child: grid);
    }
    return grid;
  }

  Widget _buildCell(BuildContext context, int index) {
    final video = videos[index];
    final url = resolveUrl(baseUrl, video.thumbnailUrl);
    return GestureDetector(
      onTap: () => onVideoTap(index),
      child: VideoThumbnail(thumbnailUrl: url),
    );
  }
}
