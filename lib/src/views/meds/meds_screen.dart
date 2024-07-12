import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/constants/sizes.dart';
//import 'package:iaso/src/services/meds/provider.dart';
import 'package:iaso/src/views/meds/create_edit_med_modal.dart';
import 'package:iaso/src/views/meds/meds_display.dart';
import 'package:iaso/src/widgets/app_text.dart';
import 'package:iaso/src/widgets/appbar.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MedsScreen extends ConsumerWidget {
  const MedsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.meds,
        //actions: const Icon(FontAwesomeIcons.rotate ),
        //actionsEvent: () => ref.refresh(medsProvider),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: navBar),
        child: FloatingActionButton(
          onPressed: () => WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) {
              return [
                WoltModalSheetPage(
                  child: const CreateEditMedModal(),
                  topBarTitle: AppText.heading(AppLocalizations.of(context)!.create_med),
                  isTopBarLayerAlwaysVisible: true,
                  trailingNavBarWidget: IconButton(
                    padding: const EdgeInsets.only(right: 20),
                    onPressed: Navigator.of(context).pop, 
                    icon: const Icon(FontAwesomeIcons.xmark)
                  ),
                  enableDrag: false,
                )
              ];
            },
          ),
          child: const Icon(FontAwesomeIcons.plus),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: edgeInset),
        child: DisplayMeds(showAll: true),
      ),
    );
  }
}