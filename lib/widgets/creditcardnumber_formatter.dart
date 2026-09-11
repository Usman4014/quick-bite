import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');

    if (text.length > 16) {
      text = text.substring(0, 16);
    }

    String formatted = '';

    for (int i = 0; i < text.length; i++) {
      if (i == 4 || i == 8 || i==12) {
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