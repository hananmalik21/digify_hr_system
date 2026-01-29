import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmploymentTypeSubsection extends ConsumerWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;

  const EmploymentTypeSubsection({super.key, required this.eligibility, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = ref.watch(absLookupValuesForCodeProvider(AbsLookupCode.empType));
    final selectedCode = eligibility.employmentTypeCode;
    final mid = values.isEmpty ? 0 : (values.length / 2).ceil();
    final first = values.sublist(0, mid);
    final second = values.isEmpty ? values : values.sublist(mid);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          EligibilitySubsectionHeader(
            title: 'Employment Type',
            iconPath: Assets.icons.workforce.totalPosition.path,
            isDark: isDark,
          ),
          Gap(12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < first.length; i++) ...[
                      if (i > 0) Gap(12.h),
                      DigifyCheckbox(
                        value: selectedCode != null && first[i].lookupValueCode == selectedCode,
                        onChanged: null,
                        label: first[i].lookupValueName,
                      ),
                    ],
                  ],
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < second.length; i++) ...[
                      if (i > 0) Gap(12.h),
                      DigifyCheckbox(
                        value: selectedCode != null && second[i].lookupValueCode == selectedCode,
                        onChanged: null,
                        label: second[i].lookupValueName,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
