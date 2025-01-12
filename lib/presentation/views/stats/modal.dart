// ignore_for_file: use_build_context_synchronously,

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/data/provider/stats_provider.dart';
import 'package:iaso/domain/stats.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/views/settings/stats_view.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/input_text_form.dart';
import 'package:iaso/utils/toast.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class StatsModal extends ConsumerWidget {
  final DateTime selectedDate;

  const StatsModal({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final selected = selectedDate;
    List months = [
      (l10n.translate('january')),
      (l10n.translate('february')),
      (l10n.translate('march')),
      (l10n.translate('april')),
      (l10n.translate('may')),
      (l10n.translate('june')),
      (l10n.translate('july')),
      (l10n.translate('august')),
      (l10n.translate('september')),
      (l10n.translate('october')),
      (l10n.translate('november')),
      (l10n.translate('december'))
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
    final l10n = AppLocalizations.of(context);
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
                  text: l10n.translate('save'),
                  progressEvent: _loading),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text("${l10n.translate('error')}: $error"),
        ),
      ),
    );
  }

  Widget _buildWeightField() {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText.subHeading("${l10n.translate('weight')}:"),
          const SizedBox(
            width: 4,
          ),
          InputTextForm(
            width: 80.0,
            controller: _controllers['weight'],
            labelText: '00.0',
            isInteger: false,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText.subHeading("${l10n.translate('temperature')}:"),
          const SizedBox(
            width: 4,
          ),
          InputTextForm(
            width: 80.0,
            controller: _controllers['temp'],
            labelText: '00.0',
            isInteger: false,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText.subHeading("${l10n.translate('night_temperature')}:"),
          const SizedBox(
            width: 4,
          ),
          InputTextForm(
            width: 80.0,
            controller: _controllers['nightTemp'],
            labelText: '00.0',
            isInteger: false,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppText.subHeading(
                  "${l10n.translate('morning_blood_pressure')}:"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpMorningSYS'],
                  labelText: 'SYS',
                  isInteger: true,
                ),
                const Text(
                  "/",
                  style: TextStyle(fontSize: 16),
                ),
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpMorningDIA'],
                  labelText: 'DIA',
                  isInteger: true,
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
                  labelText: l10n.translate('pulse'),
                  isInteger: true,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppText.subHeading(
                  "${l10n.translate('night_blood_pressure')}:"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpNightSYS'],
                  labelText: 'SYS',
                  isInteger: true,
                ),
                const Text(
                  "/",
                  style: TextStyle(fontSize: 16),
                ),
                InputTextForm(
                  width: 60.0,
                  controller: _controllers['bpNightDIA'],
                  labelText: 'DIA',
                  isInteger: true,
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
                  labelText: l10n.translate('pulse'),
                  isInteger: true,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppText.subHeading("${l10n.translate('blood_sugar')}:"),
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
              isInteger: false,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppText.subHeading("${l10n.translate('urine')}:"),
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
              isInteger: false,
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
    final l10n = AppLocalizations.of(context);

    setState(() {
      _loading = true;
    });

    try {
      final statsRepository = ref.read(statsRepositoryProvider);
      final stats = Stats(
        bpMorningSYS: int.tryParse(_controllers['bpMorningSYS']!.text),
        bpMorningDIA: int.tryParse(_controllers['bpMorningDIA']!.text),
        bpMorningPulse: int.tryParse(_controllers['bpMorningPulse']!.text),
        weight:
            double.tryParse(_controllers['weight']!.text.replaceAll(',', '.')),
        temp: double.tryParse(_controllers['temp']!.text.replaceAll(',', '.')),
        nightTemp: double.tryParse(
            _controllers['nightTemp']!.text.replaceAll(',', '.')),
        bpNightSYS: int.tryParse(_controllers['bpNightSYS']!.text),
        bpNightDIA: int.tryParse(_controllers['bpNightDIA']!.text),
        bpNightPulse: int.tryParse(_controllers['bpNightPulse']!.text),
        bloodSugar: _bloodSugarControllers
            .map((controller) =>
                double.tryParse(controller.text.replaceAll(',', '.')) ?? 0)
            .where((value) => value > 0)
            .toList(),
        urine: _urineControllers
            .map((controller) =>
                double.tryParse(controller.text.replaceAll(',', '.')) ?? 0)
            .where((value) => value > 0)
            .toList(),
        dateField: ref.read(selectedDateProvider),
      );

      await statsRepository.saveStats(stats);
      ref.invalidate(statsProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ToastUtil.success(context, l10n.translate('stats_saved'));
      }
    } catch (e) {
      if (e is ApiError) {
        ToastUtil.error(context, e.getTranslatedMessage(l10n));
      } else {
        ToastUtil.error(context, l10n.translate('server_error'));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
