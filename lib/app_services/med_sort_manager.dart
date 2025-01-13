import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/main.dart';
import 'package:iaso/domain/user_medication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MedSortMode {
  nameAZ(icon: FontAwesomeIcons.arrowDownAZ),
  nameZA(icon: FontAwesomeIcons.arrowUpZA),
  dosesLowHigh(icon: FontAwesomeIcons.arrowDown19),
  dosesHighLow(icon: FontAwesomeIcons.arrowUp91);

  const MedSortMode({required this.icon});

  final IconData icon;

  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      MedSortMode.nameAZ => l10n.translate('sort_name_az'),
      MedSortMode.nameZA => l10n.translate('sort_name_za'),
      MedSortMode.dosesLowHigh => l10n.translate('sort_doses_low_high'),
      MedSortMode.dosesHighLow => l10n.translate('sort_doses_high_low'),
    };
  }
}

class MedSortRepository {
  final SharedPreferences _prefs;

  static const String sortModeKey = "med_sort_mode";
  static const String showZeroDosesKey = "show_zero_doses";

  MedSortRepository(this._prefs);

  Future<void> setSortMode(MedSortMode sortMode) async {
    await _prefs.setString(sortModeKey, sortMode.name);
  }

  MedSortMode getSortMode() {
    final mode = _prefs.getString(sortModeKey);
    return MedSortMode.values.firstWhere(
      (value) => value.name == mode,
      orElse: () => MedSortMode.nameAZ,
    );
  }

  Future<void> setShowZeroDoses(bool show) async {
    await _prefs.setBool(showZeroDosesKey, show);
  }

  bool getShowZeroDoses() {
    return _prefs.getBool(showZeroDosesKey) ?? true;
  }
}

final medSortRepositoryProvider = Provider<MedSortRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MedSortRepository(prefs);
});

final medSortModeProvider =
    StateNotifierProvider<MedSortModeNotifier, AsyncValue<MedSortMode>>((ref) {
  final repository = ref.watch(medSortRepositoryProvider);
  return MedSortModeNotifier(repository);
});

class MedSortModeNotifier extends StateNotifier<AsyncValue<MedSortMode>> {
  MedSortModeNotifier(this._medSortRepository)
      : super(const AsyncValue.loading()) {
    _loadSortMode();
  }

  final MedSortRepository _medSortRepository;

  void _loadSortMode() {
    try {
      final sortMode = _medSortRepository.getSortMode();
      state = AsyncValue.data(sortMode);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setSortMode(MedSortMode sortMode) async {
    state = const AsyncValue.loading();
    try {
      await _medSortRepository.setSortMode(sortMode);
      state = AsyncValue.data(sortMode);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final showZeroDosesProvider =
    StateNotifierProvider<ShowZeroDosesNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(medSortRepositoryProvider);
  return ShowZeroDosesNotifier(repository);
});

class ShowZeroDosesNotifier extends StateNotifier<AsyncValue<bool>> {
  ShowZeroDosesNotifier(this._medSortRepository)
      : super(const AsyncValue.loading()) {
    _loadShowZeroDoses();
  }

  final MedSortRepository _medSortRepository;

  void _loadShowZeroDoses() {
    try {
      final showZeroDoses = _medSortRepository.getShowZeroDoses();
      state = AsyncValue.data(showZeroDoses);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setShowZeroDoses(bool show) async {
    state = const AsyncValue.loading();
    try {
      await _medSortRepository.setShowZeroDoses(show);
      state = AsyncValue.data(show);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

List<UserMedication> sortMedications(
    List<UserMedication> meds, MedSortMode sortMode, bool showZeroDoses) {
  final filteredMeds = showZeroDoses
      ? meds
      : meds.where((med) => med.takeQuantityPerDay > 0).toList();

  switch (sortMode) {
    case MedSortMode.nameAZ:
      filteredMeds.sort((a, b) => a.medicationInfo
          .getLocalizedName('en')
          .toLowerCase()
          .compareTo(b.medicationInfo.getLocalizedName('en').toLowerCase()));
    case MedSortMode.nameZA:
      filteredMeds.sort((a, b) => b.medicationInfo
          .getLocalizedName('en')
          .toLowerCase()
          .compareTo(a.medicationInfo.getLocalizedName('en').toLowerCase()));
    case MedSortMode.dosesLowHigh:
      filteredMeds.sort((a, b) => a.totalDoses.compareTo(b.totalDoses));
    case MedSortMode.dosesHighLow:
      filteredMeds.sort((a, b) => b.totalDoses.compareTo(a.totalDoses));
  }

  return filteredMeds;
}
