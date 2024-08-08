// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter_test/flutter_test.dart';
import 'package:iaso/data/stats_repository.dart';
import 'package:iaso/domain/stats.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([StatsRepository])
import 'stats_test.mocks.dart';

void main() {
  group('Stats Feature Tests', () {
    late MockStatsRepository mockRepository;

    setUp(() {
      mockRepository = MockStatsRepository();
    });

    test('Adding new stats', () async {
      final stats = Stats(
        weight: 70.5,
        temp: 36.6,
        bpMorningSYS: 120,
        bpMorningDIA: 80,
        bpMorningPulse: 72,
        dateField: DateTime.now(),
      );

      when(mockRepository.createStatsForUser(stats)).thenAnswer((_) async {});

      await mockRepository.createStatsForUser(stats);

      verify(mockRepository.createStatsForUser(stats)).called(1);
    });

    test('Fetching stats for a specific date', () async {
      final date = DateTime(2023, 7, 1);
      final expectedStats = Stats(
        weight: 70.5,
        temp: 36.6,
        bpMorningSYS: 120,
        bpMorningDIA: 80,
        bpMorningPulse: 72,
        dateField: date,
      );

      when(mockRepository.fetchStats(date))
          .thenAnswer((_) async => expectedStats);

      final result = await mockRepository.fetchStats(date);

      expect(result, expectedStats);
      verify(mockRepository.fetchStats(date)).called(1);
    });

    test('Fetching stats for a date with no data', () async {
      final date = DateTime(2023, 7, 2);

      when(mockRepository.fetchStats(date)).thenAnswer((_) async => null);

      final result = await mockRepository.fetchStats(date);

      expect(result, isNull);
      verify(mockRepository.fetchStats(date)).called(1);
    });
  });
}
