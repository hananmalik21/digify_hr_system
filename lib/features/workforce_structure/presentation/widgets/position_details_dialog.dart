import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionDetailsDialog extends StatelessWidget {
  final Position position;

  const PositionDetailsDialog({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1000.w,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${localizations.positionDetails} - ${position.titleEnglish}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tight(Size(32.w, 32.h)),
                      icon: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildSection(
                  localizations.basicInformation,
                  [
                    _DetailEntry(
                      label: localizations.positionCode,
                      value: position.code,
                    ),
                    _DetailEntry(
                      label: localizations.status,
                      value: position.isActive
                          ? localizations.active.toUpperCase()
                          : localizations.active,
                      highlight: true,
                    ),
                    _DetailEntry(
                      label: localizations.titleEnglish,
                      value: position.titleEnglish,
                    ),
                    _DetailEntry(
                      label: localizations.titleArabic,
                      value: position.titleArabic,
                      isRtl: true,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildSection(
                  localizations.organizationalInformation,
                  [
                    _DetailEntry(
                      label: localizations.division,
                      value: position.division,
                    ),
                    _DetailEntry(
                      label: localizations.department,
                      value: position.department,
                    ),
                    _DetailEntry(
                      label: localizations.costCenter,
                      value: position.costCenter,
                    ),
                    _DetailEntry(
                      label: localizations.location,
                      value: position.location,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _buildSection(
                  localizations.jobClassification,
                  [
                    _DetailEntry(
                      label: localizations.jobFamily,
                      value: position.jobFamily,
                    ),
                    _DetailEntry(
                      label: localizations.jobLevel,
                      value: position.level,
                    ),
                    _DetailEntry(
                      label: localizations.gradeStep,
                      value: position.grade,
                    ),
                    _DetailEntry(
                      label: localizations.step,
                      value: position.step,
                    ),
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

  Widget _buildSection(String title, List<_DetailEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: entries
              .map(
                (entry) => _buildDetailCard(entry),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDetailCard(_DetailEntry entry) {
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
          crossAxisAlignment:
              entry.isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              entry.label,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            SizedBox(height: 6.h),
            entry.highlight
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF047857),
                      ),
                    ),
                  )
                : Text(
                    entry.value,
                    textDirection:
                        entry.isRtl ? TextDirection.rtl : TextDirection.ltr,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.headcountInformation,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
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
        ),
      ],
    );
  }

  Widget _buildSalarySection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.salaryInformation,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: [
            _buildDetailCard(
              _DetailEntry(
                label: localizations.budgetedMin,
                value: position.budgetedMin,
              ),
            ),
            _buildDetailCard(
              _DetailEntry(
                label: localizations.budgetedMax,
                value: position.budgetedMax,
              ),
            ),
            _buildDetailCard(
              _DetailEntry(
                label: localizations.actualAverage,
                value: position.actualAverage,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportingRelationship(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.reportingRelationship,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
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
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
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
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: valueColor,
                height: 32 / 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailEntry {
  final String label;
  final String value;
  final bool highlight;
  final bool isRtl;

  const _DetailEntry({
    required this.label,
    required this.value,
    this.highlight = false,
    this.isRtl = false,
  });
}

