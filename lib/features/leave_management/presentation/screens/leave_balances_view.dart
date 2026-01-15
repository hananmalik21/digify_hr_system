import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_header.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_row.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveBalancesView extends StatefulWidget {
  const LeaveBalancesView({super.key});

  @override
  State<LeaveBalancesView> createState() => _LeaveBalancesViewState();
}

class _LeaveBalancesViewState extends State<LeaveBalancesView> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedDepartment;

  // Mock data
  final List<Map<String, dynamic>> _employees = [
    {
      'name': 'Ahmed Al-Mutairi',
      'id': 'EMP001',
      'department': 'IT',
      'joinDate': '2020-01-15',
      'annualLeave': 23,
      'sickLeave': 15,
      'unpaidLeave': 0,
      'totalAvailable': 38,
    },
    {
      'name': 'Fatima Al-Rashid',
      'id': 'EMP002',
      'department': 'Human Resources',
      'joinDate': '2019-03-20',
      'annualLeave': 30,
      'sickLeave': 15,
      'unpaidLeave': 0,
      'totalAvailable': 45,
    },
    {
      'name': 'Mohammed Al-Sabah',
      'id': 'EMP003',
      'department': 'Finance',
      'joinDate': '2021-06-10',
      'annualLeave': 30,
      'sickLeave': 15,
      'unpaidLeave': 0,
      'totalAvailable': 45,
    },
  ];

  final List<String> _departments = ['All Departments', 'IT', 'Human Resources', 'Finance'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(top: 45.5.h, start: 32.w, end: 32.w, bottom: 24.h),
        child: SizedBox(
          width: 1470.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(localizations, isDark),
              Gap(21.h),
              _buildSummaryCards(isDark),
              Gap(21.h),
              _buildLaborLawSection(isDark),
              Gap(21.h),
              _buildFiltersBar(isDark),
              Gap(21.h),
              _buildTable(localizations, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leave Balance',
          style: TextStyle(
            fontSize: 16.5.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
            height: 26.25 / 16.5,
          ),
        ),
        Gap(3.5.h),
        Text(
          'View and manage employee leave balances and accruals',
          style: TextStyle(
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
            height: 21 / 13.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            label: 'Total Employees',
            value: '3',
            iconPath: Assets.icons.calendarIcon.path,
            iconColor: const Color(0xFF155DFC),
            iconBackground: const Color(0xFFDBEAFE),
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            label: 'Avg Annual Leave',
            value: '27.7 days',
            iconPath: Assets.icons.calendarIcon.path,
            iconColor: const Color(0xFF008236),
            iconBackground: const Color(0xFFDCFCE7),
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            label: 'Avg Sick Leave',
            value: '15.0 days',
            iconPath: Assets.icons.calendarIcon.path,
            iconColor: const Color(0xFF8B5CF6),
            iconBackground: const Color(0xFFF3E8FF),
            isDark: isDark,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildSummaryCard(
            label: 'Low Balance Alerts',
            value: '0',
            iconPath: Assets.icons.calendarIcon.path,
            iconColor: const Color(0xFF9F2D00),
            iconBackground: const Color(0xFFFFEDD4),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required String iconPath,
    required Color iconColor,
    required Color iconBackground,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
                  height: 21 / 13.6,
                ),
              ),
              Gap(3.5.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
                  height: 21 / 14,
                ),
              ),
            ],
          ),
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(7.r)),
            child: Center(
              child: DigifyAsset(assetPath: iconPath, width: 21, height: 21, color: iconColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaborLawSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
        ),
        border: Border.all(color: const Color(0xFFBEDBFF)),
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.calendarIcon.path,
                width: 17.5,
                height: 17.5,
                color: const Color(0xFF1C398E),
              ),
              Gap(7.w),
              Text(
                'Kuwait Labor Law Annual Leave Entitlements',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
                  height: 21 / 13.5,
                ),
              ),
            ],
          ),
          Gap(14.h),
          Row(
            children: [
              Expanded(
                child: _buildLawCard(
                  title: 'Standard Annual Leave',
                  description: '30 days per year after 1 year of service',
                  titleColor: const Color(0xFF1C398E),
                  descriptionColor: const Color(0xFF1447E6),
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _buildLawCard(
                  title: 'Sick Leave',
                  description: '15 days full pay + 10 days half pay + 10 days unpaid',
                  titleColor: const Color(0xFF0D542B),
                  descriptionColor: const Color(0xFF008236),
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _buildLawCard(
                  title: 'Leave Accrual',
                  description: 'Accrues monthly at 2.5 days per month',
                  titleColor: const Color(0xFF59168B),
                  descriptionColor: const Color(0xFF8200DB),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLawCard({
    required String title,
    required String description,
    required Color titleColor,
    required Color descriptionColor,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13.6.sp, fontWeight: FontWeight.w400, color: titleColor, height: 21 / 13.6),
          ),
          Gap(3.5.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: descriptionColor,
              height: 21 / 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar(bool isDark) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use Wrap for smaller screens, Row for larger screens
          final useWrap = constraints.maxWidth < 800;

          if (useWrap) {
            return Wrap(
              spacing: 14.w,
              runSpacing: 14.h,
              alignment: WrapAlignment.start,
              children: [
                SizedBox(
                  width: constraints.maxWidth < 600 ? constraints.maxWidth : 300.w,
                  child: DigifyTextField.search(
                    controller: _searchController,
                    hintText: 'Search by name or employee number...',
                    filled: false,
                    borderColor: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC),
                  ),
                ),
                _buildDepartmentDropdown(isDark),
                _buildExportButton(isDark),
                _buildRefreshButton(isDark),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: DigifyTextField.search(
                  controller: _searchController,
                  hintText: 'Search by name or employee number...',
                  filled: false,
                  borderColor: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC),
                ),
              ),
              Gap(14.w),
              _buildDepartmentDropdown(isDark),
              Gap(14.w),
              _buildExportButton(isDark),
              Gap(14.w),
              _buildRefreshButton(isDark),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDepartmentDropdown(bool isDark) {
    return Container(
      height: 40.h,
      constraints: BoxConstraints(minWidth: 150.w, maxWidth: 200.w),
      padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC), width: 1),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'All Departments',
            style: TextStyle(
              fontSize: 13.7.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
              height: 16.5 / 13.7,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items: _departments
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13.7.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          value: _selectedDepartment,
          onChanged: (value) => setState(() => _selectedDepartment = value),
          iconStyleData: IconStyleData(
            icon: DigifyAsset(
              assetPath: Assets.icons.workforce.chevronDown.path,
              height: 20,
              color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
            ),
            iconSize: 24.sp,
          ),
          buttonStyleData: ButtonStyleData(padding: EdgeInsets.zero, height: 40.h),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              borderRadius: BorderRadius.circular(7.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExportButton(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Handle export
        },
        borderRadius: BorderRadius.circular(7.r),
        child: Container(
          constraints: BoxConstraints(minHeight: 40.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC), width: 1),
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: Assets.icons.exportIconFigma.path,
                width: 14,
                height: 14,
                color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
              ),
              Gap(7.w),
              Text(
                'Export',
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
                  height: 21 / 13.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Handle refresh
        },
        borderRadius: BorderRadius.circular(7.r),
        child: Container(
          constraints: BoxConstraints(minHeight: 40.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
          decoration: BoxDecoration(color: const Color(0xFF155DFC), borderRadius: BorderRadius.circular(7.r)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(assetPath: Assets.icons.refreshGray.path, width: 14, height: 14, color: Colors.white),
              Gap(7.w),
              Text(
                'Refresh Balances',
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 21 / 13.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(AppLocalizations localizations, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeaveBalancesTableHeader(isDark: isDark, localizations: localizations),
            if (_employees.isEmpty)
              SizedBox(
                width: 1200.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: Center(
                    child: Text(
                      localizations.noResultsFound,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              )
            else
              ..._employees.map(
                (employee) =>
                    LeaveBalancesTableRow(employeeData: employee, localizations: localizations, isDark: isDark),
              ),
          ],
        ),
      ),
    );
  }
}
