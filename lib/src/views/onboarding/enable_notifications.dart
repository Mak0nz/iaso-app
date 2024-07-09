import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EnableNotifications extends StatefulWidget {
  const EnableNotifications({super.key});

  @override
  State<EnableNotifications> createState() => _EnableNotificationsState();
}

class _EnableNotificationsState extends State<EnableNotifications> {
 // Initial text
  late String _buttonText = _buttonTextT;
  String get _buttonTextT => AppLocalizations.of(context)!.enable_notifications;

 // Initial color
  Color _textColor = Colors.grey.shade400; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FontAwesomeIcons.bell, applyTextScaling: true, size: 100,),
                const SizedBox(height: 15,),
                Text("${AppLocalizations.of(context)!.enable_notifications}?", style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 22,
                ),),
                const SizedBox(height: 10,),
                Text(AppLocalizations.of(context)!.med_notification_description, style: const TextStyle( 
                  fontSize: 20,
                ),),
                const SizedBox(height: 15,),
                GestureDetector(
                  child: Text(_buttonText,
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                    ),
                  ),
                  onTap: () => _enableNotifications(),
                ),
                const SizedBox(height: 40,),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(left: 20,right: 20,bottom: 12),
        child: GestureDetector(
          child: Text(AppLocalizations.of(context)!.finish, style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.bold, fontSize: 22),),
          onTap:() => Navigator.pushNamedAndRemoveUntil(context, '/navigation_menu', (Route<dynamic> route) => false,),
        ),
        
      ),
    );
  }

  // ignore: unused_element
  void _enableNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    setState(() {
      _buttonText = AppLocalizations.of(context)!.enabled; // Change text to "Enabled"
      _textColor = Colors.green; // Change color to green
    });
  } 
}