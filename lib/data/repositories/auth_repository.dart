import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/data/repositories/language_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final languageCode = ref.watch(languageProvider);
  return AuthRepository(languageCode: languageCode);
});

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthRepository({
    ApiClient? apiClient,
    FlutterSecureStorage? secureStorage,
    required String languageCode,
  })  : _apiClient = apiClient ??
            ApiClient(
              baseUrl: ApiEndpoints.baseUrl,
              languageCode: languageCode,
            ),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> signUp(String email, String password, String name) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      {
        'email': email,
        'password': password,
        'password_confirmation': password,
        'name': name,
      },
    );

    final token = response['token'] as String;
    await _secureStorage.write(key: 'auth_token', value: token);
    _apiClient.setAuthToken(token);
  }

  Future<Map<String, dynamic>> fetchCurrentUser() async {
    if (kDebugMode) {
      print(
          'fetchCurrentUser called, sending GET request to ${ApiEndpoints.user}');
    }
    final response = await _apiClient.get(ApiEndpoints.user);
    if (kDebugMode) {
      print('fetchCurrentUser response: $response');
    }
    return response;
  }

  Future<void> signIn(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      {
        'email': email,
        'password': password,
      },
    );

    final token = response['token'] as String;
    await _secureStorage.write(key: 'auth_token', value: token);
    _apiClient.setAuthToken(token);
  }

  Future<void> signOut() async {
    try {
      await _apiClient.post(ApiEndpoints.logout, {});
    } finally {
      await _secureStorage.delete(key: 'auth_token');
      _apiClient.setAuthToken('');
    }
  }

  Future<void> initializeAuth() async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null) {
      _apiClient.setAuthToken(token);
    }
  }

  Future<void> updateUsername(String username) async {
    await _apiClient.post(
      ApiEndpoints.updateUsername,
      {
        'username': username,
      },
    );
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    await _apiClient.post(
      ApiEndpoints.updatePassword,
      {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      },
    );
  }

  Future<void> deleteAccount(String password) async {
    await _apiClient.post(
      ApiEndpoints.deleteAccount,
      {
        'password': password,
      },
    );
  }

  Future<void> forgotPassword(String email) async {
    final response = await _apiClient.post(
      ApiEndpoints.forgotPassword,
      {
        'email': email,
      },
    );

    if (response['code'] != 'reset_email_sent') {
      throw ApiError(
        code: response['code'],
        statusCode: 400,
      );
    }
  }
}
