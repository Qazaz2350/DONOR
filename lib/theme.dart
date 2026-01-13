import 'package:donate/Utilis/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // 🌞 LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    dividerColor: Colors.grey.shade300,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.white, // card background
      background: AppColors.white, // scaffold background
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onSurface: AppColors.black,
      onBackground: AppColors.black,
    ),

    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      elevation: 0,
      centerTitle: true,
    ),

    iconTheme: const IconThemeData(color: AppColors.black),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // 🌙 DARK THEME
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.black, // Scaffold will be black
    dividerColor: Colors.white24,
    useMaterial3: false, // prevents M3 override

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.black, // Cards / Containers
      background: AppColors.black, // general background
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.white,
      onBackground: AppColors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
    ),

    iconTheme: const IconThemeData(color: AppColors.white),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.blue, // inputs stay blue
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
