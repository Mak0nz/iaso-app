import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/services/meds/provider.dart';
import 'package:iaso/src/views/meds/med_card.dart';
import 'package:iaso/src/widgets/app_text.dart';
import 'package:iaso/src/widgets/card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DisplayMeds extends ConsumerWidget {
  final bool showAll;

  const DisplayMeds({super.key, required this.showAll});

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
      error: (error, stack) => Center(child: Text('${AppLocalizations.of(context)!.error}: $error')),
      data: (meds) {
        final filteredMeds = showAll ? meds : meds.where((med) => med.totalDoses <= 14).toList();
        
        return ListView(
          children: [
            if (!showAll) ...[
              Padding(
                padding: const EdgeInsets.only(left: edgeInset, top: edgeInset),
                child: AppText.subHeading("${AppLocalizations.of(context)!.meds_running_out}:"),
              ),
              const SizedBox(height: 10),
            ],
            if (!showAll && filteredMeds.isEmpty)
              CustomCard(
                leading: const Icon(FontAwesomeIcons.pills),
                title: AppText.subHeading(AppLocalizations.of(context)!.meds_not_running_out)
              )
            else
              ...filteredMeds.map((med) => MedCard(medication: med)),
          ],
        );
      },
    );
  }
}