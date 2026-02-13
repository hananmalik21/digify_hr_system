import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/date_selection_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/widgets/assets/digify_asset.dart';

class NewTimesheetDialog extends StatefulWidget {
  const NewTimesheetDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, barrierDismissible: true, builder: (context) => const NewTimesheetDialog());
  }

  @override
  State<NewTimesheetDialog> createState() => _NewTimesheetDialogState();
}

class _NewTimesheetDialogState extends State<NewTimesheetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _employeeSearchController = TextEditingController();
  final _employeeNameController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _positionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<TextEditingController> _taskControllers = [];
  final List<TextEditingController> _regularHoursControllers = [];
  final List<TextEditingController> _otHoursControllers = [];

  DateTime? _weekStartDate;
  DateTime? _weekEndDate;

  @override
  void initState() {
    super.initState();
    // Initialize with current week
    final now = DateTime.now();
    _weekStartDate = _getWeekStart(now);
    _weekEndDate = _getWeekEnd(now);

    // Initialize controllers for 7 days
    for (int i = 0; i < 7; i++) {
      _taskControllers.add(TextEditingController());
      _regularHoursControllers.add(TextEditingController(text: '0'));
      _otHoursControllers.add(TextEditingController(text: '0'));
    }
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  DateTime _getWeekEnd(DateTime date) {
    final weekday = date.weekday;
    return date.add(Duration(days: 7 - weekday));
  }

  @override
  void dispose() {
    _employeeSearchController.dispose();
    _employeeNameController.dispose();
    _projectNameController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _descriptionController.dispose();
    for (var controller in _taskControllers) {
      controller.dispose();
    }
    for (var controller in _regularHoursControllers) {
      controller.dispose();
    }
    for (var controller in _otHoursControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<DateTime> _getWeekDates() {
    if (_weekStartDate == null) return [];
    final dates = <DateTime>[];
    for (int i = 0; i < 7; i++) {
      dates.add(_weekStartDate!.add(Duration(days: i)));
    }
    return dates;
  }

  double _calculateTotalRegularHours() {
    double total = 0;
    for (var controller in _regularHoursControllers) {
      total += double.tryParse(controller.text) ?? 0;
    }
    return total;
  }

  double _calculateTotalOTHours() {
    double total = 0;
    for (var controller in _otHoursControllers) {
      total += double.tryParse(controller.text) ?? 0;
    }
    return total;
  }

  void _updateWeekEndDate(DateTime startDate) {
    setState(() {
      _weekStartDate = startDate;
      _weekEndDate = startDate.add(const Duration(days: 6));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final weekDates = _getWeekDates();
    final dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final totalRegularHours = _calculateTotalRegularHours();
    final totalOTHours = _calculateTotalOTHours();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 14.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 700.w, maxHeight: MediaQuery.of(context).size.height * 0.9),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 25, offset: const Offset(0, 12))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.isMobile ? 20.w : 32.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form Fields Section
                        _buildFormFields(context, isDark),
                        Gap(24.h),
                        // Date Selection
                        _buildDateSelection(context, isDark),
                        Gap(24.h),
                        // Daily Time Entries Table
                        _buildDailyTimeEntriesTable(context, isDark, weekDates, dayNames, totalRegularHours, totalOTHours),
                      ],
                    ),
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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DigifyAsset(assetPath: Assets.icons.viewIconBlueFigma.path, width: 18.w, height: 18.h, color: Colors.white),
          Gap(4.w),
          Expanded(
            child: Text(
              'New Weekly Timesheet',
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size(32.w, 32.h)),
            icon: Icon(Icons.cancel_outlined, size: 20.r, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Employee - Full width
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Select Employee',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.error, fontFamily: 'Inter'),
                  ),
                ],
              ),
            ),
            Gap(6.h),
            DigifyTextField(
              hintText: 'Type to search employees...',
              controller: _employeeSearchController,
              prefixIcon: Icon(Icons.search, size: 20.r, color: AppColors.textSecondary),
              suffixIcon: Icon(Icons.arrow_drop_down, size: 24.r, color: AppColors.textSecondary),
              fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
              filled: true,
              onChanged: (value) {
                // TODO: Implement employee search
              },
            ),
          ],
        ),
        Gap(16.h),
        // Employee Name and Project Name - One row on desktop, stacked on mobile
        context.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employee Name',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                      ),
                      Gap(6.h),
                      DigifyTextField(hintText: 'Employee Name', controller: _employeeNameController, fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg, filled: true),
                    ],
                  ),
                  Gap(16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Name',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                      ),
                      Gap(6.h),
                      DigifyTextField(hintText: 'Project Name', controller: _projectNameController, fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg, filled: true),
                    ],
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Employee Name',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                        ),
                        Gap(6.h),
                        DigifyTextField(hintText: 'Employee Name', controller: _employeeNameController, fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg, filled: true),
                      ],
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project Name',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                        ),
                        Gap(6.h),
                        DigifyTextField(hintText: 'Project Name', controller: _projectNameController, fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg, filled: true),
                      ],
                    ),
                  ),
                ],
              ),
        Gap(16.h),
        // Position and Department - One row on desktop, stacked on mobile
        context.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Position',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                      ),
                      Gap(6.h),
                      DigifyTextField(hintText: 'Position', controller: _positionController, fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg, filled: true),
                    ],
                  ),
                  Gap(16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Department',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                      ),
                      Gap(6.h),
                      DigifyTextField(
                        hintText: 'Department',
                        controller: _departmentController,
                        suffixIcon: Icon(Icons.arrow_drop_down, size: 24.r, color: AppColors.textSecondary),
                        fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                        filled: true,
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Position',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                        ),
                        Gap(6.h),
                        DigifyTextField(hintText: 'Position', controller: _positionController, fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg, filled: true),
                      ],
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Department',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
                        ),
                        Gap(6.h),
                        DigifyTextField(
                          hintText: 'Department',
                          controller: _departmentController,
                          suffixIcon: Icon(Icons.arrow_drop_down, size: 24.r, color: AppColors.textSecondary),
                          fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                          filled: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        Gap(16.h),
        // Description - Full width
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? context.themeTextPrimary : AppColors.inputLabel, fontFamily: 'Inter'),
            ),
            Gap(6.h),
            DigifyTextField(hintText: 'Write...', controller: _descriptionController, maxLines: 3, fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg, filled: true),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelection(BuildContext context, bool isDark) {
    return context.isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateSelectionField(
                label: 'Week Starting',
                date: _weekStartDate,
                onDateSelected: _updateWeekEndDate,
                isRequired: true,
                labelIconPath: Assets.icons.attendance.emptyCalander.path,
              ),
              Gap(16.h),
              DateSelectionField(
                label: 'Week Ending',
                date: _weekEndDate,
                onDateSelected: (date) {
                  setState(() {
                    _weekEndDate = date;
                    _weekStartDate = date.subtract(const Duration(days: 6));
                  });
                },
                labelIconPath: Assets.icons.attendance.emptyCalander.path,
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: DateSelectionField(
                  label: 'Week Starting',
                  date: _weekStartDate,
                  onDateSelected: _updateWeekEndDate,
                  isRequired: true,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DateSelectionField(
                  label: 'Week Ending',
                  date: _weekEndDate,
                  onDateSelected: (date) {
                    setState(() {
                      _weekEndDate = date;
                      _weekStartDate = date.subtract(const Duration(days: 6));
                    });
                  },

                ),
              ),
            ],
          );
  }

  Widget _buildDailyTimeEntriesTable(BuildContext context, bool isDark, List<DateTime> weekDates, List<String> dayNames, double totalRegularHours, double totalOTHours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Daily Time Entries',
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle),
            ),
            Gap(4.w),
            Text(
              '*',
              style: TextStyle(color: AppColors.error, fontSize: 16.sp),
            ),
          ],
        ),
        Gap(16.h),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
          ),
          child: context.isMobile
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 600.w),
                    child: _buildTableContent(context, isDark, weekDates, dayNames, totalRegularHours, totalOTHours),
                  ),
                )
              : _buildTableContent(context, isDark, weekDates, dayNames, totalRegularHours, totalOTHours),
        ),
      ],
    );
  }

  Widget _buildTableContent(BuildContext context, bool isDark, List<DateTime> weekDates, List<String> dayNames, double totalRegularHours, double totalOTHours) {
    return Column(
      children: [
        // Table Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text('Day', style: _getHeaderStyle(context, isDark))),
              Gap(16.w),
              Expanded(flex: 2, child: Text('Date', style: _getHeaderStyle(context, isDark))),
              Gap(16.w),
              Expanded(flex: 3, child: Text('Project/Task', style: _getHeaderStyle(context, isDark))),
              Gap(16.w),
              Expanded(flex: 2, child: Text('Regular Hrs', style: _getHeaderStyle(context, isDark))),
              Gap(16.w),
              Expanded(flex: 2, child: Text('OT Hrs', style: _getHeaderStyle(context, isDark))),
            ],
          ),
        ),
        // Table Rows
        ...List.generate(7, (index) {
                final date = weekDates.isNotEmpty ? weekDates[index] : DateTime.now().add(Duration(days: index));
                final dayName = dayNames[index];
                final isRestDay = index >= 5; // Friday and Saturday

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: index < 6 ? 1 : 0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          isRestDay ? '$dayName (Rest)' : dayName,
                          style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, fontSize: 14.sp),
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        flex: 2,
                        child: Text(
                          DateFormat('MMM d').format(date),
                          style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, fontSize: 14.sp),
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        flex: 3,
                        child: DigifyTextField(
                          hintText: 'Enter task...',
                          controller: _taskControllers[index],
                          fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                          filled: true,
                          enabled: !isRestDay,
                          border: 4.r,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        flex: 2,
                        child: DigifyTextField(
                          hintText: '0',
                          controller: _regularHoursControllers[index],
                          fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                          filled: true,
                          enabled: !isRestDay,
                          border: 4.r,
                          keyboardType: TextInputType.number,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      Gap(16.w),
                      Expanded(
                        flex: 2,
                        child: DigifyTextField(
                          hintText: '0',
                          controller: _otHoursControllers[index],
                          fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
                          filled: true,
                          enabled: !isRestDay,
                          border: 4.r,
                          keyboardType: TextInputType.number,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        // Weekly Total Row
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r)),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text('Weekly Total', style: _getHeaderStyle(context, isDark))),
              Gap(16.w),
              Expanded(flex: 2, child: SizedBox()), // Spacer for Date column
              Gap(16.w),
              Expanded(flex: 3, child: SizedBox()), // Spacer for Project/Task column
              Gap(16.w),
              Expanded(flex: 2, child: Text('${totalRegularHours.toInt()}h', style: _getHeaderStyle(context, isDark))),
              Gap(16.w),
              Expanded(flex: 2, child: Text('${totalOTHours.toInt()}h', style: _getHeaderStyle(context, isDark))),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle? _getHeaderStyle(BuildContext context, bool isDark) {
    return context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153));
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    final isMobile = context.isMobile;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
      ),
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                  type: AppButtonType.outline,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textSecondary,
                  height: 40.h,
                  borderRadius: BorderRadius.circular(7.0),
                  fontSize: 14.sp,
                  width: double.infinity,
                ),
                Gap(12.h),
                AppButton(
                  label: 'Save as Draft',
                  onPressed: () {
                    // TODO: Implement save as draft
                    Navigator.of(context).pop();
                  },
                  icon: Icons.description_outlined,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  type: AppButtonType.outline,

                  height: 40.h,
                  borderRadius: BorderRadius.circular(7.0),
                  fontSize: 14.sp,
                  width: double.infinity,
                ),
                Gap(12.h),
                AppButton(
                  label: 'Submit for Approval',
                  onPressed: () {
                    final formState = _formKey.currentState;
                    if (formState != null && formState.validate()) {
                      // TODO: Implement submit for approval
                      Navigator.of(context).pop();
                    }
                  },
                  type: AppButtonType.primary,
                  icon: Icons.send_outlined,
                  height: 40.h,
                  borderRadius: BorderRadius.circular(7.0),
                  fontSize: 14.sp,
                  width: double.infinity,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                  type: AppButtonType.outline,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textSecondary,
                  height: 40.h,
                  borderRadius: BorderRadius.circular(7.0),
                  fontSize: 14.sp,
                ),
                Gap(12.w),
                AppButton(
                  label: 'Save as Draft',
                  onPressed: () {
                    // TODO: Implement save as draft
                    Navigator.of(context).pop();
                  },
                  type: AppButtonType.outline,
                  icon: Icons.description_outlined,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  height: 40.h,
                  borderRadius: BorderRadius.circular(7.0),
                  fontSize: 14.sp,
                ),
                Gap(12.w),
                AppButton(
                  label: 'Submit for Approval',
                  onPressed: () {
                    final formState = _formKey.currentState;
                    if (formState != null && formState.validate()) {
                      // TODO: Implement submit for approval
                      Navigator.of(context).pop();
                    }
                  },
                  type: AppButtonType.primary,
                  icon: Icons.send_outlined,
                  height: 40.h,
                  borderRadius: BorderRadius.circular(7.0),
                  fontSize: 14.sp,
                ),
              ],
            ),
    );
  }
}
