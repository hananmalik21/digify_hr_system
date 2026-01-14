import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
  final bool isDeleting;

  const HolidayCard({
    super.key,
    required this.holiday,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.showBorder = true,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: showBorder
          ? BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateBadge(context, isDark),
          Gap(16.w),
          Expanded(child: _buildHolidayInfo(context, isDark)),
          Gap(16.w),
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
        color: isDark ? AppColors.cardBackgroundDark : AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${holiday.day}',
            style: context.textTheme.displaySmall?.copyWith(
              fontSize: 24.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
            ),
          ),
          Gap(4.h),
          Text(
            holiday.month,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 11.8.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
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
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 15.8.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            Gap(12.w),
            HolidayTypeBadge(type: holiday.type, paymentStatus: holiday.paymentStatus),
          ],
        ),
        Gap(8.h),
        Text(
          holiday.nameAr,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
          textDirection: TextDirection.rtl,
        ),
        Gap(8.h),
        Text(
          holiday.descriptionEn,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 13.6.sp,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(8.h),
        Text(
          holiday.descriptionAr,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
          textDirection: TextDirection.rtl,
        ),
        Gap(8.h),
        Row(
          children: [
            Text(
              'Applies to: ${holiday.appliesTo}',
              style: context.textTheme.labelMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textTertiary,
              ),
            ),
            Gap(8.w),
            Text(
              '•',
              style: context.textTheme.labelMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textTertiary,
              ),
            ),
            Gap(16.w),
            Text(
              'Date: ${holiday.date}',
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 11.8.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textTertiary,
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
        Gap(8.w),
        DigifyAssetButton(
          assetPath: Assets.icons.editIcon.path,
          onTap: onEdit,
          width: 18,
          height: 18,
          color: isDark ? null : AppColors.editIconGreen,
        ),
        Gap(8.w),
        DigifyAssetButton(
          assetPath: Assets.icons.deleteIconRed.path,
          onTap: onDelete,
          width: 18,
          height: 18,
          color: isDark ? null : AppColors.deleteIconRed,
          isLoading: isDeleting,
        ),
      ],
    );
  }
}
