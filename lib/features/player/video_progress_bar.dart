import 'package:flutter/material.dart';

class VideoProgressBar extends StatelessWidget {
  const VideoProgressBar({
    super.key,
    required this.position,
    required this.duration,
  });

  final Duration position;
  final Duration duration;

  double get _progress {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _progress,
      backgroundColor: Colors.white24,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      minHeight: 3,
    );
  }
}
