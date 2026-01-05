import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DepartmentField extends StatelessWidget {
  final TextEditingController controller;
  final AssignmentLevel? selectedLevel;
  final String? Function(String?)? validator;

  const DepartmentField({super.key, required this.controller, this.selectedLevel, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Select Department',
              style: TextStyle(
                fontSize: 13.8.sp,
                fontWeight: FontWeight.w500,
                color: context.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '*',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.deleteIconRed),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        DigifyTextField(
          controller: controller,
          hintText: 'Type to search departments...',
          suffixIcon: DigifyAsset(assetPath: Assets.icons.arrowIcon.path, width: 18, height: 18),
          validator: validator,
        ),
        SizedBox(height: 8.h),
        Text(
          'The schedule will be applied to all employees in the selected department',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: context.isDark ? AppColors.textMutedDark : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
