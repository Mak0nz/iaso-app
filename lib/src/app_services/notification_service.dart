import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:iaso/src/utils/number_formatter.dart';
import 'package:iaso/src/domain/language.dart';

class NotificationService {
  Future<void> sendLowMedicationNotification(String medicationName, double totalDoses, Language language) async {
    String notificationTitle = _getLocalizedMedicationRunningOut(medicationName, language);
    String notificationBody = _getRemainingMedication(NumberFormatter.formatDouble(totalDoses).toString(), language);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: medicationName.hashCode,
        channelKey: 'med_updates',
        title: notificationTitle,
        body: notificationBody,
      )
    );
  }

  String _getLocalizedMedicationRunningOut(String medicationName, Language language) {
    Map<Language, String> translations = {
      Language.english: '{medication} is running out!',
      Language.hungarian: '{medication} fogyóban van!',
    };

    String template = translations[language] ?? translations[Language.english]!;
    return template.replaceAll('{medication}', medicationName);
  }

  String _getRemainingMedication(String remaining, Language language) {
    Map<Language, String> translations = {
      Language.english: 'There\'s only {remaining} days worth left.',
      Language.hungarian: 'Már csak {remaining} napnyi van.',
    };

    String template = translations[language] ?? translations[Language.english]!;
    return template.replaceAll('{remaining}', remaining);
  }
}