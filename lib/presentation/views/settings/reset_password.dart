import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/form_container.dart';
import 'package:iaso/utils/toast.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:iaso/data/repositories/auth_repository.dart';

class ResetPasswordModal extends ConsumerStatefulWidget {
  const ResetPasswordModal({super.key});

  @override
  ConsumerState<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends ConsumerState<ResetPasswordModal> {
  bool _loading = false;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _loading = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.forgotPassword(_emailController.text.trim());

      if (mounted) {
        Navigator.pop(context);
        ToastUtil.success(context, l10n.translate('reset_password_success'));
      }
    } catch (e) {
      if (mounted) {
        if (e is ApiError) {
          ToastUtil.error(context, e.getTranslatedMessage(l10n));
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        WoltModalSheet.show(
          context: context,
          pageListBuilder: (context) {
            return [
              WoltModalSheetPage(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(edgeInset, 0, edgeInset, 65),
                  child: Column(
                    children: [
                      AppText.heading(l10n.translate('forgot_password')),
                      const SizedBox(height: 10),
                      Text(
                        l10n.translate('forgot_password_description'),
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      FormContainer(
                        controller: _emailController,
                        hintText: l10n.translate('email'),
                        isPasswordField: false,
                      ),
                      const SizedBox(height: 15),
                      AnimatedButton(
                        onTap: _resetPassword,
                        text: l10n.translate('reset_password'),
                        progressEvent: _loading,
                      ),
                    ],
                  ),
                ),
              )
            ];
          },
        );
      },
      child: Text(l10n.translate('forgot_password'),
          style: TextStyle(
              color: Colors.blue.shade400, fontWeight: FontWeight.bold)),
    );
  }
}
