import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/auth_service.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/views/auth/language_appbar.dart';
import 'package:iaso/presentation/views/settings/reset_password.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/form_container.dart';
import 'package:iaso/constants/images.dart';
import 'package:iaso/constants/text_strings.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/utils/toast.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  bool _loading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                const SizedBox(height: 25),
                // Email form
                FormContainer(
                  controller: _emailController,
                  hintText: l10n.translate('email'),
                  isPasswordField: false,
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: 10),
                // Password form
                FormContainer(
                  controller: _passwordController,
                  hintText: l10n.translate('password'),
                  isPasswordField: true,
                  autofillHints: const [AutofillHints.password],
                ),
                const SizedBox(height: 10),
                // Reset password
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ResetPasswordModal(),
                  ],
                ),
                const SizedBox(height: 15),
                // Login button
                AnimatedButton(
                  onTap: _signIn,
                  text: l10n.translate('login'),
                  progressEvent: _loading,
                ),
                const SizedBox(height: 20),
                // Don't have an account? Register
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(l10n.translate('noaccount')),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text(l10n.translate('register'),
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

  Future<void> _signIn() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(_emailController.text.trim(),
          _passwordController.text.trim(), context);

      if (mounted) {
        updateAuthState(true);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        if (e is ApiError) {
          if (e.validationErrors != null) {
            // Show all validation errors if present
            final errors = e.getAllValidationErrors().join('\n');
            ToastUtil.error(context, errors);
          } else {
            // Show translated error message
            ToastUtil.error(context, e.getTranslatedMessage(l10n));
          }
        } else {
          // Show unexpected error message
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
