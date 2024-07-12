import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/utils/language/language_repository.dart';
import 'package:iaso/src/utils/theme/theme_mode.dart';

class ThemeRepository {
  ThemeRepository({required this.ref});
  final Ref ref;

  static const String themeModeKey = "theme_mode";

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    final pref = await ref.read(sharedPreferencesProvider.future);
    await pref.setString(themeModeKey, themeMode.name);
    ref.read(themeModeProvider.notifier).update((_) => themeMode);
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

final themeRepositoryProvider = Provider<ThemeRepository>((ref) => ThemeRepository(ref: ref));