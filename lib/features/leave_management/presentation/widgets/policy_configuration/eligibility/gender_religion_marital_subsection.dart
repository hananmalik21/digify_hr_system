import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility/radio_group_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderReligionMaritalSubsection extends StatelessWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;

  const GenderReligionMaritalSubsection({super.key, required this.eligibility, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return isMobile
            ? Column(
                spacing: 14.h,
                children: [
                  RadioGroupCard(
                    title: 'Gender',
                    iconPath: Assets.icons.usersIcon.path,
                    options: ['All', 'Male', 'Female'],
                    selectedValue: eligibility.gender,
                    isDark: isDark,
                  ),
                  RadioGroupCard(
                    title: 'Religion',
                    iconPath: Assets.icons.leaveManagement.globe.path,
                    options: ['All', 'Muslim', 'Non Muslim'],
                    selectedValue: eligibility.religion,
                    isDark: isDark,
                  ),
                  RadioGroupCard(
                    title: 'Marital Status',
                    iconPath: Assets.icons.leaveManagement.martialStatus.path,
                    options: ['All', 'Single', 'Married'],
                    selectedValue: eligibility.maritalStatus,
                    isDark: isDark,
                  ),
                ],
              )
            : Row(
                spacing: 14.w,
                children: [
                  Expanded(
                    child: RadioGroupCard(
                      title: 'Gender',
                      iconPath: Assets.icons.employeesBlueIcon.path,
                      options: ['All', 'Male', 'Female'],
                      selectedValue: eligibility.gender,
                      isDark: isDark,
                    ),
                  ),
                  Expanded(
                    child: RadioGroupCard(
                      title: 'Religion',
                      iconPath: Assets.icons.leaveManagement.globe.path,
                      options: ['All', 'Muslim', 'Non Muslim'],
                      selectedValue: eligibility.religion,
                      isDark: isDark,
                    ),
                  ),
                  Expanded(
                    child: RadioGroupCard(
                      title: 'Marital Status',
                      iconPath: Assets.icons.leaveManagement.martialStatus.path,
                      options: ['All', 'Single', 'Married'],
                      selectedValue: eligibility.maritalStatus,
                      isDark: isDark,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
