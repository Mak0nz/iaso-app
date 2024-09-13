import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/utils/dose_calculator.dart';
import 'package:iaso/utils/number_formatter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/domain/medication.dart';
import 'package:iaso/data/med_provider.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/input_med_form.dart';
import 'package:iaso/presentation/widgets/outlined_button.dart';
import 'package:iaso/utils/toast.dart';

class CreateEditMedModal extends ConsumerStatefulWidget {
  final Medication? medication;

  const CreateEditMedModal({super.key, this.medication});

  @override
  // ignore: library_private_types_in_public_api
  _CreateEditMedModalState createState() => _CreateEditMedModalState();
}

class _CreateEditMedModalState extends ConsumerState<CreateEditMedModal> {
  late final l10n = AppLocalizations.of(context)!;
  late TextEditingController nameController;
  late TextEditingController nameReplacementController;
  late TextEditingController activeAgentController;
  late TextEditingController useCaseController;
  late TextEditingController sideEffectController;
  late TextEditingController takeQuantityPerDayController;
  late TextEditingController currentQuantityController;
  late TextEditingController orderedByController;
  late bool isInCloud;
  late List<bool> takeDays;
  late List<bool> originalTakeDays;
  late bool isAlternatingSchedule;
  late bool takeEveryDay;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final med = widget.medication;
    nameController = TextEditingController(text: med?.name ?? '');
    nameReplacementController =
        TextEditingController(text: med?.nameReplacement ?? '');
    activeAgentController = TextEditingController(text: med?.activeAgent ?? '');
    useCaseController = TextEditingController(text: med?.useCase ?? '');
    sideEffectController = TextEditingController(text: med?.sideEffect ?? '');
    takeQuantityPerDayController = TextEditingController(
        text: NumberFormatter.formatDouble(med?.takeQuantityPerDay ?? 0)
            .toString());
    currentQuantityController = TextEditingController(
        text:
            NumberFormatter.formatDouble(med?.currentQuantity ?? 0).toString());
    orderedByController = TextEditingController(text: med?.orderedBy ?? '');
    isInCloud = med?.isInCloud ?? false;
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(edgeInset, edgeInset, edgeInset, 35),
      child: Column(
        children: [
          InputMedForm(
            controller: nameController,
            labelText: l10n.med_name,
            require: true,
          ),
          InputMedForm(
            controller: nameReplacementController,
            labelText: l10n.med_replacement_name,
          ),
          InputMedForm(
            controller: activeAgentController,
            labelText: l10n.active_agent,
          ),
          InputMedForm(controller: useCaseController, labelText: l10n.use_case),
          InputMedForm(
              controller: sideEffectController, labelText: l10n.side_effect),
          InputMedForm(
            controller: takeQuantityPerDayController,
            labelText: l10n.daily_quantity,
            textInputType: TextInputType.number,
            require: true,
          ),
          Padding(
              padding: const EdgeInsets.only(left: edgeInset, top: 6),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      AppText.subHeading(l10n.intake_which_days),
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ))),
          SwitchListTile(
            title: Text(l10n.take_every_day),
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
          if (!takeEveryDay && !isAlternatingSchedule) ..._buildDailySchedule(),
          SwitchListTile(
            title: Text(l10n.take_alternating_days),
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
          InputMedForm(
            controller: currentQuantityController,
            labelText: l10n.current_quantity,
            textInputType: TextInputType.number,
            require: true,
          ),
          InputMedForm(
            controller: orderedByController,
            labelText: l10n.ordered_by,
          ),
          CheckboxListTile(
            title: Text(l10n.is_in_cloud),
            value: isInCloud,
            onChanged: (value) => setState(() => isInCloud = value!),
          ),
          AnimatedButton(
            onTap: saveMed,
            text: widget.medication == null ? (l10n.create) : (l10n.update),
            progressEvent: _loading,
          ),
          if (widget.medication != null)
            Padding(
              padding: const EdgeInsets.only(top: 23),
              child: CustomOutlinedButton(
                onTap: deleteMed,
                text: l10n.delete,
                progressEvent: _loading,
                outlineColor: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildDailySchedule() {
    final days = [
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
      l10n.sunday,
    ];
    return [
      ...List.generate(7, (index) {
        return CheckboxListTile(
          title: Text(days[index]),
          value: takeDays[index],
          onChanged: (value) {
            setState(() {
              takeDays[index] = value!;
              takeEveryDay = takeDays.every((day) => day);
            });
          },
        );
      }),
    ];
  }

  Future saveMed() async {
    setState(() {
      _loading = true;
    });

    final doseCalculator = DoseCalculator();
    final currentQuantity =
        double.tryParse(currentQuantityController.text) ?? 0;
    final takeQuantityPerDay =
        double.tryParse(takeQuantityPerDayController.text) ?? 0;

    final totalDoses = doseCalculator.calculateTotalDoses(
        currentQuantity, takeQuantityPerDay, isAlternatingSchedule);

    final medication = Medication(
      id: widget.medication?.id,
      name: nameController.text,
      nameReplacement: nameReplacementController.text.isNotEmpty
          ? nameReplacementController.text
          : null,
      activeAgent: activeAgentController.text.isNotEmpty
          ? activeAgentController.text
          : null,
      useCase:
          useCaseController.text.isNotEmpty ? useCaseController.text : null,
      sideEffect: sideEffectController.text.isNotEmpty
          ? sideEffectController.text
          : null,
      takeMonday: takeDays[0],
      takeTuesday: takeDays[1],
      takeWednesday: takeDays[2],
      takeThursday: takeDays[3],
      takeFriday: takeDays[4],
      takeSaturday: takeDays[5],
      takeSunday: takeDays[6],
      isAlternatingSchedule: isAlternatingSchedule,
      orderedBy:
          orderedByController.text.isNotEmpty ? orderedByController.text : null,
      isInCloud: isInCloud,
      currentQuantity: currentQuantity,
      takeQuantityPerDay: takeQuantityPerDay,
      totalDoses: totalDoses,
      lastUpdatedDate: DateTime.now(),
    );

    if (widget.medication == null) {
      ref.read(medRepositoryProvider).addMedication(medication);
      ToastUtil.success(context, l10n.saved);
    } else {
      ref.read(medRepositoryProvider).updateMedication(medication);
      ToastUtil.success(context, l10n.saved);
    }

    Navigator.of(context).pop();

    setState(() {
      _loading = false;
    });
  }

  Future deleteMed() async {
    setState(() {
      _loading = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_med),
        content: Text(l10n.delete_med_description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(medRepositoryProvider)
                  .deleteMedication(widget.medication!.id!);

              ToastUtil.success(context, l10n.success_delete);

              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close modal
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    setState(() {
      _loading = false;
    });
  }
}
