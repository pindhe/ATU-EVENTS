import 'package:flutter/material.dart';

class ApexTheme {
  static const Color primary = Color(0xFF5A67D8);
  static const Color lightBg = Color(0xFFF8F9FF);
  static const Color darkBg = Color(0xFF0F172A);
  static const Color lightText = Color(0xFF0B1C30);
  static const Color darkText = Color(0xFFF8FAFC);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: lightBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBg,
      elevation: 0,
      iconTheme: IconThemeData(color: lightText),
      titleTextStyle: TextStyle(color: lightText, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: lightText),
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: darkBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      surface: const Color(0xFF1E293B),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
      iconTheme: IconThemeData(color: darkText),
      titleTextStyle: TextStyle(color: darkText, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: darkText),
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
