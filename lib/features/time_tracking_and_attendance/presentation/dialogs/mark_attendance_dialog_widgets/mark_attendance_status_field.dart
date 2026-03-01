import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_text_theme.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/attendance/mark_attendance_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MarkAttendanceStatusField extends StatelessWidget {
  final MarkAttendanceFormState state;
  final MarkAttendanceFormNotifier notifier;
  final TextEditingController controller;
  final bool enabled;
  final bool isStatusPrefilled;

  const MarkAttendanceStatusField({
    super.key,
    required this.state,
    required this.notifier,
    required this.controller,
    this.enabled = true,
    this.isStatusPrefilled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Status',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: ' *',
                style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Gap(6.h),
        DigifyTextField(
          controller: controller,
          readOnly: isStatusPrefilled || !enabled,
          fillColor: (isStatusPrefilled || !enabled)
              ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
              : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground),
          filled: true,
          hintText: isStatusPrefilled ? null : 'e.g. Present, Late, Absent',
          onChanged: (isStatusPrefilled || !enabled)
              ? null
              : (value) {
                  notifier.setStatus(value.trim().isEmpty ? null : Attendance.parseStatus(value));
                },
        ),
      ],
    );
  }
}
