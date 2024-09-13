// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/data/auth_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iaso/utils/toast.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthService(authRepository);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
    if (user != null) {
      // Delay the emission of the authenticated state
      await Future.delayed(const Duration(seconds: 0));
    }
    return user;
  });
});

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<User?> signIn(
      String email, String password, BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        // await _showSuccessToast(context, l10n.login_success);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      await _showErrorToast(context, _handleAuthError(e.code, context));
      return null;
    } catch (e) {
      await _showErrorToast(context, l10n.unexpected_error);
      return null;
    }
  }

  Future<User?> signUp(
      String email, String password, BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final user = await _authRepository.signUp(email, password);
      if (user != null) {
        await _showSuccessToast(context, l10n.signup_success);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      await _showErrorToast(context, _handleAuthError(e.code, context));
      return null;
    } catch (e) {
      await _showErrorToast(context, l10n.unexpected_error);
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await _authRepository.signOut();
      //await _showSuccessToast(context, l10n.logout_success);
    } catch (e) {
      await _showErrorToast(context, l10n.logout_error);
    }
  }

  _showSuccessToast(BuildContext context, String message) {
    ToastUtil.success(context, message);
  }

  _showErrorToast(BuildContext context, String message) {
    ToastUtil.error(context, message);
  }

  String _handleAuthError(String code, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 'user-not-found':
        return l10n.user_not_found;
      case 'wrong-password':
        return l10n.wrong_password;
      case 'invalid-email':
        return l10n.invalid_email;
      case 'user-disabled':
        return l10n.user_disabled;
      case 'email-already-in-use':
        return l10n.email_already_in_use;
      case 'operation-not-allowed':
        return l10n.operation_not_allowed;
      case 'weak-password':
        return l10n.weak_password;
      default:
        return l10n.auth_error;
    }
  }
}
