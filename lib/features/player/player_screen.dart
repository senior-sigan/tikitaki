import 'package:flutter/material.dart';
import 'package:tikitaki/core/url_utils.dart';
import 'package:tikitaki/features/favorites/favorites_view_model.dart';
import 'package:tikitaki/features/player/like_button.dart';
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
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.playerViewModel.currentIndex,
    );
    widget.favoritesViewModel.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    widget.favoritesViewModel.removeListener(_onFavoritesChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  void _onPageChanged(int index) {
    widget.playerViewModel.jumpToIndex(index);
    setState(() {
      _position = Duration.zero;
      _duration = Duration.zero;
    });
  }

  void _onProgressUpdate(Duration position, Duration duration) {
    if (mounted) {
      setState(() {
        _position = position;
        _duration = duration;
      });
    }
  }

  String _resolveVideoUrl(String relativePath) {
    return resolveUrl(widget.baseUrl, relativePath);
  }

  @override
  Widget build(BuildContext context) {
    final videos = widget.playerViewModel.videoList;
    final currentVideo = widget.playerViewModel.currentVideo;
    final isFav = widget.favoritesViewModel.isFavorite(currentVideo.url);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildPageView(videos),
          _buildBackButton(context),
          _buildLikeButton(isFav, currentVideo.url),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildPageView(List videos) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final videoUrl = _resolveVideoUrl(videos[index].url);
        return VideoPage(
          videoUrl: videoUrl,
          onProgressUpdate: _onProgressUpdate,
        );
      },
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

  Widget _buildLikeButton(bool isFav, String videoUrl) {
    return Positioned(
      right: 16,
      bottom: 120,
      child: LikeButton(
        isFavorite: isFav,
        onToggle: () => widget.favoritesViewModel.toggle(videoUrl),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: VideoProgressBar(position: _position, duration: _duration),
    );
  }
}
