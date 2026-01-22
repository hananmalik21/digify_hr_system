import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeCategorySubsection extends StatelessWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;

  const EmployeeCategorySubsection({super.key, required this.eligibility, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          EligibilitySubsectionHeader(
            title: 'Employee Category',
            iconPath: Assets.icons.leaveManagement.globe.path,
            isDark: isDark,
          ),
          Row(
            spacing: 16.w,
            children: [
              Flexible(
                child: DigifyCheckbox(
                  value: eligibility.employeeCategory == 'Kuwaiti Nationals',
                  onChanged: null,
                  label: 'Kuwaiti Nationals',
                ),
              ),
              Flexible(
                child: DigifyCheckbox(
                  value: eligibility.employeeCategory == 'Expatriates',
                  onChanged: null,
                  label: 'Expatriates',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
