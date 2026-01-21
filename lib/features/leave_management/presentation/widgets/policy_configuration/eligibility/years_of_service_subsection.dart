import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YearsOfServiceSubsection extends StatelessWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;

  const YearsOfServiceSubsection({super.key, required this.eligibility, required this.isDark});

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
          EligibilitySubsectionHeader(title: 'Years of Service', iconPath: Assets.icons.gradeIcon.path, isDark: isDark),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: TextEditingController(text: eligibility.minYearsRequired ?? ''),
                  labelText: 'Minimum Years Required',
                  hintText: 'Enter minimum years',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  filled: true,
                  fillColor: AppColors.cardBackground,
                ),
              ),
              Expanded(
                child: DigifyTextField(
                  controller: TextEditingController(text: eligibility.maxYearsAllowed ?? ''),
                  labelText: 'Maximum Years (Optional)',
                  hintText: 'No limit',
                  filled: true,
                  fillColor: AppColors.cardBackground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
