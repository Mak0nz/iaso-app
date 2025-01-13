import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/main.dart';

class SettingsSync extends StateNotifier<Map<String, String>> {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  // Keys that should be synced
  static const _syncedKeys = {
    'language_code',
    'username',
    'show_weight',
    'show_temperature',
    'show_night_temperature',
    'show_morning_bp',
    'show_night_bp',
    'show_blood_sugar',
    'show_urine',
    'show_zero_doses',
    'med_sort_mode',
  };

  SettingsSync(this._apiClient, this._prefs) : super({}) {
    _init();
  }

  Future<void> _init() async {
    // Load local settings first
    _loadLocalSettings();

    // Then try to fetch from server
    await syncFromServer();
  }

  void _loadLocalSettings() {
    final Map<String, String> settings = {};
    for (final key in _syncedKeys) {
      final value = _prefs.getString(key);
      if (value != null) {
        settings[key] = value;
      }
    }
    state = settings;
  }

  Future<void> syncFromServer() async {
    try {
      final response = await _apiClient.get('/settings');
      final serverSettings =
          Map<String, String>.from(response['settings'] as Map);

      // Update local storage and state
      for (final entry in serverSettings.entries) {
        if (_syncedKeys.contains(entry.key)) {
          await _prefs.setString(entry.key, entry.value);
          state = {...state, entry.key: entry.value};
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing from server: $e');
      }
    }
  }

  Future<void> syncToServer() async {
    try {
      await _apiClient.post(
        '/settings/sync',
        {'settings': state},
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing to server: $e');
      }
    }
  }

  Future<void> setSetting(String key, String value) async {
    if (!_syncedKeys.contains(key)) return;

    // Update local storage and state
    await _prefs.setString(key, value);
    state = {...state, key: value};

    // Try to sync to server
    await syncToServer();
  }

  String? getSetting(String key) {
    return state[key];
  }

  Future<void> clearAllExceptLanguageAndTheme() async {
    // Keep the old values for language and theme
    final language = _prefs.getString('language_code');
    final theme = _prefs.getString('theme_mode');

    // Clear all synced settings
    final keysToKeep = {'language_code', 'theme_mode'};
    for (final key in _syncedKeys) {
      if (!keysToKeep.contains(key)) {
        await _prefs.remove(key);
      }
    }

    // Restore language and theme
    if (language != null) {
      await _prefs.setString('language_code', language);
    }
    if (theme != null) {
      await _prefs.setString('theme_mode', theme);
    }

    // Update state
    state = {
      if (language != null) 'language_code': language,
      if (theme != null) 'theme_mode': theme,
    };
  }
}

final settingsSyncProvider =
    StateNotifierProvider<SettingsSync, Map<String, String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final language = ref.watch(languageProvider);
  final apiClient = ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
    languageCode: language,
  );

  return SettingsSync(apiClient, prefs);
});
