import 'package:flutter/material.dart';
import '../config/app_config.dart';

class AppColors {
  // Dynamic brand colors tied to AppConfig
  static Color get primary => AppConfig.current.primaryColor;
  static Color get primaryDark => AppConfig.current.primaryDarkColor;
  static Color get primaryLight => AppConfig.current.primaryLightColor;
  static Color get secondary => AppConfig.current.secondaryColor;
  static Color get starGold => AppConfig.current.secondaryColor;
  static Color get starGoldLight => AppConfig.current.accentColor;

  static const Color brandGray = Color(0xFF6B7280);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF1E293B);
  static const Color textDark = Color(0xFFF1F5F9);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
}
