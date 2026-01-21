import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_radio.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioGroupCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final List<String> options;
  final String? selectedValue;
  final bool isDark;

  const RadioGroupCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.options,
    required this.selectedValue,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.categoryBadgeBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          EligibilitySubsectionHeader(title: title, iconPath: iconPath, isDark: isDark),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.h,
            children: options.map((option) {
              return DigifyRadio<String>(value: option, groupValue: selectedValue, onChanged: (_) {}, label: option);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
