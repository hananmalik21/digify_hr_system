import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveEntitlementsSection extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveEntitlementsSection({
    super.key,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.kuwaitLaborLawLeaveEntitlements,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: context.themeTextPrimary,
              height: 27 / 17,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _EntitlementCard(
                  title: localizations.annualLeave,
                  description: localizations.annualLeaveEntitlement,
                  backgroundColor: AppColors.infoBg,
                  titleColor: AppColors.infoText,
                  descriptionColor: AppColors.infoTextSecondary,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _EntitlementCard(
                  title: localizations.sickLeave,
                  description: localizations.sickLeaveEntitlement,
                  backgroundColor: AppColors.greenBg,
                  titleColor: AppColors.greenText,
                  descriptionColor: AppColors.greenTextSecondary,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _EntitlementCard(
                  title: localizations.maternityLeave,
                  description: localizations.maternityLeaveEntitlement,
                  backgroundColor: AppColors.purpleBg,
                  titleColor: AppColors.purpleText,
                  descriptionColor: const Color(0xFFC6005C),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _EntitlementCard(
                  title: localizations.emergencyLeave,
                  description: localizations.emergencyLeaveEntitlement,
                  backgroundColor: AppColors.warningBg,
                  titleColor: const Color(0xFF733E0A),
                  descriptionColor: const Color(0xFFA65F00),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntitlementCard extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color titleColor;
  final Color descriptionColor;

  const _EntitlementCard({
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.titleColor,
    required this.descriptionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.1.sp,
              fontWeight: FontWeight.w400,
              color: titleColor,
              height: 24 / 15.1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 15.1.sp,
              fontWeight: FontWeight.w400,
              color: descriptionColor,
              height: 24 / 15.1,
            ),
          ),
        ],
      ),
    );
  }
}
