import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:iaso/l10n/l10n.dart';

void main() {
  group('L10n', () {
    test('supported languages are correctly configured', () {
      expect(L10n.supportedLanguages.keys, contains('en'));
      expect(L10n.supportedLanguages.keys, contains('hu'));
      expect(L10n.supportedLanguages.length, 2);
    });

    test('getFlag returns correct flags', () {
      expect(L10n.getFlag('en'), '🇬🇧');
      expect(L10n.getFlag('hu'), '🇭🇺');
      expect(L10n.getFlag('invalid'), '🏳️');
    });

    test('isSupported correctly validates language codes', () {
      expect(L10n.isSupported('en'), true);
      expect(L10n.isSupported('hu'), true);
      expect(L10n.isSupported('invalid'), false);
    });
  });

  group('AppLocalizations', () {
    late AppLocalizations enLocalizations;
    late AppLocalizations huLocalizations;

    setUp(() {
      enLocalizations = AppLocalizations(const Locale('en'));
      huLocalizations = AppLocalizations(const Locale('hu'));
    });

    test('common translations exist in both languages', () {
      // Test some common strings
      expect(enLocalizations.translate('language'), 'Language');
      expect(huLocalizations.translate('language'), 'Nyelv');
      expect(enLocalizations.translate('save'), 'Save');
      expect(huLocalizations.translate('save'), 'Mentés');
    });

    test('medication translations work with parameters', () {
      final enDoses =
          enLocalizations.translate('total_doses').replaceAll('{doses}', '5');
      final huDoses =
          huLocalizations.translate('total_doses').replaceAll('{doses}', '5');

      expect(enDoses, '5 days remaining.');
      expect(huDoses, '5 napnyi van.');
    });

    test('error messages are correctly translated', () {
      expect(enLocalizations.translate('unexpected_error'),
          'An unexpected error occurred');
      expect(huLocalizations.translate('unexpected_error'),
          'Váratlan hiba történt');
    });

    test('missing translations return key', () {
      const nonExistentKey = 'this_key_does_not_exist';
      expect(enLocalizations.translate(nonExistentKey), nonExistentKey);
      expect(huLocalizations.translate(nonExistentKey), nonExistentKey);
    });

    test('auth related translations exist in both languages', () {
      final authKeys = [
        'login',
        'logout',
        'register',
        'sign_up',
        'forgot_password',
        'change_password',
      ];

      for (final key in authKeys) {
        // Ensure both languages have translations (not returning the key itself)
        expect(enLocalizations.translate(key), isNot(equals(key)),
            reason: 'English translation missing for: $key');
        expect(huLocalizations.translate(key), isNot(equals(key)),
            reason: 'Hungarian translation missing for: $key');

        // For keys that should have different translations
        if (!['email'].contains(key)) {
          // Exclude keys that might be same in both languages
          expect(enLocalizations.translate(key),
              isNot(equals(huLocalizations.translate(key))),
              reason: 'Translations should differ for: $key');
        }
      }
    });
  });
}
