import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/review_summary_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeReviewStep extends StatelessWidget {
  const AddEmployeeReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final em = Assets.icons.employeeManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: Assets.icons.checkIconGreen.path,
          title: localizations.reviewAndConfirm,
          subtitle: localizations.reviewAndConfirmSubtitle,
        ),
        ReviewSummaryCard(
          iconPath: em.basicInfo.path,
          title: localizations.personalInformation,
          rows: [
            ReviewSummaryRow(label: localizations.reviewName, value: '—'),
            ReviewSummaryRow(label: localizations.phone, value: '—'),
            ReviewSummaryRow(label: localizations.nationality, value: '—'),
            ReviewSummaryRow(label: localizations.email, value: '—'),
            ReviewSummaryRow(label: localizations.reviewDob, value: '—'),
            ReviewSummaryRow(label: localizations.gender, value: '—'),
          ],
        ),
        ReviewSummaryCard(
          iconPath: Assets.icons.departmentsIcon.path,
          title: localizations.enterpriseStructure,
          rows: [ReviewSummaryRow(label: localizations.company, value: '—')],
        ),
        ReviewSummaryCard(
          iconPath: em.assignment.path,
          title: localizations.employmentDetails,
          rows: [
            ReviewSummaryRow(label: localizations.position, value: '—'),
            ReviewSummaryRow(label: localizations.contractType, value: '—'),
            ReviewSummaryRow(label: localizations.joinDate, value: '—'),
            ReviewSummaryRow(label: localizations.status, value: '—'),
          ],
        ),
        ReviewSummaryCard(
          iconPath: em.compensation.path,
          title: localizations.addEmployeeStepCompensation,
          rows: [
            ReviewSummaryRow(label: localizations.basicSalaryKwd, value: '0.000 KWD', rightAlign: true),
            ReviewSummaryRow(label: localizations.allowances, value: '0.000 KWD', rightAlign: true),
            ReviewSummaryRow(
              label: localizations.reviewTotal,
              value: '0.000 KWD',
              valueBold: true,
              labelBold: true,
              rightAlign: true,
              dividerBefore: true,
            ),
          ],
        ),
        ReviewSummaryCard(
          iconPath: em.banking.path,
          title: localizations.addEmployeeStepBanking,
          rows: [
            ReviewSummaryRow(label: localizations.reviewBank, value: '—'),
            ReviewSummaryRow(label: localizations.reviewAccount, value: '—'),
          ],
        ),
      ],
    );
  }
}
