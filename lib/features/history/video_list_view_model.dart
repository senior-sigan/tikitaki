import 'package:flutter/foundation.dart';
import 'package:tikitaki/data/video_helpers.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/data/video_repository.dart';

enum VideoListState { initial, loading, loaded, error }

class VideoListViewModel extends ChangeNotifier {
  VideoListViewModel({required VideoRepository repository})
    : _repository = repository;

  final VideoRepository _repository;

  VideoListState _state = VideoListState.initial;
  List<VideoItem> _videos = const [];
  String? _errorMessage;

  VideoListState get state => _state;
  List<VideoItem> get videos => _videos;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _state = VideoListState.loading;
    notifyListeners();
    try {
      final result = await _repository.getVideos();
      _videos = sortByCollection(result);
      _errorMessage = null;
      _state = VideoListState.loaded;
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _state = VideoListState.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => load();
}
