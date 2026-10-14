import 'package:flutter/material.dart';

class AppTheme {
  static const teal = Color(0xFF2F7E79);
  static const tealDark = Color(0xFF276862);
  static const background = Color(0xFFF7F9F9);
  static const ink = Color(0xFF252A2A);
  static const muted = Color(0xFF8B9695);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: teal),
    appBarTheme: const AppBarTheme(
      backgroundColor: teal,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E7E6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E7E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: teal, width: 1.4),
      ),
      labelStyle: const TextStyle(fontSize: 12, color: muted),
    ),
  );
}
