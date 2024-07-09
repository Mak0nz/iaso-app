import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/services/backend/account/user_avatar.dart';
import 'package:iaso/src/services/backend/account/username_manager.dart';
import 'package:iaso/src/widgets/app_text.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UsernameManager().getUsername();
    final username = ref.watch(usernameProvider) ?? 'User';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: edgeInset),
          child: InitialAvatar(
            username: username
          ),
        ),
        title: AppText.bold("${AppLocalizations.of(context)!.hello} $username",),
        // temporary logout button until settings page is done
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              UsernameManager().clearUsername();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false,);
              
            },
            child: const Padding(
              padding: EdgeInsets.only(right: edgeInset),
              child: Icon(FontAwesomeIcons.rightFromBracket,),
            ),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: edgeInset),
          child: Column(
            children: [
              Text(username),
            ],
          ),
      ),
    );
  }
}