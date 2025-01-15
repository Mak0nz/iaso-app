import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/app_services/med_sort_manager.dart';
import 'package:iaso/data/provider/med_provider.dart';
import 'package:iaso/domain/user_medication.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/views/meds/create_edit_med_modal.dart';
import 'package:iaso/presentation/views/meds/med_card.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/floating_arrow.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class DisplayMeds extends ConsumerWidget {
  final bool showAll;
  final MedSortMode sortMode;
  final bool showZeroDoses;

  const DisplayMeds({
    super.key,
    required this.showAll,
    required this.sortMode,
    required this.showZeroDoses,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final medications = ref.watch(medicationSyncProvider);

    return medications.isEmpty
        ? _buildEmptyState(context)
        : _buildMedicationList(context, ref, l10n, medications.values.toList());
  }

  Widget _buildMedicationList(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, List medications) {
    final sortedMeds = sortMedications(
        medications.cast<UserMedication>(), sortMode, showZeroDoses);
    final filteredMeds = showAll
        ? sortedMeds
        : sortedMeds.where((med) => med.totalDoses <= 14).toList();

    return ListView(
      children: [
        if (!showAll) ...[
          Padding(
            padding: const EdgeInsets.only(left: edgeInset, top: edgeInset),
            child: AppText.subHeading("${l10n.translate('meds_running_out')}:"),
          ),
          const SizedBox(height: 10),
        ],
        if (!showAll && filteredMeds.isEmpty)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: edgeInset),
              child: AppText.subHeading(l10n.translate('meds_not_running_out')))
        else if (showAll)
          const SizedBox(height: edgeInset),
        ...filteredMeds.map((med) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: edgeInset),
              child: MedCard(medication: med),
            )),
        const SizedBox(height: 75),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    bool loading = false;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.pills,
            size: 60,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.translate('no_medications_added'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.translate('add_medication_guide'),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const FloatingArrow(),
          const SizedBox(height: 20),
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
