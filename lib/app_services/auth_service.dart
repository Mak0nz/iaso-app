// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/data/repositories/auth_repository.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/utils/toast.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final language = ref.watch(languageProvider);
  return AuthRepository(languageCode: language);
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
      // await _showSuccessToast(context, l10n.login_success);
    } catch (e) {
      _handleError(context, e);
      rethrow; // Rethrow to let the UI handle the error state
    }
  }

  Future<void> signUp(
      String email, String password, String name, BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    try {
      await _authRepository.signUp(email, password, name);
      await _showSuccessToast(context, l10n.translate('signup_success'));
    } catch (e) {
      _handleError(context, e);
      rethrow; // Rethrow to let the UI handle the error state
    }
  }

  Future<void> signOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    try {
      await _authRepository.signOut();
      //await _showSuccessToast(context, l10n.logout_success);
    } catch (e) {
      await _showErrorToast(context, l10n.translate('logout_error'));
      rethrow;
    }
  }

  void _handleError(BuildContext context, dynamic error) {
    final l10n = AppLocalizations.of(context);
    String errorMessage;

    if (error is ApiError) {
      errorMessage = error.getTranslatedMessage(l10n);
    } else {
      errorMessage = l10n.translate('unexpected_error');
    }

    _showErrorToast(context, errorMessage);
  }

  Future<void> _showSuccessToast(BuildContext context, String message) async {
    ToastUtil.success(context, message);
  }

  Future<void> _showErrorToast(BuildContext context, String message) async {
    ToastUtil.error(context, message);
  }
}
