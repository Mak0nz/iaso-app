import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/services/meds/medication.dart';
import 'package:iaso/src/views/meds/create_edit_med_modal.dart';
import 'package:iaso/src/widgets/app_text.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MedCard extends StatelessWidget {
  final Medication? medication;

  const MedCard({super.key, this.medication});

  @override
  Widget build(BuildContext context) {
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
        : medication!.totalDoses <= 14 ? Colors.orange : Colors.grey.shade900;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: medication!.isInCloud ? const Icon(FontAwesomeIcons.cloud) : null,
        title: Text(medication!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(AppLocalizations.of(context)!.total_doses(medication!.totalDoses)),
        trailing: IconButton(
          icon: const Icon(FontAwesomeIcons.penToSquare),
          onPressed: () => WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) {
              return [
                WoltModalSheetPage(
                  child: CreateEditMedModal(medication: medication),
                  topBarTitle: AppText.heading(AppLocalizations.of(context)!.edit_med),
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