import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/l10n/l10n.dart';

class LanguagePopupMenu extends ConsumerWidget {
  const LanguagePopupMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    return PopupMenuButton<String>(
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
          Text(AppLocalizations.of(context).translate('language')),
          const Text(': '),
          Text(L10n.getFlag(currentLanguage)),
        ],
      ),
    );
  }
}
