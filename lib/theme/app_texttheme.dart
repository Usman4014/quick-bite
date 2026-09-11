// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextStyle appbarText = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

   static TextStyle titleText = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

   static TextStyle textfieldtitleText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.grey.shade900,
  );

  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey.shade900,
  );

  static TextStyle textButton = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );



  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 13,
    color: Color(0xFF9E9E9E),
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

   static TextStyle homecategory = GoogleFonts.poppins(
    fontSize: 12,
     fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}
