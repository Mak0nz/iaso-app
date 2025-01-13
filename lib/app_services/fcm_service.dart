// lib/services/fcm_service.dart

import 'package:http/http.dart' as http;
import 'package:iaso/data/api/api_endpoints.dart';
import 'dart:convert';

class FCMService {
  final String _projectId;
  final String _serverKey;

  FCMService({
    required String projectId,
    required String serverKey,
  })  : _projectId = projectId,
        _serverKey = serverKey;

  Future<void> registerToken(String token) async {
    // Your backend API call to register the token
    // This is handled in the MedicationNotificationService
  }

  Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final url = Uri.parse(ApiEndpoints.getFcmUrl(_projectId));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_serverKey',
      },
      body: jsonEncode({
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': 'med_updates',
              'priority': 'max',
              'default_sound': true,
              'default_vibrate_timings': true,
            },
          },
          'apns': {
            'payload': {
              'aps': {
                'category': 'med_updates',
                'sound': 'default',
                'content-available': 1,
              },
            },
          },
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send FCM notification: ${response.body}');
    }
  }
}
