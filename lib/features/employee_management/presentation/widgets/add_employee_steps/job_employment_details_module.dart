import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/grade_selection_dialog.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/job_employment_picker_field.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/job_family_selection_dialog.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/job_level_selection_dialog.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/position_selection_dialog.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/reporting_to_employee_search_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobEmploymentDetailsModule extends ConsumerWidget {
  const JobEmploymentDetailsModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;
    final jobState = ref.watch(addEmployeeJobEmploymentProvider);
    final jobNotifier = ref.read(addEmployeeJobEmploymentProvider.notifier);
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider) ?? 0;
    final contractTypeValuesAsync = ref.watch(
      emplLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: 'CONTRACT_TYPE')),
    );
    final contractTypeValues = contractTypeValuesAsync.valueOrNull ?? [];
    final contractTypeLoading = contractTypeValuesAsync.isLoading;
    final selectedContractType = _contractTypeByCode(jobState.contractTypeCode, contractTypeValues);
    final clockIcon = _prefixIcon(context, Assets.icons.clockIcon.path, isDark);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18.h,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: em.assignment.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.jobAndEmploymentDetails,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;
              final leftColumn = [
                JobEmploymentPickerField(
                  label: localizations.jobFamily,
                  isRequired: true,
                  value: jobState.selectedJobFamily?.nameEnglish,
                  hint: localizations.hintGradeLevel,
                  onTap: () async {
                    final selected = await JobFamilySelectionDialog.show(context);
                    if (selected != null && context.mounted) {
                      jobNotifier.setJobFamily(selected);
                    }
                  },
                ),
                JobEmploymentPickerField(
                  label: localizations.gradeLevel,
                  isRequired: true,
                  value: jobState.selectedGrade?.gradeLabel,
                  hint: localizations.hintGradeLevel,
                  onTap: () async {
                    final selected = await GradeSelectionDialog.show(context);
                    if (selected != null && context.mounted) {
                      jobNotifier.setGrade(selected);
                    }
                  },
                ),
                DigifySelectFieldWithLabel<EmplLookupValue>(
                  label: localizations.contractType,
                  isRequired: true,
                  hint: contractTypeLoading ? localizations.pleaseWait : localizations.hintContractType,
                  items: contractTypeValues,
                  itemLabelBuilder: (v) => v.meaningEn,
                  value: selectedContractType,
                  onChanged: contractTypeLoading ? null : (v) => jobNotifier.setContractTypeCode(v?.lookupCode),
                ),
                ReportingToEmployeeSearchField(
                  label: localizations.reportingTo,
                  hintText: localizations.hintReportingTo,
                  selectedEmployee: jobState.selectedReportingTo,
                  onEmployeeSelected: jobNotifier.setReportingTo,
                ),
                DigifySelectFieldWithLabel<String>(
                  label: localizations.employmentStatus,
                  isRequired: true,
                  hint: localizations.hintEmploymentStatus,
                  items: const ['ACTIVE', 'INACTIVE'],
                  itemLabelBuilder: (code) => code == 'ACTIVE' ? 'Active' : 'Inactive',
                  value: jobState.employmentStatusCode,
                  onChanged: (v) => jobNotifier.setEmploymentStatusCode(v),
                ),
              ];
              final rightColumn = [
                JobEmploymentPickerField(
                  label: localizations.position,
                  isRequired: true,
                  value: jobState.selectedPosition?.titleEnglish,
                  hint: localizations.hintGradeLevel,
                  onTap: () async {
                    final selected = await PositionSelectionDialog.show(context);
                    if (selected != null && context.mounted) {
                      jobNotifier.setPosition(selected);
                    }
                  },
                ),
                JobEmploymentPickerField(
                  label: localizations.jobLevels,
                  isRequired: true,
                  value: jobState.selectedJobLevel?.nameEn,
                  hint: localizations.hintGradeLevel,
                  onTap: () async {
                    final selected = await JobLevelSelectionDialog.show(context);
                    if (selected != null && context.mounted) {
                      jobNotifier.setJobLevel(selected);
                    }
                  },
                ),
                DigifyDateField(
                  label: localizations.enterpriseHireDate,
                  isRequired: true,
                  hintText: localizations.hintEnterpriseHireDate,
                  initialDate: jobState.enterpriseHireDate,
                  onDateSelected: (d) => jobNotifier.setEnterpriseHireDate(d),
                ),
                DigifyTextField(
                  labelText: localizations.probationPeriodDays,
                  keyboardType: TextInputType.number,
                  prefixIcon: clockIcon,
                  hintText: localizations.hintProbationPeriodDays,
                  isRequired: true,
                  initialValue: jobState.probationDays?.toString(),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    jobNotifier.setProbationDays(n);
                  },
                ),
              ];
              if (useTwoColumns) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 12.h, children: leftColumn),
                    ),
                    Gap(14.w),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 12.h, children: rightColumn),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [...leftColumn, ...rightColumn],
              );
            },
          ),
        ],
      ),
    );
  }

  static EmplLookupValue? _contractTypeByCode(String? code, List<EmplLookupValue> values) {
    if (code == null || code.trim().isEmpty) return null;
    try {
      return values.firstWhere((v) => v.lookupCode == code.trim());
    } catch (_) {
      return null;
    }
  }

  static Widget _prefixIcon(BuildContext context, String path, bool isDark) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
  }
}
