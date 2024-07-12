import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

final themeModeProvider = StateProvider<AppThemeMode>((ref) => AppThemeMode.system);
