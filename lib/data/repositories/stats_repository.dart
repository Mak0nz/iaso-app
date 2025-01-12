import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/domain/stats.dart';

class StatsRepository {
  final ApiClient _apiClient;

  StatsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Stats> fetchStats(DateTime date) async {
    final response = await _apiClient.get('/stats/${date.toIso8601String()}');

    if (response['code'] == 'stats_not_found') {
      throw ApiError(code: 'stats_not_found', statusCode: 404);
    }

    return Stats.fromJson(response['stats']);
  }

  Future<List<Stats>> fetchStatsRange(
      DateTime startDate, DateTime endDate) async {
    final response = await _apiClient.post('/stats/range', {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    });

    return (response['stats'] as List)
        .map((statsJson) => Stats.fromJson(statsJson))
        .toList();
  }

  Future<Stats> saveStats(Stats stats) async {
    final response = await _apiClient.post(
      '/stats',
      stats.toJson(),
    );

    return Stats.fromJson(response['stats']);
  }
}
