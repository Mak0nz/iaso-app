// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/constants/sizes.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/form_container.dart';
import 'package:iaso/utils/toast.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:iaso/data/repositories/auth_repository.dart';
import 'package:iaso/data/api/api_error.dart';

class ChangePasswordModal extends ConsumerStatefulWidget {
  const ChangePasswordModal({super.key});

  @override
  ConsumerState<ChangePasswordModal> createState() =>
      _ChangePasswordModalState();
}

class _ChangePasswordModalState extends ConsumerState<ChangePasswordModal> {
  bool _loading = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final l10n = AppLocalizations.of(context);

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ToastUtil.error(context, l10n.translate('password_confirmation'));
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.changePassword(
        _oldPasswordController.text,
        _newPasswordController.text,
      );

      ToastUtil.success(context, l10n.translate('change_password_success'));
      Navigator.pop(context);
    } catch (e) {
      if (e is ApiError) {
        ToastUtil.error(context, e.getTranslatedMessage(l10n));
      } else {
        ToastUtil.error(context, l10n.translate('unexpected_error'));
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
                      AppText.heading(l10n.translate('change_password')),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          l10n.translate('password_requirements'),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      FormContainer(
                        controller: _oldPasswordController,
                        hintText: l10n.translate('old_password'),
                        isPasswordField: true,
                      ),
                      const SizedBox(height: 10),
                      FormContainer(
                        controller: _newPasswordController,
                        hintText: l10n.translate('new_password'),
                        isPasswordField: true,
                      ),
                      const SizedBox(height: 10),
                      FormContainer(
                        controller: _confirmPasswordController,
                        hintText:
                            '${l10n.translate('new_password')} (${l10n.translate('confirm')})',
                        isPasswordField: true,
                      ),
                      const SizedBox(height: 15),
                      AnimatedButton(
                        onTap: _changePassword,
                        text: l10n.translate('change_password'),
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
      child: const Icon(FontAwesomeIcons.chevronRight),
    );
  }
}
