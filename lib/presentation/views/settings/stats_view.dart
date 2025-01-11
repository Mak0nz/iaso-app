import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/settings_sync.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

final statsViewSettingsProvider = StateNotifierProvider<
    StatsViewSettingsNotifier, AsyncValue<Map<String, bool>>>((ref) {
  final settingsSync = ref.watch(settingsSyncProvider.notifier);
  return StatsViewSettingsNotifier(settingsSync);
});

class StatsViewSettingsNotifier
    extends StateNotifier<AsyncValue<Map<String, bool>>> {
  final SettingsSync _settingsSync;
  bool _mounted = true;

  StatsViewSettingsNotifier(this._settingsSync)
      : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  void _loadSettings() {
    if (!_mounted) return;

    final settings = {
      'weight':
          _settingsSync.getSetting('show_weight')?.toLowerCase() == 'true',
      'temperature':
          _settingsSync.getSetting('show_temperature')?.toLowerCase() == 'true',
      'nightTemperature':
          _settingsSync.getSetting('show_night_temperature')?.toLowerCase() ==
              'true',
      'morningBP':
          _settingsSync.getSetting('show_morning_bp')?.toLowerCase() == 'true',
      'nightBP':
          _settingsSync.getSetting('show_night_bp')?.toLowerCase() == 'true',
      'bloodSugar':
          _settingsSync.getSetting('show_blood_sugar')?.toLowerCase() == 'true',
      'urine': _settingsSync.getSetting('show_urine')?.toLowerCase() == 'true',
    };

    state = AsyncValue.data(settings);
  }

  Future<void> toggleSetting(String key) async {
    if (!_mounted) return;

    state = await AsyncValue.guard(() async {
      final currentSettings = state.value ?? {};
      final newValue = !(currentSettings[key] ?? true);

      await _settingsSync.setSetting('show_$key', newValue.toString());

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
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        WoltModalSheet.show(
          context: context,
          pageListBuilder: (BuildContext context) {
            return [
              WoltModalSheetPage(
                topBarTitle: AppText.heading(l10n.translate('stats_view')),
                isTopBarLayerAlwaysVisible: true,
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
    final l10n = AppLocalizations.of(context);
    final settingsAsyncValue = ref.watch(statsViewSettingsProvider);

    return settingsAsyncValue.when(
      data: (settings) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            l10n.translate('stats_view_description'),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          _buildCheckboxListTile(
              context, ref, 'weight', l10n.translate('weight'), settings),
          _buildCheckboxListTile(context, ref, 'temperature',
              l10n.translate('temperature'), settings),
          _buildCheckboxListTile(context, ref, 'nightTemperature',
              l10n.translate('night_temperature'), settings),
          _buildCheckboxListTile(context, ref, 'morningBP',
              l10n.translate('morning_blood_pressure'), settings),
          _buildCheckboxListTile(context, ref, 'nightBP',
              l10n.translate('night_blood_pressure'), settings),
          _buildCheckboxListTile(context, ref, 'bloodSugar',
              l10n.translate('blood_sugar'), settings),
          _buildCheckboxListTile(
              context, ref, 'urine', l10n.translate('urine'), settings),
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
