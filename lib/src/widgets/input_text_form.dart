// ignore_for_file: unnecessary_new, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class InputTextForm extends StatefulWidget {
  final double? width;
  final TextEditingController? controller;
  final String? labelText;

  const InputTextForm({
    this.width,
    this.controller,
    this.labelText,
  }
  );

  @override
  // ignore: library_private_types_in_public_api
  _InputTextFormState createState() => new _InputTextFormState();
}

class _InputTextFormState extends State<InputTextForm> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Adjust padding as needed
        child: SizedBox(
          width: widget.width, // Set a fixed width for better layout control
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0,),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0,),
              ),
              labelText: widget.labelText,
            ),
          ),
        ),
      ),
    );
  }
}