import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/auth_service.dart';
import 'package:iaso/presentation/routing/navigation_menu.dart';
import 'package:iaso/domain/language.dart';
import 'package:iaso/utils/theme/theme.dart';
import 'package:iaso/utils/theme/theme_manager.dart';
import 'package:iaso/presentation/views/auth/log_in.dart';
import 'package:iaso/presentation/views/auth/sign_up.dart';
import 'package:iaso/presentation/views/home_screen.dart';
import 'package:iaso/presentation/views/onboarding/enable_notifications.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(themeModeProvider.notifier).loadTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const AppWrapper();
        } else {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: switch (themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      },
      routes: {
        '/navigation_menu': (context) => const NavigationMenu(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LogInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/enable_notifications': (context) => const EnableNotifications(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(language.code),
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const NavigationMenu();
          } else {
            return const LogInScreen();
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Authentication error occurred')),
      ),
    );
  }
}
