import 'package:flutter/foundation.dart';
import 'package:tikitaki/data/video_item.dart';

class PlayerViewModel extends ChangeNotifier {
  PlayerViewModel({
    required List<VideoItem> videoList,
    required int startIndex,
  })  : _videoList = List.unmodifiable(videoList),
        _currentIndex = startIndex;

  final List<VideoItem> _videoList;
  int _currentIndex;

  VideoItem get currentVideo => _videoList[_currentIndex];
  int get currentIndex => _currentIndex;
  List<VideoItem> get videoList => _videoList;

  bool get hasNext => _currentIndex < _videoList.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  void next() {
    if (hasNext) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previous() {
    if (hasPrevious) {
      _currentIndex--;
      notifyListeners();
    }
  }
}
