import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<String> getBaseUrl();
  Future<void> setBaseUrl(String url);
}

class SharedPreferencesSettingsRepository implements SettingsRepository {
  SharedPreferencesSettingsRepository(this._prefs);

  static const _baseUrlKey = 'base_url';
  static const defaultBaseUrl = 'http://localhost:8080';

  final SharedPreferences _prefs;

  @override
  Future<String> getBaseUrl() async {
    return _prefs.getString(_baseUrlKey) ?? defaultBaseUrl;
  }

  @override
  Future<void> setBaseUrl(String url) async {
    await _prefs.setString(_baseUrlKey, url);
  }
}
