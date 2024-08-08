import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/app_services/med_sort_manager.dart';
import 'package:iaso/data/med_provider.dart';
import 'package:iaso/presentation/views/meds/med_card.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final medsAsyncValue = ref.watch(medsProvider);

    return medsAsyncValue.when(
      loading: () => Skeletonizer(
        enabled: true,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => const MedCard(medication: null),
        ),
      ),
      error: (error, stack) =>
          Center(child: Text('${AppLocalizations.of(context)!.error}: $error')),
      data: (meds) {
        final sortedMeds = sortMedications(meds, sortMode, showZeroDoses);
        final filteredMeds = showAll
            ? sortedMeds
            : sortedMeds.where((med) => med.totalDoses <= 14).toList();

        return ListView(
          children: [
            if (!showAll) ...[
              Padding(
                padding: const EdgeInsets.only(left: edgeInset, top: edgeInset),
                child: AppText.subHeading(
                    "${AppLocalizations.of(context)!.meds_running_out}:"),
              ),
              const SizedBox(height: 10),
            ],
            if (!showAll && filteredMeds.isEmpty)
              CustomCard(
                  leading: const Icon(FontAwesomeIcons.pills),
                  title: AppText.subHeading(
                      AppLocalizations.of(context)!.meds_not_running_out))
            else if (showAll)
              const SizedBox(height: edgeInset),
            ...filteredMeds.map((med) => MedCard(medication: med)),
            const SizedBox(
              height: 75,
            ), // add bottom padding to not hide behind floatingActionButton
          ],
        );
      },
    );
  }
}
