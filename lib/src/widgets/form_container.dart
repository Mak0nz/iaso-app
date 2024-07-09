import 'package:flutter/material.dart';

class FormContainer extends StatefulWidget {

  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  final Iterable<String>? autofillHints;

  const FormContainer({super.key, 
    this.controller,
    this.isPasswordField,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
    this.autofillHints
  });

  @override
  // ignore: library_private_types_in_public_api
  _FormContainerState createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField == true? _obscureText : false,
        autofillHints: widget.autofillHints,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: Theme.of(context).brightness == Brightness.light
                ? const BorderSide(color: Colors.black87) // Light theme
                : const BorderSide(color: Colors.white),
          ),
          border: InputBorder.none,
          fillColor: Colors.black12,
          filled: true,
          hintText: widget.hintText,
          hintStyle: Theme.of(context).brightness == Brightness.light
            ? TextStyle(color: Colors.grey.shade700) // Light theme
            : const TextStyle(color: Colors.grey),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child:
            widget.isPasswordField==true? Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: _obscureText == false ? Colors.white : Colors.grey,) : const Text(""),
          ),
        ),
      ),
    );
  }
}