import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_icon_label_section_card.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_row_section_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationBenefitsTabContent extends StatelessWidget {
  const CompensationBenefitsTabContent({super.key, required this.isDark, this.wrapInScrollView = true});

  final bool isDark;
  final bool wrapInScrollView;

  static const List<EmployeeDetailRowItem> _salaryComponentsRows = [
    EmployeeDetailRowItem(label: 'Basic Salary', value: '3000.000 KWD'),
    EmployeeDetailRowItem(label: 'Housing Allowance', value: '0.000 KWD'),
    EmployeeDetailRowItem(label: 'Transportation Allowance', value: '34.000 KWD'),
    EmployeeDetailRowItem(label: 'Food Allowance', value: '23.000 KWD'),
    EmployeeDetailRowItem(label: 'Mobile Allowance', value: '34.000 KWD'),
    EmployeeDetailRowItem(label: 'Other Allowances', value: '3.000 KWD'),
  ];

  static final List<EmployeeDetailIconLabelRow> _bankingInfoRows = [
    EmployeeDetailIconLabelRow(
      iconPath: Assets.icons.buildingSmallIcon.path,
      label: 'Bank Name',
      value: 'National Bank of Kuwait',
    ),
    EmployeeDetailIconLabelRow(
      iconPath: Assets.icons.employeeManagement.hash.path,
      label: 'Account Number',
      value: '—',
    ),
    EmployeeDetailIconLabelRow(iconPath: Assets.icons.employeeManagement.card.path, label: 'IBAN', value: '—'),
  ];

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final footerBg = isDark ? AppColors.infoBgDark : AppColors.infoBg;
    final footerBorderColor = isDark ? AppColors.infoBorderDark : AppColors.infoBorder;

    final salaryFooter = Container(
      margin: EdgeInsets.all(24.w).copyWith(top: 0.0),
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: footerBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: footerBorderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Total Monthly Salary', style: context.textTheme.titleMedium?.copyWith(color: textPrimary)),
              Text(
                '3094.000 KWD',
                style: context.textTheme.displaySmall?.copyWith(color: AppColors.primary, fontSize: 29.sp),
              ),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.infoCircleBlue.path,
                width: 16.w,
                height: 16.h,
                color: AppColors.permissionBadgeText,
              ),
              Gap(6.w),
              Expanded(
                child: Text(
                  'PIFSS Contribution (Expat 8%): 240.000 KWD',
                  style: context.textTheme.bodyMedium?.copyWith(color: AppColors.permissionBadgeText),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmployeeDetailRowSectionCard(
            title: 'Salary Components',
            titleIconAssetPath: Assets.icons.leaveManagement.dollar.path,
            rows: _salaryComponentsRows,
            footer: salaryFooter,
            isDark: isDark,
          ),
          Gap(24.h),
          EmployeeDetailIconLabelSectionCard(
            title: 'Banking Information',
            titleIconAssetPath: Assets.icons.employeeManagement.banking.path,
            rows: _bankingInfoRows,
            isDark: isDark,
            borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
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
