import 'package:flutter/material.dart';

import 'en/auth.dart';
import 'en/calendar.dart';
import 'en/common.dart';
import 'en/error.dart';
import 'en/medication.dart';
import 'en/onboarding.dart';
import 'en/settings.dart';
import 'en/stats.dart';

import 'hu/auth.dart' as hu_auth;
import 'hu/calendar.dart' as hu_calendar;
import 'hu/common.dart' as hu_common;
import 'hu/error.dart' as hu_error;
import 'hu/medication.dart' as hu_med;
import 'hu/onboarding.dart' as hu_onboarding;
import 'hu/settings.dart' as hu_settings;
import 'hu/stats.dart' as hu_stats;

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('hu'),
  ];

  static final supportedLanguages = {
    'en': 'English',
    'hu': 'Magyar',
  };

  static bool isSupported(String code) => supportedLanguages.containsKey(code);

  static String getFlag(String code) {
    // flags from: https://emojipedia.org/flags
    return switch (code) {
      'en' => '🇬🇧',
      'hu' => '🇭🇺',
      _ => '🏳️',
    };
  }

  static String getName(String code) => supportedLanguages[code] ?? code;
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late final Map<String, String> _localizedStrings = {
    if (locale.languageCode == 'en') ...{
      ...enAuth,
      ...enCalendar,
      ...enCommon,
      ...enError,
      ...enMedication,
      ...enOnboarding,
      ...enSettings,
      ...enStats,
    } else if (locale.languageCode == 'hu') ...{
      ...hu_auth.huAuth,
      ...hu_calendar.huCalendar,
      ...hu_common.huCommon,
      ...hu_error.huError,
      ...hu_med.huMedication,
      ...hu_onboarding.huOnboarding,
      ...hu_settings.huSettings,
      ...hu_stats.huStats,
    }
  };
  // also need to change lib/app_services/notification_service.dart

  String translate(String key) => _localizedStrings[key] ?? key;

  String get localeName => locale.languageCode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => L10n.isSupported(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
