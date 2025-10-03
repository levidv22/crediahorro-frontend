import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // --- Títulos de pantallas ---
  static const TextStyle screenTitle = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );

  // --- Nombre de marca ---
  static const TextStyle brandName = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 1.5,
  );

  // --- Texto principal ---
  static const TextStyle body = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // --- Botones ---
  static const TextStyle button = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1,
  );

  // --- Inputs ---
  static const TextStyle inputLabel = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // --- Enlaces ---
  static const TextStyle textLink = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );

  // --- Pequeños subtítulos / info ---
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'SansSerif',
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
