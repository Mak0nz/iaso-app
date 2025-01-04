import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/l10n/l10n.dart';

class SettingChangeLanguage extends ConsumerWidget {
  const SettingChangeLanguage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final language = ref.watch(languageProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.translate('change_language'),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) =>
                ref.read(languageRepositoryProvider).setLanguage(value),
            itemBuilder: (context) => [
              for (var code in L10n.supportedLanguages.keys)
                PopupMenuItem(
                    value: code,
                    child: Row(
                      children: [
                        Text(L10n.getFlag(code)),
                        const SizedBox(width: 8),
                        Text(L10n.getName(code)),
                      ],
                    ))
            ],
            child: Row(
              children: [
                Text(L10n.getFlag(language)),
                const SizedBox(width: 8),
                Text(
                  L10n.getName(language),
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
