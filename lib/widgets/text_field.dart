// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/theme/App_Constants.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class Text_Field extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? maxlength;
  final String hintText;
  final FaIconData prefixIcon;
  final FaIconData? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onSuffixPressed;
  final String? prefixText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  // NEW
  final List<TextInputFormatter>? inputFormatters;

  const Text_Field({
    super.key,
    required this.controller,
    this.inputFormatters,
    this.prefixText,
    this.onChanged,
    this.onSubmitted,
    this.maxlength,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onSuffixPressed,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      // Maximum number of characters
      maxLength: maxlength,

      obscureText: obscureText,

      // Use the formatters passed from the screen
      inputFormatters: inputFormatters ?? [],

      keyboardType: keyboardType,
      textInputAction: textInputAction,

      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,

      decoration: InputDecoration(
        prefixText: prefixText,

        prefixStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(100),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(100),
        ),

        filled: true,
        fillColor: Colors.white,

        hintStyle: AppTextTheme.caption,

        suffixIcon: Center(
          widthFactor: 3,
          heightFactor: 3,
          child: GestureDetector(
            onTap: onSuffixPressed,
            child: FaIcon(
              suffixIcon,
              color: Colors.grey.shade700,
              size: AppConstants.textfieldiconSize,
            ),
          ),
        ),

        prefixIcon: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: FaIcon(
            prefixIcon,
            color: AppColors.primary,
            size: AppConstants.textfieldiconSize,
          ),
        ),

        hintText: hintText,
      ),
    );
  }
}
