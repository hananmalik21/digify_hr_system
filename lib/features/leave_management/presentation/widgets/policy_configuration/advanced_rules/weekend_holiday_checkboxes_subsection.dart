import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeekendHolidayCheckboxesSubsection extends StatelessWidget {
  final AdvancedRules advanced;

  const WeekendHolidayCheckboxesSubsection({super.key, required this.advanced});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.securityProfilesBackground,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: DigifyCheckbox(
              value: advanced.countWeekendsAsLeave,
              onChanged: null,
              label: 'Count weekends as leave days',
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.securityProfilesBackground,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: DigifyCheckbox(
              value: advanced.countPublicHolidaysAsLeave,
              onChanged: null,
              label: 'Count public holidays as leave days',
            ),
          ),
        ),
      ],
    );
  }
}
