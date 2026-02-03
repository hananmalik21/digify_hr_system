import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Tab content for Compensation & Benefits: salary and benefits.
class CompensationBenefitsTabContent extends StatelessWidget {
  const CompensationBenefitsTabContent({super.key, required this.isDark, this.wrapInScrollView = true});

  final bool isDark;
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeDetailSectionCard(
          title: 'Salary',
          isDark: isDark,
          rows: const [
            EmployeeDetailSectionRow(label: 'Basic Salary', value: '—'),
            EmployeeDetailSectionRow(label: 'Allowances', value: '—'),
            EmployeeDetailSectionRow(label: 'Currency', value: '—'),
          ],
        ),
        Gap(16.h),
        EmployeeDetailSectionCard(
          title: 'Benefits',
          isDark: isDark,
          rows: const [
            EmployeeDetailSectionRow(label: 'Health Insurance', value: '—'),
            EmployeeDetailSectionRow(label: 'Leave Entitlement', value: '—'),
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
