import 'package:flutter/foundation.dart';
import 'package:tikitaki/data/video_helpers.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

class CollectionsViewModel extends ChangeNotifier {
  CollectionsViewModel({required VideoListViewModel videoListViewModel})
    : _videoListViewModel = videoListViewModel {
    _videoListViewModel.addListener(_onVideoListChanged);
  }

  final VideoListViewModel _videoListViewModel;
  bool _disposed = false;

  Map<String, List<VideoItem>>? _cachedCollections;
  List<({String name, VideoItem preview})>? _cachedPreviews;

  void _onVideoListChanged() {
    if (_videoListViewModel.state != VideoListState.loaded) return;
    _cachedCollections = null;
    _cachedPreviews = null;
    notifyListeners();
  }

  Map<String, List<VideoItem>> get collections =>
      _cachedCollections ??= groupByCollection(_videoListViewModel.videos);

  List<({String name, VideoItem preview})> get collectionPreviews =>
      _cachedPreviews ??= collections.entries
          .map((e) => (name: e.key, preview: e.value.first))
          .toList();

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _videoListViewModel.removeListener(_onVideoListChanged);
    super.dispose();
  }
}
