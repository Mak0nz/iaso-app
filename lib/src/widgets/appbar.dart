// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/widgets/app_text.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final title;
  final leading;
  final actions;
  final actionsEvent;

  const CustomAppBar({
    super.key, 
    required this.title,
    this.leading,
    this.actions,
    this.actionsEvent,
  });
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: AppText.bold(widget.title),
      leading: Padding(
        padding: const EdgeInsets.only(left: edgeInset),
        child: widget.leading,
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: widget.actionsEvent,
          child: Padding(
            padding: const EdgeInsets.only(right: edgeInset),
            child: widget.actions,
          ),
        ),
      ],
    );
  }
}