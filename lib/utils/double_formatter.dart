import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow backspace and deletion
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Replace commas with dots
    String text = newValue.text.replaceAll(',', '.');

    // Only allow one decimal point
    if (text.split('.').length > 2) {
      return oldValue;
    }

    // Only allow digits and one decimal point
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      return oldValue;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class IntegerInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow backspace and deletion
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Round decimals to integers
    if (newValue.text.contains(',') || newValue.text.contains('.')) {
      final value = double.tryParse(newValue.text.replaceAll(',', '.'));
      if (value != null) {
        final roundedText = value.round().toString();
        return TextEditingValue(
          text: roundedText,
          selection: TextSelection.collapsed(offset: roundedText.length),
        );
      }
      return oldValue;
    }

    // Only allow digits
    if (!RegExp(r'^\d+$').hasMatch(newValue.text)) {
      return oldValue;
    }

    return newValue;
  }
}
