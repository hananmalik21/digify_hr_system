import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'holiday_type_badge.dart';

class HolidayCardData {
  final String id;
  final int day;
  final String month;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final HolidayType type;
  final HolidayPaymentStatus paymentStatus;
  final String date;
  final String appliesTo;

  const HolidayCardData({
    required this.id,
    required this.day,
    required this.month,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    required this.paymentStatus,
    required this.date,
    required this.appliesTo,
  });
}

class HolidayCard extends StatelessWidget {
  final HolidayCardData holiday;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showBorder;

  const HolidayCard({
    super.key,
    required this.holiday,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: showBorder
          ? BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateBadge(context, isDark),
          SizedBox(width: 16.w),
          Expanded(child: _buildHolidayInfo(context, isDark)),
          SizedBox(width: 16.w),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context, bool isDark) {
    return Container(
      width: 64.w,
      height: 64.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${holiday.day}',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
              fontFamily: 'Inter',
              height: 32 / 24,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            holiday.month,
            style: TextStyle(
              fontSize: 11.8.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
              fontFamily: 'Inter',
              height: 16 / 11.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidayInfo(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              holiday.nameEn,
              style: TextStyle(
                fontSize: 15.8.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                fontFamily: 'Inter',
                height: 24 / 15.8,
              ),
            ),
            SizedBox(width: 12.w),
            HolidayTypeBadge(type: holiday.type, paymentStatus: holiday.paymentStatus),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          holiday.nameAr,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontFamily: 'Inter',
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 8.h),
        Text(
          holiday.descriptionEn,
          style: TextStyle(
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontFamily: 'Inter',
            height: 20 / 13.6,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          holiday.descriptionAr,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontFamily: 'Inter',
            height: 1.4,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              'Applies to: ${holiday.appliesTo}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                fontFamily: 'Inter',
                height: 16 / 12,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '•',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                fontFamily: 'Inter',
                height: 16 / 12,
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              'Date: ${holiday.date}',
              style: TextStyle(
                fontSize: 11.8.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                fontFamily: 'Inter',
                height: 16 / 11.8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isDark = context.isDark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAssetButton(
          assetPath: Assets.icons.viewIconBlue.path,
          onTap: onView,
          width: 18,
          height: 18,
          color: isDark ? null : AppColors.viewIconBlue,
        ),
        SizedBox(width: 8.w),
        DigifyAssetButton(
          assetPath: Assets.icons.editIcon.path,
          onTap: onEdit,
          width: 18,
          height: 18,
          color: isDark ? null : AppColors.editIconGreen,
        ),
        SizedBox(width: 8.w),
        DigifyAssetButton(
          assetPath: Assets.icons.deleteIconRed.path,
          onTap: onDelete,
          width: 18,
          height: 18,
          color: isDark ? null : AppColors.deleteIconRed,
        ),
      ],
    );
  }
}
