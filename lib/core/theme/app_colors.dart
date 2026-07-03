import 'package:flutter/material.dart';

/// AgroLink Uganda brand color palette.
class AppColors {
  AppColors._();

  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color goldAccent = Color(0xFFFFC107);
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121712);

  static const Color surfaceLight = Color(0xFFF6F8F6);
  static const Color surfaceDark = Color(0xFF1E241E);

  static const Color textPrimary = Color(0xFF1B1F1B);
  static const Color textSecondary = Color(0xFF6B756B);
  static const Color textOnDark = Color(0xFFF1F5F1);

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  static const Color border = Color(0xFFE1E6E1);
  static const Color borderDark = Color(0xFF2C332C);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, secondaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
