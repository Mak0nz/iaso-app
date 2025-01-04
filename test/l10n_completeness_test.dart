import 'package:flutter_test/flutter_test.dart';
import 'package:iaso/l10n/en/auth.dart';
import 'package:iaso/l10n/en/common.dart';
import 'package:iaso/l10n/en/error.dart';
import 'package:iaso/l10n/en/medication.dart';
import 'package:iaso/l10n/en/settings.dart';
import 'package:iaso/l10n/en/stats.dart';
import 'package:iaso/l10n/en/onboarding.dart';
import 'package:iaso/l10n/hu/auth.dart' as hu_auth;
import 'package:iaso/l10n/hu/common.dart' as hu_common;
import 'package:iaso/l10n/hu/error.dart' as hu_error;
import 'package:iaso/l10n/hu/medication.dart' as hu_med;
import 'package:iaso/l10n/hu/settings.dart' as hu_settings;
import 'package:iaso/l10n/hu/stats.dart' as hu_stats;
import 'package:iaso/l10n/hu/onboarding.dart' as hu_onboarding;

void main() {
  test('All English keys have Hungarian translations', () {
    final enKeys = [
      ...enAuth.keys,
      ...enCommon.keys,
      ...enError.keys,
      ...enMedication.keys,
      ...enSettings.keys,
      ...enStats.keys,
      ...enOnboarding.keys,
    ];

    final huKeys = [
      ...hu_auth.huAuth.keys,
      ...hu_common.huCommon.keys,
      ...hu_error.huError.keys,
      ...hu_med.huMedication.keys,
      ...hu_settings.huSettings.keys,
      ...hu_stats.huStats.keys,
      ...hu_onboarding.huOnboarding.keys,
    ];

    // Check for missing translations
    final missingInHungarian = enKeys.where((key) => !huKeys.contains(key));
    expect(
      missingInHungarian,
      isEmpty,
      reason: 'Hungarian translations missing for keys: $missingInHungarian',
    );

    // Check for extra translations
    final extraInHungarian = huKeys.where((key) => !enKeys.contains(key));
    expect(
      extraInHungarian,
      isEmpty,
      reason: 'Extra Hungarian translations for keys: $extraInHungarian',
    );
  });

  test('No duplicate keys across categories in English', () {
    final allKeys = [
      enAuth,
      enCommon,
      enError,
      enMedication,
      enSettings,
      enStats,
      enOnboarding,
    ];

    final seenKeys = <String>{};
    final duplicates = <String>{};

    for (final category in allKeys) {
      for (final key in category.keys) {
        if (!seenKeys.add(key)) {
          duplicates.add(key);
        }
      }
    }

    expect(
      duplicates,
      isEmpty,
      reason: 'Found duplicate translation keys: $duplicates',
    );
  });

  test('Translations contain correct placeholders', () {
    // Test specific strings that should have placeholders
    expect(
      enMedication['total_doses']?.contains('{doses}'),
      true,
      reason: 'English total_doses missing {doses} placeholder',
    );
    expect(
      hu_med.huMedication['total_doses']?.contains('{doses}'),
      true,
      reason: 'Hungarian total_doses missing {doses} placeholder',
    );

    // Add more placeholder checks as needed
  });
}
