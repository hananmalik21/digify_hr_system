import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_dialog_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveDetailsLeaveTypeSelector extends StatelessWidget {
  const LeaveDetailsLeaveTypeSelector({
    super.key,
    required this.selectedLeaveType,
    required this.onTypeChanged,
    required this.isDark,
  });

  final LeaveType selectedLeaveType;
  final ValueChanged<LeaveType> onTypeChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Leave Type',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(8.h),
        Row(
          spacing: 7.w,
          children: [
            Expanded(
              child: _LeaveTypeButton(
                label: 'Annual Leave',
                type: LeaveType.annualLeave,
                isSelected: selectedLeaveType == LeaveType.annualLeave,
                isDark: isDark,
                onTap: () => onTypeChanged(LeaveType.annualLeave),
              ),
            ),
            Expanded(
              child: _LeaveTypeButton(
                label: 'Sick Leave',
                type: LeaveType.sickLeave,
                isSelected: selectedLeaveType == LeaveType.sickLeave,
                isDark: isDark,
                onTap: () => onTypeChanged(LeaveType.sickLeave),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LeaveTypeButton extends StatelessWidget {
  const _LeaveTypeButton({
    required this.label,
    required this.type,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final LeaveType type;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 42.h,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey),
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
