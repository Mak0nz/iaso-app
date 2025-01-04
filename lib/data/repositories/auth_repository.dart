import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;
  final String _languageCode;

  AuthRepository({
    ApiClient? apiClient,
    FlutterSecureStorage? secureStorage,
    required String languageCode,
  })  : _apiClient = apiClient ?? ApiClient(baseUrl: ApiEndpoints.baseUrl),
        _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _languageCode = languageCode;

  Future<void> signUp(String email, String password, String username) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      {
        'email': email,
        'password': password,
        'password_confirmation': password,
        'username': username,
      },
      _languageCode,
    );

    final token = response['token'] as String;
    await _secureStorage.write(key: 'auth_token', value: token);
    _apiClient.setAuthToken(token);
  }

  Future<void> signIn(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      {
        'email': email,
        'password': password,
      },
      _languageCode,
    );

    final token = response['token'] as String;
    await _secureStorage.write(key: 'auth_token', value: token);
    _apiClient.setAuthToken(token);
  }

  Future<void> signOut() async {
    try {
      await _apiClient.post(ApiEndpoints.logout, {}, _languageCode);
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
}
