// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/services/account/user_avatar.dart';
import 'package:iaso/src/services/account/username_manager.dart';
import 'package:iaso/src/services/meds/med_sort_manager.dart';
import 'package:iaso/src/views/meds/meds_display.dart';
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
      ),
      extendBodyBehindAppBar: true,
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: edgeInset),
        child: DisplayMeds(showAll: false, sortMode: MedSortMode.dosesLowHigh, showZeroDoses: true,),
      ),
    );
  }
}