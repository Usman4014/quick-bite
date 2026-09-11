// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // Scaffold
    scaffoldBackgroundColor: AppColors.background,

    // Primary Color
    primaryColor: AppColors.primary,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
    ),

    // Card
    cardTheme: const CardThemeData(color: Colors.white, elevation: 2),

    // Divider
   

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    ),

    // Input Field
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: AppTextTheme.caption,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFEEEEEE)),
        borderRadius: BorderRadius.circular(100),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  );
}
