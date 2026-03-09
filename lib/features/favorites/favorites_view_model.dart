import 'package:flutter/foundation.dart';
import 'package:tikitaki/data/favorites_repository.dart';
import 'package:tikitaki/data/video_item.dart';
import 'package:tikitaki/features/history/video_list_view_model.dart';

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel({
    required FavoritesRepository favoritesRepository,
    required VideoListViewModel videoListViewModel,
  }) : _favoritesRepository = favoritesRepository,
       _videoListViewModel = videoListViewModel {
    _videoListViewModel.addListener(_onVideoListChanged);
  }

  final FavoritesRepository _favoritesRepository;
  final VideoListViewModel _videoListViewModel;

  void _onVideoListChanged() {
    notifyListeners();
  }

  List<VideoItem> get favoriteVideos {
    return _favoritesRepository.getFavoriteVideos(_videoListViewModel.videos);
  }

  bool isFavorite(String url) {
    return _favoritesRepository.isFavorite(url);
  }

  Future<void> toggle(String url) async {
    await _favoritesRepository.toggle(url);
    notifyListeners();
  }

  @override
  void dispose() {
    _videoListViewModel.removeListener(_onVideoListChanged);
    super.dispose();
  }
}
