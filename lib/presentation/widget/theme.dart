import 'package:flutter/material.dart';

class CustomTheme {
  static const primary = Color(0xFF714333);
  static const neutral = Color(0xFFF8F8F8);
  static const neutral200 = Color(0xFFE9EBE8);
  static const info = Color(0xFF5991F2);

  static final theme = ThemeData(
      scaffoldBackgroundColor: neutral,
      appBarTheme: const AppBarTheme(
          elevation: 0, color: neutral, foregroundColor: primary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 16)),
          backgroundColor: MaterialStateProperty.all(primary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(primary),
        side: MaterialStateProperty.all(
            const BorderSide(color: primary, width: 1)),
        padding:
            MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
      )),
      textButtonTheme: TextButtonThemeData(
          style:
              ButtonStyle(foregroundColor: MaterialStateProperty.all(info))));
}
