import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/department.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DepartmentDetailsDialog extends StatelessWidget {
  final DepartmentOverview department;

  const DepartmentDetailsDialog({
    super.key,
    required this.department,
  });

  static Future<void> show(
    BuildContext context,
    DepartmentOverview department,
  ) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => DepartmentDetailsDialog(
        department: department,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 860.w,
        constraints: BoxConstraints(maxHeight: 780.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 50,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, localizations),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            _buildTitleBlock(context, localizations),
            SizedBox(height: 24.h),
            _buildBasicInformationSection(context, localizations, isDark),
            SizedBox(height: 24.h),
            _buildLeadershipSection(context, localizations, isDark),
                      SizedBox(height: 24.h),
                      _buildMetricsSection(context, localizations, isDark),
                      SizedBox(height: 24.h),
                      _buildDescription(context, localizations, isDark),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BBA7), Color(0xFF00858F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgIconWidget(
                assetPath: 'assets/icons/department_card_icon.svg',
                size: 20.sp,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              Text(
                localizations.departmentDetails,
                style: TextStyle(
                  fontSize: 18.8.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 30 / 18.8,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: SvgIconWidget(
                assetPath: 'assets/icons/close_dialog_icon.svg',
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBlock(BuildContext context, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          department.name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: context.themeTextPrimary,
            height: 28 / 20,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          department.nameArabic,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w400,
            color: context.themeTextSecondary,
            height: 24 / 17,
          ),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildBadge(department.code, const Color(0xFFF3F4F6), const Color(0xFF364153)),
            _buildBadge(
              department.isActive ? localizations.active : localizations.inactive,
              department.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
              department.isActive ? const Color(0xFF016630) : const Color(0xFFB91C1C),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicInformationSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          localizations.basicInformation,
          'assets/icons/company_stat_icon.svg',
          isDark,
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              _buildLabelValueRow(
                context: context,
                label: localizations.departmentCode,
                value: department.code,
                isDark: isDark,
              ),
              SizedBox(height: 8.h),
              _buildLabelValueRow(
                context: context,
                label: localizations.status,
                value: '',
                isDark: isDark,
                trailing: _buildBadge(
                  department.isActive ? localizations.active : localizations.inactive,
                  department.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  department.isActive ? const Color(0xFF016630) : const Color(0xFFB91C1C),
                ),
              ),
              SizedBox(height: 8.h),
              _buildLabelValueRow(
                context: context,
                label: localizations.businessUnit,
                value: department.businessUnitName,
                isDark: isDark,
              ),
              SizedBox(height: 8.h),
              _buildLabelValueRow(
                context: context,
                label: localizations.division,
                value: department.divisionName,
                isDark: isDark,
              ),
              SizedBox(height: 8.h),
              _buildLabelValueRow(
                context: context,
                label: localizations.departmentFocus,
                value: department.focusArea,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeadershipSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          localizations.departmentLeadership,
          'assets/icons/head_icon.svg',
          isDark,
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabelValueRow(
                context: context,
                label: localizations.head,
                value: department.headName,
                isDark: isDark,
              ),
              SizedBox(height: 12.h),
              _buildContactRow(
                context,
                'assets/icons/email_icon.svg',
                department.headEmail ?? localizations.notSpecified,
                isDark,
              ),
              SizedBox(height: 12.h),
              _buildContactRow(
                context,
                'assets/icons/phone_icon.svg',
                department.headPhone ?? localizations.notSpecified,
                isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          localizations.organizationalMetrics,
          'assets/icons/department_metric_icon.svg',
          isDark,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildMetricCard(
              context,
              '${department.employees}',
              localizations.totalEmployees,
              'assets/icons/department_metric_icon.svg',
              isDark,
            ),
            SizedBox(width: 12.w),
            _buildMetricCard(
              context,
              '${department.sections}',
              localizations.totalDepartments,
              'assets/icons/department_metric2_icon.svg',
              isDark,
            ),
            SizedBox(width: 12.w),
            _buildMetricCard(
              context,
              department.budget,
              localizations.departmentBudget,
              'assets/icons/department_metric3_icon.svg',
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          localizations.departmentDescription,
          'assets/icons/department_card_icon.svg',
          isDark,
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(
            department.focusArea,
            style: TextStyle(
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              color: context.themeTextSecondary,
              height: 22 / 15.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String iconPath,
    bool isDark,
  ) {
    return Row(
      children: [
        SvgIconWidget(
          assetPath: iconPath,
          size: 20.sp,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 22 / 15.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color background, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 18 / 13.5,
        ),
      ),
    );
  }

  Widget _buildLabelValueRow({
    required BuildContext context,
    required String label,
    required String value,
    required bool isDark,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: context.themeTextSecondary,
              height: 22 / 15,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (value.isNotEmpty)
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: context.themeTextPrimary,
                    height: 22 / 15,
                  ),
                ),
              if (value.isNotEmpty && trailing != null) SizedBox(width: 8.w),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(
    BuildContext context,
    String iconPath,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        SvgIconWidget(
          assetPath: iconPath,
          size: 16.sp,
          color: context.themeTextSecondary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: context.themeTextSecondary,
              height: 20 / 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String value,
    String label,
    String iconPath,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgIconWidget(
                  assetPath: iconPath,
                  size: 20.sp,
                  color: const Color(0xFF101828),
                ),
                SizedBox(width: 8.w),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: context.themeTextPrimary,
                    height: 22 / 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: context.themeTextSecondary,
                height: 20 / 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
