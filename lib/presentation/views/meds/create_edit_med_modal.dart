// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/data/provider/med_provider.dart';
import 'package:iaso/domain/user_medication.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/views/meds/med_info_view.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/input_med_form.dart';
import 'package:iaso/presentation/widgets/outlined_button.dart';
import 'package:iaso/utils/toast.dart';

enum MedModalView { info, schedule }

class CreateEditMedModal extends ConsumerStatefulWidget {
  final UserMedication? medication;

  const CreateEditMedModal({super.key, this.medication});

  @override
  ConsumerState<CreateEditMedModal> createState() => _CreateEditMedModalState();
}

class _CreateEditMedModalState extends ConsumerState<CreateEditMedModal> {
  bool _loading = false;
  MedModalView _currentView = MedModalView.info;
  late TextEditingController takeQuantityPerDayController;
  late TextEditingController currentQuantityController;
  late TextEditingController orderedByController;
  late bool isInCloud;
  late List<bool> takeDays;
  late List<bool> originalTakeDays;
  late bool isAlternatingSchedule;
  late bool takeEveryDay;

  @override
  void initState() {
    super.initState();
    final med = widget.medication;
    if (med != null) {
      ref.read(selectedMedicationProvider.notifier).state = med.medicationInfo;
    }

    takeQuantityPerDayController = TextEditingController(
      text: med?.takeQuantityPerDay.toString() ?? '',
    );
    currentQuantityController = TextEditingController(
      text: med?.currentQuantity.toString() ?? '',
    );
    orderedByController = TextEditingController(text: med?.orderedBy ?? '');
    isInCloud = med?.isInCloud ?? true;
    takeDays = [
      med?.takeMonday ?? false,
      med?.takeTuesday ?? false,
      med?.takeWednesday ?? false,
      med?.takeThursday ?? false,
      med?.takeFriday ?? false,
      med?.takeSaturday ?? false,
      med?.takeSunday ?? false,
    ];
    originalTakeDays = List.from(takeDays);
    isAlternatingSchedule = med?.isAlternatingSchedule ?? false;
    takeEveryDay = takeDays.every((day) => day);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedMedication = ref.watch(selectedMedicationProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(edgeInset, edgeInset, edgeInset, 35),
      child: Column(
        children: [
          // View selector
          SegmentedButton<MedModalView>(
            segments: [
              ButtonSegment<MedModalView>(
                value: MedModalView.info,
                label: Text(l10n.translate('med_info')),
              ),
              ButtonSegment<MedModalView>(
                value: MedModalView.schedule,
                label: Text(l10n.translate('med_schedule')),
              ),
            ],
            selected: {_currentView},
            onSelectionChanged: (Set<MedModalView> newSelection) {
              setState(() => _currentView = newSelection.first);
            },
          ),
          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: _currentView == MedModalView.info
                  ? MedicationInfoView(
                      initialMedication: widget.medication?.medicationInfo,
                      isEditing: widget.medication != null,
                    )
                  : _buildScheduleView(l10n),
            ),
          ),

          AnimatedButton(
            onTap: selectedMedication != null ? _saveMed : null,
            text: widget.medication == null
                ? l10n.translate('create')
                : l10n.translate('update'),
            progressEvent: _loading,
          ),

          if (widget.medication != null)
            Padding(
              padding: const EdgeInsets.only(top: 23),
              child: CustomOutlinedButton(
                onTap: _deleteMed,
                text: l10n.translate('delete'),
                progressEvent: _loading,
                outlineColor: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleView(AppLocalizations l10n) {
    final days = [
      l10n.translate('monday'),
      l10n.translate('tuesday'),
      l10n.translate('wednesday'),
      l10n.translate('thursday'),
      l10n.translate('friday'),
      l10n.translate('saturday'),
      l10n.translate('sunday'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputMedForm(
          controller: takeQuantityPerDayController,
          labelText: l10n.translate('daily_quantity'),
          textInputType: TextInputType.number,
          require: true,
        ),
        InputMedForm(
          controller: currentQuantityController,
          labelText: l10n.translate('current_quantity'),
          textInputType: TextInputType.number,
          require: true,
        ),
        InputMedForm(
          controller: orderedByController,
          labelText: l10n.translate('ordered_by'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: edgeInset, top: 6),
          child: AppText.subHeading(l10n.translate('intake_which_days')),
        ),
        SwitchListTile(
          title: Text(l10n.translate('take_every_day')),
          value: takeEveryDay,
          onChanged: (value) {
            setState(() {
              takeEveryDay = value;
              if (takeEveryDay) {
                isAlternatingSchedule = false;
                takeDays = List.filled(7, true);
              } else {
                takeDays = List.from(originalTakeDays);
              }
            });
          },
        ),
        if (!takeEveryDay) ...[
          SwitchListTile(
            title: Text(l10n.translate('take_alternating_days')),
            value: isAlternatingSchedule,
            onChanged: (value) {
              setState(() {
                isAlternatingSchedule = value;
                if (isAlternatingSchedule) {
                  takeEveryDay = false;
                  takeDays = List.filled(7, false);
                } else {
                  takeDays = List.from(originalTakeDays);
                }
              });
            },
          ),
          if (!isAlternatingSchedule)
            ...List.generate(7, (index) {
              return CheckboxListTile(
                title: Text(days[index]),
                value: takeDays[index],
                onChanged: (value) {
                  setState(() {
                    takeDays[index] = value ?? false;
                    takeEveryDay = takeDays.every((day) => day);
                  });
                },
              );
            }),
        ],
        CheckboxListTile(
          title: Text(l10n.translate('is_in_cloud')),
          value: isInCloud,
          onChanged: (value) => setState(() => isInCloud = value!),
        ),
      ],
    );
  }

  Future<void> _saveMed() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _loading = true);

    try {
      final selectedMedication = ref.read(selectedMedicationProvider);
      if (selectedMedication == null) return;

      final medication = UserMedication(
        id: widget.medication?.id,
        medicationId: selectedMedication.id,
        medicationInfo: selectedMedication,
        takeQuantityPerDay: double.parse(takeQuantityPerDayController.text),
        currentQuantity: double.parse(currentQuantityController.text),
        takeMonday: takeDays[0],
        takeTuesday: takeDays[1],
        takeWednesday: takeDays[2],
        takeThursday: takeDays[3],
        takeFriday: takeDays[4],
        takeSaturday: takeDays[5],
        takeSunday: takeDays[6],
        isAlternatingSchedule: isAlternatingSchedule,
        orderedBy: orderedByController.text.isNotEmpty
            ? orderedByController.text
            : null,
        isInCloud: isInCloud,
        totalDoses: 0, // Will be calculated by the backend
        lastUpdatedDate: DateTime.now(),
      );

      if (widget.medication == null) {
        await ref
            .read(medicationSyncProvider.notifier)
            .addMedication(medication);
        ToastUtil.success(context, l10n.translate('saved'));
      } else {
        await ref
            .read(medicationSyncProvider.notifier)
            .updateMedication(medication);
        ToastUtil.success(context, l10n.translate('saved'));
      }

      Navigator.of(context).pop();
    } catch (e) {
      ToastUtil.error(context, e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _deleteMed() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _loading = true);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate('delete_med')),
        content: Text(l10n.translate('delete_med_description')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.translate('cancel')),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(medicationSyncProvider.notifier)
                  .deleteMedication(widget.medication!.id!);

              ToastUtil.success(context, l10n.translate('success_delete'));
              if (mounted) {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close modal
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.translate('delete')),
          ),
        ],
      ),
    );

    setState(() => _loading = false);
  }
}
