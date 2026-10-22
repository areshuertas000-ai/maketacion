import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const ink = Color(0xFF192033);
  static const muted = Color(0xFF737B8C);
  static const purple = Color(0xFF8738F5);
  static const pink = Color(0xFFED429A);
  static const green = Color(0xFF238555);
  static const gradient = LinearGradient(colors: [purple, pink]);
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: purple),
    scaffoldBackgroundColor: const Color(0xFFECEBF1),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: ink, fontSize: 14),
      bodySmall: TextStyle(color: muted, fontSize: 12, height: 1.5),
      headlineMedium: TextStyle(
        color: ink,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.12,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      hintStyle: const TextStyle(color: AppTheme.muted, fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE4E6EE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: purple, width: 1.5),
      ),
      errorMaxLines: 3,
      errorStyle: const TextStyle(fontSize: 12),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
