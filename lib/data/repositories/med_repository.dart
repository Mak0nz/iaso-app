// lib/data/repositories/med_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/domain/medication_info.dart';
import 'package:iaso/domain/user_medication.dart';

class MedRepository {
  final ApiClient _apiClient;

  MedRepository(this._apiClient);

  Future<List<UserMedication>> getMedications() async {
    final response = await _apiClient.get(ApiEndpoints.medications);
    return (response['medications'] as List)
        .map((json) => UserMedication.fromJson(json))
        .toList();
  }

  Future<List<MedicationInfo>> searchMedications(String query) async {
    if (query.length < 2) return [];

    final response =
        await _apiClient.get('${ApiEndpoints.medicationSearch}?query=$query');
    return (response['medications'] as List)
        .map((json) => MedicationInfo.fromJson(json))
        .toList();
  }

  Future<UserMedication> addMedication(UserMedication medication) async {
    final response = await _apiClient.post(
      ApiEndpoints.medications,
      medication.toJson(),
    );
    return UserMedication.fromJson(response['medication']);
  }

  Future<UserMedication> updateMedication(UserMedication medication) async {
    if (medication.id == null) {
      throw Exception('Cannot update medication without id');
    }

    final response = await _apiClient.put(
      '${ApiEndpoints.medications}/${medication.id}',
      medication.toJson(),
    );
    return UserMedication.fromJson(response['medication']);
  }

  Future<void> deleteMedication(String id) async {
    await _apiClient.delete('${ApiEndpoints.medications}/$id');
  }

  Future<Map<String, dynamic>> syncMedications(DateTime lastSync) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.medicationSync}?last_sync=${lastSync.toIso8601String()}',
    );

    return {
      'updated': (response['updated'] as List)
          .map((json) => UserMedication.fromJson(json))
          .toList(),
      'deleted': (response['deleted'] as List).cast<String>(),
    };
  }
}

final medRepositoryProvider = Provider<MedRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MedRepository(apiClient);
});

// Separate provider for the ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final language = ref.watch(languageProvider);
  return ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
    languageCode: language,
  );
});
