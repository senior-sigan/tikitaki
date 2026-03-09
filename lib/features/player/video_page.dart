import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tikitaki/features/player/scrub_gesture_detector.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({
    super.key,
    required this.videoUrl,
    required this.progressNotifier,
  });

  final String videoUrl;
  final ValueNotifier<(Duration, Duration)> progressNotifier;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  Duration _scrubStartPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      _controller = controller;
      controller.addListener(_onVideoUpdate);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      log('Failed to initialize video: $e', name: 'VideoPage');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _onVideoUpdate() {
    if (!mounted) return;
    final controller = _controller;
    if (controller == null) return;
    final position = controller.value.position;
    final duration = controller.value.duration;
    widget.progressNotifier.value = (position, duration);
  }

  void _togglePlayPause() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _onScrubStart() {
    final controller = _controller;
    if (controller == null) return;
    _scrubStartPosition = controller.value.position;
    controller.pause();
  }

  void _onScrubUpdate(double fraction) {
    final controller = _controller;
    if (controller == null) return;
    final totalDuration = controller.value.duration;
    final offset = totalDuration * fraction;
    final target = _scrubStartPosition + offset;
    final clamped = _clampDuration(target, totalDuration);
    controller.seekTo(clamped);
  }

  void _onScrubEnd() {
    _controller?.play();
  }

  Duration _clampDuration(Duration value, Duration max) {
    if (value < Duration.zero) return Duration.zero;
    if (value > max) return max;
    return value;
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoUpdate);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Icon(Icons.error_outline, color: Colors.white, size: 48),
      );
    }
    final controller = _controller;
    if (!_isInitialized || controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return ScrubGestureDetector(
      onScrubStart: _onScrubStart,
      onScrubUpdate: _onScrubUpdate,
      onScrubEnd: _onScrubEnd,
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}
