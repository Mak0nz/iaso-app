// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final borderColor;
  final leading;
  final title;
  final subtitle;
  final trailing;

  const CustomCard({
    super.key, 
    this.borderColor,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? Colors.grey.shade900;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2.0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: widget.leading,
        title: widget.title,
        subtitle: widget.subtitle,
        trailing: widget.trailing,
      ),
    );
  }
}