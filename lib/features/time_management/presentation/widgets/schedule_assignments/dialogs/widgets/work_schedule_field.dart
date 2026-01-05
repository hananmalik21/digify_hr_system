import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkScheduleField extends StatelessWidget {
  final String? selectedWorkSchedule;
  final List<String> workSchedules;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const WorkScheduleField({
    super.key,
    this.selectedWorkSchedule,
    required this.workSchedules,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifySelectField<String>(
          label: 'Work Schedule',
          isRequired: true,
          hint: 'Select Work Schedule',
          items: workSchedules,
          itemLabelBuilder: (item) => item,
          value: selectedWorkSchedule,
          onChanged: onChanged,
          validator: validator,
        ),
        SizedBox(height: 8.h),
        Text(
          'Select an existing work schedule',
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
