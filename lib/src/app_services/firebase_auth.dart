// ignore_for_file: use_build_context_synchronously, recursive_getters

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirebaseAuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  BuildContext get context => context;

  Future<User?> signUpWithEmailAndPassword(String email, String password,) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        CherryToast.error(
          title: Text(AppLocalizations.of(context)!.email_already_in_use),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      } else if (e.code == 'channel-error') {
        CherryToast.error(
          title: Text(AppLocalizations.of(context)!.channel_error),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      } else if (e.code == 'weak-password') {
        CherryToast.error(
          title: Text(AppLocalizations.of(context)!.weak_password),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      } else {
        CherryToast.error(
          title: Text(e.code),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        CherryToast.error(
          title: Text(AppLocalizations.of(context)!.invalid_credential),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      } else if (e.code == 'channel-error') {
        CherryToast.error(
          title: Text(AppLocalizations.of(context)!.channel_error),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      } else {
        CherryToast.error(
          title: Text(e.code),
          animationType: AnimationType.fromTop,
          displayCloseButton: false,
          inheritThemeColors: true,
        ).show(context);
      }
    }
    return null;
  }

}