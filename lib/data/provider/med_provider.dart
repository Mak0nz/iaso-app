import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/domain/medication_info.dart';
import 'package:iaso/main.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';
import 'package:iaso/app_services/medication_sync_service.dart';
import 'package:iaso/app_services/medication_notification_service.dart';
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

final medicationNotificationProvider = Provider((ref) {
  final language = ref.watch(languageProvider);
  final apiClient = ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
    languageCode: language,
  );
  return MedicationNotificationService(apiClient);
});

// UI State Providers
final selectedMedicationIdProvider = StateProvider<String?>((ref) => null);

final medicationSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredMedicationsProvider = Provider<List<UserMedication>>((ref) {
  final medications = ref.watch(medicationSyncProvider).values.toList();
  final query = ref.watch(medicationSearchQueryProvider).toLowerCase();

  if (query.isEmpty) {
    return medications;
  }

  return medications.where((med) {
    final name = med.medicationInfo
        .getLocalizedName(ref.read(languageProvider))
        .toLowerCase();
    return name.contains(query);
  }).toList();
});

final medicationSearchResultsProvider =
    FutureProvider.family<List<MedicationInfo>, String>((ref, query) async {
  if (query.length < 2) return [];

  final syncService = ref.read(medicationSyncProvider.notifier);
  return await syncService.searchMedications(query);
});
