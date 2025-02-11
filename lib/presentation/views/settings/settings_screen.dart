// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/constants/text_strings.dart';
import 'package:iaso/domain/user_avatar.dart';
import 'package:iaso/domain/username_manager.dart';
import 'package:iaso/presentation/views/settings/change_language.dart';
import 'package:iaso/presentation/views/settings/change_password.dart';
import 'package:iaso/presentation/views/settings/change_theme.dart';
import 'package:iaso/presentation/views/settings/delete_account.dart';
import 'package:iaso/presentation/views/settings/edit_username.dart';
import 'package:iaso/presentation/views/settings/stats_view.dart';
import 'package:iaso/presentation/widgets/appbar.dart';
import 'package:iaso/presentation/widgets/body.dart';
import 'package:iaso/presentation/widgets/outlined_button.dart';
import 'package:iaso/presentation/widgets/settings/header.dart';
import 'package:iaso/presentation/widgets/settings/option.dart';
import 'package:iaso/utils/toast.dart';
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
        extendBodyBehindAppBar: true,
        body: Body(children: [
          const SizedBox(
            height: kToolbarHeight * 1.4,
          ),
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
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

          const SizedBox(
            height: 15,
          ),
          SettingHeader(
              title: AppLocalizations.of(context)!.other_settings,
              icon: FontAwesomeIcons.gears),

          const SettingChangeLanguage(),

          const SettingChangeTheme(),

          SettingOption(
            title: AppLocalizations.of(context)!.notifications,
            trailing: GestureDetector(
              onTap: () => {
                AwesomeNotifications().requestPermissionToSendNotifications(),
                _isNotificationsEnabled(),
              },
              child: Text(
                notifStateText,
                style: TextStyle(
                  color: notifTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          SettingOption(
            title: AppLocalizations.of(context)!.stats_view,
            trailing: const StatsViewSettingsModal(),
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

          const SizedBox(
            height: 35,
          ),

          CustomOutlinedButton(
            onTap: _logout,
            text: AppLocalizations.of(context)!.logout,
            progressEvent: _loading,
            outlineColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade900 // Light theme color
                : Colors.grey,
          ),

          const SizedBox(
            height: 10,
          ),

          const DeleteAccount(),

          const SizedBox(height: navBar + 15), // Add some bottom padding
        ]));
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

      setState(() {
        _loading = false;
      });

      await ref.read(authServiceProvider).signOut(context);

      ToastUtil.success(context, AppLocalizations.of(context)!.success);
    } catch (e) {
      if (kDebugMode) {
        print("sign out error: $e");
      }
    }
  }
}
