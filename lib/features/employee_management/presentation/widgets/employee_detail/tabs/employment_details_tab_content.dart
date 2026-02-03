import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/employment_details_sections/employment_details_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Tab content for Employment Details.
/// Composes section modules; each section owns its own data and card.
class EmploymentDetailsTabContent extends StatelessWidget {
  const EmploymentDetailsTabContent({super.key, required this.isDark, this.wrapInScrollView = true});

  final bool isDark;
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EnterpriseStructureSection(isDark: isDark),
          Gap(24.h),
          WorkforceStructureSection(isDark: isDark),
          Gap(24.h),
          EmploymentInformationSection(isDark: isDark),
        ],
      ),
    );
    if (wrapInScrollView) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: content,
      );
    }
    return content;
  }
}
