import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade_structure.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/grade_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradeStructureCard extends StatelessWidget {
  final GradeStructure grade;

  const GradeStructureCard({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgIconWidget(
                    assetPath: 'assets/icons/grade_icon.svg',
                    color: const Color(0xff2B7FFF),
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    grade.gradeLabel,
                    style: TextStyle(
                      fontSize: 15.6.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 24 / 15.6,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F0FF),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      grade.gradeCategory,
                      style: TextStyle(
                        fontSize: 12.2.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1D4ED8),
                        height: 16 / 12.2,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  GradeFormDialog.show(
                    context,
                    grade: grade,
                    isEdit: true,
                    onSave: (updated) {},
                  );
                },
                child: SvgIconWidget(
                  assetPath: 'assets/icons/edit_icon.svg',
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            grade.description,
            style: TextStyle(
              fontSize: 13.7.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 20 / 13.7,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: grade.steps.map((step) {
              return Container(
                width: 266.4.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Column(
                  children: [
                    Text(
                      step.label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      step.amount,
                      style: TextStyle(
                        fontSize: 15.8.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
