import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/utils/theme/theme_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingChangeTheme extends ConsumerWidget {
  const SettingChangeTheme({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.change_theme,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          PopupMenuButton<AppThemeMode>(
            onSelected: (value) =>
                ref.read(themeModeProvider.notifier).setThemeMode(value),
            itemBuilder: (context) => [
              for (var value in AppThemeMode.values)
                PopupMenuItem(
                    value: value,
                    child: Row(
                      children: [
                        Icon(value.icon),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(value.getName(context)),
                      ],
                    ))
            ],
            child: Row(
              children: [
                Icon(themeMode.icon),
                const SizedBox(width: 8),
                Text(
                  themeMode.getName(context),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
