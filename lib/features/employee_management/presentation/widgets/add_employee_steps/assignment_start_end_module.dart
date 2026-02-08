import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AssignmentStartEndModule extends ConsumerWidget {
  const AssignmentStartEndModule({super.key});

  static final DateTime _firstDate = DateTime(2000);
  static final DateTime _lastDate = DateTime(2100, 12, 31);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(addEmployeeAssignmentProvider);
    final notifier = ref.read(addEmployeeAssignmentProvider.notifier);
    final calendarPath = Assets.icons.leaveManagementMainIcon.path;
    final em = Assets.icons.employeeManagement;

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
                localizations.assignmentPeriod,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyDateField(
                  label: localizations.assignmentStartDate,
                  isRequired: true,
                  hintText: localizations.hintSelectDate,
                  calendarIconPath: calendarPath,
                  initialDate: state.asgStart,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  onDateSelected: (d) => notifier.setAsgStart(d),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyDateField(
                  label: localizations.assignmentEndDate,
                  isRequired: true,
                  hintText: localizations.hintSelectDate,
                  calendarIconPath: calendarPath,
                  initialDate: state.asgEnd,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  onDateSelected: (d) => notifier.setAsgEnd(d),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
