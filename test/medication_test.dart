// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter_test/flutter_test.dart';
import 'package:iaso/data/med_repository.dart';
import 'package:iaso/domain/medication.dart';
import 'package:iaso/utils/dose_calculator.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([MedRepository])
import 'medication_test.mocks.dart';

void main() {
  group('Medication Feature Tests', () {
    late MockMedRepository mockRepository;
    late DoseCalculator doseCalculator;

    setUp(() {
      mockRepository = MockMedRepository();
      doseCalculator = DoseCalculator();
    });

    test('Adding a new medication', () async {
      final medication = Medication(
        name: 'Test Med',
        takeQuantityPerDay: 1,
        currentQuantity: 30,
        isInCloud: false,
        totalDoses: 30,
        lastUpdatedDate: DateTime.now(),
        takeMonday: true,
        takeTuesday: true,
        takeWednesday: true,
        takeThursday: true,
        takeFriday: true,
        takeSaturday: true,
        takeSunday: true,
      );

      // Setup the mock to return a Future<void>
      when(mockRepository.addMedication(medication)).thenAnswer((_) async {});

      await mockRepository.addMedication(medication);

      verify(mockRepository.addMedication(medication)).called(1);
    });

    test('Calculating total doses', () {
      expect(doseCalculator.calculateTotalDoses(30, 1, false), 30);
      expect(doseCalculator.calculateTotalDoses(30, 0.5, false), 60);
      expect(doseCalculator.calculateTotalDoses(30, 2, false), 15);
    });

    test('Updating medication quantity', () async {
      final initialMed = Medication(
        id: '1',
        name: 'Test Med',
        takeQuantityPerDay: 1,
        currentQuantity: 30,
        isInCloud: false,
        totalDoses: 30,
        lastUpdatedDate: DateTime.now(),
        takeMonday: true,
        takeTuesday: true,
        takeWednesday: true,
        takeThursday: true,
        takeFriday: true,
        takeSaturday: true,
        takeSunday: true,
      );

      final updatedMed = initialMed.copyWith(
        currentQuantity: 29,
        totalDoses: 29,
      );

      when(mockRepository.updateMedication(updatedMed))
          .thenAnswer((_) async {});

      await mockRepository.updateMedication(updatedMed);

      verify(mockRepository.updateMedication(updatedMed)).called(1);
    });
  });
}
