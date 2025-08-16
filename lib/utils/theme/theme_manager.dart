import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/l10n/app_localizations.dart';
import 'package:iaso/data/language_repository.dart';

enum AppThemeMode {
  system(icon: FontAwesomeIcons.palette),
  light(icon: FontAwesomeIcons.sun),
  dark(icon: FontAwesomeIcons.moon);

  const AppThemeMode({
    required this.icon,
  });

  final IconData icon;

  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      AppThemeMode.system => l10n.system_theme,
      AppThemeMode.light => l10n.light_theme,
      AppThemeMode.dark => l10n.dark_theme,
    };
  }
}

class ThemeRepository {
  ThemeRepository({required this.ref});
  final Ref ref;

  static const String themeModeKey = "theme_mode";

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    final pref = await ref.read(sharedPreferencesProvider.future);
    await pref.setString(themeModeKey, themeMode.name);
  }

  Future<AppThemeMode> getThemeMode() async {
    final pref = await ref.read(sharedPreferencesProvider.future);
    final mode = pref.getString(themeModeKey);
    for (var value in AppThemeMode.values) {
      if (value.name == mode) return value;
    }
    return AppThemeMode.system;
  }
}

final themeRepositoryProvider =
    Provider<ThemeRepository>((ref) => ThemeRepository(ref: ref));

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(themeRepositoryProvider));
});

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier(this._themeRepository) : super(AppThemeMode.system) {
    loadTheme();
  }

  final ThemeRepository _themeRepository;

  Future<void> loadTheme() async {
    try {
      final themeMode = await _themeRepository.getThemeMode();
      state = themeMode;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme: $e');
      }
    }
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    try {
      await _themeRepository.setThemeMode(themeMode);
      state = themeMode;
    } catch (e) {
      if (kDebugMode) {
        print('Error setting theme: $e');
      }
    }
  }
}

final themeLoadingProvider = StateProvider<bool>((ref) => true);
