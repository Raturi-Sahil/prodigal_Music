import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary gradient colors
  static const Color primaryPurple = Color(0xFF7B2FBE);
  static const Color primaryViolet = Color(0xFF9B59B6);
  static const Color primaryCyan = Color(0xFF00D2FF);
  static const Color primaryBlue = Color(0xFF3A7BD5);

  // Background
  static const Color background = Color(0xFF0D0D1A);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF16213E);
  static const Color cardDark = Color(0xFF1E1E32);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C3);
  static const Color textHint = Color(0xFF6C6C80);

  // Accent
  static const Color accentGreen = Color(0xFF1DB954);
  static const Color error = Color(0xFFFF4C6A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0D0D1A), Color(0xFF1A0A2E), Color(0xFF0A1628)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
