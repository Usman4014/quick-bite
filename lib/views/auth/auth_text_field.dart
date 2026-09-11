
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FaIconData prefixIcon;

  final bool obscureText;

  final TextInputType keyboardType;

  final TextInputAction textInputAction;

  final String? Function(String?)? validator;

  final VoidCallback? onSuffixPressed;

  final FaIconData? suffixIcon;

  final bool enabled;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSuffixPressed,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      enabled: enabled,

      style: AppTextTheme.bodyText,

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),

        //========================================================
        // PREFIX ICON
        //========================================================

        prefixIcon: Padding(
          padding: const EdgeInsets.all(14),
          child: FaIcon(
            prefixIcon,
            size: 18,
            color: AppColors.primary,
          ),
        ),

        //========================================================
        // SUFFIX ICON
        //========================================================

        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixPressed,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: FaIcon(
                  suffixIcon,
                  size: 17,
                  color: Colors.grey.shade600,
                ),
              )
            : null,

        //========================================================
        // BACKGROUND
        //========================================================

        filled: true,

        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),

        //========================================================
        // BORDER
        //========================================================

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

