class ApiEndpoints {
  // static const String baseUrl = 'https://iaso.benedek.site/api';
  //redirect to the local server outside of emulator (127.0.0.1)
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Auth endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String updateUsername = '/update-username';
  static const String updatePassword = '/update-password';
  static const String deleteAccount = '/delete-account';
  static const String forgotPassword = '/forgot-password';

  // UserStats endpoints
  static const String userStats = '/UserStats';

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
