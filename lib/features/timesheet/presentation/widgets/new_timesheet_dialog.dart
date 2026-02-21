import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
// import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_theme.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/assets/digify_asset.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/forms/date_selection_field.dart';
import '../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../gen/assets.gen.dart';
import '../providers/new_timesheet_provider.dart';

class NewTimesheetDialog extends ConsumerWidget {
  NewTimesheetDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NewTimesheetDialog(),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    // final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(newTimesheetProvider);
    final notifier = ref.read(newTimesheetProvider.notifier);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 650.w,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(context, isDark, notifier),
                Expanded(child: _buildBody(context, isDark, state, notifier)),
                _buildFooter(context, isDark, notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header
  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    NewTimesheetNotifier notifier,
  ) {
    final title = 'New Weekly Timesheet';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          DigifyAsset(
            assetPath: Assets.icons.sidebar.scheduleAssignments.path,
            width: 18.w,
            height: 18.h,
            color: Colors.white,
          ),
          Gap(4.w),
          Expanded(
            child: Text(
              title,
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size(32.w, 32.h)),
            icon: Icon(Icons.cancel_outlined, size: 20.r, color: Colors.white),
            onPressed: () {
              notifier.reset();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// Body
  Widget _buildBody(
    BuildContext context,
    bool isDark,
    NewTimesheetFormState state,
    NewTimesheetNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInputsForm(context, isDark, state, notifier),
          Gap(24.h),
          _buildTimesheetTable(context, isDark, state, notifier),
        ],
      ),
    );
  }

  /// Body Children
  Widget _buildBasicInputsForm(
    BuildContext context,
    bool isDark,
    NewTimesheetFormState state,
    NewTimesheetNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField(
          labelText: "Select Employee",
          isRequired: true,
          onChanged: (value) => notifier.setEmployee(employeeName: value),
          hintText: 'Type to search employees...',
          prefixIcon: Icon(Icons.search_outlined, size: 20.r),
          suffixIcon: Icon(Icons.arrow_drop_down_outlined, size: 20.r),
        ),
        Gap(16.h),
        if (context.isMobile) ...[
          DigifyTextField(
            labelText: "Employee Name",
            onChanged: (value) => notifier.setEmployee(employeeName: value),
            hintText: 'Employee Name',
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: "Project Name",
            onChanged: (value) => notifier.setProjectName(value),
            hintText: 'Project Name',
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: "Employee Name",
                  onChanged: (value) =>
                      notifier.setEmployee(employeeName: value),
                  hintText: 'Employee Name',
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyTextField(
                  labelText: "Project Name",
                  onChanged: (value) => notifier.setProjectName(value),
                  hintText: 'Project Name',
                ),
              ),
            ],
          ),
        ],
        Gap(16.h),
        if (context.isMobile) ...[
          DigifyTextField(
            labelText: "Position",
            onChanged: (value) => notifier.setPosition(value),
            hintText: 'Position',
          ),
          Gap(16.h),
          DigifySelectFieldWithLabel<String>(
            label: 'Department',
            items: const ['Select Department'],
            itemLabelBuilder: (item) => item,
            hint: 'Department',
            onChanged: (value) => notifier.setDepartmentId(value),
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: "Position",
                  onChanged: (value) => notifier.setPosition(value),
                  hintText: 'Position',
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Department',
                  items: const ['Select Department'],
                  itemLabelBuilder: (item) => item,
                  hint: 'Department',
                  onChanged: (value) => notifier.setDepartmentId(value),
                ),
              ),
            ],
          ),
        ],
        Gap(16.h),
        DigifyTextArea(
          labelText: "Description",
          onChanged: (value) => notifier.setDescription(value),
          hintText: 'Write...',
          maxLines: 5,
        ),
        Gap(16.h),
        if (context.isMobile) ...[
          DateSelectionField(
            label: 'Week Starting',
            isRequired: true,
            date: state.startDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
            onDateSelected: (value) => notifier.setStartDate(value),
          ),
          Gap(16.h),
          DateSelectionField(
            label: 'Week Ending',
            isRequired: false,
            enabled: false,
            date: state.endDate,
            onDateSelected: (value) {},
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: DateSelectionField(
                  label: 'Week Starting',
                  isRequired: true,
                  date: state.startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  onDateSelected: (value) => notifier.setStartDate(value),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DateSelectionField(
                  label: 'Week Ending',
                  isRequired: false,
                  enabled: false,
                  date: state.endDate,
                  onDateSelected: (value) {},
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTimesheetTable(
    BuildContext context,
    bool isDark,
    NewTimesheetFormState state,
    NewTimesheetNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Daily Time Entries",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? context.themeTextPrimary
                      : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
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
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              _buildTimeSheetTableHeader(isDark, context),
              _buildTimeSheetTableBody(context, isDark, state, notifier),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSheetTableHeader(bool isDark, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardBackgroundGreyDark
            : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Day',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF364153),
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              'Date',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF364153),
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 3,
            child: Text(
              'Project/Task',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF364153),
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              'Regular Hrs',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF364153),
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              'OT Hrs',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF364153),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSheetTableBody(
    BuildContext context,
    bool isDark,
    NewTimesheetFormState state,
    NewTimesheetNotifier notifier,
  ) {
    return Column(
      children: List.generate(
        state.weekDays.length,
        (index) => _buildTimeSheetTableRow(
          context,
          isDark,
          state.weekDays[index],
          notifier,
        ),
      ),
    );
  }

  Widget _buildTimeSheetTableRow(
    BuildContext context,
    bool isDark,
    DateTime date,
    NewTimesheetNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('EEEE').format(date),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF364153),
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('MMM d').format(date),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF364153),
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 3,
            child: DigifyTextField(
              hintText: 'Enter Task',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: DigifyTextField(
              initialValue: '0',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: DigifyTextField(
              initialValue: '0',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Footer
  Widget _buildFooter(
    BuildContext context,
    bool isDark,
    NewTimesheetNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
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
              if (_formKey.currentState!.validate()) {
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
