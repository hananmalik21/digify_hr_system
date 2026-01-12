import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static const double _defaultHeight = 1.2;

  static TextTheme get lightTextTheme {
    return TextTheme(
      labelSmall: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      bodySmall: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displayMedium: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displayLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
    );
  }

  static TextTheme get darkTextTheme {
    return TextTheme(
      labelSmall: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      bodySmall: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displayMedium: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displayLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
    );
  }
}
