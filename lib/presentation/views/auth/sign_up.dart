import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:iaso/constants/images.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/constants/text_strings.dart';
import 'package:iaso/data/repositories/language_repository.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/views/auth/language_appbar.dart';
import 'package:iaso/presentation/widgets/form_container.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool _loading = false;
  bool _privacyPolicyAccepted = false;

  // Field error states
  String? _emailError;
  String? _passwordError;
  String? _nameError;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _nameError = null;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                const SizedBox(height: 5),
                Text(
                  appName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    letterSpacing: 4,
                    fontFamily: 'LilitaOne',
                  ),
                ),
                const SizedBox(height: 15),
                // username field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormContainer(
                      controller: _usernameController,
                      hintText: l10n.translate('username'),
                      isPasswordField: false,
                      autofillHints: const [AutofillHints.newUsername],
                    ),
                    if (_nameError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                        child: Text(
                          _nameError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormContainer(
                      controller: _emailController,
                      hintText: l10n.translate('email'),
                      isPasswordField: false,
                      autofillHints: const [AutofillHints.email],
                    ),
                    if (_emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                        child: Text(
                          _emailError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // password field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormContainer(
                      controller: _passwordController,
                      hintText: l10n.translate('password'),
                      isPasswordField: true,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    if (_passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                        child: Text(
                          _passwordError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // confirm password field
                FormContainer(
                  controller: _confirmPasswordController,
                  hintText: '${l10n.translate('password')} (confirm)',
                  isPasswordField: true,
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(height: 10),

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
                          final language = ref.read(languageProvider);
                          final privacyUrl = '$BASE_URL$language/privacy';
                          await launchUrl(
                            Uri.parse(privacyUrl),
                            mode: LaunchMode.inAppBrowserView,
                          );
                        },
                        child: Text(l10n.translate('read_privacy_policy')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // signup button
                AnimatedButton(
                  onTap: _signUp,
                  text: l10n.translate('sign_up'),
                  progressEvent: _loading,
                ),
                const SizedBox(height: 20),
                // already have an account? login
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(l10n.translate('have_account')),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(l10n.translate('login'),
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
    final l10n = AppLocalizations.of(context);
    _clearErrors(); // Clear previous errors

    if (!_privacyPolicyAccepted) {
      CherryToast.error(
        title: Text(l10n.translate('accept_privacy_policy_error')),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _passwordError = l10n.translate('password_confirmation');
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
        context,
      );

      if (mounted) {
        updateAuthState(true);
        Navigator.pushReplacementNamed(
          context,
          '/onboarding_screen',
        );
      }
    } catch (e) {
      if (mounted) {
        if (e is ApiError) {
          if (e.validationErrors != null) {
            setState(() {
              _emailError = e.getValidationError('email');
              _passwordError = e.getValidationError('password');
              _nameError = e.getValidationError('name');
            });

            // Show a general validation error message if there are errors
            if (_emailError != null ||
                _passwordError != null ||
                _nameError != null) {
              ToastUtil.error(context, l10n.translate('validation_error'));
            }
          } else {
            // For non-validation API errors, show translated message and potentially set specific field errors
            ToastUtil.error(context, e.getTranslatedMessage(l10n));

            // Set specific field errors based on error code
            setState(() {
              switch (e.code) {
                case 'email_already_in_use':
                case 'invalid_email':
                  _emailError = e.getTranslatedMessage(l10n);
                  break;
                case 'weak_password':
                  _passwordError = e.getTranslatedMessage(l10n);
                  break;
              }
            });
          }
        } else {
          ToastUtil.error(context, l10n.translate('unexpected_error'));
        }
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
