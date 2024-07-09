// ignore_for_file: use_build_context_synchronously

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/widgets/animated_button.dart';
import 'package:iaso/src/widgets/app_text.dart';
import 'package:iaso/src/widgets/form_container.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ResetPasswordModal extends StatefulWidget {
  const ResetPasswordModal({super.key});

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  bool _loading = false;

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    setState(() {
      _loading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());

      Navigator.pop(context);

      CherryToast.success(
        title: Text(AppLocalizations.of(context)!.reset_password_success),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);

    } on FirebaseAuthException catch (error) {
      CherryToast.error(
        title: Text(error.message.toString()),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
    } 
    
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WoltModalSheet.show(context: context, pageListBuilder: (context) {
          return [ WoltModalSheetPage(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(edgeInset, 0, edgeInset, 65),
              child: Column(
                children: [
                  AppText.heading(AppLocalizations.of(context)!.forgot_password),

                  const SizedBox(height: 10,),

                  Text(AppLocalizations.of(context)!.forgot_password_description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25,),

                  FormContainer(
                    controller: _emailController,
                    hintText: AppLocalizations.of(context)!.email,
                    isPasswordField: false,
                  ),

                  const SizedBox(height: 15,),

                  AnimatedButton(
                    onTap: () {
                      resetPassword();
                    }, 
                    text: AppLocalizations.of(context)!.reset_password, 
                    progressEvent: _loading
                  ),
                ],
              ),
            ),
          )];
        });
      },
      child: Text(AppLocalizations.of(context)!.forgot_password,style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.bold)),
    );
  }
}