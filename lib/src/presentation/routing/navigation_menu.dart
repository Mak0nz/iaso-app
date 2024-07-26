import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:iaso/src/presentation/home_screen.dart';
import 'package:iaso/src/presentation/meds/meds_screen.dart';
import 'package:iaso/src/presentation/settings/settings_screen.dart';
import 'package:iaso/src/presentation/stats/stats_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int currentIndex = 0;
  int _previousIndex = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const StatsScreen(),
    const MedsScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              spreadRadius: 10,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.5),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: NavigationBar(
              selectedIndex: currentIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              onDestinationSelected: (index) {
                setState(() {
                  _previousIndex = currentIndex;
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
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: currentIndex < _previousIndex,
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: pages[currentIndex],
      ),
    );
  }
}