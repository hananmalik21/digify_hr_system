import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Tab content for Employment Details: job information and reporting.
class EmploymentDetailsTabContent extends StatelessWidget {
  const EmploymentDetailsTabContent({super.key, required this.isDark, this.wrapInScrollView = true});

  final bool isDark;
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeDetailSectionCard(
          title: 'Job Information',
          isDark: isDark,
          rows: const [
            EmployeeDetailSectionRow(label: 'Position', value: '—'),
            EmployeeDetailSectionRow(label: 'Department', value: '—'),
            EmployeeDetailSectionRow(label: 'Start Date', value: '—'),
            EmployeeDetailSectionRow(label: 'Employee ID', value: '—'),
            EmployeeDetailSectionRow(label: 'Work Location', value: '—'),
          ],
        ),
        Gap(16.h),
        EmployeeDetailSectionCard(
          title: 'Reporting',
          isDark: isDark,
          rows: const [
            EmployeeDetailSectionRow(label: 'Reports To', value: '—'),
            EmployeeDetailSectionRow(label: 'Job Grade', value: '—'),
          ],
        ),
      ],
    );
    if (wrapInScrollView) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: content,
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: content,
    );
  }
}
