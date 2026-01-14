import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveEntitlementsSection extends StatelessWidget {
  const LeaveEntitlementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              height: 27 / 17,
            ),
          ),
          Gap(16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
              
              if (isMobile) {
                return Column(
                  children: [
                    _LeaveEntitlementCard(
                      title: localizations.annualLeave,
                      description: localizations.annualLeaveDescription,
                      backgroundColor: const Color(0xFFEFF6FF),
                      titleColor: const Color(0xFF1C398E),
                      descriptionColor: const Color(0xFF1447E6),
                    ),
                    Gap(12.h),
                    _LeaveEntitlementCard(
                      title: localizations.sickLeave,
                      description: localizations.sickLeaveDescription,
                      backgroundColor: const Color(0xFFF0FDF4),
                      titleColor: const Color(0xFF0D542B),
                      descriptionColor: const Color(0xFF008236),
                    ),
                    Gap(12.h),
                    _LeaveEntitlementCard(
                      title: localizations.maternityLeave,
                      description: localizations.maternityLeaveDescription,
                      backgroundColor: const Color(0xFFFDF2F8),
                      titleColor: const Color(0xFF861043),
                      descriptionColor: const Color(0xFFC6005C),
                    ),
                    Gap(12.h),
                    _LeaveEntitlementCard(
                      title: localizations.emergencyLeave,
                      description: localizations.emergencyLeaveDescription,
                      backgroundColor: const Color(0xFFFEFCE8),
                      titleColor: const Color(0xFF733E0A),
                      descriptionColor: const Color(0xFFA65F00),
                    ),
                  ],
                );
              } else if (isTablet) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _LeaveEntitlementCard(
                            title: localizations.annualLeave,
                            description: localizations.annualLeaveDescription,
                            backgroundColor: const Color(0xFFEFF6FF),
                            titleColor: const Color(0xFF1C398E),
                            descriptionColor: const Color(0xFF1447E6),
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: _LeaveEntitlementCard(
                            title: localizations.sickLeave,
                            description: localizations.sickLeaveDescription,
                            backgroundColor: const Color(0xFFF0FDF4),
                            titleColor: const Color(0xFF0D542B),
                            descriptionColor: const Color(0xFF008236),
                          ),
                        ),
                      ],
                    ),
                    Gap(12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _LeaveEntitlementCard(
                            title: localizations.maternityLeave,
                            description: localizations.maternityLeaveDescription,
                            backgroundColor: const Color(0xFFFDF2F8),
                            titleColor: const Color(0xFF861043),
                            descriptionColor: const Color(0xFFC6005C),
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: _LeaveEntitlementCard(
                            title: localizations.emergencyLeave,
                            description: localizations.emergencyLeaveDescription,
                            backgroundColor: const Color(0xFFFEFCE8),
                            titleColor: const Color(0xFF733E0A),
                            descriptionColor: const Color(0xFFA65F00),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: _LeaveEntitlementCard(
                        title: localizations.annualLeave,
                        description: localizations.annualLeaveDescription,
                        backgroundColor: const Color(0xFFEFF6FF),
                        titleColor: const Color(0xFF1C398E),
                        descriptionColor: const Color(0xFF1447E6),
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: _LeaveEntitlementCard(
                        title: localizations.sickLeave,
                        description: localizations.sickLeaveDescription,
                        backgroundColor: const Color(0xFFF0FDF4),
                        titleColor: const Color(0xFF0D542B),
                        descriptionColor: const Color(0xFF008236),
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: _LeaveEntitlementCard(
                        title: localizations.maternityLeave,
                        description: localizations.maternityLeaveDescription,
                        backgroundColor: const Color(0xFFFDF2F8),
                        titleColor: const Color(0xFF861043),
                        descriptionColor: const Color(0xFFC6005C),
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: _LeaveEntitlementCard(
                        title: localizations.emergencyLeave,
                        description: localizations.emergencyLeaveDescription,
                        backgroundColor: const Color(0xFFFEFCE8),
                        titleColor: const Color(0xFF733E0A),
                        descriptionColor: const Color(0xFFA65F00),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LeaveEntitlementCard extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color titleColor;
  final Color descriptionColor;

  const _LeaveEntitlementCard({
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
          Gap(4.h),
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
