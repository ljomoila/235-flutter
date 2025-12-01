import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Colors.black;
  static const Color white = Colors.white;
  static const Color green = Color(0xFF23FF06);
  static const Color purple = Color(0xFFFF00FF);
  static const Color blue = Color(0xFF21FFFF);
  static const Color border = Color(0xFF454547);
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: AppColors.blue,
    surface: AppColors.background,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontFamily: 'Teletext',
      color: AppColors.white,
      height: 1.2,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Teletext',
      color: AppColors.white,
      height: 1.2,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Teletext',
      color: AppColors.white,
      height: 1.2,
      fontSize: 16,
    ),
  ),
  iconTheme: const IconThemeData(color: AppColors.white),
);
