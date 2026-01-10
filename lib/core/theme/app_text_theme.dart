import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static const double _defaultHeight = 1.2;

  static TextTheme get lightTextTheme {
    return TextTheme(
      labelSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
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
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 15.5.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 15.5.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displayMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displayLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
    );
  }

  static TextTheme get darkTextTheme {
    return TextTheme(
      labelSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
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
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 15.5.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 15.5.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displayMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
      displayLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimaryDark,
        height: _defaultHeight,
        letterSpacing: 0,
      ),
    );
  }
}
