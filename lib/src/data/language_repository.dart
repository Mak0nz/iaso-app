import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/domain/language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LanguageRepository {
  LanguageRepository({required this.ref});
  final Ref ref;

  static const String languageCodeKey = "language_code";

  Future<void> setLanguage(Language language) async {
    final pref = await ref.read(sharedPreferencesProvider.future);
    await pref.setString(languageCodeKey, language.code);
    ref.read(languageProvider.notifier).update((_) => language);
  }

  Future<Language> getLanguage() async {
    final pref = await ref.read(sharedPreferencesProvider.future);
    final code = pref.getString(languageCodeKey);
    if (code != null) {
      return _getLanguageFromCode(code);
    }
    
    // If no language is set, get the device language
    final deviceLocales = ui.PlatformDispatcher.instance.locales;
    String deviceLanguageCode = 'en'; // Default to English
    
    if (deviceLocales.isNotEmpty) {
      deviceLanguageCode = deviceLocales.first.languageCode;
    }
    
    // Check if the device language is supported
    final supportedLanguage = _getLanguageFromCode(deviceLanguageCode);
    if (supportedLanguage != Language.english) {
      // If a supported non-English language is found, set and return it
      await setLanguage(supportedLanguage);
      return supportedLanguage;
    }
    
    // Default to English if device language is not supported
    await setLanguage(Language.english);
    return Language.english;
  }

  Language _getLanguageFromCode(String code) {
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.english,
    );
  }
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());

final languageRepositoryProvider = Provider<LanguageRepository>((ref) => LanguageRepository(ref: ref));