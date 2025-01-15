import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/med_sync_manager.dart';
import 'package:iaso/domain/medication_info.dart';
import 'package:iaso/main.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';
import 'package:iaso/domain/user_medication.dart';
import 'package:iaso/data/repositories/language_repository.dart';

// Service Providers
final medicationSyncProvider =
    StateNotifierProvider<MedicationSyncService, Map<String, UserMedication>>(
        (ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final language = ref.watch(languageProvider);
  final apiClient = ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
    languageCode: language,
  );
  return MedicationSyncService(apiClient, prefs);
});

// Search-related Providers
final medicationSearchQueryProvider = StateProvider<String>((ref) => '');

final medicationSearchResultsProvider =
    FutureProvider.family<List<MedicationInfo>, String>((ref, query) async {
  if (query.length < 2) return [];

  final syncService = ref.read(medicationSyncProvider.notifier);
  // Just use searchMedications which will handle both cached and API searches
  return await syncService.searchMedications(query);
});

// Cached Medications Provider
final cachedMedicationsProvider =
    StateProvider<List<MedicationInfo>>((ref) => []);

// Selected Medication Provider for editing
final selectedMedicationProvider =
    StateProvider<MedicationInfo?>((ref) => null);

// UI State Providers
final medicationViewTabProvider = StateProvider<int>((ref) => 0);

final filteredMedicationsProvider = Provider<List<UserMedication>>((ref) {
  final medications = ref.watch(medicationSyncProvider).values.toList();
  final query = ref.watch(medicationSearchQueryProvider).toLowerCase();
  final language = ref.watch(languageProvider);

  if (query.isEmpty) {
    return medications;
  }

  return medications.where((med) {
    final name = med.medicationInfo.getLocalizedName(language).toLowerCase();
    return name.contains(query);
  }).toList();
});
