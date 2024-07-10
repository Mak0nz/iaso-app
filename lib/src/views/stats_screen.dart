import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/widgets/appbar.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.stats,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: edgeInset),
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