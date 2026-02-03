import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_document_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DocumentsBankingTabContent extends StatelessWidget {
  const DocumentsBankingTabContent({super.key, required this.isDark, this.wrapInScrollView = true});

  final bool isDark;
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EmployeeDetailDocumentCard(
                  title: 'Civil ID',
                  iconPath: Assets.icons.employeeManagement.basicInfo.path,
                  statusLabel: 'Valid',
                  number: '989987878',
                  expiryDate: '19/09/2027',
                  isDark: isDark,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: EmployeeDetailDocumentCard(
                  title: 'Passport',
                  iconPath: Assets.icons.employeeManagement.passport.path,
                  statusLabel: 'Valid',
                  number: '8777898978',
                  expiryDate: '10/10/2026',
                  isDark: isDark,
                ),
              ),
            ],
          ),
          Gap(12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EmployeeDetailDocumentCard(
                  title: 'Visa',
                  iconPath: Assets.icons.employeeManagement.document.path,
                  statusLabel: 'Valid',
                  number: '12312312',
                  expiryDate: '01/01/2027',
                  isDark: isDark,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: EmployeeDetailDocumentCard(
                  title: 'Work Permit',
                  iconPath: Assets.icons.employeeManagement.document.path,
                  statusLabel: 'Valid',
                  number: '1231',
                  expiryDate: '01/12/2027',
                  isDark: isDark,
                ),
              ),
            ],
          ),
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
