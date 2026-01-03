import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterpriseDropdown extends StatelessWidget {
  final String label;
  final bool isRequired;
  final int? selectedEnterpriseId;
  final List<Enterprise> enterprises;
  final bool isLoading;
  final bool readOnly;
  final ValueChanged<int?>? onChanged;
  final String? errorText;

  const EnterpriseDropdown({
    super.key,
    required this.label,
    this.isRequired = false,
    this.selectedEnterpriseId,
    required this.enterprises,
    this.isLoading = false,
    this.readOnly = false,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelFontSize = 15.1.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
              height: 24 / 15.1,
              letterSpacing: 0,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: isDark ? AppColors.errorTextDark : const Color(0xFFFB2C36)),
                    ),
                  ]
                : null,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          constraints: BoxConstraints(
            minHeight: 56, // Text height + vertical padding
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : Colors.white,
            border: Border.all(
              color: errorText != null
                  ? (isDark ? AppColors.errorTextDark : const Color(0xFFFB2C36))
                  : (isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC)),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: isLoading
              ? Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w, vertical: 9.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Loading enterprises...',
                        style: TextStyle(
                          fontSize: 15.6.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.textPlaceholderDark
                              : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                          height: 24 / 15.6,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedEnterpriseId,
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                        size: 24.sp,
                      ),
                      style: TextStyle(
                        fontSize: 15.6.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                        height: 24 / 15.6,
                        letterSpacing: 0,
                      ),
                      dropdownColor: isDark ? AppColors.inputBgDark : Colors.white,
                      hint: Text(
                        'Select enterprise',
                        style: TextStyle(
                          fontSize: 15.6.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.textPlaceholderDark
                              : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                          height: 24 / 15.6,
                          letterSpacing: 0,
                        ),
                      ),
                      items: enterprises
                          .map(
                            (enterprise) => DropdownMenuItem<int>(
                              value: enterprise.id,
                              child: Text(
                                enterprise.name,
                                style: TextStyle(
                                  fontSize: 15.6.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A),
                                  height: 24 / 15.6,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: readOnly ? null : onChanged,
                    ),
                  ),
                ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText!,
            style: TextStyle(fontSize: 12.sp, color: isDark ? AppColors.errorTextDark : const Color(0xFFFB2C36)),
          ),
        ],
      ],
    );
  }
}
