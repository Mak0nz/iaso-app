import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await _storeUserToken(user);
      }
      return user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        await _storeUserToken(user);
      }
      return user;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: 'userToken');
  }

  Future<void> _storeUserToken(User user) async {
    String? token = await user.getIdToken();
    await _secureStorage.write(key: 'userToken', value: token);
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<bool> refreshToken() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.getIdToken(true);  // Force token refresh
        await _storeUserToken(user);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing token: $e');
      }
      return false;
    }
  }
}