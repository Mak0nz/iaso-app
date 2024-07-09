import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsernameManager extends StateNotifier<String?> {
  UsernameManager() : super(null) {
    _init();
  }

  static const String _usernameKey = 'username';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _init() async {
    state = await getUsername();
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(_usernameKey);

    if (username == null || username.isEmpty) {
      username = await _fetchUsernameFromFirestore();
      if (username != null) {
        await _saveUsernameToPrefs(username);
      }
    }

    return username;
  }

  Future<String?> _fetchUsernameFromFirestore() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.displayName;
    }
    return null;
  }

  Future<void> updateUsername(String newUsername) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(newUsername);
      await _saveUsernameToPrefs(newUsername);
      state = newUsername;
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
  return UsernameManager();
});