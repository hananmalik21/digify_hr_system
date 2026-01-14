import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveDetailsStep extends StatefulWidget {
  final VoidCallback onStepComplete;

  const LeaveDetailsStep({
    super.key,
    required this.onStepComplete,
  });

  @override
  State<LeaveDetailsStep> createState() => _LeaveDetailsStepState();
}

class _LeaveDetailsStepState extends State<LeaveDetailsStep> {
  final _employeeController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String? _selectedLeaveType;
  String? _startTime;
  String? _endTime;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _employeeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: isDark ? AppColors.cardBackgroundDark : Colors.white,
              onSurface: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(top: 32.h, start: 0, end: 0, bottom: 0),
      child: SizedBox(
        width: 832.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guidelines Banner
            Container(
              padding: EdgeInsets.all(17.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
                ),
                border: Border.all(color: const Color(0xFFBEDBFF), width: 1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: DigifyAsset(
                      assetPath: Assets.icons.infoIconGreen.path,
                      width: 20,
                      height: 20,
                      color: const Color(0xFF1C398E),
                    ),
                  ),
                  Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          localizations.leaveRequestGuidelines,
                          style: TextStyle(
                            fontSize: 13.7.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1C398E),
                            height: 20 / 13.7,
                          ),
                        ),
                        Gap(4.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ${localizations.submitRequests3DaysAdvance}',
                              style: TextStyle(
                                fontSize: 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1447E6),
                                height: 16 / 11.8,
                              ),
                            ),
                            Text(
                              '• ${localizations.sickLeaveRequiresCertificate}',
                              style: TextStyle(
                                fontSize: 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1447E6),
                                height: 16 / 11.8,
                              ),
                            ),
                            Text(
                              '• ${localizations.ensureWorkHandover}',
                              style: TextStyle(
                                fontSize: 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1447E6),
                                height: 16 / 11.8,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(24.h),
          // Employee Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${localizations.employee} ',
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                        height: 20 / 13.6,
                      ),
                    ),
                    const TextSpan(
                      text: '*',
                      style: TextStyle(color: Color(0xFFFB2C36)),
                    ),
                  ],
                ),
              ),
              Gap(8.h),
              Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD1D5DC), width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.searchIcon.path,
                      width: 18,
                      height: 18,
                      color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                    ),
                    Gap(8.w),
                    Expanded(
                      child: TextField(
                        controller: _employeeController,
                        style: TextStyle(
                          fontSize: 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: localizations.typeToSearchEmployees,
                          hintStyle: TextStyle(
                            fontSize: 15.3.sp,
                            color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsetsDirectional.only(top: 2.5.h, bottom: 2.5.h),
                        ),
                      ),
                    ),
                    Gap(8.w),
                    DigifyAsset(
                      assetPath: Assets.icons.workforce.chevronDown.path,
                      width: 18,
                      height: 18,
                      color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(24.h),
          // Leave Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${localizations.leaveType} *',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                  height: 20 / 13.5,
                ),
              ),
              Gap(8.h),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(localizations.leaveType),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Annual Leave (Paid Vacation)'),
                            onTap: () {
                              setState(() {
                                _selectedLeaveType = 'Annual Leave (Paid Vacation)';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Sick Leave'),
                            onTap: () {
                              setState(() {
                                _selectedLeaveType = 'Sick Leave';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Maternity Leave'),
                            onTap: () {
                              setState(() {
                                _selectedLeaveType = 'Maternity Leave';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Emergency Leave'),
                            onTap: () {
                              setState(() {
                                _selectedLeaveType = 'Emergency Leave';
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsetsDirectional.only(start: 21.w, end: 33.w, top: 13.h, bottom: 13.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD1D5DC), width: 1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedLeaveType ?? localizations.leaveType,
                          style: TextStyle(
                            fontSize: 15.1.sp,
                            fontWeight: FontWeight.w400,
                            color: _selectedLeaveType == null
                                ? const Color(0xFF0A0A0A).withValues(alpha: 0.5)
                                : (isDark ? AppColors.textPrimaryDark : const Color(0xFF0A0A0A)),
                            height: 19 / 15.1,
                          ),
                        ),
                      ),
                      DigifyAsset(
                        assetPath: Assets.icons.workforce.chevronDown.path,
                        width: 18,
                        height: 18,
                        color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_selectedLeaveType == 'Annual Leave (Paid Vacation)') ...[
            Gap(12.h),
            Container(
              padding: EdgeInsets.all(13.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                border: Border.all(color: const Color(0xFFBEDBFF), width: 1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 2.h),
                    child: DigifyAsset(
                      assetPath: Assets.icons.infoIconGreen.path,
                      width: 16,
                      height: 16,
                      color: const Color(0xFF193CB8),
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.regularPaidVacationLeave,
                          style: TextStyle(
                            fontSize: 15.4.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF193CB8),
                            height: 24 / 15.4,
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          localizations.maximum30DaysPerYear,
                          style: TextStyle(
                            fontSize: 15.3.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1447E6),
                            height: 24 / 15.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          Gap(24.h),
          // Date Fields
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${localizations.startDate} *',
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                        height: 20 / 13.6,
                      ),
                    ),
                    Gap(8.h),
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w, vertical: 13.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD1D5DC),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _startDateController.text.isEmpty
                                    ? 'dd/mm/yyyy'
                                    : _startDateController.text,
                                style: TextStyle(
                                  fontSize: 15.4.sp,
                                  fontWeight: FontWeight.w400,
                                  color: _startDateController.text.isEmpty
                                      ? const Color(0xFF0A0A0A).withValues(alpha: 0.5)
                                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                                  height: 24 / 15.4,
                                ),
                              ),
                            ),
                            Gap(8.w),
                            DigifyAsset(
                              assetPath: Assets.icons.calendarIcon.path,
                              width: 20,
                              height: 20,
                              color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(8.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.startTime,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                            height: 16 / 12,
                          ),
                        ),
                        Gap(4.h),
                        _buildTimeDropdown(
                          value: _startTime ?? localizations.fullDay,
                          onChanged: (value) {
                            setState(() {
                              _startTime = value;
                            });
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${localizations.endDate} *',
                      style: TextStyle(
                        fontSize: 13.7.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                        height: 20 / 13.7,
                      ),
                    ),
                    Gap(8.h),
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w, vertical: 13.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD1D5DC),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _endDateController.text.isEmpty
                                    ? 'dd/mm/yyyy'
                                    : _endDateController.text,
                                style: TextStyle(
                                  fontSize: 15.4.sp,
                                  fontWeight: FontWeight.w400,
                                  color: _endDateController.text.isEmpty
                                      ? const Color(0xFF0A0A0A).withValues(alpha: 0.5)
                                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                                  height: 24 / 15.4,
                                ),
                              ),
                            ),
                            Gap(8.w),
                            DigifyAsset(
                              assetPath: Assets.icons.calendarIcon.path,
                              width: 20,
                              height: 20,
                              color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(8.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.endTime,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                            height: 16 / 12,
                          ),
                        ),
                        Gap(4.h),
                        _buildTimeDropdown(
                          value: _endTime ?? localizations.fullDay,
                          onChanged: (value) {
                            setState(() {
                              _endTime = value;
                            });
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildTimeDropdown({
    required String value,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        final localizations = AppLocalizations.of(context)!;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localizations.startTime),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(localizations.fullDay),
                  onTap: () {
                    onChanged(localizations.fullDay);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('${localizations.startTime} - Morning'),
                  onTap: () {
                    onChanged('${localizations.startTime} - Morning');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('${localizations.endTime} - Afternoon'),
                  onTap: () {
                    onChanged('${localizations.endTime} - Afternoon');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 17.w, end: 29.w, top: 9.h, bottom: 9.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFD1D5DC),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13.8.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  height: 16.5 / 13.8,
                ),
              ),
            ),
            DigifyAsset(
              assetPath: Assets.icons.workforce.chevronDown.path,
              width: 18,
              height: 18,
              color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}
