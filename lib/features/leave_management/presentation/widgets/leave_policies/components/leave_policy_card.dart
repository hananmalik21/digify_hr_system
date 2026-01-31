import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeavePolicyCard extends StatelessWidget {
  final LeavePolicy policy;
  final bool isDark;

  const LeavePolicyCard({super.key, required this.policy, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = isMobile ? 16.w : 20.w;
    final gapSmall = isMobile ? 8.h : 12.h;
    final gapMedium = isMobile ? 10.h : 14.h;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            policy.nameEn,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: isMobile ? 14.sp : 16.sp,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (policy.isKuwaitLaw) ...[
                          Gap(isMobile ? 8.w : 11.w),
                          DigifyCapsule(
                            label: 'Kuwait Law',
                            backgroundColor: AppColors.successBg,
                            textColor: AppColors.successText,
                          ),
                        ],
                      ],
                    ),
                    Gap(4.h),
                    Text(
                      policy.nameAr,
                      textDirection: ui.TextDirection.rtl,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: isMobile ? 13.sp : 15.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(gapMedium),
          Flexible(
            child: Text(
              policy.description,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: isMobile ? 11.sp : 12.sp,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              ),
              maxLines: isMobile ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(gapMedium),
          Row(
            children: [
              Expanded(child: _buildDetailItem(context, 'Entitlement', policy.entitlement)),
              Gap(isMobile ? 8.w : 12.w),
              Expanded(child: _buildDetailItem(context, 'Accrual Type', policy.accrualType)),
            ],
          ),
          Gap(gapSmall),
          Row(
            children: [
              Expanded(child: _buildDetailItem(context, 'Min Service', policy.minService)),
              Gap(isMobile ? 8.w : 12.w),
              Expanded(child: _buildDetailItem(context, 'Advance Notice', policy.advanceNotice)),
            ],
          ),
          Gap(gapMedium),
          Flexible(
            child: Wrap(
              spacing: isMobile ? 6.w : 7.w,
              runSpacing: isMobile ? 6.h : 7.h,
              children: [
                DigifyCapsule(
                  label: policy.isPaid ? 'Paid' : 'Unpaid',
                  backgroundColor: policy.isPaid ? AppColors.successBg : AppColors.orangeBg,
                  textColor: policy.isPaid ? AppColors.successText : AppColors.orangeText,
                ),
                if (policy.carryoverDays != null)
                  DigifyCapsule(
                    label: 'Carryover: ${policy.carryoverDays} days',
                    backgroundColor: AppColors.jobRoleBg,
                    textColor: AppColors.permissionBadgeText,
                  ),
                if (policy.requiresAttachment)
                  DigifyCapsule(
                    label: 'Attachment Required',
                    backgroundColor: AppColors.orangeBg,
                    textColor: AppColors.orangeText,
                  ),
                if (policy.genderRestriction != null)
                  DigifyCapsule(
                    label: '${policy.genderRestriction} Only',
                    backgroundColor: AppColors.purpleBg,
                    textColor: AppColors.statIconPurple,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final isMobile = context.isMobile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: isMobile ? 11.sp : 12.sp,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(isMobile ? 3.h : 4.h),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: isMobile ? 13.sp : 14.sp,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
