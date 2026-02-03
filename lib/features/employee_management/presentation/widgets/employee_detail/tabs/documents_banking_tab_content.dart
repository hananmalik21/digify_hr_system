import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Tab content for Documents & Banking: documents and bank details.
class DocumentsBankingTabContent extends StatelessWidget {
  const DocumentsBankingTabContent({super.key, required this.isDark, this.wrapInScrollView = true});

  final bool isDark;
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeDetailSectionCard(
          title: 'Documents',
          isDark: isDark,
          rows: const [
            EmployeeDetailSectionRow(label: 'Civil ID', value: '—'),
            EmployeeDetailSectionRow(label: 'Contract', value: '—'),
            EmployeeDetailSectionRow(label: 'Passport', value: '—'),
          ],
        ),
        Gap(16.h),
        EmployeeDetailSectionCard(
          title: 'Banking',
          isDark: isDark,
          rows: const [
            EmployeeDetailSectionRow(label: 'Bank Name', value: '—'),
            EmployeeDetailSectionRow(label: 'IBAN', value: '—'),
            EmployeeDetailSectionRow(label: 'Account Number', value: '—'),
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
