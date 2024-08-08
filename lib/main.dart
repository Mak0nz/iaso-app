import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/firebase_options.dart';
import 'package:iaso/app_services/calculate_med_quantity.dart';
import 'package:iaso/presentation/routing/wrapper.dart';
import 'package:iaso/domain/language.dart';
import 'package:iaso/data/language_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Determine if we're in a debug environment
  bool isDebug = kDebugMode;

  await FirebaseAppCheck.instance.activate(
    // https://firebase.google.com/docs/app-check/flutter/default-providers#initialize
    androidProvider:
        isDebug ? AndroidProvider.debug : AndroidProvider.playIntegrity,
  );

  initializeDateFormatting();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: isDebug);
  await Workmanager().registerPeriodicTask(
    "calculate_med_quantity",
    "CalculateMedQuantity",
    frequency: const Duration(hours: 12),
    inputData: <String, dynamic>{},
    constraints: Constraints(
      networkType: NetworkType.connected,
      //requiresDeviceIdle: true,
    ),
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'med_updates',
        channelName: 'Medication updates',
        channelDescription: 'Get reminders when a medication is running out.',
      )
    ],
    debug: isDebug,
  );

  final container = ProviderContainer();
  final language =
      await container.read(languageRepositoryProvider).getLanguage();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    languageProvider.overrideWith((ref) => language),
  ], child: const MyApp()));
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  // This will be called when a background task is triggered
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (task == "CalculateMedQuantity") {
      try {
        await calculateMedQuantities();
        if (kDebugMode) {
          print("Calculate med quantities task ran successfuly");
        }
      } catch (error) {
        if (kDebugMode) {
          print("Error during background task: $error");
        }
        return Future.value(false);
      }
    }
    return Future.value(true); // Indicate successful task execution
    // Handle other tasks if any
  });
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
