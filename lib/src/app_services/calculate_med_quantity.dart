import 'package:iaso/src/utils/dose_calculator.dart';
import 'package:iaso/src/app_services/notification_service.dart';
import 'package:iaso/src/data/med_repository.dart';
import 'package:iaso/src/domain/medication.dart';
import 'package:iaso/src/domain/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> calculateMedQuantities() async {
  final medRepository = MedRepository();
  final notificationService = NotificationService();
  final doseCalculator = DoseCalculator();

  List<Medication> medications = await medRepository.getMedicationsList();
  final today = DateTime.now();
  final currentLanguage = await _getLanguageFromPreferences();

  for (final medication in medications) {
    var lastUpdatedDate = medication.lastUpdatedDate;
    bool isTodaySameDay = _isSameDay(lastUpdatedDate, today);

    if (!isTodaySameDay) {
      if (medication.takeQuantityPerDay != 0 && _shouldTakeMedicationToday(medication, today)) {
        final newQuantity = medication.currentQuantity - medication.takeQuantityPerDay;
        final double updatedQuantity = newQuantity > 0 ? newQuantity : 0;

        final updatedTotalDoses = doseCalculator.calculateTotalDoses(updatedQuantity, medication.takeQuantityPerDay);

        final updatedMedication = medication.copyWith(
          currentQuantity: updatedQuantity,
          totalDoses: updatedTotalDoses,
          lastUpdatedDate: today,
        );

        await medRepository.updateMedication(updatedMedication);

        if (updatedTotalDoses <= 14) {
          await notificationService.sendLowMedicationNotification(
            medication.name,
            updatedTotalDoses,
            currentLanguage,
          );
        }
      }
    }
  }
}

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

bool _shouldTakeMedicationToday(Medication medication, DateTime today) {
  switch (today.weekday) {
    case DateTime.monday: return medication.takeMonday;
    case DateTime.tuesday: return medication.takeTuesday;
    case DateTime.wednesday: return medication.takeWednesday;
    case DateTime.thursday: return medication.takeThursday;
    case DateTime.friday: return medication.takeFriday;
    case DateTime.saturday: return medication.takeSaturday;
    case DateTime.sunday: return medication.takeSunday;
    default: return false;
  }
}

Future<Language> _getLanguageFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('language_code') ?? 'en';
  return Language.values.firstWhere(
    (lang) => lang.code == languageCode,
    orElse: () => Language.english,
  );
}