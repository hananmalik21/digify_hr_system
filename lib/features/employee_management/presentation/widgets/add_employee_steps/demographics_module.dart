import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_demographics_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/employee_abs_lookups_provider.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DemographicsModule extends ConsumerWidget {
  const DemographicsModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;
    final demographics = ref.watch(addEmployeeDemographicsProvider);
    final demographicsNotifier = ref.read(addEmployeeDemographicsProvider.notifier);

    final genderValues = ref.watch(employeeAbsLookupValuesForCodeProvider(AbsLookupCode.gender));
    final maritalValues = ref.watch(employeeAbsLookupValuesForCodeProvider(AbsLookupCode.maritalStatus));
    final nationalityValues = ref.watch(employeeAbsLookupValuesForCodeProvider(AbsLookupCode.nationality));
    final religionValues = ref.watch(employeeAbsLookupValuesForCodeProvider(AbsLookupCode.religion));

    final lookupValuesAsync = ref.watch(employeeAbsLookupValuesAsyncProvider);
    final isLoadingLookups = lookupValuesAsync.isLoading;

    final selectedGender = _valueByCode(demographics.genderCode, genderValues);
    final selectedMarital = _valueByCode(demographics.maritalStatusCode, maritalValues);
    final selectedNationality = _valueByCode(demographics.nationality, nationalityValues);
    final selectedReligion = _valueByCode(demographics.religionCode, religionValues);

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
                assetPath: em.demographics.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.demographics,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;

              final genderField = DigifySelectFieldWithLabel<AbsLookupValue>(
                label: localizations.gender,
                isRequired: true,
                hint: localizations.hintGender,
                items: genderValues,
                itemLabelBuilder: (v) => v.lookupValueName,
                value: selectedGender,
                onChanged: isLoadingLookups ? null : (v) => demographicsNotifier.setGenderCode(v?.lookupValueCode),
              );

              final nationalityField = DigifySelectFieldWithLabel<AbsLookupValue>(
                label: localizations.nationality,
                isRequired: true,
                hint: localizations.hintNationality,
                items: nationalityValues,
                itemLabelBuilder: (v) => v.lookupValueName,
                value: selectedNationality,
                onChanged: isLoadingLookups ? null : (v) => demographicsNotifier.setNationality(v?.lookupValueCode),
              );

              final maritalField = DigifySelectFieldWithLabel<AbsLookupValue>(
                label: localizations.maritalStatus,
                hint: localizations.hintMaritalStatus,
                items: maritalValues,
                itemLabelBuilder: (v) => v.lookupValueName,
                value: selectedMarital,
                onChanged: isLoadingLookups
                    ? null
                    : (v) => demographicsNotifier.setMaritalStatusCode(v?.lookupValueCode),
              );

              final religionField = DigifySelectFieldWithLabel<AbsLookupValue>(
                label: localizations.religion,
                hint: localizations.hintReligion,
                items: religionValues,
                itemLabelBuilder: (v) => v.lookupValueName,
                value: selectedReligion,
                onChanged: isLoadingLookups ? null : (v) => demographicsNotifier.setReligionCode(v?.lookupValueCode),
              );

              final row1 = [genderField, nationalityField];
              final row2 = [maritalField, religionField];

              if (useTwoColumns) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: row1[0]),
                        Gap(14.w),
                        Expanded(child: row1[1]),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: row2[0]),
                        Gap(14.w),
                        Expanded(child: row2[1]),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [row1[0], row1[1], row2[0], row2[1]],
              );
            },
          ),
        ],
      ),
    );
  }

  static AbsLookupValue? _valueByCode(String? code, List<AbsLookupValue> values) {
    if (code == null || code.isEmpty) return null;
    try {
      return values.firstWhere((v) => v.lookupValueCode == code);
    } catch (_) {
      return null;
    }
  }
}
