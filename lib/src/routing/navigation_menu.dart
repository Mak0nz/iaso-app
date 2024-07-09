import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/views/home_screen.dart';
import 'package:iaso/src/views/meds_screen.dart';
import 'package:iaso/src/views/settings_screen.dart';
import 'package:iaso/src/views/stats_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int currentIndex = 0;
  List pages = [
    const HomeScreen(),
    const StatsScreen(),
    const MedsScreen(),
    const SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
        decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              spreadRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade900.withAlpha(20), width: 2.0, style: BorderStyle.solid),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: NavigationBar(
              //backgroundColor: Colors.transparent,
              selectedIndex: currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              onDestinationSelected: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              destinations: [
                NavigationDestination(icon: const Icon(FontAwesomeIcons.house), label: AppLocalizations.of(context)!.home),
                NavigationDestination(icon: const Icon(FontAwesomeIcons.heartCirclePlus), label: AppLocalizations.of(context)!.stats),
                NavigationDestination(icon: const Icon(FontAwesomeIcons.capsules), label: AppLocalizations.of(context)!.meds),
                NavigationDestination(icon: const Icon(FontAwesomeIcons.gear), label: AppLocalizations.of(context)!.settings),
              ],
            ),
          ),
        ),
      ),
      body: pages[currentIndex],
    );
  }
}