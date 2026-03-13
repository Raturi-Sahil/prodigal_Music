import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand color - Dhanur Orange
  static const Color primary = Color(0xFFE8632B);
  static const Color primaryLight = Color(0xFFFF8A50);
  static const Color primaryDark = Color(0xFFBF360C);

  // Background
  static const Color background = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF282828);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color cardLight = Color(0xFF2A2A2A);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textHint = Color(0xFF727272);

  // Accent colors for genre cards
  static const Color genrePurple = Color(0xFF8B5CF6);
  static const Color genreGreen = Color(0xFF1DB954);
  static const Color genreOrange = Color(0xFFFF6B35);
  static const Color genreBlue = Color(0xFF3B82F6);
  static const Color genrePink = Color(0xFFEC4899);
  static const Color genreYellow = Color(0xFFF59E0B);
  static const Color genreTeal = Color(0xFF14B8A6);
  static const Color genreRed = Color(0xFFEF4444);

  // Player
  static const Color progressBar = Color(0xFFE8632B);
  static const Color progressBackground = Color(0xFF535353);

  // Bottom nav
  static const Color navActive = Color(0xFFE8632B);
  static const Color navInactive = Color(0xFFB3B3B3);

  // Legacy / auth screen colors (backward compat)
  static const Color primaryPurple = Color(0xFF7B2FBE);
  static const Color primaryViolet = Color(0xFF9B59B6);
  static const Color primaryCyan = Color(0xFFE8632B); // mapped to primary
  static const Color primaryMagenta = Color(0xFFE040FB);
  static const Color primaryBlue = Color(0xFF3A7BD5);
  static const Color accentGreen = Color(0xFF1DB954);
  static const Color error = Color(0xFFFF4C6A);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE8632B), Color(0xFFFF8A50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF121212), Color(0xFF1A1A1A), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Gradients
  static const LinearGradient homeGradient = LinearGradient(
    colors: [Color(0xFF3D1A0A), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.4],
  );

  static const LinearGradient playerGradient = LinearGradient(
    colors: [Color(0xFF3D1A0A), Color(0xFF1A1A1A), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF1A0A04), Color(0xFF121212), Color(0xFF0A0A0A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
