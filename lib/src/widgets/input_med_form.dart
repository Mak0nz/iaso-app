// ignore_for_file: unnecessary_new, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:iaso/src/constants/sizes.dart';
import 'package:iaso/src/widgets/app_text.dart';

class InputMedForm extends StatefulWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final bool? require;

  const InputMedForm({
    required this.labelText,
    required this.controller,
    this.textInputType,
    this.require,
  }
  );

  @override
  // ignore: library_private_types_in_public_api
  _InputMedFormState createState() => new _InputMedFormState();
}

class _InputMedFormState extends State<InputMedForm> {
  @override
  Widget build(BuildContext context) {
    final require = widget.require ?? false;

    return new Padding(
      padding: const EdgeInsets.fromLTRB(edgeInset, 0, edgeInset, 6), // Adjust padding as needed
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(children: [
              AppText.subHeading("${widget.labelText}"),
              if (require) const Text('*', style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
            ],),
          ),
          const SizedBox(height: 2,),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.textInputType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0,),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0,),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(15.0,),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}