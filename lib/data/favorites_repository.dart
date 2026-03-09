import 'package:tikitaki/data/video_item.dart';

abstract class FavoritesRepository {
  bool isFavorite(String url);
  Future<void> toggle(String url);
  Set<String> getAll();
  List<VideoItem> getFavoriteVideos(List<VideoItem> allVideos);
}
