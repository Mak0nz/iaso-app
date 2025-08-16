import 'package:flutter/material.dart';
import 'package:iaso/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/utils/number_formatter.dart';
import 'package:iaso/domain/medication.dart';
import 'package:iaso/presentation/views/meds/create_edit_med_modal.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MedCard extends StatelessWidget {
  final Medication? medication;

  const MedCard({super.key, this.medication});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (medication == null) {
      return const Card(
        child: ListTile(
          leading: Icon(FontAwesomeIcons.fileMedical),
          title: Text('Loading...'),
          subtitle: Text('Please wait'),
        ),
      );
    }

    final borderColor = medication!.totalDoses <= 7
        ? Colors.red
        : medication!.totalDoses <= 14
            ? Colors.orange
            : Colors.grey.shade900;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading:
            medication!.isInCloud ? const Icon(FontAwesomeIcons.cloud) : null,
        title: Text(medication!.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(l10n
            .total_doses(NumberFormatter.formatDouble(medication!.totalDoses))),
        trailing: IconButton(
          icon: const Icon(FontAwesomeIcons.penToSquare),
          onPressed: () => WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) {
              return [
                WoltModalSheetPage(
                  child: CreateEditMedModal(medication: medication),
                  topBarTitle: AppText.heading(l10n.edit_med),
                  isTopBarLayerAlwaysVisible: true,
                  enableDrag: false,
                )
              ];
            },
          ),
        ),
      ),
    );
  }
}
