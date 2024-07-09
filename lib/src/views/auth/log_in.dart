// ignore_for_file: use_build_context_synchronously

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/services/backend/firebase_auth.dart';
import 'package:iaso/src/views/auth/language_appbar.dart';
import 'package:iaso/src/views/settings/reset_password.dart';
import 'package:iaso/src/widgets/animated_button.dart';
import 'package:iaso/src/widgets/form_container.dart';
import 'package:iaso/src/constants/images.dart';
import 'package:iaso/src/constants/text_strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _loading = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

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
                    image: const DecorationImage(
                      image: AssetImage(logo)
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                const SizedBox(height: 5,),
                Text(appName.toUpperCase(), style: const TextStyle(
                  fontSize: 40,
                  letterSpacing: 4,
                  fontFamily: 'LilitaOne',
                ),),
                const SizedBox(height: 25,),
              // Email form
                FormContainer(
                  controller: _emailController,
                  hintText: AppLocalizations.of(context)!.email,
                  isPasswordField: false,
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: 10,),
              // Password form
                FormContainer(
                  controller: _passwordController,
                  hintText: AppLocalizations.of(context)!.password,
                  isPasswordField: true,
                  autofillHints: const [AutofillHints.password],
                ),
                const SizedBox(height: 10,),
                // Reset password
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ResetPasswordModal(),
                  ],
                ),
                const SizedBox(height: 15,),
              // Login button
                AnimatedButton(
                  onTap: _signIn,
                  text: AppLocalizations.of(context)!.login,
                  progressEvent: _loading,
                ),

                const SizedBox(height: 20),
                /*
              // or continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade500,
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Vagy jelentkezzen be google-al',),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade500,
                      )
                    ),
                  ],
                ),
                SizedBox(height: 15,),
              // login using google
                InkWell(
                  onTap: _signInWithGoogle,
                  borderRadius: BorderRadius.circular(15),
                  child: Ink(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black12,
                    ),
                    child: Image.asset('assets/google.png', height: 40,),
                  ),
                ),
              */
              // Don't have an account? Register
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children : [
                    Text(AppLocalizations.of(context)!.noaccount),
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text(AppLocalizations.of(context)!.register,style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.bold)),
                    ),
                  ]),
              ],
            ),
          ),
        ),
      ), 
    );
  }

  void _signIn() async {
    setState(() {
      _loading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim()
      );

      CherryToast.success(
        title: Text(AppLocalizations.of(context)!.login_success),
        animationType: AnimationType.fromTop,
        displayCloseButton: false,
        inheritThemeColors: true,
      ).show(context);

      Navigator.pushNamedAndRemoveUntil(context, '/navigation_menu', (Route<dynamic> route) => false,);

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