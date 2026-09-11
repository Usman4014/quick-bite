import 'package:flutter/services.dart';

class CVVFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');

    if (text.length > 3) {
      text = text.substring(0, 3);
    }

    String formatted = '';

    for (int i = 0; i < text.length; i++) {
      
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