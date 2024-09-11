// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iaso/domain/language.dart';
import 'package:iaso/data/language_repository.dart';

class SettingChangeLanguage extends ConsumerWidget {
  const SettingChangeLanguage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final language = ref.watch(languageProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.change_language,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          PopupMenuButton<Language>(
            onSelected: (value) =>
                ref.read(languageRepositoryProvider).setLanguage(value),
            itemBuilder: (context) => [
              for (var value in Language.values)
                PopupMenuItem(
                    value: value,
                    child: Row(
                      children: [
                        Text(value.flag),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(value.name),
                      ],
                    ))
            ],
            child: Row(
              children: [
                Text(
                  language.flag,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  language.name,
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
