// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/src/constants/text_strings.dart';
import 'package:iaso/src/services/backend/account/user_avatar.dart';
import 'package:iaso/src/services/backend/account/username_manager.dart';
import 'package:iaso/src/views/settings/change_language.dart';
import 'package:iaso/src/views/settings/change_password.dart';
import 'package:iaso/src/views/settings/delete_account.dart';
import 'package:iaso/src/views/settings/edit_username.dart';
import 'package:iaso/src/widgets/appbar.dart';
import 'package:iaso/src/widgets/body.dart';
import 'package:iaso/src/widgets/outlined_button.dart';
import 'package:iaso/src/widgets/settings/header.dart';
import 'package:iaso/src/widgets/settings/option.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState(); 
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late String notifStateText = _stateText;
  String get _stateText => AppLocalizations.of(context)!.enable;
  var notifTextColor = Colors.blue.shade400;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _isNotificationsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    UsernameManager().getUsername();
    final username = ref.watch(usernameProvider) ?? 'User';

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.settings,
      ),
      body: Body(children: [
        SettingHeader(
          title: AppLocalizations.of(context)!.account,
          icon: FontAwesomeIcons.userGear,
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade900, width: 2.0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InitialAvatar(username: username),
                      Text(username, style: const TextStyle( 
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),),
                      const EditUsernameModal(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        SettingOption(
          title: AppLocalizations.of(context)!.change_password,
          trailing: const ChangePasswordModal(),
        ),

        const SizedBox(height: 15,),
        SettingHeader(
          title: AppLocalizations.of(context)!.other_settings,
          icon: FontAwesomeIcons.gears
        ),

        const SettingChangeLanguage(),
        
        SettingOption(
          title: AppLocalizations.of(context)!.notifications,
          trailing: GestureDetector(
            onTap:() => {
              AwesomeNotifications().requestPermissionToSendNotifications(),
              _isNotificationsEnabled(),
            },
            child: Text(notifStateText, style: TextStyle(
              color: notifTextColor, 
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),),
          ),
        ),

        SettingOption(
          title: AppLocalizations.of(context)!.privacy_policy, 
          trailing: GestureDetector(
            onTap: () async {
              launchUrl(
                Uri.parse(PRIVACY_POLICY_URL),
                mode: LaunchMode.inAppBrowserView,
              );
            }, 
            child: const Icon(FontAwesomeIcons.chevronRight),
          ),
        ),

        const SizedBox(height: 100,),
      
        CustomOutlinedButton(
          onTap: _logout,
          text: AppLocalizations.of(context)!.logout, 
          progressEvent: _loading, 
          outlineColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade900 // Light theme color
          : Colors.grey,
        ),

        const SizedBox(height: 10,),
        
        const DeleteAccount(),

        const SizedBox(height: 75), // Add some bottom padding
      ])
    );
  }

  void _isNotificationsEnabled() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        setState(() {
          notifStateText = AppLocalizations.of(context)!.enable;
          notifTextColor = Colors.blue.shade400; 
        });
      } else {
        setState(() {
          notifStateText = AppLocalizations.of(context)!.enabled;
          notifTextColor = Theme.of(context).brightness == Brightness.light
            ? Colors.green.shade700 // Light theme color
            : Colors.green;
        });
      }
    });
  }

  void _logout() async {
    setState(() {
      _loading = true;
    });

    try {
      await UsernameManager().clearUsername();
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false,); 
      
      CherryToast.success(
        title: Text(AppLocalizations.of(context)!.success),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
    } catch (e) {
      CherryToast.error(
        title: Text(e.toString()),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
    }
    
    setState(() {
      _loading = false;
    });
  }

}