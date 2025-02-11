// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iaso/domain/username_manager.dart';
import 'package:iaso/presentation/widgets/animated_button.dart';
import 'package:iaso/presentation/widgets/app_text.dart';
import 'package:iaso/presentation/widgets/form_container.dart';
import 'package:iaso/utils/toast.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class EditUsernameModal extends ConsumerStatefulWidget {
  const EditUsernameModal({super.key});

  @override
  ConsumerState<EditUsernameModal> createState() => _EditUsernameModalState();
}

class _EditUsernameModalState extends ConsumerState<EditUsernameModal> {
  bool _loading = false;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchExistingUsername();
    });
  }

  Future fetchExistingUsername() async {
    final username = await ref.read(usernameProvider.notifier).getUsername();
    if (username != null) {
      setState(() {
        _usernameController.text = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) {
              return [
                WoltModalSheetPage(
                  isTopBarLayerAlwaysVisible: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 65),
                    child: Column(
                      children: [
                        AppText.heading(l10n.change_username),
                        const SizedBox(
                          height: 25,
                        ),
                        FormContainer(
                          controller: _usernameController,
                          hintText: "",
                          isPasswordField: false,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AnimatedButton(
                          onTap: saveUsername,
                          text: l10n.save,
                          progressEvent: _loading,
                        ),
                      ],
                    ),
                  ),
                )
              ];
            });
      },
      child: const Icon(FontAwesomeIcons.penToSquare),
    );
  }

  Future saveUsername() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _loading = true;
    });

    try {
      await ref
          .read(usernameProvider.notifier)
          .updateUsername(_usernameController.text);

      ToastUtil.success(context, l10n.saved);
      Navigator.pop(context);
    } catch (e) {
      ToastUtil.error(context, e.toString());
    }

    setState(() {
      _loading = false;
    });
  }
}
