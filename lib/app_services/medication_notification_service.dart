import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';

class MedicationNotificationService {
  final ApiClient _apiClient;
  final FirebaseMessaging _messaging;

  MedicationNotificationService(this._apiClient)
      : _messaging = FirebaseMessaging.instance {
    _init();
  }

  Future<void> _init() async {
    // Request permission for notifications
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      String? token = await _messaging.getToken();
      if (token != null) {
        await _registerFCMToken(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_registerFCMToken);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    }
  }

  Future<void> _registerFCMToken(String token) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.notifications}/register',
        {'token': token},
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error registering FCM token: $e');
      }
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Handle the notification when the app is in foreground
    if (kDebugMode) {
      print('Received foreground message: ${message.data}');
    }

    // Here you could trigger a local notification or update the UI
    // depending on your app's needs
  }

  // Methods to handle background messages should be registered at the app level
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Received background message: ${message.data}');
    }
  }
}
