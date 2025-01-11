import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system(icon: FontAwesomeIcons.palette),
  light(icon: FontAwesomeIcons.sun),
  dark(icon: FontAwesomeIcons.moon);

  const AppThemeMode({
    required this.icon,
  });

  final IconData icon;

  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      AppThemeMode.system => l10n.translate('system_theme'),
      AppThemeMode.light => l10n.translate('light_theme'),
      AppThemeMode.dark => l10n.translate('dark_theme'),
    };
  }
}

class ThemeManager extends StateNotifier<AppThemeMode> {
  ThemeManager({required SharedPreferences prefs})
      : _prefs = prefs,
        super(AppThemeMode.system) {
    _loadTheme();
  }

  final SharedPreferences _prefs;
  static const String themeModeKey = "theme_mode";

  void _loadTheme() {
    try {
      final themeName = _prefs.getString(themeModeKey);
      if (themeName != null) {
        for (var mode in AppThemeMode.values) {
          if (mode.name == themeName) {
            state = mode;
            break;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme: $e');
      }
    }
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    try {
      await _prefs.setString(themeModeKey, themeMode.name);
      state = themeMode;
    } catch (e) {
      if (kDebugMode) {
        print('Error setting theme: $e');
      }
    }
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeManager, AppThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeManager(prefs: prefs);
});
