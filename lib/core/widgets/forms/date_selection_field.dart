import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DateSelectionField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final DateTime? date;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;

  const DateSelectionField({
    super.key,
    required this.label,
    required this.date,
    required this.onDateSelected,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(6.h),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null ? DateFormat('dd/MM/yyyy').format(date!) : (hintText ?? 'Select Date'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: date != null ? AppColors.textPrimary : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DigifyAsset(
                  assetPath: Assets.icons.leaveManagement.emptyLeave.path,
                  color: AppColors.textSecondary,
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }
}
