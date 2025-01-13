import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';
import 'package:iaso/domain/user_medication.dart';
import 'package:iaso/domain/medication_info.dart';

class MedicationSyncService extends StateNotifier<Map<String, UserMedication>> {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;
  static const String _medsKey = 'medications';
  static const String _infoKey = 'medication_info';
  static const String _lastSyncKey = 'last_sync_timestamp';

  MedicationSyncService(this._apiClient, this._prefs) : super({}) {
    _init();
  }

  Future<void> _init() async {
    _loadLocalData();
    await syncFromServer();
  }

  void _loadLocalData() {
    final medsJson = _prefs.getString(_medsKey);
    if (medsJson != null) {
      try {
        final Map<String, dynamic> medsMap = jsonDecode(medsJson);
        state = Map.fromEntries(medsMap.entries
            .map((e) => MapEntry(e.key, UserMedication.fromJson(e.value))));
      } catch (e) {
        if (kDebugMode) {
          print('Error loading local medications: $e');
        }
      }
    }

    final infoJson = _prefs.getString(_infoKey);
    if (infoJson != null) {
      try {
        _medicationInfoCache = Map.fromEntries(
            (jsonDecode(infoJson) as Map<String, dynamic>)
                .entries
                .map((e) => MapEntry(e.key, MedicationInfo.fromJson(e.value))));
      } catch (e) {
        if (kDebugMode) {
          print('Error loading medication info cache: $e');
        }
      }
    }
  }

  DateTime? get lastSyncTime {
    final timestamp = _prefs.getInt(_lastSyncKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> _updateLastSyncTime() async {
    await _prefs.setInt(
      _lastSyncKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, MedicationInfo> _medicationInfoCache = {};

  void _cacheMedicationInfo(MedicationInfo info) {
    _medicationInfoCache[info.id.toString()] = info;
    _saveMedicationInfoCache();
  }

  Future<void> _saveMedicationInfoCache() async {
    final Map<String, dynamic> infoMap = {};
    for (var entry in _medicationInfoCache.entries) {
      infoMap[entry.key] = entry.value.toJson();
    }
    await _prefs.setString(_infoKey, jsonEncode(infoMap));
  }

  Future<void> syncFromServer() async {
    if (state is AsyncLoading) return;

    try {
      final response = await _apiClient.get(ApiEndpoints.medications);
      final medications = (response['medications'] as List)
          .map((med) => UserMedication.fromJson(med))
          .toList();

      // Server data is the source of truth
      final Map<String, UserMedication> newState = {};
      for (var med in medications) {
        if (med.id != null) {
          newState[med.id!] = med;
          _cacheMedicationInfo(med.medicationInfo);
        }
      }

      // Replace local data with server data
      state = newState;
      await _saveToLocal();
      await _updateLastSyncTime();
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing medications: $e');
      }
      // On error, ensure local data is loaded
      _loadLocalData();
      rethrow;
    }
  }

  Future<void> _saveToLocal() async {
    final Map<String, dynamic> medsMap = {};
    for (var entry in state.entries) {
      medsMap[entry.key] = entry.value.toJson();
    }
    await _prefs.setString(_medsKey, jsonEncode(medsMap));
  }

  Future<void> addOrUpdate(UserMedication medication) async {
    try {
      final response = medication.id == null
          ? await _apiClient.post(ApiEndpoints.medications, medication.toJson())
          : await _apiClient.put('${ApiEndpoints.medications}/${medication.id}',
              medication.toJson());

      final updatedMed = UserMedication.fromJson(response['medication']);

      if (updatedMed.id != null) {
        state = {...state, updatedMed.id!: updatedMed};
        _cacheMedicationInfo(updatedMed.medicationInfo);
        await _saveToLocal();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving medication: $e');
      }
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete('${ApiEndpoints.medications}/$id');
      state = {...state}..remove(id);
      await _saveToLocal();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting medication: $e');
      }
      rethrow;
    }
  }

  UserMedication? getMedication(String id) => state[id];

  List<UserMedication> getAllMedications() => state.values.toList();

  MedicationInfo? getCachedMedicationInfo(String id) =>
      _medicationInfoCache[id];

  Future<List<MedicationInfo>> searchMedications(String query) async {
    try {
      final response = await _apiClient
          .get('${ApiEndpoints.medications}/search?query=$query');

      final medications = (response['medications'] as List)
          .map((med) => MedicationInfo.fromJson(med))
          .toList();

      // Cache the results
      for (var med in medications) {
        _cacheMedicationInfo(med);
      }

      return medications;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching medications: $e');
      }
      rethrow;
    }
  }

  Future<bool> needsSync() async {
    final lastSync = lastSyncTime;
    if (lastSync == null) return true;

    final diff = DateTime.now().difference(lastSync);
    return diff.inHours >= 1; // Sync if last sync was more than 1 hour ago
  }
}
