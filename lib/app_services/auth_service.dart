// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/data/repositories/auth_repository.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/utils/toast.dart';
import 'package:iaso/l10n/l10n.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final languageCode = ref.watch(languageProvider);
  return AuthRepository(languageCode: languageCode);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthService(authRepository);
});

final authStateProvider = StreamProvider<bool>((ref) async* {
  final authRepository = ref.watch(authRepositoryProvider);

  // Initial state
  try {
    await authRepository.initializeAuth();
    yield true;
  } catch (_) {
    yield false;
  }

  // Create a stream for auth state changes
  await for (final isAuthenticated in _authStateChanges.stream) {
    yield isAuthenticated;
  }
});

// Stream controller for auth state changes
final _authStateChanges = StreamController<bool>.broadcast();

void updateAuthState(bool isAuthenticated) {
  _authStateChanges.add(isAuthenticated);
}

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      await _authRepository.signIn(email, password);
      // await _showSuccessToast(context, AppLocalizations.of(context).translate('login_success'));
    } catch (e) {
      await _showErrorToast(context, e.toString());
    }
  }

  Future<void> signUp(
      String email, String password, String name, BuildContext context) async {
    try {
      await _authRepository.signUp(email, password, name);
      await _showSuccessToast(
          context, AppLocalizations.of(context).translate('signup_success'));
    } catch (e) {
      await _showErrorToast(context, e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _authRepository.signOut();
      // await _showSuccessToast(context, AppLocalizations.of(context).translate('logout_success'));
    } catch (e) {
      await _showErrorToast(
          context, AppLocalizations.of(context).translate('logout_error'));
    }
  }

  _showSuccessToast(BuildContext context, String message) {
    ToastUtil.success(context, message);
  }

  _showErrorToast(BuildContext context, String message) {
    ToastUtil.error(context, message);
  }
}
