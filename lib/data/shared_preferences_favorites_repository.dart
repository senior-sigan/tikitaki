import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikitaki/data/favorites_repository.dart';
import 'package:tikitaki/data/video_item.dart';

class SharedPreferencesFavoritesRepository implements FavoritesRepository {
  SharedPreferencesFavoritesRepository(this._prefs)
    : _favorites = Set<String>.from(_prefs.getStringList(_key) ?? <String>[]);

  static const _key = 'favorite_urls';
  final SharedPreferences _prefs;
  final Set<String> _favorites;

  @override
  bool isFavorite(String url) => _favorites.contains(url);

  @override
  Future<void> toggle(String url) async {
    if (_favorites.contains(url)) {
      _favorites.remove(url);
    } else {
      _favorites.add(url);
    }
    await _prefs.setStringList(_key, _favorites.toList());
  }

  @override
  Set<String> getAll() => Set<String>.unmodifiable(_favorites);

  @override
  List<VideoItem> getFavoriteVideos(List<VideoItem> allVideos) {
    return allVideos.where((v) => _favorites.contains(v.url)).toList();
  }
}
