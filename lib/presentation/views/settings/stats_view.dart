// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final initialSettingsProvider = FutureProvider<Map<String, bool>>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return {
    'weight': prefs.getBool('show_weight') ?? true,
    'temperature': prefs.getBool('show_temperature') ?? true,
    'nightTemperature': prefs.getBool('show_night_temperature') ?? true,
    'morningBP': prefs.getBool('show_morning_bp') ?? true,
    'nightBP': prefs.getBool('show_night_bp') ?? true,
    'bloodSugar': prefs.getBool('show_blood_sugar') ?? true,
    'urine': prefs.getBool('show_urine') ?? true,
  };
});

final statsViewSettingsProvider = StateNotifierProvider<
    StatsViewSettingsNotifier, AsyncValue<Map<String, bool>>>((ref) {
  final sharedPreferencesAsyncValue = ref.watch(sharedPreferencesProvider);
  final initialSettings = ref.watch(initialSettingsProvider);
  return StatsViewSettingsNotifier(
      sharedPreferencesAsyncValue, initialSettings);
});

class StatsViewSettingsNotifier
    extends StateNotifier<AsyncValue<Map<String, bool>>> {
  final AsyncValue<SharedPreferences> _sharedPreferencesAsyncValue;
  bool _mounted = true;

  StatsViewSettingsNotifier(this._sharedPreferencesAsyncValue,
      AsyncValue<Map<String, bool>> initialSettings)
      : super(initialSettings);

  Future<void> toggleSetting(String key) async {
    if (!_mounted) return;

    state = await AsyncValue.guard(() async {
      final currentSettings = state.value ?? {};
      final newValue = !(currentSettings[key] ?? true);

      final prefs = await _sharedPreferencesAsyncValue.when(
        data: (prefs) => prefs,
        loading: () => throw Exception('SharedPreferences not initialized'),
        error: (e, st) => throw Exception('Failed to load SharedPreferences'),
      );

      // Use consistent key names
      final prefKey = switch (key) {
        'weight' => 'show_weight',
        'temperature' => 'show_temperature',
        'nightTemperature' => 'show_night_temperature',
        'morningBP' => 'show_morning_bp',
        'nightBP' => 'show_night_bp',
        'bloodSugar' => 'show_blood_sugar',
        'urine' => 'show_urine',
        _ => throw Exception('Invalid key'),
      };

      await prefs.setBool(prefKey, newValue);
      return {...currentSettings, key: newValue};
    });
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

class StatsViewSettingsModal extends ConsumerWidget {
  const StatsViewSettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        WoltModalSheet.show(
          context: context,
          pageListBuilder: (BuildContext context) {
            return [
              WoltModalSheetPage(
                topBarTitle: AppText.heading(l10n.stats_view),
                isTopBarLayerAlwaysVisible: true,
                child: const ProviderScope(
                  child: Padding(
                    padding: EdgeInsets.all(edgeInset),
                    child: StatsViewSettingsContent(),
                  ),
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
    final l10n = AppLocalizations.of(context)!;
    final settingsAsyncValue = ref.watch(statsViewSettingsProvider);

    return settingsAsyncValue.when(
      data: (settings) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            l10n.stats_view_description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          _buildCheckboxListTile(context, ref, 'weight', l10n.weight, settings),
          _buildCheckboxListTile(
              context, ref, 'temperature', l10n.temperature, settings),
          _buildCheckboxListTile(context, ref, 'nightTemperature',
              l10n.night_temperature, settings),
          _buildCheckboxListTile(
              context, ref, 'morningBP', l10n.morning_blood_pressure, settings),
          _buildCheckboxListTile(
              context, ref, 'nightBP', l10n.night_blood_pressure, settings),
          _buildCheckboxListTile(
              context, ref, 'bloodSugar', l10n.blood_sugar, settings),
          _buildCheckboxListTile(context, ref, 'urine', l10n.urine, settings),
        ],
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  Widget _buildCheckboxListTile(BuildContext context, WidgetRef ref, String key,
      String title, Map<String, bool> settings) {
    return CheckboxListTile(
      title: Text(title),
      value: settings[key] ?? true,
      onChanged: (bool? value) {
        ref.read(statsViewSettingsProvider.notifier).toggleSetting(key);
      },
    );
  }
}
