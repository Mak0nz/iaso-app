import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/firebase_options.dart';
import 'package:iaso/src/services/backend/calculate_med_quantity.dart';
import 'package:iaso/src/routing/wrapper.dart';
import 'package:iaso/src/utils/language/language.dart';
import 'package:iaso/src/utils/language/language_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await Workmanager().registerPeriodicTask(
    "calculate_med_quantity",
    "CalculateMedQuantity",
    // initialDelay: Duration(seconds: 5),
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
    debug: false,
  );

  final container = ProviderContainer();
  final language = await container.read(languageRepositoryProvider).getLanguage();
  runApp(ProviderScope(
    overrides: [languageProvider.overrideWith((ref) => language)],
    child: const MyApp()
  ));
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
        } return Future.value(false);
      }
    } return Future.value(true); // Indicate successful task execution
    // Handle other tasks if any
  });
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref,) {
    return const Wrapper();
  }
}