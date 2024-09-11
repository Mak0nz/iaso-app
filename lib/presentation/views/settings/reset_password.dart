// ignore_for_file: use_build_context_synchronously

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/form_container.dart';
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
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _loading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      Navigator.pop(context);

      CherryToast.success(
        title: Text(l10n.reset_password_success),
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
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) {
              return [
                WoltModalSheetPage(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(edgeInset, 0, edgeInset, 65),
                    child: Column(
                      children: [
                        AppText.heading(l10n.forgot_password),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          l10n.forgot_password_description,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        FormContainer(
                          controller: _emailController,
                          hintText: l10n.email,
                          isPasswordField: false,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AnimatedButton(
                            onTap: () {
                              resetPassword();
                            },
                            text: l10n.reset_password,
                            progressEvent: _loading),
                      ],
                    ),
                  ),
                )
              ];
            });
      },
      child: Text(l10n.forgot_password,
          style: TextStyle(
              color: Colors.blue.shade400, fontWeight: FontWeight.bold)),
    );
  }
}
