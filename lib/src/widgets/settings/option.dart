// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class SettingOption extends StatefulWidget {
  final title;
  final trailing;

  const SettingOption({
    super.key, 
    required this.title,
    required this.trailing
  });

  @override
  State<SettingOption> createState() => _SettingOptionState();
}

class _SettingOptionState extends State<SettingOption> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: const TextStyle(
            fontSize: 20,
          ),),
          widget.trailing,
        ],
      ),
    );
  }
}