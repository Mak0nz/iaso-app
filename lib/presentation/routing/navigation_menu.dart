import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/presentation/views/home_screen.dart';
import 'package:iaso/presentation/views/meds/meds_screen.dart';
import 'package:iaso/presentation/views/settings/settings_screen.dart';
import 'package:iaso/presentation/views/stats/stats_screen.dart';
import 'package:iaso/utils/toast.dart';

import '../../utils/battery_optimization.dart';

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

  bool isOptimizationDisabled = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBatteryOptimization();
    });
  }

  Future<void> _checkBatteryOptimization() async {
    bool isOptimizationDisabled =
        await BatteryOptimization.isOptimizationDisabled();
    if (!isOptimizationDisabled) {
      _showBatteryOptimizationModal();
    }
  }

  void _showBatteryOptimizationModal() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40, horizontal: edgeInset),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOptimizationDisabled
                      ? Icons.battery_full
                      : Icons.battery_alert,
                  size: 80,
                  color: isOptimizationDisabled ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.battery_optimization_title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  isOptimizationDisabled
                      ? l10n.battery_optimization_disabled
                      : l10n.battery_optimization_description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: handleBatteryOptimization,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            isOptimizationDisabled
                                ? l10n.optimization_disabled
                                : l10n.disable_optimization,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> handleBatteryOptimization() async {
    final l10n = AppLocalizations.of(context)!;

    if (isOptimizationDisabled) {
      ToastUtil.success(context, l10n.optimization_disabled);
      Navigator.of(context).pop(); // Close the dialog
      return;
    }

    setState(() {
      isLoading = true;
    });

    await BatteryOptimization.openBatteryOptimizationSettings();

    // We don't need to call _checkBatteryOptimizationStatus() here
    // as it will be called when the app resumes

    setState(() {
      isLoading = false;
    });

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                NavigationDestination(
                    icon: const Icon(FontAwesomeIcons.house), label: l10n.home),
                NavigationDestination(
                    icon: const Icon(FontAwesomeIcons.heartCirclePlus),
                    label: l10n.stats),
                NavigationDestination(
                    icon: const Icon(FontAwesomeIcons.capsules),
                    label: l10n.meds),
                NavigationDestination(
                    icon: const Icon(FontAwesomeIcons.gear),
                    label: l10n.settings),
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
