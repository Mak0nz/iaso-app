import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/settings_sync.dart';
import 'dart:ui' as ui;
import 'package:iaso/l10n/l10n.dart';

class LanguageRepository {
  LanguageRepository({required this.ref});
  final Ref ref;

  static const String languageCodeKey = "language_code";

  Future<void> setLanguage(String languageCode) async {
    if (!L10n.isSupported(languageCode)) return;

    final settingsSync = ref.read(settingsSyncProvider.notifier);
    await settingsSync.setSetting(languageCodeKey, languageCode);
    ref.read(languageProvider.notifier).state = languageCode;
  }

  Future<String> getLanguage() async {
    final settingsSync = ref.read(settingsSyncProvider.notifier);
    final code = settingsSync.getSetting(languageCodeKey);

    if (code != null && L10n.isSupported(code)) {
      return code;
    }

    // If no language is set, get the device language
    final deviceLocales = ui.PlatformDispatcher.instance.locales;
    String deviceLanguageCode = 'en'; // Default to English

    if (deviceLocales.isNotEmpty) {
      final deviceCode = deviceLocales.first.languageCode;
      if (L10n.isSupported(deviceCode)) {
        deviceLanguageCode = deviceCode;
      }
    }

    // Save and return the selected language
    await setLanguage(deviceLanguageCode);
    return deviceLanguageCode;
  }
}

final languageRepositoryProvider =
    Provider<LanguageRepository>((ref) => LanguageRepository(ref: ref));

final languageProvider = StateProvider<String>((ref) => 'en');
