import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/my_leave_balance_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// My Leave Balance View - displays employee's personal leave balances
class MyLeaveBalanceView extends StatefulWidget {
  const MyLeaveBalanceView({super.key});

  @override
  State<MyLeaveBalanceView> createState() => _MyLeaveBalanceViewState();
}

class _MyLeaveBalanceViewState extends State<MyLeaveBalanceView> {
  // Mock employee data - replace with actual data from provider
  final Map<String, dynamic> _employeeData = {
    'name': 'Ahmed Al-Mutairi',
    'employeeNumber': 'EMP001',
    'department': 'IT',
    'joinDate': '2020-01-15',
  };

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          top: 0.h,
          start: 21.w,
          end: 21.w,
          bottom: 30.h,
        ),
        child: SizedBox(
          width: 1470.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(45.5.h),
              _buildHeader(localizations, isDark),
              Gap(21.h),
              _buildEmployeeInfoCard(localizations, isDark),
              Gap(21.h),
              _buildLeaveBalanceCards(localizations, isDark),
              Gap(21.h),
              _buildPolicySection(localizations, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.myLeaveBalance,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
                  height: 31.5 / 25,
                ),
              ),
              Gap(3.5.h),
              Text(
                localizations.myLeaveBalanceDescription,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
                  height: 21 / 13.6,
                ),
              ),
            ],
          ),
        ),
        Gap(10.51.w),
        Row(
          children: [
            AppButton(
              label: localizations.applyLeave,
              svgPath: Assets.icons.calendarIcon.path,
              type: AppButtonType.primary,
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(11.r),
              padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.5.h),
              fontSize: 13.7.sp,
              onPressed: () {
                // TODO: Navigate to apply leave
              },
            ),
            Gap(10.51.w),
            AppButton(
              label: localizations.requestEncashment,
              svgPath: Assets.icons.attendanceLeavesIcon.path,
              type: AppButtonType.primary,
              backgroundColor: const Color(0xFF00A63E),
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(11.r),
              padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.5.h),
              fontSize: 13.8.sp,
              onPressed: () {
                // TODO: Navigate to encashment request
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployeeInfoCard(AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
        borderRadius: BorderRadius.circular(11.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoField(
              label: localizations.employeeName,
              value: _employeeData['name'] as String,
              isDark: isDark,
            ),
          ),
          Gap(21.w),
          Expanded(
            child: _buildInfoField(
              label: localizations.employeeNumber,
              value: _employeeData['employeeNumber'] as String,
              isDark: isDark,
            ),
          ),
          Gap(21.w),
          Expanded(
            child: _buildInfoField(
              label: localizations.department,
              value: _employeeData['department'] as String,
              isDark: isDark,
            ),
          ),
          Gap(21.w),
          Expanded(
            child: _buildInfoField(
              label: localizations.joinDate,
              value: _employeeData['joinDate'] as String,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.1.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? context.themeTextSecondary : const Color(0xFF6A7282),
            height: 17.5 / 12.1,
          ),
        ),
        Gap(3.5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
            height: 21 / 13.8,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveBalanceCards(AppLocalizations localizations, bool isDark) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MyLeaveBalanceCard(
                data: MyLeaveBalanceCardData(
                  leaveType: localizations.annualLeave,
                  leaveTypeArabic: localizations.annualLeaveArabic,
                  iconPath: Assets.icons.calendarIcon.path,
                  totalBalance: 24.5,
                  currentYear: 18,
                  carriedForward: 6.5,
                  carryForwardAllowed: true,
                  carryForwardMax: '10',
                  expiryDate: '2024-03-31',
                  isAtRisk: true,
                  atRiskDays: 3.5,
                  atRiskExpiryDate: '2024-03-31',
                  encashmentAvailable: true,
                  onEncashmentRequest: () {
                    // TODO: Handle encashment request
                  },
                ),
                isDark: isDark,
              ),
            ),
            Gap(21.w),
            Expanded(
              child: MyLeaveBalanceCard(
                data: MyLeaveBalanceCardData(
                  leaveType: localizations.sickLeave,
                  leaveTypeArabic: localizations.sickLeaveArabic,
                  iconPath: Assets.icons.attendanceLeavesIcon.path,
                  totalBalance: 12,
                  currentYear: 12,
                  carriedForward: 0,
                  carryForwardAllowed: false,
                  expiryDate: '2024-12-31',
                ),
                isDark: isDark,
              ),
            ),
          ],
        ),
        Gap(21.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MyLeaveBalanceCard(
                data: MyLeaveBalanceCardData(
                  leaveType: localizations.hajjLeave,
                  leaveTypeArabic: localizations.hajjLeaveArabic,
                  iconPath: Assets.icons.leaveCalendarIcon.path,
                  totalBalance: 15,
                  currentYear: 15,
                  carriedForward: 0,
                  carryForwardAllowed: false,
                  expiryDate: null,
                ),
                isDark: isDark,
              ),
            ),
            Gap(21.w),
            Expanded(
              child: MyLeaveBalanceCard(
                data: MyLeaveBalanceCardData(
                  leaveType: localizations.compassionateLeave,
                  leaveTypeArabic: localizations.compassionateLeaveArabic,
                  iconPath: Assets.icons.clockIcon.path,
                  totalBalance: 5,
                  currentYear: 5,
                  carriedForward: 0,
                  carryForwardAllowed: true,
                  carryForwardMax: '3',
                  expiryDate: '2024-12-31',
                  isAtRisk: true,
                  atRiskDays: 2,
                  atRiskExpiryDate: '2024-12-31',
                ),
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPolicySection(AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
        ),
        border: Border.all(color: const Color(0xFFBEDBFF)),
        borderRadius: BorderRadius.circular(11.r),
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
                localizations.kuwaitLaborLawLeavePolicy,
                style: TextStyle(
                  fontSize: 15.4.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C398E),
                  height: 24.5 / 15.4,
                ),
              ),
            ],
          ),
          Gap(13.75.h),
          Row(
            children: [
              Expanded(
                child: _buildPolicyCard(
                  title: localizations.carryForwardPolicy,
                  description: localizations.carryForwardPolicyDescription,
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _buildPolicyCard(
                  title: localizations.forfeitRules,
                  description: localizations.forfeitRulesDescription,
                  isDark: isDark,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: _buildPolicyCard(
                  title: localizations.encashmentPolicy,
                  description: localizations.encashmentPolicyDescription,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C398E),
              height: 21 / 13.8,
            ),
          ),
          Gap(7.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.1.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1447E6),
              height: 17.5 / 12.1,
            ),
          ),
        ],
      ),
    );
  }
}
