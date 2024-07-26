// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/presentation/widgets/app_text.dart';

class SettingHeader extends StatefulWidget {
  final title;
  final IconData icon;

  const SettingHeader({
    super.key, 
    required this.title,
    required this.icon
  });

  @override
  State<SettingHeader> createState() => _SettingHeaderState();
}

class _SettingHeaderState extends State<SettingHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: edgeInset),
              child: Icon(widget.icon, color: Colors.blue.shade400,),
            ),
            AppText.heading(widget.title),
            ],),
          const Divider(),
        ],
      ),
    );
  }
}