import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({
    super.key,
    required this.videoUrl,
    required this.onProgressUpdate,
  });

  final String videoUrl;
  final void Function(Duration position, Duration duration) onProgressUpdate;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller.addListener(_onVideoUpdate);
    await _controller.initialize();
    await _controller.setLooping(true);
    await _controller.play();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _onVideoUpdate() {
    if (!mounted) return;
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    widget.onProgressUpdate(position, duration);
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
