import 'dart:ui' as ui;
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_management/data/config/public_holidays_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/public_holiday.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ViewHolidayDialog {
  static Future<void> show(BuildContext context, {required PublicHoliday holiday}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ViewHolidayDialogContent(holiday: holiday),
    );
  }
}

class _ViewHolidayDialogContent extends StatelessWidget {
  final PublicHoliday holiday;

  const _ViewHolidayDialogContent({required this.holiday});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy');
    final formattedDate = dateFormatter.format(holiday.date);

    return AppDialog(
      title: 'Holiday Details',
      width: 672.w,
      onClose: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(context, label: 'Holiday Name', value: holiday.nameEn, isDark: isDark),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildInfoCard(context, label: 'اسم العطلة', value: holiday.nameAr, isDark: isDark, isRtl: true),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: _buildInfoCard(context, label: 'Date', value: formattedDate, isDark: isDark),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  label: 'Type',
                  value: PublicHolidaysConfig.getHolidayTypeDisplayName(holiday.type).toUpperCase(),
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildInfoCard(
                  context,
                  label: 'Paid Holiday',
                  value: holiday.paymentStatus == HolidayPaymentStatus.paid ? 'Yes' : 'No',
                  isDark: isDark,
                ),
              ),
              // SizedBox(width: 16.w),
              // Expanded(
              //   child: _buildInfoCard(context, label: 'Recurring', value: 'Yes', isDark: isDark),
              // ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: _buildDescriptionCard(
              context,
              label: 'Description',
              valueEn: holiday.descriptionEn,
              valueAr: holiday.descriptionAr,
              isDark: isDark,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: _buildInfoCard(
              context,
              label: 'Applies To',
              value: PublicHolidaysConfig.getAppliesToDisplayName(holiday.appliesTo) ?? holiday.appliesTo.toLowerCase(),
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String label,
    required String value,
    required bool isDark,
    bool isRtl = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
              height: 20 / 13.6,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 8.h),
          Directionality(
            textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.6.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                height: 24 / 15.6,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(
    BuildContext context, {
    required String label,
    required String valueEn,
    required String valueAr,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
              height: 20 / 13.6,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            valueEn,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.6.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              height: 24 / 15.6,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 8.h),
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Text(
              valueAr,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.6.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                height: 24 / 15.6,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
