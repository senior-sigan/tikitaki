import 'package:flutter/foundation.dart';
import 'package:tikitaki/data/video_helpers.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

enum CollectionSortOrder { apiOrder, name }

class CollectionsViewModel extends ChangeNotifier {
  CollectionsViewModel({required VideoListViewModel videoListViewModel})
    : _videoListViewModel = videoListViewModel {
    _videoListViewModel.addListener(_onVideoListChanged);
  }

  final VideoListViewModel _videoListViewModel;
  bool _disposed = false;

  CollectionSortOrder _sortOrder = CollectionSortOrder.apiOrder;
  Map<String, List<VideoItem>>? _cachedCollections;
  List<({String name, VideoItem preview})>? _cachedPreviews;

  CollectionSortOrder get sortOrder => _sortOrder;

  void setSortOrder(CollectionSortOrder value) {
    _sortOrder = value;
    _cachedPreviews = null;
    notifyListeners();
  }

  void _onVideoListChanged() {
    if (_videoListViewModel.state != VideoListState.loaded) return;
    _cachedCollections = null;
    _cachedPreviews = null;
    notifyListeners();
  }

  Map<String, List<VideoItem>> get collections =>
      _cachedCollections ??= groupByCollection(_videoListViewModel.videos);

  List<({String name, VideoItem preview})> get collectionPreviews {
    if (_cachedPreviews != null) return _cachedPreviews!;
    final previews = collections.entries
        .map((e) => (name: e.key, preview: e.value.first))
        .toList();
    if (_sortOrder == CollectionSortOrder.name) {
      previews.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }
    return _cachedPreviews = previews;
  }

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
