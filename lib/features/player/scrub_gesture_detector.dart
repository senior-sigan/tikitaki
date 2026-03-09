import 'package:flutter/material.dart';

class ScrubGestureDetector extends StatefulWidget {
  const ScrubGestureDetector({
    super.key,
    required this.onScrubStart,
    required this.onScrubUpdate,
    required this.onScrubEnd,
    required this.child,
  });

  final VoidCallback onScrubStart;
  final ValueChanged<double> onScrubUpdate;
  final VoidCallback onScrubEnd;
  final Widget child;

  @override
  State<ScrubGestureDetector> createState() => _ScrubGestureDetectorState();
}

class _ScrubGestureDetectorState extends State<ScrubGestureDetector> {
  double _startX = 0;

  void _onLongPressStart(LongPressStartDetails details) {
    _startX = details.globalPosition.dx;
    widget.onScrubStart();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth == 0) return;
    final deltaX = details.globalPosition.dx - _startX;
    final fraction = deltaX / screenWidth;
    widget.onScrubUpdate(fraction);
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    widget.onScrubEnd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: _onLongPressStart,
      onLongPressMoveUpdate: _onLongPressMoveUpdate,
      onLongPressEnd: _onLongPressEnd,
      child: widget.child,
    );
  }
}
