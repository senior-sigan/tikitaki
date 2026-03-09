import 'package:checks/checks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tikitaki/data/settings_repository.dart';
import 'package:tikitaki/features/settings/settings_screen.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockSettingsRepo;

  setUp(() {
    mockSettingsRepo = MockSettingsRepository();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: SettingsScreen(settingsRepository: mockSettingsRepo),
    );
  }

  group('SettingsScreen', () {
    testWidgets('shows text field with current base URL', (tester) async {
      when(
        () => mockSettingsRepo.getBaseUrl(),
      ).thenAnswer((_) async => 'http://example.com');

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      check(textField.controller?.text).equals('http://example.com');
    });

    testWidgets('save button saves new URL via SettingsRepository', (
      tester,
    ) async {
      when(
        () => mockSettingsRepo.getBaseUrl(),
      ).thenAnswer((_) async => 'http://example.com');
      when(() => mockSettingsRepo.setBaseUrl(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'http://new-url.com');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pumpAndSettle();

      verify(() => mockSettingsRepo.setBaseUrl('http://new-url.com')).called(1);
    });

    testWidgets('shows snackbar confirmation after save', (tester) async {
      when(
        () => mockSettingsRepo.getBaseUrl(),
      ).thenAnswer((_) async => 'http://example.com');
      when(() => mockSettingsRepo.setBaseUrl(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('saved'), findsOneWidget);
    });
  });
}
