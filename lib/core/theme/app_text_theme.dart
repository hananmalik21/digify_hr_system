import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static const double _defaultHeight = 1.2;

  static TextTheme get lightTextTheme {
    return TextTheme(
      labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: _defaultHeight, letterSpacing: 0),
      labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: _defaultHeight, letterSpacing: 0),
      labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: _defaultHeight, letterSpacing: 0),
      bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      titleSmall: TextStyle(fontFamily: 'Inter', fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      headlineSmall: TextStyle(fontFamily: 'Inter', fontSize: 17.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      headlineMedium: TextStyle(fontFamily: 'Inter', fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 22.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      displaySmall: TextStyle(fontFamily: 'Inter', fontSize: 24.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      displayMedium: TextStyle(fontFamily: 'Inter', fontSize: 28.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
      displayLarge: TextStyle(fontFamily: 'Inter', fontSize: 32.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: _defaultHeight, letterSpacing: 0),
    );
  }

  static TextTheme get darkTextTheme {
    return TextTheme(
      labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.textSecondaryDark, height: _defaultHeight, letterSpacing: 0),
      labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondaryDark, height: _defaultHeight, letterSpacing: 0),
      labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, fontWeight: FontWeight.w400, color: AppColors.textSecondaryDark, height: _defaultHeight, letterSpacing: 0),
      bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      titleSmall: TextStyle(fontFamily: 'Inter', fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      titleMedium: TextStyle(fontFamily: 'Inter', fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      headlineSmall: TextStyle(fontFamily: 'Inter', fontSize: 17.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      headlineMedium: TextStyle(fontFamily: 'Inter', fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 22.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      displaySmall: TextStyle(fontFamily: 'Inter', fontSize: 24.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      displayMedium: TextStyle(fontFamily: 'Inter', fontSize: 28.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
      displayLarge: TextStyle(fontFamily: 'Inter', fontSize: 32.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark, height: _defaultHeight, letterSpacing: 0),
    );
  }
}
