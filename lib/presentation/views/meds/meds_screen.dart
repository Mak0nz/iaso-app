import 'package:flutter/material.dart';
import 'package:iaso/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/app_services/med_sort_manager.dart';
import 'package:iaso/presentation/views/meds/create_edit_med_modal.dart';
import 'package:iaso/presentation/views/meds/meds_display.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/appbar.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MedsScreen extends ConsumerWidget {
  const MedsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sortModeAsync = ref.watch(medSortModeProvider);
    final showZeroDosesAsync = ref.watch(showZeroDosesProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.meds,
        leading: sortModeAsync.when(
          data: (sortMode) => Icon(sortMode.icon),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Icon(Icons.error),
        ),
        leadingEvent: () => _showSortMenu(context, ref),
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
                  topBarTitle: AppText.heading(l10n.create_med),
                  isTopBarLayerAlwaysVisible: true,
                  enableDrag: false,
                )
              ];
            },
          ),
          child: const Icon(FontAwesomeIcons.plus),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: edgeInset),
        child: sortModeAsync.when(
          data: (sortMode) => showZeroDosesAsync.when(
            data: (showZeroDoses) => DisplayMeds(
              showAll: true,
              sortMode: sortMode,
              showZeroDoses: showZeroDoses,
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Error loading settings'),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('Error loading settings'),
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sortModeAsync = ref.read(medSortModeProvider);
    final showZeroDosesAsync = ref.read(showZeroDosesProvider);

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
      items: [
        for (var mode in MedSortMode.values)
          PopupMenuItem<MedSortMode>(
            value: mode,
            child: ListTile(
              leading: Icon(mode.icon),
              title: Text(mode.getName(context)),
              trailing: sortModeAsync.whenOrNull(
                data: (currentMode) =>
                    mode == currentMode ? const Icon(Icons.check) : null,
              ),
            ),
          ),
        const PopupMenuItem(child: Divider()),
        PopupMenuItem(
          child: ListTile(
            leading: showZeroDosesAsync.whenOrNull(
                  data: (show) =>
                      Icon(show ? Icons.visibility : Icons.visibility_off),
                ) ??
                const SizedBox(),
            title: Text(l10n.show_zero_doses),
            trailing: Switch(
              value:
                  showZeroDosesAsync.whenOrNull(data: (show) => show) ?? false,
              onChanged: (value) {
                ref
                    .read(showZeroDosesProvider.notifier)
                    .setShowZeroDoses(value);
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null && value is MedSortMode) {
        ref.read(medSortModeProvider.notifier).setSortMode(value);
      }
    });
  }
}
