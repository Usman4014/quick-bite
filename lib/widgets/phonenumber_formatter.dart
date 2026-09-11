import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');

    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    String formatted = '';

    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) {
        formatted += ' ';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}