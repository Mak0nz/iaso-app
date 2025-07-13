import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/presentation/routing/wrapper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FCM
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
  );

  // Stuff for Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Set up background message handling
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

  final sharedPreferences = await SharedPreferences.getInstance();

  initializeDateFormatting();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
  );

  final language =
      await container.read(languageRepositoryProvider).getLanguage();

  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    languageProvider.overrideWith((ref) => language),
  ], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return const Wrapper();
  }
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // Handle background messages here
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
  }
}
