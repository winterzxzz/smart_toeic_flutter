import 'package:flutter/services.dart';

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) return newValue;

    final firstLetter = text.substring(0, 1).toUpperCase();
    final rest = text.length > 1 ? text.substring(1) : '';

    final newText = '$firstLetter$rest';
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
