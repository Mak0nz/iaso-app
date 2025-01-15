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
  static const String _searchCacheKey = 'medication_search_cache';
  static const String _lastSyncKey = 'last_sync_timestamp';

  MedicationSyncService(this._apiClient, this._prefs) : super({}) {
    _init();
  }

  DateTime? get lastSyncTime {
    final timestamp = _prefs.getInt(_lastSyncKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  Future<void> _updateLastSyncTime() async {
    await _prefs.setInt(
      _lastSyncKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> _init() async {
    _loadLocalData();
    await syncFromServer();
  }

  void _loadLocalData() {
    final medsJson = _prefs.getString(_medsKey);
    if (medsJson != null) {
      final Map<String, dynamic> medsMap = jsonDecode(medsJson);
      state = Map.fromEntries(medsMap.entries
          .map((e) => MapEntry(e.key, UserMedication.fromJson(e.value))));
    }

    final infoJson = _prefs.getString(_infoKey);
    if (infoJson != null) {
      _medicationInfoCache = Map.fromEntries(
          (jsonDecode(infoJson) as Map<String, dynamic>)
              .entries
              .map((e) => MapEntry(e.key, MedicationInfo.fromJson(e.value))));
    }

    final searchCacheJson = _prefs.getString(_searchCacheKey);
    if (searchCacheJson != null) {
      _searchCache = Map.fromEntries(
          (jsonDecode(searchCacheJson) as Map<String, dynamic>).entries.map(
              (e) => MapEntry(
                  e.key,
                  (e.value as List)
                      .map((m) => MedicationInfo.fromJson(m))
                      .toList())));
    }
  }

  Map<String, MedicationInfo> _medicationInfoCache = {};
  Map<String, List<MedicationInfo>> _searchCache = {};

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

  Future<void> _saveSearchCache() async {
    final Map<String, dynamic> cacheMap = {};
    for (var entry in _searchCache.entries) {
      cacheMap[entry.key] = entry.value.map((m) => m.toJson()).toList();
    }
    await _prefs.setString(_searchCacheKey, jsonEncode(cacheMap));
  }

  Future<void> _saveToLocal() async {
    final Map<String, dynamic> medsMap = {};
    for (var entry in state.entries) {
      medsMap[entry.key] = entry.value.toJson();
    }
    await _prefs.setString(_medsKey, jsonEncode(medsMap));
  }

  Future<void> syncFromServer() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.medications);
      final medications = (response['medications'] as List)
          .map((med) => UserMedication.fromJson(med))
          .toList();

      final Map<String, UserMedication> newState = {};
      for (var med in medications) {
        if (med.id != null) {
          newState[med.id!] = med;
          _cacheMedicationInfo(med.medicationInfo);
        }
      }

      state = newState;
      await _saveToLocal();
      await _updateLastSyncTime();
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing medications: $e');
      }
    }
  }

  Future<List<MedicationInfo>> searchMedications(String query) async {
    final normalizedQuery = query.toLowerCase();

    // Check cache first
    if (_searchCache.containsKey(normalizedQuery)) {
      return _searchCache[normalizedQuery] ?? [];
    }

    // Check local medication info
    final localResults = _medicationInfoCache.values.where((med) {
      return med.names.values
          .any((name) => name.toLowerCase().contains(normalizedQuery));
    }).toList();

    if (localResults.isNotEmpty) {
      _searchCache[normalizedQuery] = localResults;
      await _saveSearchCache();
      return localResults;
    }

    // Try API
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

      // Cache the search results
      _searchCache[normalizedQuery] = medications;
      await _saveSearchCache();

      return medications;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching medications: $e');
      }
      rethrow;
    }
  }

  // CRUD Operations
  Future<void> addMedication(UserMedication medication) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.medications,
        medication.toJson(),
      );

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

  Future<void> updateMedication(UserMedication medication) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.medications}/${medication.id}',
        medication.toJson(),
      );

      final updatedMed = UserMedication.fromJson(response['medication']);
      if (updatedMed.id != null) {
        state = {...state, updatedMed.id!: updatedMed};
        _cacheMedicationInfo(updatedMed.medicationInfo);
        await _saveToLocal();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating medication: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteMedication(String id) async {
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
}
