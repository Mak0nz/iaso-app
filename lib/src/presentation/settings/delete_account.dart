// ignore_for_file: use_build_context_synchronously

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/domain/models/username_manager.dart';
import 'package:iaso/src/presentation/widgets/app_text.dart';
import 'package:iaso/src/presentation/widgets/outlined_button.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      onTap: () => showConfirmationDialog(), 
      text: AppLocalizations.of(context)!.delete_account, 
      progressEvent: _loading, 
      outlineColor: Colors.red.shade400,
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(FontAwesomeIcons.triangleExclamation, size: 44, color: Colors.red,),
              ),
              Expanded(child:Text(AppLocalizations.of(context)!.confirm_account_delete_heading),),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.subHeading(AppLocalizations.of(context)!.non_cancellable),
              Text(AppLocalizations.of(context)!.delete_account_description),
            ],
          ), 
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteAccount();
              },
              child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  Future deleteAccount() async {

    setState(() {
      _loading = true;  
    });

    final docRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);

    try {
      await UsernameManager().clearUsername();
      await docRef.delete();

      CherryToast.success(
        title: Text(AppLocalizations.of(context)!.success_delete),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);

      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false,); 
      
    } catch (error) {
      CherryToast.error(
        title: Text(error.toString(),),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
    }

    setState(() {
      _loading = false;  
    });

  }

}