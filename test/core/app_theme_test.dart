import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaki/core/app_theme.dart';

void main() {
  group('appTheme', () {
    test('has dark brightness', () {
      check(appTheme.brightness).equals(Brightness.dark);
    });

    test('uses Material 3', () {
      check(appTheme.useMaterial3).equals(true);
    });

    test('has color scheme with dark brightness', () {
      check(appTheme.colorScheme.brightness).equals(Brightness.dark);
    });

    test('uses teal as seed color basis', () {
      final primary = appTheme.colorScheme.primary;
      final hue = HSLColor.fromColor(primary).hue;
      // Teal hue is around 170-180 degrees
      check(hue).isGreaterOrEqual(140.0);
      check(hue).isLessOrEqual(200.0);
    });
  });
}
