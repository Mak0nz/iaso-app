import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/med_sync_manager.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/presentation/routing/wrapper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize FCM
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up background message handling
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

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
