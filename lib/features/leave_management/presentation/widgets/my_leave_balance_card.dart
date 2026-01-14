import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
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

  const MyLeaveBalanceCard({
    super.key,
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      height: 570.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border.all(
          color: data.isAtRisk
              ? const Color(0xFFFFD230)
              : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          width: data.isAtRisk ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(11.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: _buildContent(context, localizations),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(11.r),
          topRight: Radius.circular(11.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Center(
              child: DigifyAsset(
                assetPath: data.iconPath,
                width: 17.5,
                height: 17.5,
                color: Colors.white,
              ),
            ),
          ),
          Gap(10.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.leaveType,
                  style: TextStyle(
                    fontSize: 15.4.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 24.5 / 15.4,
                  ),
                ),
                Text(
                  data.leaveTypeArabic,
                  style: TextStyle(
                    fontSize: 12.3.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 17.5 / 12.3,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          if (data.isAtRisk)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.5.w, vertical: 3.5.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(1000.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.arrowUp.path,
                    width: 14,
                    height: 14,
                    color: Colors.white,
                  ),
                  Gap(3.5.w),
                  Text(
                    'At Risk',
                    style: TextStyle(
                      fontSize: 12.3.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 17.5 / 12.3,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: EdgeInsets.all(21.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalBalance(context),
          Gap(14.h),
          _buildBalanceBreakdown(),
          Gap(14.h),
          Divider(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            height: 1,
            thickness: 1,
          ),
          Gap(15.h),
          _buildCarryForwardInfo(localizations,context),
          if (data.isAtRisk && data.atRiskDays != null) ...[
            Gap(7.h),
            _buildAtRiskSection(localizations),
          ],
          if (data.encashmentAvailable) ...[
            Gap(7.h),
            _buildEncashmentSection(localizations),
          ],
          Gap(7.h),
          _buildExpiryDate(localizations,context),
        ],
      ),
    );
  }

  Widget _buildTotalBalance(BuildContext context) {
    return Container(
      width: 678.5.w,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 12.1.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
              height: 17.5 / 12.1,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(3.5.h),
          Text(
            data.totalBalance.toString(),
            style: TextStyle(
              fontSize: 30.6.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
              height: 35 / 30.6,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(3.5.h),
          Text(
            'days available',
            style: TextStyle(
              fontSize: 12.1.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? context.themeTextSecondary : const Color(0xFF6A7282),
              height: 17.5 / 12.1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceBreakdown() {
    return SizedBox(
      width: 678.5.w,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.5.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Year',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF155DFC),
                      height: 14 / 10.5,
                    ),
                  ),
                  Gap(3.5.h),
                  Text(
                    data.currentYear.toString(),
                    style: TextStyle(
                      fontSize: 17.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1C398E),
                      height: 24.5 / 17.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.5.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF5FF),
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Carried Forward',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9810FA),
                      height: 14 / 10.5,
                    ),
                  ),
                  Gap(3.5.h),
                  Text(
                    data.carriedForward.toString(),
                    style: TextStyle(
                      fontSize: 17.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF59168B),
                      height: 24.5 / 17.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarryForwardInfo(AppLocalizations localizations,BuildContext context) {
    return SizedBox(
      width: 678.5.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Carry Forward Allowed',
                style: TextStyle(
                  fontSize: 12.1.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
                  height: 17.5 / 12.1,
                ),
              ),
              Gap(7.w),
              DigifyAsset(
                assetPath: Assets.icons.infoCircleBlue.path,
                width: 14,
                height: 14,
                color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.5.w, vertical: 3.5.h),
            decoration: BoxDecoration(
              color: data.carryForwardAllowed
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFFFE2E2),
              borderRadius: BorderRadius.circular(1000.r),
            ),
            child: Text(
              data.carryForwardAllowed
                  ? (data.carryForwardMax != null ? 'Yes (Max ${data.carryForwardMax})' : 'Yes')
                  : 'No',
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: data.carryForwardAllowed
                    ? const Color(0xFF008236)
                    : const Color(0xFFC10007),
                height: 14 / 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAtRiskSection(AppLocalizations localizations) {
    return SizedBox(
      width: 678.5.w,
      child: Container(
        padding: EdgeInsets.all(11.5.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          border: Border.all(color: const Color(0xFFFEE685)),
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 655.5.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      DigifyAsset(
                        assetPath: Assets.icons.warningIconYellow.path,
                        width: 14,
                        height: 14,
                        color: const Color(0xFF7B3306),
                      ),
                      Gap(3.5.w),
                      Text(
                        'At-Risk (Forfeitable)',
                        style: TextStyle(
                          fontSize: 12.3.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7B3306),
                          height: 17.5 / 12.3,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${data.atRiskDays} days',
                    style: TextStyle(
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7B3306),
                      height: 24.5 / 15.4,
                    ),
                  ),
                ],
              ),
            ),
            Gap(7.h),
            SizedBox(
              width: 655.5.w,
              child: Text(
                data.atRiskExpiryDate != null
                    ? 'These days exceed the carry forward limit and will be forfeited after ${data.atRiskExpiryDate}'
                    : 'These days exceed the carry forward limit and will be forfeited',
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFBB4D00),
                  height: 14 / 10.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEncashmentSection(AppLocalizations localizations) {
    return SizedBox(
      width: 678.5.w,
      child: Container(
        padding: EdgeInsets.all(11.5.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          border: Border.all(color: const Color(0xFFB9F8CF)),
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 655.5.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      DigifyAsset(
                        assetPath: Assets.icons.infoIconGreen.path,
                        width: 14,
                        height: 14,
                        color: const Color(0xFF0D542B),
                      ),
                      Gap(3.5.w),
                      Text(
                        'Encashment Available',
                        style: TextStyle(
                          fontSize: 12.1.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0D542B),
                          height: 17.5 / 12.1,
                        ),
                      ),
                    ],
                  ),
                  if (data.onEncashmentRequest != null)
                    GestureDetector(
                      onTap: data.onEncashmentRequest,
                      child: Text(
                        'Request →',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF008236),
                          height: 14 / 10.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Gap(3.25.h),
            SizedBox(
              width: 655.5.w,
              child: Text(
                'You can request to encash unused leave days for monetary compensation',
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF008236),
                  height: 14 / 10.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryDate(AppLocalizations localizations,BuildContext context) {
    return SizedBox(
      width: 678.5.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Expiry Date',
            style: TextStyle(
              fontSize: 12.1.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
              height: 17.5 / 12.1,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.5.w, vertical: 3.5.h),
            decoration: BoxDecoration(
              color: data.expiryDate != null
                  ? const Color(0xFFDBEAFE)
                  : (isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF3F4F6)),
              borderRadius: BorderRadius.circular(1000.r),
            ),
            child: Text(
              data.expiryDate ?? 'N/A',
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: data.expiryDate != null
                    ? const Color(0xFF1447E6)
                    : (isDark ? context.themeTextSecondary : const Color(0xFF364153)),
                height: 14 / 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
