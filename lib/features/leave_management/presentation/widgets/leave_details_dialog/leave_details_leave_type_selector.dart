import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/api_leave_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveDetailsLeaveTypeSelector extends StatelessWidget {
  const LeaveDetailsLeaveTypeSelector({
    super.key,
    required this.leaveTypes,
    required this.selectedLeaveTypeId,
    required this.onTypeChanged,
    required this.isDark,
    this.isLoading = false,
  });

  final List<ApiLeaveType> leaveTypes;
  final int? selectedLeaveTypeId;
  final ValueChanged<ApiLeaveType> onTypeChanged;
  final bool isDark;
  final bool isLoading;

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
        if (isLoading)
          SizedBox(
            height: 42.h,
            child: const Center(child: AppLoadingIndicator(type: LoadingType.circle, size: 24)),
          )
        else if (leaveTypes.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No leave types available',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          )
        else
          Row(
            spacing: 7.w,
            children: [
              for (final leaveType in leaveTypes)
                Expanded(
                  child: _LeaveTypeButton(
                    label: leaveType.displayName,
                    isSelected: selectedLeaveTypeId == leaveType.id,
                    isDark: isDark,
                    onTap: () => onTypeChanged(leaveType),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _LeaveTypeButton extends StatelessWidget {
  const _LeaveTypeButton({required this.label, required this.isSelected, required this.isDark, required this.onTap});

  final String label;
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
