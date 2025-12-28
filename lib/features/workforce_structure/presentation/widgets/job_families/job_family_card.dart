import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_family_detail_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobFamilyCard extends StatelessWidget {
  final JobFamily jobFamily;
  final List<JobLevel> jobLevels;
  final AppLocalizations localizations;
  final bool isDark;

  const JobFamilyCard({
    super.key,
    required this.jobFamily,
    required this.jobLevels,
    required this.localizations,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final gap = 16.h;

    final cardContent = Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobFamily.nameEnglish,
                      style: TextStyle(
                        fontSize: 15.6.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 24 / 15.6,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      jobFamily.nameArabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 20 / 14,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        jobFamily.code,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF193CB8),
                          height: 16 / 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SvgIconWidget(
                assetPath: 'assets/icons/business_unit_details_icon.svg',
                color: const Color(0xFF2B7FFF),
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: gap),
          Text(
            jobFamily.description,
            style: TextStyle(
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 20 / 13.6,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: gap),
          Divider(color: AppColors.cardBorder, thickness: 1.w, height: 1),
          SizedBox(height: gap),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => JobFamilyDetailDialog.show(
                      context,
                      jobFamily: jobFamily,
                      jobLevels: jobLevels,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgIconWidget(
                            assetPath: 'assets/icons/view_icon_blue.svg',
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            localizations.view,
                            style: TextStyle(
                              fontSize: 15.1.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primary,
                              height: 24 / 15.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      JobFamilyFormDialog.show(
                        context,
                        jobFamily: jobFamily,
                        isEdit: true,
                        onSave: (updated) {},
                      );
                    },
                    borderRadius: BorderRadius.circular(4.r),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgIconWidget(
                            assetPath: 'assets/icons/edit_icon_green.svg',
                            size: 16.sp,
                            color: AppColors.greenButton,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            localizations.edit,
                            style: TextStyle(
                              fontSize: 15.4.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greenButton,
                              height: 24 / 15.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: cardContent,
    );
  }
}
