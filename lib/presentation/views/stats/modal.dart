// ignore_for_file: use_build_context_synchronously,

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/data/stats_repository.dart';
import 'package:iaso/data/stats_provider.dart';
import 'package:iaso/domain/stats.dart';
import 'package:iaso/presentation/views/settings/stats_view.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/input_text_form.dart';
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
    final month = months[selected.month - 1];

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
  final List<TextEditingController> _bloodSugarControllers = [];
  final List<TextEditingController> _urineControllers = [];

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadExistingData();
  }

  void _initControllers() {
    for (var field in [
      'bpMorningSYS',
      'bpMorningDIA',
      'bpMorningPulse',
      'weight',
      'temp',
      'nightTemp',
      'bpNightSYS',
      'bpNightDIA',
      'bpNightPulse'
    ]) {
      _controllers[field] = TextEditingController();
    }
    _bloodSugarControllers.add(TextEditingController());
    _urineControllers.add(TextEditingController());
  }

  void _loadExistingData() {
    final statsAsync = ref.read(statsProvider);
    statsAsync.whenData((stats) {
      if (stats != null) {
        setState(() {
          _controllers['bpMorningSYS']?.text =
              stats.bpMorningSYS?.toString() ?? '';
          _controllers['bpMorningDIA']?.text =
              stats.bpMorningDIA?.toString() ?? '';
          _controllers['bpMorningPulse']?.text =
              stats.bpMorningPulse?.toString() ?? '';
          _controllers['weight']?.text = stats.weight?.toString() ?? '';
          _controllers['temp']?.text = stats.temp?.toString() ?? '';
          _controllers['nightTemp']?.text = stats.nightTemp?.toString() ?? '';
          _controllers['bpNightSYS']?.text = stats.bpNightSYS?.toString() ?? '';
          _controllers['bpNightDIA']?.text = stats.bpNightDIA?.toString() ?? '';
          _controllers['bpNightPulse']?.text =
              stats.bpNightPulse?.toString() ?? '';
        });

        // Load blood sugar values
        _bloodSugarControllers.clear();
        if (stats.bloodSugar != null && stats.bloodSugar!.isNotEmpty) {
          for (var value in stats.bloodSugar!) {
            _bloodSugarControllers
                .add(TextEditingController(text: value.toString()));
          }
        } else {
          _bloodSugarControllers.add(TextEditingController());
        }

        // Load urine values
        _urineControllers.clear();
        if (stats.urine != null && stats.urine!.isNotEmpty) {
          for (var value in stats.urine!) {
            _urineControllers
                .add(TextEditingController(text: value.toString()));
          }
        } else {
          _urineControllers.add(TextEditingController());
        }
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var controller in _bloodSugarControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsyncValue = ref.watch(statsViewSettingsProvider);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(edgeInset, edgeInset, edgeInset, 35),
        child: settingsAsyncValue.when(
          data: (settings) => Column(
            children: [
              if (settings['weight'] ?? true) _buildWeightField(),
              if (settings['temperature'] ?? true) _buildTemperatureField(),
              if (settings['nightTemperature'] ?? true)
                _buildNightTemperatureField(),
              if (settings['morningBP'] ?? true) _buildMorningBPField(),
              if (settings['nightBP'] ?? true) _buildNightBPField(),
              if (settings['bloodSugar'] ?? true) _buildBSField(),
              if (settings['urine'] ?? true) _buildUrineField(),
              const SizedBox(
                height: 11,
              ),
              AnimatedButton(
                  onTap: _submitForm,
                  text: AppLocalizations.of(context)!.save,
                  progressEvent: _loading),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) =>
              Text("${AppLocalizations.of(context)!.error}: $error"),
        ),
      ),
    );
  }

  Widget _buildWeightField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText.subHeading("${AppLocalizations.of(context)!.weight}:"),
          const SizedBox(
            width: 4,
          ),
          InputTextForm(
            width: 80.0,
            controller: _controllers['weight'],
            labelText: '00.0',
          ),
          const Text(
            "Kg",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText.subHeading("${AppLocalizations.of(context)!.temperature}:"),
          const SizedBox(
            width: 4,
          ),
          InputTextForm(
            width: 80.0,
            controller: _controllers['temp'],
            labelText: '00.0',
          ),
          const Text(
            "°C",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNightTemperatureField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText.subHeading(
              "${AppLocalizations.of(context)!.night_temperature}:"),
          const SizedBox(
            width: 4,
          ),
          InputTextForm(
            width: 80.0,
            controller: _controllers['nightTemp'],
            labelText: '00.0',
          ),
          const Text(
            "°C",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMorningBPField() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppText.subHeading(
                  "${AppLocalizations.of(context)!.morning_blood_pressure}:"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpMorningSYS'],
                  labelText: 'SYS',
                ),
                const Text(
                  "/",
                  style: TextStyle(fontSize: 16),
                ),
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpMorningDIA'],
                  labelText: 'DIA',
                ),
                const Text(
                  "mmHg",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 10.0, // Add horizontal spacing between the fields
                ),
                InputTextForm(
                  width: 80.0,
                  controller: _controllers['bpMorningPulse'],
                  labelText: AppLocalizations.of(context)!.pulse,
                ),
                const Text(
                  "bpm",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildNightBPField() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppText.subHeading(
                  "${AppLocalizations.of(context)!.night_blood_pressure}:"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpNightSYS'],
                  labelText: 'SYS',
                ),
                const Text(
                  "/",
                  style: TextStyle(fontSize: 16),
                ),
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpNightDIA'],
                  labelText: 'DIA',
                ),
                const Text(
                  "mmHg",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 10.0, // Add horizontal spacing between the fields
                ),
                InputTextForm(
                  width: 80.0,
                  controller: _controllers['bpNightPulse'],
                  labelText: AppLocalizations.of(context)!.pulse,
                ),
                const Text(
                  "bpm",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildBSField() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppText.subHeading(
                  "${AppLocalizations.of(context)!.blood_sugar}:"),
            ),
            ..._buildBloodSugarFields(),
          ],
        ));
  }

  List<Widget> _buildBloodSugarFields() {
    return List.generate(_bloodSugarControllers.length, (index) {
      return Row(
        children: [
          Expanded(
            child: InputTextForm(
              controller: _bloodSugarControllers[index],
              labelText: 'mg/dL',
            ),
          ),
          IconButton(
            icon: Icon(index == _bloodSugarControllers.length - 1
                ? FontAwesomeIcons.plus
                : FontAwesomeIcons.minus),
            onPressed: () {
              setState(() {
                if (index == _bloodSugarControllers.length - 1) {
                  _bloodSugarControllers.add(TextEditingController());
                } else {
                  _bloodSugarControllers.removeAt(index);
                }
              });
            },
          ),
        ],
      );
    });
  }

  Widget _buildUrineField() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child:
                  AppText.subHeading("${AppLocalizations.of(context)!.urine}:"),
            ),
            ..._buildUrineFields(),
          ],
        ));
  }

  List<Widget> _buildUrineFields() {
    return List.generate(_urineControllers.length, (index) {
      return Row(
        children: [
          Expanded(
            child: InputTextForm(
              controller: _urineControllers[index],
              labelText: 'mL',
            ),
          ),
          IconButton(
            icon: Icon(index == _urineControllers.length - 1
                ? FontAwesomeIcons.plus
                : FontAwesomeIcons.minus),
            onPressed: () {
              setState(() {
                if (index == _urineControllers.length - 1) {
                  _urineControllers.add(TextEditingController());
                } else {
                  _urineControllers.removeAt(index);
                }
              });
            },
          ),
        ],
      );
    });
  }

  void _submitForm() async {
    setState(() {
      _loading = true;
    });

    if (_formKey.currentState!.validate()) {
      final bloodSugarValues = _bloodSugarControllers
          .map((controller) => double.tryParse(controller.text))
          .where((value) => value != null)
          .map((value) =>
              value!) // This line ensures we have non-nullable doubles
          .toList();

      final urineValues = _urineControllers
          .map((controller) => double.tryParse(controller.text))
          .where((value) => value != null)
          .map((value) =>
              value!) // This line ensures we have non-nullable doubles
          .toList();

      final stats = Stats(
        bpMorningSYS: int.tryParse(_controllers['bpMorningSYS']!.text),
        bpMorningDIA: int.tryParse(_controllers['bpMorningDIA']!.text),
        bpMorningPulse: int.tryParse(_controllers['bpMorningPulse']!.text),
        weight: double.tryParse(_controllers['weight']!.text),
        temp: double.tryParse(_controllers['temp']!.text),
        nightTemp: double.tryParse(_controllers['nightTemp']!.text),
        bpNightSYS: int.tryParse(_controllers['bpNightSYS']!.text),
        bpNightDIA: int.tryParse(_controllers['bpNightDIA']!.text),
        bpNightPulse: int.tryParse(_controllers['bpNightPulse']!.text),
        bloodSugar: bloodSugarValues.isNotEmpty ? bloodSugarValues : null,
        urine: urineValues.isNotEmpty ? urineValues : null,
        dateField: ref.read(selectedDateProvider),
      );

      try {
        await StatsRepository().createStatsForUser(stats);
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
      _loading = false;
    });
  }
}
