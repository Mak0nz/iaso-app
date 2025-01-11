import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iaso/data/api/api_client.dart';
import 'package:iaso/data/api/api_endpoints.dart';
import 'package:iaso/data/repositories/language_repository.dart';

class UsernameManager extends StateNotifier<String?> {
  static const String _usernameKey = 'username';
  final ApiClient _apiClient;

  UsernameManager(this._apiClient) : super(null) {
    _init();
  }

  Future<void> _init() async {
    state = await getUsername();
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(_usernameKey);

    if (username == null || username.isEmpty) {
      username = await _fetchUsernameFromApi();
      if (username != null) {
        await _saveUsernameToPrefs(username);
      }
    }

    return username;
  }

  Future<String?> _fetchUsernameFromApi() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.user);

      if (response.containsKey('user') &&
          response['user'].containsKey('name')) {
        return response['user']['name'] as String;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUsername(String newUsername) async {
    try {
      await _apiClient.post(
        ApiEndpoints.user,
        {'name': newUsername},
      );
      await _saveUsernameToPrefs(newUsername);
      state = newUsername;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    state = null;
  }

  Future<void> _saveUsernameToPrefs(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }
}

final usernameProvider = StateNotifierProvider<UsernameManager, String?>((ref) {
  final language = ref.watch(languageProvider);
  return UsernameManager(
    ApiClient(
      baseUrl: ApiEndpoints.baseUrl,
      languageCode: language,
    ),
  );
});
