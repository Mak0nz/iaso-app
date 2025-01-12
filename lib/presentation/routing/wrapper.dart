import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iaso/app_services/settings_sync.dart';
import 'package:iaso/data/repositories/auth_repository.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/app_services/auth_service.dart';
import 'package:iaso/presentation/routing/navigation_menu.dart';
import 'package:iaso/presentation/views/onboarding/onboarding_screen.dart';
import 'package:iaso/utils/theme/theme.dart';
import 'package:iaso/utils/theme/theme_manager.dart';
import 'package:iaso/presentation/views/auth/log_in.dart';
import 'package:iaso/presentation/views/auth/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      await authRepository.initializeAuth();
      await ref.read(settingsSyncProvider.notifier).syncFromServer();
      updateAuthState(true);
    } catch (e) {
      updateAuthState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: Locale(language),
      routes: {
        '/navigation_menu': (context) => const NavigationMenu(),
        '/login': (context) => const LogInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/onboarding_screen': (context) => const OnboardingScreen(),
      },
      home: authState.when(
        data: (isAuthenticated) {
          if (isAuthenticated) {
            return const NavigationMenu();
          } else {
            return FutureBuilder<bool>(
              future: _isFirstLaunch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == true) {
                    return const SignUpScreen();
                  } else {
                    return const LogInScreen();
                  }
                }
                return const CircularProgressIndicator();
              },
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Authentication error: $error'),
        ),
      ),
    );
  }

  Future<bool> _isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }
    return isFirstLaunch;
  }
}
