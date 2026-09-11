// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/theme/app_colors.dart';

class Snack_Bar {
  static void show({
    required String title,
    required String message,
    required FaIconData icon,

    int duration = 2,
  }) {
    Get.snackbar(
      '',
      '',
      titleText: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black),
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      margin: const EdgeInsets.all(15),
      borderRadius: 15,
      backgroundColor: AppColors.primary,
      shouldIconPulse: false,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 300),
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FaIcon(icon, color: Colors.black, size: 17),
      ),
    );
  }
}
