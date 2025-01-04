import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/views/meds/create_edit_med_modal.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:iaso/presentation/widgets/app_text.dart';

class AddMedScreen extends StatelessWidget {
  const AddMedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    bool loading = false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: edgeInset),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.fileCirclePlus,
            size: 60,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.translate('add_medication'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.translate('add_medication_guide'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),
          AnimatedButton(
            onTap: () => WoltModalSheet.show(
              context: context,
              pageListBuilder: (context) {
                return [
                  WoltModalSheetPage(
                    child: const CreateEditMedModal(),
                    topBarTitle: AppText.heading(l10n.translate('create_med')),
                    isTopBarLayerAlwaysVisible: true,
                    enableDrag: false,
                  )
                ];
              },
            ),
            text: l10n.translate('add_medication'),
            progressEvent: loading,
          ),
        ],
      ),
    );
  }
}
