// ignore_for_file: prefer_final_fields, unused_field, use_build_context_synchronously

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/services/backend/firebase_auth.dart';
import 'package:iaso/src/widgets/animated_button.dart';
import 'package:iaso/src/widgets/app_text.dart';
import 'package:iaso/src/widgets/form_container.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({super.key});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  bool _loading = false;

  final FirebaseAuthService _auth = FirebaseAuthService();
  final currentUser = FirebaseAuth.instance.currentUser;
  final _email = FirebaseAuth.instance.currentUser?.email;

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  changePassword() async {
    setState(() {
      _loading = true;  
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: _email.toString(), 
        password: _oldPasswordController.toString(),
      );

      await currentUser!.reauthenticateWithCredential(credential).then((value){
        currentUser!.updatePassword(_newPasswordController.toString());
      });

      CherryToast.success(
        title: Text(AppLocalizations.of(context)!.change_password_success),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
      Navigator.pop(context);

    } catch (e) {
      CherryToast.error(
        title: Text(e.toString()),
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
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
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
                  AppText.heading("${AppLocalizations.of(context)!.change_password}:"),
                  
                  const SizedBox(height: 25,),

                  FormContainer(
                    controller: _oldPasswordController,
                    hintText: AppLocalizations.of(context)!.old_password,
                    isPasswordField: true,
                  ),
                  
                  const SizedBox(height: 10,),
                  
                  FormContainer(
                    controller: _newPasswordController,
                    hintText: AppLocalizations.of(context)!.new_password,
                    isPasswordField: true,
                  ),

                  const SizedBox(height: 15,),

                  AnimatedButton(
                    onTap: () {
                      changePassword();
                    }, 
                    text: AppLocalizations.of(context)!.change_password, 
                    progressEvent: _loading
                  ),
                ],
              ),
            ),
          )];
        });
      },
      child: const Icon(FontAwesomeIcons.chevronRight),
    );
  }
}