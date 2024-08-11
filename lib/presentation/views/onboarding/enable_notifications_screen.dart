import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EnableNotificationsScreen extends StatefulWidget {
  const EnableNotificationsScreen({super.key});

  @override
  State<EnableNotificationsScreen> createState() =>
      _EnableNotificationsScreenState();
}

class _EnableNotificationsScreenState extends State<EnableNotificationsScreen> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    setState(() {
      _notificationsEnabled = isAllowed;
    });
  }

  Future<void> _enableNotifications() async {
    final isAllowed =
        await AwesomeNotifications().requestPermissionToSendNotifications();
    setState(() {
      _notificationsEnabled = isAllowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.bell,
            size: 60,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.enable_notifications,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              AppLocalizations.of(context)!.med_notification_description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _notificationsEnabled ? null : _enableNotifications,
            child: Text(_notificationsEnabled
                ? AppLocalizations.of(context)!.enabled
                : AppLocalizations.of(context)!.enable_notifications),
          ),
        ],
      ),
    );
  }
}
