import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iaso/app_services/settings_sync.dart';
import 'package:iaso/data/api/api_error.dart';
import 'package:iaso/data/repositories/auth_repository.dart';
import 'package:iaso/l10n/l10n.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/outlined_button.dart';
import 'package:iaso/utils/toast.dart';

class DeleteAccount extends ConsumerStatefulWidget {
  const DeleteAccount({super.key});

  @override
  ConsumerState<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends ConsumerState<DeleteAccount> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CustomOutlinedButton(
      onTap: () => _showConfirmationDialog(context),
      text: l10n.translate('delete_account'),
      progressEvent: _loading,
      outlineColor: Colors.red.shade400,
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade400,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.translate('confirm_account_delete_heading'),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.subHeading(l10n.translate('non_cancellable')),
              const SizedBox(height: 8),
              Text(l10n.translate('delete_account_description')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.translate('delete')),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _loading = true;
    });

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.deleteAccount();

      await ref
          .read(settingsSyncProvider.notifier)
          .clearAllExceptLanguageAndTheme();

      if (mounted) {
        ToastUtil.success(context, l10n.translate('account_deleted'));
        // Navigate to login screen and clear navigation stack
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
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
}
