import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/presentation/views/stats/urine_card.dart';
import 'package:iaso/utils/number_formatter.dart';
import 'package:iaso/domain/stats.dart';
import 'package:iaso/presentation/views/stats/blood_sugar_card.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/card.dart';

class StatsDisplay extends StatelessWidget {
  final Stats? stats;

  const StatsDisplay({super.key, this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (stats == null) {
      return Column(
        children: [
          CustomCard(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.notesMedical),
                const SizedBox(
                  width: 10,
                ),
                AppText.bold(l10n.no_data_text),
              ],
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 140),
      child: Column(
        children: [
          if (stats!.weight != null)
            CustomCard(
              title: Row(
                children: [
                  AppText.bold('${l10n.weight}: '),
                  Text(
                      '${NumberFormatter.formatDouble(stats!.weight ?? 0)} kg'),
                ],
              ),
            ),
          if (stats!.temp != null)
            CustomCard(
              title: Row(
                children: [
                  AppText.bold('${l10n.temperature}: '),
                  Text('${NumberFormatter.formatDouble(stats!.temp ?? 0)} °C'),
                ],
              ),
            ),
          if (stats!.nightTemp != null)
            CustomCard(
              title: Row(
                children: [
                  AppText.bold('${l10n.night_temperature}: '),
                  Text(
                      '${NumberFormatter.formatDouble(stats!.nightTemp ?? 0)} °C'),
                ],
              ),
            ),
          if (stats!.bpMorningSYS != null ||
              stats!.bpMorningDIA != null ||
              stats!.bpMorningPulse != null)
            CustomCard(
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppText.bold('${l10n.morning_blood_pressure}:'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.bold('${stats!.bpMorningSYS ?? '___'}'),
                      const Text(
                        "  /  ",
                      ),
                      AppText.bold('${stats!.bpMorningDIA ?? '__'}'),
                      const Text(" mmHg"),
                      const SizedBox(
                        width: 25,
                      ),
                      AppText.bold('${stats!.bpMorningPulse ?? '__'}'),
                      const Text(
                        " bpm",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (stats!.bpNightSYS != null ||
              stats!.bpNightDIA != null ||
              stats!.bpNightPulse != null)
            CustomCard(
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppText.bold('${l10n.night_blood_pressure}:'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.bold('${stats!.bpNightSYS ?? '___'}'),
                      const Text(
                        "  /  ",
                      ),
                      AppText.bold('${stats!.bpNightDIA ?? '__'}'),
                      const Text(" mmHg"),
                      const SizedBox(
                        width: 25,
                      ),
                      AppText.bold('${stats!.bpNightPulse ?? '__'}'),
                      const Text(
                        " bpm",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (stats!.bloodSugar != null && stats!.bloodSugar!.isNotEmpty)
            ExpandableBloodSugarCard(bloodSugar: stats!.bloodSugar!),
          if (stats!.urine != null && stats!.urine!.isNotEmpty)
            ExpandableUrineCard(urine: stats!.urine!),
        ],
      ),
    );
  }
}
