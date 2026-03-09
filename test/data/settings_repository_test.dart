import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tikitaki/data/settings_repository.dart';

void main() {
  group('SharedPreferencesSettingsRepository', () {
    late SharedPreferencesSettingsRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = SharedPreferencesSettingsRepository();
    });

    test(
      'getBaseUrl returns default http://localhost:8080 if nothing saved',
      () async {
        final url = await repository.getBaseUrl();
        check(url).equals('http://localhost:8080');
      },
    );

    test('setBaseUrl saves url and getBaseUrl returns it', () async {
      const newUrl = 'https://api.example.com';
      await repository.setBaseUrl(newUrl);
      final url = await repository.getBaseUrl();
      check(url).equals(newUrl);
    });
  });
}
