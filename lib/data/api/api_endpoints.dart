class ApiEndpoints {
  static const String baseUrl = 'https://iaso.benedek.site/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String user = '/auth/user';
  static const String deleteAccount = '/auth/user';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Medication endpoints
  static const String medications = '/medications';
  static const String medicationSearch = '/medications/search';
  static const String medicationSync = '/medications/sync';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String notificationToken = '/notifications/token';

  // FCM HTTP v1 endpoint
  static const String fcmUrl =
      'https://fcm.googleapis.com/v1/projects/{project-id}/messages:send';

  static String getFcmUrl(String projectId) =>
      fcmUrl.replaceAll('{project-id}', projectId);
}
