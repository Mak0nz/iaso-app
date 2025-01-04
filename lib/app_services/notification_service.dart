import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:iaso/utils/number_formatter.dart';

class NotificationService {
  Future<void> sendLowMedicationNotification(
      String medicationName, double totalDoses, String languageCode) async {
    String notificationTitle =
        _getLocalizedMedicationRunningOut(medicationName, languageCode);
    String notificationBody = _getRemainingMedication(
        NumberFormatter.formatDouble(totalDoses).toString(), languageCode);

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: medicationName.hashCode,
      channelKey: 'med_updates',
      title: notificationTitle,
      body: notificationBody,
    ));
  }

  String _getLocalizedMedicationRunningOut(
      String medicationName, String languageCode) {
    final translations = {
      'en': '{medication} is running out!',
      'hu': '{medication} fogyóban van!',
    };

    String template = translations[languageCode] ?? translations['en']!;
    return template.replaceAll('{medication}', medicationName);
  }

  String _getRemainingMedication(String remaining, String languageCode) {
    final translations = {
      'en': 'There\'s only {remaining} days worth left.',
      'hu': 'Már csak {remaining} napnyi van.',
    };

    String template = translations[languageCode] ?? translations['en']!;
    return template.replaceAll('{remaining}', remaining);
  }
}
