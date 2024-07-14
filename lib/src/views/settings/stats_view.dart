import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/widgets/app_text.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

final statsViewSettingsProvider = StateNotifierProvider<StatsViewSettingsNotifier, Map<String, bool>>((ref) {
  return StatsViewSettingsNotifier();
});

class StatsViewSettingsNotifier extends StateNotifier<Map<String, bool>> {
  StatsViewSettingsNotifier() : super({}) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = {
      'weight': prefs.getBool('show_weight') ?? true,
      'temperature': prefs.getBool('show_temperature') ?? true,
      'morningBP': prefs.getBool('show_morning_bp') ?? true,
      'nightBP': prefs.getBool('show_night_bp') ?? true,
      'bloodSugar': prefs.getBool('show_blood_sugar') ?? true,
    };
  }

  Future<void> toggleSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !(state[key] ?? true);
    await prefs.setBool('show_$key', newValue);
    state = {...state, key: newValue};
  }
}

class StatsViewSettingsModal extends ConsumerWidget {
  const StatsViewSettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        WoltModalSheet.show(
          context: context,
          pageListBuilder: (context) {
            return [
              WoltModalSheetPage(
                topBarTitle: AppText.heading(AppLocalizations.of(context)!.stats_view),
                isTopBarLayerAlwaysVisible: true,
                trailingNavBarWidget: IconButton(
                  padding: const EdgeInsets.only(right: 20),
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(FontAwesomeIcons.xmark),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(edgeInset),
                  child: StatsViewSettingsContent(),
                ),
              ),
            ];
          },
        );
      },
      child: const Icon(FontAwesomeIcons.chevronRight),
    );
  }
}

class StatsViewSettingsContent extends ConsumerWidget {
  const StatsViewSettingsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(statsViewSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.stats_view_description,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        _buildCheckboxListTile(context, ref, 'weight', AppLocalizations.of(context)!.weight, settings),
        _buildCheckboxListTile(context, ref, 'temperature', AppLocalizations.of(context)!.temperature, settings),
        _buildCheckboxListTile(context, ref, 'morningBP', AppLocalizations.of(context)!.morning_blood_pressure, settings),
        _buildCheckboxListTile(context, ref, 'nightBP', AppLocalizations.of(context)!.night_blood_pressure, settings),
        _buildCheckboxListTile(context, ref, 'bloodSugar', AppLocalizations.of(context)!.blood_sugar, settings),
      ],
    );
  }

  Widget _buildCheckboxListTile(BuildContext context, WidgetRef ref, String key, String title, Map<String, bool> settings) {
    return CheckboxListTile(
      title: Text(title),
      value: settings[key] ?? true,
      onChanged: (bool? value) {
        ref.read(statsViewSettingsProvider.notifier).toggleSetting(key);
      },
    );
  }
}