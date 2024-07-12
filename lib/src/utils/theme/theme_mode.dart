import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum AppThemeMode {
  system(icon: FontAwesomeIcons.palette, name: 'System'),
  light(icon: FontAwesomeIcons.sun, name: 'Light'),
  dark(icon: FontAwesomeIcons.moon, name: 'Dark');

  const AppThemeMode({
    required this.icon,
    required this.name,
  });

  final IconData icon;
  final String name;
}

final themeModeProvider = StateProvider<AppThemeMode>((ref) => AppThemeMode.system);
