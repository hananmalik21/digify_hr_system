import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeekendHolidayCheckboxesSubsection extends ConsumerWidget {
  final AdvancedRules advanced;
  final bool isEditing;

  const WeekendHolidayCheckboxesSubsection({super.key, required this.advanced, required this.isEditing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.securityProfilesBackground,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: DigifyCheckbox(
              value: advanced.countWeekendsAsLeave,
              onChanged: isEditing ? (v) => draftNotifier.updateCountWeekendsAsLeave(v ?? false) : null,
              label: 'Count weekends as leave days',
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.securityProfilesBackground,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: DigifyCheckbox(
              value: advanced.countPublicHolidaysAsLeave,
              onChanged: isEditing ? (v) => draftNotifier.updateCountPublicHolidaysAsLeave(v ?? false) : null,
              label: 'Count public holidays as leave days',
            ),
          ),
        ),
      ],
    );
  }
}
