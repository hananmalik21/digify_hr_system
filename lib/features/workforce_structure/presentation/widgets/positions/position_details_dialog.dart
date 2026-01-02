import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class PositionDetailsDialog extends StatelessWidget {
  final Position position;

  const PositionDetailsDialog({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PositionDialogHeader(
                  title: '${localizations.positionDetails} - ${position.titleEnglish}',
                  onClose: () => Navigator.of(context).pop(),
                ),
                SizedBox(height: 24.h),
                PositionDialogSection(
                  title: localizations.basicInformation,
                  children: [
                    _buildDetailCard(localizations.positionCode, position.code),
                    _buildDetailCard(
                      localizations.status,
                      position.isActive ? localizations.active.toUpperCase() : localizations.active,
                      highlight: true,
                    ),
                    _buildDetailCard(localizations.titleEnglish, position.titleEnglish),
                    _buildDetailCard(localizations.titleArabic, position.titleArabic, isRtl: true),
                  ],
                ),
                SizedBox(height: 24.h),
                PositionDialogSection(
                  title: localizations.organizationalInformation,
                  children: [
                    _buildDetailCard(localizations.division, position.division),
                    _buildDetailCard(localizations.department, position.department),
                    _buildDetailCard(localizations.costCenter, position.costCenter),
                    _buildDetailCard(localizations.location, position.location),
                  ],
                ),
                SizedBox(height: 24.h),
                PositionDialogSection(
                  title: localizations.jobClassification,
                  children: [
                    _buildDetailCard(localizations.jobFamily, position.jobFamily),
                    _buildDetailCard(localizations.jobLevel, position.level),
                    _buildDetailCard(localizations.gradeStep, position.grade),
                    _buildDetailCard(localizations.step, position.step),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildHeadcountSection(localizations),
                SizedBox(height: 24.h),
                _buildSalarySection(localizations),
                SizedBox(height: 24.h),
                _buildReportingRelationship(localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, {bool highlight = false, bool isRtl = false}) {
    return SizedBox(
      width: 432.w,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            SizedBox(height: 6.h),
            highlight
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF047857)),
                    ),
                  )
                : Text(
                    value,
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 24 / 15.4,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadcountSection(AppLocalizations localizations) {
    return PositionDialogSection(
      title: localizations.headcountInformation,
      children: [
        _buildHighlightCard(
          label: localizations.totalPositions,
          value: '${position.headcount}',
          backgroundColor: const Color(0xFFDBEAFE),
          valueColor: const Color(0xFF1D3DB9),
        ),
        _buildHighlightCard(
          label: localizations.filled,
          value: '${position.filled}',
          backgroundColor: const Color(0xFFD1FAE5),
          valueColor: const Color(0xFF047857),
        ),
        _buildHighlightCard(
          label: localizations.vacant,
          value: '${position.vacant}',
          backgroundColor: const Color(0xFFFEECDC),
          valueColor: const Color(0xFFB45309),
        ),
      ],
    );
  }

  Widget _buildSalarySection(AppLocalizations localizations) {
    return PositionDialogSection(
      title: localizations.salaryInformation,
      children: [
        _buildDetailCard(localizations.budgetedMin, position.budgetedMin),
        _buildDetailCard(localizations.budgetedMax, position.budgetedMax),
        _buildDetailCard(localizations.actualAverage, position.actualAverage),
      ],
    );
  }

  Widget _buildReportingRelationship(AppLocalizations localizations) {
    return PositionDialogSection(
      title: localizations.reportingRelationship,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.reportsTo,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 20 / 13.6,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                position.reportsTo ?? '-',
                style: TextStyle(
                  fontSize: 15.6.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 24 / 15.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightCard({
    required String label,
    required String value,
    required Color backgroundColor,
    required Color valueColor,
  }) {
    return SizedBox(
      width: 272.w,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: valueColor, height: 32 / 24),
            ),
          ],
        ),
      ),
    );
  }
}
