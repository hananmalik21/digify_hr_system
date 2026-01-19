import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyLeaveBalanceCardData {
  final String leaveType;
  final String leaveTypeArabic;
  final String iconPath;
  final double totalBalance;
  final double currentYear;
  final double carriedForward;
  final bool carryForwardAllowed;
  final String? carryForwardMax;
  final String? expiryDate;
  final bool isAtRisk;
  final double? atRiskDays;
  final String? atRiskExpiryDate;
  final bool encashmentAvailable;
  final VoidCallback? onEncashmentRequest;

  const MyLeaveBalanceCardData({
    required this.leaveType,
    required this.leaveTypeArabic,
    required this.iconPath,
    required this.totalBalance,
    required this.currentYear,
    required this.carriedForward,
    required this.carryForwardAllowed,
    this.carryForwardMax,
    this.expiryDate,
    this.isAtRisk = false,
    this.atRiskDays,
    this.atRiskExpiryDate,
    this.encashmentAvailable = false,
    this.onEncashmentRequest,
  });
}

class MyLeaveBalanceCard extends StatelessWidget {
  final MyLeaveBalanceCardData data;
  final bool isDark;

  const MyLeaveBalanceCard({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 570.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border.all(
          color: data.isAtRisk ? AppColors.warning : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          width: data.isAtRisk ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Expanded(child: SingleChildScrollView(child: _buildContent(context))),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [AppColors.primaryLight, AppColors.primary],
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: data.iconPath, width: 18, height: 18, color: Colors.white),
          ),
          Gap(11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.leaveType,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  data.leaveTypeArabic,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          if (data.isAtRisk) _buildAtRiskBadge(),
        ],
      ),
    );
  }

  Widget _buildAtRiskBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAsset(assetPath: Assets.icons.leaveManagement.warning.path, width: 14, height: 14, color: Colors.white),
          Gap(4.w),
          Text(
            'At Risk',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(21.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalBalance(context),
          Gap(14.h),
          _buildBalanceBreakdown(context),
          DigifyDivider(margin: EdgeInsets.symmetric(vertical: 14.h)),
          _buildCarryForwardInfo(context),
          if (data.isAtRisk && data.atRiskDays != null) ...[Gap(7.h), _buildAtRiskSection()],
          if (data.encashmentAvailable) ...[Gap(7.h), _buildEncashmentSection()],
          Gap(7.h),
          _buildExpiryDate(context),
        ],
      ),
    );
  }

  Widget _buildTotalBalance(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total Balance',
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? context.themeTextSecondary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(4.h),
          Text(
            data.totalBalance.toString(),
            style: context.textTheme.displaySmall?.copyWith(
              fontSize: 31.sp,
              color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(4.h),
          Text(
            'days available',
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? context.themeTextSecondary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceBreakdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildBalanceItem(context: context, label: 'Current Year', value: data.currentYear.toString()),
        ),
        Gap(14.w),
        Expanded(
          child: _buildBalanceItem(context: context, label: 'Carried Forward', value: data.carriedForward.toString()),
        ),
      ],
    );
  }

  Widget _buildBalanceItem({required BuildContext context, required String label, required String value}) {
    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.textTheme.labelSmall?.copyWith(color: AppColors.primary)),
          Gap(4.h),
          Text(
            value,
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildCarryForwardInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Carry Forward Allowed',
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 12.sp,
                color: isDark ? context.themeTextSecondary : AppColors.textSecondary,
              ),
            ),
            Gap(7.w),
            DigifyAsset(
              assetPath: Assets.icons.infoCircleBlue.path,
              width: 14,
              height: 14,
              color: isDark ? context.themeTextSecondary : AppColors.textSecondary,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: data.carryForwardAllowed ? AppColors.successBg : AppColors.errorBg,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Text(
            data.carryForwardAllowed
                ? (data.carryForwardMax != null ? 'Yes (Max ${data.carryForwardMax})' : 'Yes')
                : 'No',
            style: context.textTheme.labelMedium?.copyWith(
              fontSize: 11.sp,
              color: data.carryForwardAllowed ? AppColors.successText : AppColors.errorText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAtRiskSection() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.leaveManagement.warning.path,
                    width: 14,
                    height: 14,
                    color: AppColors.warningText,
                  ),
                  Gap(4.w),
                  Text(
                    'At-Risk (Forfeitable)',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.warningText),
                  ),
                ],
              ),
              Text(
                '${data.atRiskDays} days',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.warningText),
              ),
            ],
          ),
          Gap(7.h),
          Text(
            data.atRiskExpiryDate != null
                ? 'These days exceed the carry forward limit and will be forfeited after ${data.atRiskExpiryDate}'
                : 'These days exceed the carry forward limit and will be forfeited',
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.yellowSubtitle),
          ),
        ],
      ),
    );
  }

  Widget _buildEncashmentSection() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.greenBg,
        border: Border.all(color: AppColors.greenBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.infoIconGreen.path,
                    width: 14,
                    height: 14,
                    color: AppColors.greenText,
                  ),
                  Gap(4.w),
                  Text(
                    'Encashment Available',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.greenText),
                  ),
                ],
              ),
              if (data.onEncashmentRequest != null)
                GestureDetector(
                  onTap: data.onEncashmentRequest,
                  child: Text(
                    'Request →',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.greenTextSecondary),
                  ),
                ),
            ],
          ),
          Gap(3.h),
          Text(
            'You can request to encash unused leave days for monetary compensation',
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: AppColors.greenTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryDate(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Expiry Date',
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            color: isDark ? context.themeTextSecondary : AppColors.textSecondary,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: data.expiryDate != null
                ? AppColors.infoBg
                : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg),
            borderRadius: BorderRadius.circular(1000.r),
          ),
          child: Text(
            data.expiryDate ?? 'N/A',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: data.expiryDate != null
                  ? AppColors.infoTextSecondary
                  : (isDark ? context.themeTextSecondary : AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
