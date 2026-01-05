import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/data/custom_status_cell.dart';
import 'package:digify_hr_system/features/time_management/domain/models/schedule_assignment.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class ViewScheduleAssignmentDialog extends StatelessWidget {
  final ScheduleAssignment assignment;

  const ViewScheduleAssignmentDialog({super.key, required this.assignment});

  static Future<void> show(BuildContext context, ScheduleAssignment assignment) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ViewScheduleAssignmentDialog(assignment: assignment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final assignmentLevel = assignment.assignmentLevel.toLowerCase() == 'department'
        ? AssignmentLevel.department
        : AssignmentLevel.employee;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 768.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 25, offset: const Offset(0, 12)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, isDark),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAssignedEntitySection(context, isDark, assignmentLevel),
                      SizedBox(height: 24.h),
                      _buildDetailsSection(context, isDark),
                      SizedBox(height: 24.h),
                      _buildInfoBox(context, isDark),
                    ],
                  ),
                ),
              ),
              _buildFooter(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.all(24.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          Text(
            'Schedule Assignment Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: 'Inter',
              fontSize: 15.6.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
              height: 24 / 15.6,
              letterSpacing: 0,
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: DigifyAsset(
                  assetPath: Assets.icons.closeIcon.path,
                  width: 24,
                  height: 24,
                  color: AppColors.dialogCloseIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedEntitySection(BuildContext context, bool isDark, AssignmentLevel level) {
    final icon = level == AssignmentLevel.department
        ? Assets.icons.departmentIcon.path
        : Assets.icons.addEmployeeIcon.path;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: DigifyAsset(
                assetPath: icon,
                width: 32,
                height: 32,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  assignment.assignedToName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    height: 28 / 18,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  assignment.assignedToCode,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    height: 24 / 15,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    level == AssignmentLevel.department ? 'department' : 'employee',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                      height: 20 / 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDetailCard(
          context,
          isDark,
          label: 'Assigned Schedule',
          value: assignment.workSchedule.scheduleNameEn,
          subtitle: assignment.workSchedule.scheduleCode,
          fullWidth: true,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Effective Start Date',
                value: assignment.formattedStartDate,
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Effective End Date',
                value: assignment.formattedEndDate.isEmpty ? 'N/A' : assignment.formattedEndDate,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Status',
                value: '',
                customWidget: CustomStatusCell(
                  isActive: assignment.isActive,
                  activeLabel: 'ACTIVE',
                  inactiveLabel: 'INACTIVE',
                ),
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Assignment ID',
                value: 'SA-${assignment.scheduleAssignmentId.toString().padLeft(3, '0')}',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(context, isDark, label: 'Assigned By', value: assignment.assignedByName),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Assigned Date',
                value: assignment.creationDate.toString().substring(0, 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    bool isDark, {
    required String label,
    String? value,
    String? subtitle,
    Widget? customWidget,
    bool fullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              height: 20 / 13.8,
            ),
          ),
          SizedBox(height: 8.h),
          if (customWidget != null)
            customWidget
          else ...[
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                height: 24 / 15,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                  height: 20 / 13,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, bool isDark) {
    final statusText = assignment.isActive ? 'Active Assignment' : 'Inactive Assignment';
    final descriptionText = assignment.isActive
        ? 'This schedule assignment is currently active and will remain in effect until ${assignment.formattedEndDate.isEmpty ? 'indefinitely' : assignment.formattedEndDate}.'
        : 'This schedule assignment is currently inactive.';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE0F2FE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(assetPath: Assets.icons.infoIconGreen.path, width: 20, height: 20, color: AppColors.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  descriptionText,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 24.w, end: 24.w, top: 20.h, bottom: 24.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            label: 'Close',
            type: AppButtonType.outline,
            onPressed: () => Navigator.of(context).pop(),
            width: null,
          ),
          SizedBox(width: 12.w),
          AppButton(
            label: 'Edit Assignment',
            type: AppButtonType.primary,
            onPressed: () {
              Navigator.of(context).pop();
            },
            width: null,
            svgPath: Assets.icons.editIcon.path,
          ),
        ],
      ),
    );
  }
}
