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

  void _onVideoListChanged() {
    notifyListeners();
  }

  Map<String, List<VideoItem>> get collections {
    return groupByCollection(_videoListViewModel.videos);
  }

  List<({String name, VideoItem preview})> get collectionPreviews {
    final grouped = collections;
    return grouped.entries
        .map((e) => (name: e.key, preview: e.value.first))
        .toList();
  }

  @override
  void dispose() {
    _videoListViewModel.removeListener(_onVideoListChanged);
    super.dispose();
  }
}
