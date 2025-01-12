import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/domain/stats.dart';
import 'package:iaso/data/repositories/stats_repository.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';
import 'package:iaso/data/repositories/language_repository.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  final language = ref.watch(languageProvider);
  final apiClient = ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
    languageCode: language,
  );
  return StatsRepository(apiClient: apiClient);
});

final statsProvider = FutureProvider.autoDispose<Stats?>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final repository = ref.watch(statsRepositoryProvider);

  try {
    return await repository.fetchStats(selectedDate);
  } on ApiError catch (e) {
    if (e.code == 'stats_not_found') {
      return null;
    }
    rethrow;
  }
});

final statsRangeProvider = FutureProvider.family<List<Stats>, DateTimeRange>(
  (ref, dateRange) async {
    final repository = ref.watch(statsRepositoryProvider);
    return await repository.fetchStatsRange(
      dateRange.start,
      dateRange.end,
    );
  },
);
