// ignore_for_file: use_build_context_synchronously,

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/services/stats/firestore_service.dart';
import 'package:iaso/src/services/stats/provider.dart';
import 'package:iaso/src/services/stats/stats.dart';
import 'package:iaso/src/widgets/animated_button.dart';
import 'package:iaso/src/widgets/app_text.dart';
import 'package:iaso/src/widgets/input_text_form.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class StatsModal extends ConsumerWidget {
  final DateTime selectedDate;

  const StatsModal({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = selectedDate;
    List months = [
      (AppLocalizations.of(context)!.january),
      (AppLocalizations.of(context)!.february),
      (AppLocalizations.of(context)!.march),
      (AppLocalizations.of(context)!.april),
      (AppLocalizations.of(context)!.may),
      (AppLocalizations.of(context)!.june),
      (AppLocalizations.of(context)!.july),
      (AppLocalizations.of(context)!.august),
      (AppLocalizations.of(context)!.september),
      (AppLocalizations.of(context)!.october),
      (AppLocalizations.of(context)!.november),
      (AppLocalizations.of(context)!.december)
    ];
    final month = months[selected.month-1];

    return Padding(
      padding: const EdgeInsets.only(bottom: navBar),
      child: FloatingActionButton(
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) {
              return [
                WoltModalSheetPage(
                  child: StatsForm(selectedDate: selectedDate),
                  topBarTitle: AppText.heading("$month ${selected.day}"),
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
          );
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }
}

class StatsForm extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const StatsForm({super.key, required this.selectedDate});

  @override
  ConsumerState<StatsForm> createState() => _StatsFormState();
}

class _StatsFormState extends ConsumerState<StatsForm> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadExistingData();
  }

  void _initControllers() {
    for (var field in ['bpMorningSYS', 'bpMorningDIA', 'bpMorningPulse', 'weight', 'temp', 'bpNightSYS', 'bpNightDIA', 'bpNightPulse']) {
      _controllers[field] = TextEditingController();
    }
  }

  void _loadExistingData() {
    final statsAsync = ref.read(statsProvider);
    statsAsync.whenData((stats) {
      if (stats != null) {
        setState(() {
          _controllers['bpMorningSYS']?.text = stats.bpMorningSYS?.toString() ?? '';
          _controllers['bpMorningDIA']?.text = stats.bpMorningDIA?.toString() ?? '';
          _controllers['bpMorningPulse']?.text = stats.bpMorningPulse?.toString() ?? '';
          _controllers['weight']?.text = stats.weight?.toString() ?? '';
          _controllers['temp']?.text = stats.temp?.toString() ?? '';
          _controllers['bpNightSYS']?.text = stats.bpNightSYS?.toString() ?? '';
          _controllers['bpNightDIA']?.text = stats.bpNightDIA?.toString() ?? '';
          _controllers['bpNightPulse']?.text = stats.bpNightPulse?.toString() ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(edgeInset, edgeInset, edgeInset, 35),
        child: Column(
          children: [
            const SizedBox(height: 9,),
            Text("${AppLocalizations.of(context)!.morning_blood_pressure}:", style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
            const SizedBox(height: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpMorningSYS'],
                  labelText: 'SYS',
                ),
                const Text("/", style: TextStyle(fontSize: 16),),
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpMorningDIA'],
                  labelText: 'DIA',
                ),
                const Text("mmHg", style: TextStyle(fontSize: 16),),
                const SizedBox(
                  width: 10.0, // Add horizontal spacing between the fields
                ),
                InputTextForm(
                  width: 80.0,
                  controller: _controllers['bpMorningPulse'],
                  labelText: AppLocalizations.of(context)!.pulse,
                ),
                const Text("bpm", style: TextStyle(fontSize: 16),),
              ],
            ), 
            
            const SizedBox(height: 22,),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${AppLocalizations.of(context)!.temperature}:   ", style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                InputTextForm(
                  width: 80.0,
                  controller: _controllers['temp'],
                  labelText: '00.0',
                ),
                const Text("°C", style: TextStyle(fontSize: 16),),
              ],
            ),
            
            const SizedBox(height: 22,),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${AppLocalizations.of(context)!.weight}:   ", style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                InputTextForm(
                  width: 80.0,
                  controller: _controllers['weight'],
                  labelText: '00.0',
                ),
                const Text("Kg", style: TextStyle(fontSize: 16),),
              ],
            ),
            
            const SizedBox(height: 22,),
        
            Text("${AppLocalizations.of(context)!.night_blood_pressure}:", style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
            const SizedBox(height: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpNightSYS'],
                  labelText: 'SYS',
                ),
                const Text("/", style: TextStyle(fontSize: 16),),
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpNightDIA'],
                  labelText: 'DIA',
                ),
                const Text("mmHg", style: TextStyle(fontSize: 16),),
                const SizedBox(
                  width: 10.0, // Add horizontal spacing between the fields
                ),
                InputTextForm(
                  width: 80.0,
                  controller: _controllers['bpNightPulse'],
                  labelText: AppLocalizations.of(context)!.pulse,
                ),
                const Text("bpm", style: TextStyle(fontSize: 16),),
              ],
            ),
            const SizedBox(height: 16,),

            AnimatedButton(
              onTap: _submitForm, 
              text: AppLocalizations.of(context)!.save, 
              progressEvent: _loading
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      _loading = true;
    });

    if (_formKey.currentState!.validate()) {
      final stats = Stats(
        bpMorningSYS: int.tryParse(_controllers['bpMorningSYS']!.text),
        bpMorningDIA: int.tryParse(_controllers['bpMorningDIA']!.text),
        bpMorningPulse: int.tryParse(_controllers['bpMorningPulse']!.text),
        weight: double.tryParse(_controllers['weight']!.text),
        temp: double.tryParse(_controllers['temp']!.text),
        bpNightSYS: int.tryParse(_controllers['bpNightSYS']!.text),
        bpNightDIA: int.tryParse(_controllers['bpNightDIA']!.text),
        bpNightPulse: int.tryParse(_controllers['bpNightPulse']!.text),
        dateField: ref.read(selectedDateProvider),
      );

      try {
        await StatsFirestoreService().createStatsForUser(stats);
        ref.invalidate(statsProvider);
        Navigator.of(context).pop();

        CherryToast.success(
          title: Text(AppLocalizations.of(context)!.saved),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      } catch (e) {
        CherryToast.error(
          title: Text("${AppLocalizations.of(context)!.error_saving}: \n $e"),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      }
    }

    setState(() {
      _loading = true;
    });
  }
}
