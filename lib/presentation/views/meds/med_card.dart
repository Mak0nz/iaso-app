import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/utils/number_formatter.dart';
import 'package:iaso/domain/user_medication.dart';
import 'package:iaso/presentation/views/meds/create_edit_med_modal.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MedCard extends ConsumerWidget {
  final UserMedication? medication;

  const MedCard({super.key, this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final language = ref.watch(languageProvider);

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

    final doseString = l10n.translate('total_doses').replaceAll(
        '{doses}', NumberFormatter.formatDouble(medication!.totalDoses));

    final medName = medication!.medicationInfo.getLocalizedName(language);

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (medication!.isInCloud) const Icon(FontAwesomeIcons.cloud),
            if (medication!.medicationInfo.isVerified)
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Icon(FontAwesomeIcons.circleCheck, color: Colors.green),
              ),
          ],
        ),
        title:
            Text(medName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doseString),
            if (medication!.orderedBy?.isNotEmpty == true)
              Text('${l10n.translate('ordered_by')}: ${medication!.orderedBy}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(FontAwesomeIcons.penToSquare),
          onPressed: () => WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) {
              return [
                WoltModalSheetPage(
                  child: CreateEditMedModal(medication: medication),
                  topBarTitle: AppText.heading(l10n.translate('edit_med')),
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
