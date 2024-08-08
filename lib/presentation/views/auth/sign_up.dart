import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iaso/constants/images.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/constants/text_strings.dart';
import 'package:iaso/presentation/views/auth/language_appbar.dart';
import 'package:iaso/presentation/widgets/form_container.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool _loading = false;
  bool _privacyPolicyAccepted = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LanguageAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: edgeInset),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: const DecorationImage(image: AssetImage(logo)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  appName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    letterSpacing: 4,
                    fontFamily: 'LilitaOne',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // username field
                FormContainer(
                  controller: _usernameController,
                  hintText: AppLocalizations.of(context)!.username,
                  isPasswordField: false,
                  autofillHints: const [AutofillHints.newUsername],
                ),
                const SizedBox(
                  height: 10,
                ),
                // email field
                FormContainer(
                  controller: _emailController,
                  hintText: AppLocalizations.of(context)!.email,
                  isPasswordField: false,
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(
                  height: 10,
                ),
                // password field
                FormContainer(
                  controller: _passwordController,
                  hintText: AppLocalizations.of(context)!.password,
                  isPasswordField: true,
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _privacyPolicyAccepted,
                      onChanged: (value) {
                        setState(() {
                          _privacyPolicyAccepted = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          launchUrl(
                            Uri.parse(PRIVACY_POLICY_URL),
                            mode: LaunchMode.inAppBrowserView,
                          );
                        },
                        child: Text(
                            AppLocalizations.of(context)!.read_privacy_policy),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // signup button
                AnimatedButton(
                  onTap: _signUp,
                  text: AppLocalizations.of(context)!.sign_up,
                  progressEvent: _loading,
                ),
                const SizedBox(height: 20),
                // already have an account? login
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(AppLocalizations.of(context)!.have_account),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(AppLocalizations.of(context)!.login,
                        style: TextStyle(
                            color: Colors.blue.shade400,
                            fontWeight: FontWeight.bold)),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (!_privacyPolicyAccepted) {
      CherryToast.error(
        title: Text(AppLocalizations.of(context)!.accept_privacy_policy_error),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signUp(_emailController.text.trim(),
          _passwordController.text.trim(), context);

      if (user != null) {
        await user.updateDisplayName(_usernameController.text.trim());
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            '/enable_notifications',
            (Route<dynamic> route) => false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
