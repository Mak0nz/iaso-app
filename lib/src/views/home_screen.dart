// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/services/account/user_avatar.dart';
import 'package:iaso/src/services/account/username_manager.dart';
import 'package:iaso/src/widgets/appbar.dart';
import 'package:iaso/src/widgets/body.dart';

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
      ),
      body: Body(children: [
        
      ])
    );
  }
}