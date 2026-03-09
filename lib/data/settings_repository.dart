import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<String> getBaseUrl();
  Future<void> setBaseUrl(String url);
}

class SharedPreferencesSettingsRepository implements SettingsRepository {
  static const _baseUrlKey = 'base_url';
  static const defaultBaseUrl = 'http://localhost:8080';

  @override
  Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseUrlKey) ?? defaultBaseUrl;
  }

  @override
  Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, url);
  }
}
