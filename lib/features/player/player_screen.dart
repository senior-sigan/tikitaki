import 'package:flutter/material.dart';
import 'package:tikitaki/core/url_utils.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/player/like_button.dart';
import 'package:tikitaki/features/player/next_video_preview.dart';
import 'package:tikitaki/features/player/player_view_model.dart';
import 'package:tikitaki/features/player/video_page.dart';
import 'package:tikitaki/features/player/video_progress_bar.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.playerViewModel,
    required this.favoritesViewModel,
    required this.baseUrl,
  });

  final PlayerViewModel playerViewModel;
  final FavoritesViewModel favoritesViewModel;
  final String baseUrl;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final PageController _pageController;
  final ValueNotifier<(Duration, Duration)> _progressNotifier = ValueNotifier((
    Duration.zero,
    Duration.zero,
  ));

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.playerViewModel.currentIndex,
    );
  }

  @override
  void dispose() {
    _progressNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    widget.playerViewModel.jumpToIndex(index);
    _progressNotifier.value = (Duration.zero, Duration.zero);
  }

  String _resolveVideoUrl(String relativePath) {
    return resolveUrl(widget.baseUrl, relativePath);
  }

  @override
  Widget build(BuildContext context) {
    final videos = widget.playerViewModel.videoList;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildPageView(videos),
          _buildBackButton(context),
          _buildLikeButton(),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildPageView(List<VideoItem> videos) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            final videoUrl = _resolveVideoUrl(videos[index].url);
            return VideoPage(
              videoUrl: videoUrl,
              progressNotifier: _progressNotifier,
            );
          },
        ),
        ListenableBuilder(
          listenable: widget.playerViewModel,
          builder: (context, _) {
            final vm = widget.playerViewModel;
            if (!vm.hasNext) return const SizedBox.shrink();
            final nextThumbnailUrl = _resolveVideoUrl(
              vm.videoList[vm.currentIndex + 1].thumbnailUrl,
            );
            return Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NextVideoPreview(
                pageController: _pageController,
                nextThumbnailUrl: nextThumbnailUrl,
                currentIndex: vm.currentIndex,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    );
  }

  Widget _buildLikeButton() {
    return Positioned(
      right: 16,
      bottom: 120,
      child: ListenableBuilder(
        listenable: widget.favoritesViewModel,
        builder: (context, _) {
          final currentVideo = widget.playerViewModel.currentVideo;
          final isFav = widget.favoritesViewModel.isFavorite(currentVideo.url);
          return LikeButton(
            isFavorite: isFav,
            onToggle: () => widget.favoritesViewModel.toggle(currentVideo.url),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ValueListenableBuilder<(Duration, Duration)>(
        valueListenable: _progressNotifier,
        builder: (context, progress, _) {
          return VideoProgressBar(position: progress.$1, duration: progress.$2);
        },
      ),
    );
  }
}
