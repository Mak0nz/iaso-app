import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iaso/domain/language.dart';
import 'package:iaso/data/language_repository.dart';

class LanguagePopupMenu extends ConsumerWidget {
  const LanguagePopupMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return PopupMenuButton<Language>(
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
      child:
          Text('${AppLocalizations.of(context)!.language}: ${language.flag}'),
    );
  }
}
