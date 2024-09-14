import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:animations/animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/presentation/views/onboarding/battery_optimization_screen.dart';
import 'package:iaso/presentation/views/onboarding/welcome_screen.dart';
import 'package:iaso/presentation/views/onboarding/enable_notifications_screen.dart';
import 'package:iaso/presentation/views/onboarding/stats_view_screen.dart';
import 'package:iaso/presentation/views/onboarding/add_med_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 5;

  final List<Widget> _pages = const [
    WelcomeScreen(),
    StatsViewSettingsScreen(),
    AddMedScreen(),
    BatteryOptimizationScreen(),
    EnableNotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _pages,
          ),
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _currentPage == _numPages - 1 ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    _numPages, (index) => _buildDotIndicator(index)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedOpacity(
              opacity: _currentPage == 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: TextButton(
                onPressed: _currentPage == 0 ? _showSkipDialog : null,
                child: Text(l10n.skip),
              ),
            ),
            FloatingActionButton(
              onPressed:
                  _currentPage < _numPages - 1 ? _nextPage : _finishOnboarding,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  _currentPage < _numPages - 1
                      ? FontAwesomeIcons.arrowRight
                      : FontAwesomeIcons.check,
                  key: ValueKey<bool>(_currentPage < _numPages - 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return GestureDetector(
      onTap: () => _goToPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == index ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    _goToPage(_currentPage + 1);
  }

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(context, '/navigation_menu');
  }

  void _showSkipDialog() {
    final l10n = AppLocalizations.of(context)!;
    showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(
        transitionDuration: Duration(milliseconds: 300),
        reverseTransitionDuration: Duration(milliseconds: 200),
      ),
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.skip_onboarding),
          content: Text(l10n.skip_onboarding_message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _finishOnboarding();
              },
              child: Text(
                l10n.skip,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
