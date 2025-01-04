// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/domain/username_manager.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/outlined_button.dart';
import 'package:iaso/utils/toast.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CustomOutlinedButton(
      onTap: () => showConfirmationDialog(),
      text: l10n.translate('delete_account'),
      progressEvent: _loading,
      outlineColor: Colors.red.shade400,
    );
  }

  void showConfirmationDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 44,
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: Text(l10n.translate('confirm_account_delete_heading')),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.subHeading(l10n.translate('non_cancellable')),
              Text(l10n.translate('delete_account_description')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteAccount();
              },
              child: Text(
                l10n.translate('delete'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _loading = true;
    });

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    try {
      await UsernameManager().clearUsername();
      await docRef.delete();

      ToastUtil.success(context, l10n.translate('success_delete'));

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      ToastUtil.error(context, error.toString());
    }

    setState(() {
      _loading = false;
    });
  }
}
