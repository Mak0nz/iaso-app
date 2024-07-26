import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/app_services/dose_calculator.dart';
import 'package:iaso/src/app_services/number_formatter.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/domain/medication.dart';
import 'package:iaso/src/data/med_provider.dart';
import 'package:iaso/src/presentation/widgets/animated_button.dart';
import 'package:iaso/src/presentation/widgets/app_text.dart';
import 'package:iaso/src/presentation/widgets/input_med_form.dart';
import 'package:iaso/src/presentation/widgets/outlined_button.dart';

class CreateEditMedModal extends ConsumerStatefulWidget {
  final Medication? medication;

  const CreateEditMedModal({super.key, this.medication});

  @override
  // ignore: library_private_types_in_public_api
  _CreateEditMedModalState createState() => _CreateEditMedModalState();
}

class _CreateEditMedModalState extends ConsumerState<CreateEditMedModal> {
  late TextEditingController nameController;
  late TextEditingController activeAgentController;
  late TextEditingController useCaseController;
  late TextEditingController sideEffectController;
  late TextEditingController takeQuantityPerDayController;
  late TextEditingController currentQuantityController;
  late TextEditingController orderedByController;
  late bool isInCloud;
  late List<bool> takeDays;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final med = widget.medication;
    nameController = TextEditingController(text: med?.name ?? '');
    activeAgentController = TextEditingController(text: med?.activeAgent ?? '');
    useCaseController = TextEditingController(text: med?.useCase ?? '');
    sideEffectController = TextEditingController(text: med?.sideEffect ?? '');
    takeQuantityPerDayController = TextEditingController(text: NumberFormatter.formatDouble(med?.takeQuantityPerDay ?? 0).toString());
    currentQuantityController = TextEditingController(text: NumberFormatter.formatDouble(med?.currentQuantity ?? 0).toString());
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(edgeInset, edgeInset, edgeInset, 35),
      child: Column(
        children: [
          InputMedForm(
            controller: nameController, 
            labelText: AppLocalizations.of(context)!.med_name, 
            require: true,
          ),
          
          InputMedForm(
            controller: activeAgentController, 
            labelText: AppLocalizations.of(context)!.active_agent,
          ),
          
          InputMedForm(
            controller: useCaseController, 
            labelText: AppLocalizations.of(context)!.use_case
          ),
          
          InputMedForm(
            controller: sideEffectController, 
            labelText: AppLocalizations.of(context)!.side_effect
          ),
          
          InputMedForm(
            controller: takeQuantityPerDayController, 
            labelText: AppLocalizations.of(context)!.daily_quantity,
            textInputType: TextInputType.number, 
            require: true,
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: edgeInset, top: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  AppText.subHeading(AppLocalizations.of(context)!.intake_which_days), 
                  const Text('*', style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              )),
          ),
          ...List.generate(7, (index) {
            final days = [
              (AppLocalizations.of(context)!.monday), 
              (AppLocalizations.of(context)!.tuesday), 
              (AppLocalizations.of(context)!.wednesday), 
              (AppLocalizations.of(context)!.thursday), 
              (AppLocalizations.of(context)!.friday), 
              (AppLocalizations.of(context)!.saturday), 
              (AppLocalizations.of(context)!.sunday)
            ];
            return CheckboxListTile(
              title: Text(days[index]),
              value: takeDays[index],
              onChanged: (value) => setState(() => takeDays[index] = value!),
            );
          }),
          
          InputMedForm(
            controller: currentQuantityController, 
            labelText: AppLocalizations.of(context)!.current_quantity,
            textInputType: TextInputType.number, 
            require: true,
          ),
          
          InputMedForm(
            controller: orderedByController, 
            labelText: AppLocalizations.of(context)!.ordered_by,
          ),
          
          CheckboxListTile(
            title: Text(AppLocalizations.of(context)!.is_in_cloud),
            value: isInCloud,
            onChanged: (value) => setState(() => isInCloud = value!),
          ),

          AnimatedButton(
            onTap: saveMed, 
            text: widget.medication == null ? (AppLocalizations.of(context)!.create) : (AppLocalizations.of(context)!.update), 
            progressEvent: _loading,
          ),

          if (widget.medication != null)
            Padding(
              padding: const EdgeInsets.only(top: 23),
              child: CustomOutlinedButton(
                onTap: deleteMed, 
                text: AppLocalizations.of(context)!.delete, 
                progressEvent: _loading, 
                outlineColor: Colors.red,
              ),
            ),
            
        ],
      ),
    );
  }

  final _doseCalculator = DoseCalculator();

  Future saveMed() async {
    final currentQuantity = double.tryParse(currentQuantityController.text) ?? 0;
    final takeQuantityPerDay = double.tryParse(takeQuantityPerDayController.text) ?? 0;

    final totalDoses = _doseCalculator.calculateTotalDoses(currentQuantity, takeQuantityPerDay);

    setState(() {
      _loading = true;
    });

    final medication = Medication(
      id: widget.medication?.id,
      name: nameController.text,
      activeAgent: activeAgentController.text.isNotEmpty ? activeAgentController.text : null,
      useCase: useCaseController.text.isNotEmpty ? useCaseController.text : null,
      sideEffect: sideEffectController.text.isNotEmpty ? sideEffectController.text : null,
      takeMonday: takeDays[0],
      takeTuesday: takeDays[1],
      takeWednesday: takeDays[2],
      takeThursday: takeDays[3],
      takeFriday: takeDays[4],
      takeSaturday: takeDays[5],
      takeSunday: takeDays[6],
      orderedBy: orderedByController.text.isNotEmpty ? orderedByController.text : null,
      isInCloud: isInCloud,
      currentQuantity: currentQuantity,
      takeQuantityPerDay: takeQuantityPerDay,
      totalDoses: totalDoses,
      lastUpdatedDate: DateTime.now(),
    );
    
    if (widget.medication == null) {
      ref.read(medRepositoryProvider).addMedication(medication);
      CherryToast.success(
        title: Text(AppLocalizations.of(context)!.saved),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
    } else {
      ref.read(medRepositoryProvider).updateMedication(medication);
      CherryToast.success(
        title: Text(AppLocalizations.of(context)!.saved),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
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
        title: Text(AppLocalizations.of(context)!.delete_med),
        content: Text(AppLocalizations.of(context)!.delete_med_description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(medRepositoryProvider).deleteMedication(widget.medication!.id!);

              CherryToast.success(
                title: Text(AppLocalizations.of(context)!.success_delete),
                animationType: AnimationType.fromTop,
                displayCloseButton: false,
                inheritThemeColors: true,
              ).show(context);

              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close modal
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    setState(() {
      _loading = false;
    });
  }

}