import 'package:flutter/material.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/presentation/views/auth/language_popup_menu.dart';

class LanguageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LanguageAppBar({super.key});
    
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      actions: const [
        LanguagePopupMenu(),
        SizedBox(width: edgeInset,)
      ],
    );
  }
}