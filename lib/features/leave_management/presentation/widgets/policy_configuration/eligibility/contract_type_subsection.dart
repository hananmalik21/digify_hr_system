import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ContractTypeSubsection extends ConsumerWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;
  final bool isEditing;

  const ContractTypeSubsection({super.key, required this.eligibility, required this.isDark, required this.isEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = ref.watch(absLookupValuesForCodeProvider(AbsLookupCode.contractType));
    final selectedCode = eligibility.contractTypeCode;
    final draftNotifier = ref.read(policyDraftProvider.notifier);

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
            title: 'Contract Type',
            iconPath: Assets.icons.leaveManagement.forfeitReports.path,
            isDark: isDark,
          ),
          Gap(12.h),
          Row(
            children: [
              for (int i = 0; i < values.length; i++) ...[
                if (i > 0) Gap(16.w),
                Flexible(
                  child: DigifyCheckbox(
                    value: selectedCode != null && values[i].lookupValueCode == selectedCode,
                    onChanged: isEditing
                        ? (checked) =>
                              draftNotifier.updateContractTypeCode(checked == true ? values[i].lookupValueCode : null)
                        : null,
                    label: values[i].lookupValueName,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
