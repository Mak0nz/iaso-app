// ignore_for_file: prefer_final_fields, unused_field, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/form_container.dart';
import 'package:iaso/utils/toast.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({super.key});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  bool _loading = false;

  final currentUser = FirebaseAuth.instance.currentUser;
  final _email = FirebaseAuth.instance.currentUser?.email;

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  changePassword() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _loading = true;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: _email.toString(),
        password: _oldPasswordController.toString(),
      );

      await currentUser!.reauthenticateWithCredential(credential).then((value) {
        currentUser!.updatePassword(_newPasswordController.toString());
      });

      ToastUtil.success(context, l10n.change_password_success);
      Navigator.pop(context);
    } catch (e) {
      ToastUtil.error(context, e.toString());
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
                        AppText.heading("${l10n.change_password}:"),
                        const SizedBox(
                          height: 25,
                        ),
                        FormContainer(
                          controller: _oldPasswordController,
                          hintText: l10n.old_password,
                          isPasswordField: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FormContainer(
                          controller: _newPasswordController,
                          hintText: l10n.new_password,
                          isPasswordField: true,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AnimatedButton(
                            onTap: () {
                              changePassword();
                            },
                            text: l10n.change_password,
                            progressEvent: _loading),
                      ],
                    ),
                  ),
                )
              ];
            });
      },
      child: const Icon(FontAwesomeIcons.chevronRight),
    );
  }
}
