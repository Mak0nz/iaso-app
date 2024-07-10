// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/services/backend/account/user_avatar.dart';
import 'package:iaso/src/services/backend/account/username_manager.dart';
import 'package:iaso/src/widgets/appbar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UsernameManager().getUsername();
    final username = ref.watch(usernameProvider) ?? 'User';

    return Scaffold(
      appBar: CustomAppBar(
        leading: InitialAvatar(username: username),
        title: "${AppLocalizations.of(context)!.hello} $username",
      // temporary logout button until settings page is done
        actions: Icon(FontAwesomeIcons.rightFromBracket,),
        actionsEvent: () {
          FirebaseAuth.instance.signOut();
          UsernameManager().clearUsername();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false,); 
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: edgeInset),
        child: SingleChildScrollView(
          child: Column(
              children: [

              ],
            ),
        ),
      ),
    );
  }
}