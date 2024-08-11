import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/presentation/views/settings/stats_view.dart';

class StatsViewSettingsScreen extends ConsumerWidget {
  const StatsViewSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 40, horizontal: edgeInset),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.chartSimple,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.customize_stats_view,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Card(
              child: StatsViewSettingsContent(),
            ),
          ],
        ),
      ),
    );
  }
}
