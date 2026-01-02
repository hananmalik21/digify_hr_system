import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class OrgUnitDetailsDialog extends StatelessWidget {
  final OrgStructureLevel unit;

  const OrgUnitDetailsDialog({super.key, required this.unit});

  static Future<void> show(BuildContext context, OrgStructureLevel unit) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => OrgUnitDetailsDialog(unit: unit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          width: 800.w,
          constraints: BoxConstraints(maxHeight: 700.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 50, offset: const Offset(0, 25)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(localizations),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBasicInformation(localizations, isDark),
                        SizedBox(height: 24.h),
                        _buildManagerInformation(localizations, isDark),
                        SizedBox(height: 24.h),
                        _buildLocationInformation(localizations, isDark),
                        if (unit.description.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          _buildDescription(localizations, isDark),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F39F6), Color(0xFF432DD7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgIconWidget(assetPath: 'assets/icons/company_stat_icon.svg', size: 20.sp, color: Colors.white),
              SizedBox(width: 8.w),
              Text(
                'Unit Details - ${unit.levelCode}',
                style: TextStyle(
                  fontSize: 18.8.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 30 / 18.8,
                ),
              ),
            ],
          ),
          Builder(
            builder: (innerContext) => GestureDetector(
              onTap: () => Navigator.of(innerContext).pop(),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: SvgIconWidget(assetPath: 'assets/icons/close_dialog_icon.svg', size: 20.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformation(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(localizations.basicInformation, 'assets/icons/company_stat_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              _buildInfoRow('Unit Code:', unit.orgUnitCode, isDark),
              SizedBox(height: 8.h),
              _buildInfoRow('Unit Name (English):', unit.orgUnitNameEn, isDark),
              SizedBox(height: 8.h),
              _buildInfoRow('Unit Name (Arabic):', unit.orgUnitNameAr, isDark),
              SizedBox(height: 8.h),
              _buildInfoRowWithBadge(
                '${localizations.status}:',
                unit.isActive ? 'Active' : 'Inactive',
                unit.isActive,
                isDark,
              ),
              SizedBox(height: 8.h),
              _buildInfoRow('Level Code:', unit.levelCode, isDark),
              if (unit.parentOrgUnitId != null) ...[
                SizedBox(height: 8.h),
                _buildInfoRow('Parent Unit ID:', unit.parentOrgUnitId.toString(), isDark),
              ],
              SizedBox(height: 8.h),
              _buildInfoRow('Structure ID:', unit.orgStructureId.toString(), isDark),
              SizedBox(height: 8.h),
              _buildInfoRow('Enterprise ID:', unit.enterpriseId.toString(), isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManagerInformation(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Manager Information', 'assets/icons/phone_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              if (unit.managerName.isNotEmpty) ...[
                _buildInfoRow('Manager Name:', unit.managerName, isDark),
                SizedBox(height: 8.h),
              ],
              if (unit.managerEmail.isNotEmpty) ...[
                _buildContactIconRow('assets/icons/email_envelope_purple.svg', unit.managerEmail, isDark),
                SizedBox(height: 8.h),
              ],
              if (unit.managerPhone.isNotEmpty) ...[
                _buildContactIconRow('assets/icons/phone_icon.svg', unit.managerPhone, isDark),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInformation(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Location Information', 'assets/icons/location_header_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              if (unit.location.isNotEmpty) ...[
                _buildInfoRow('${localizations.location}:', unit.location, isDark),
                SizedBox(height: 8.h),
              ],
              if (unit.city.isNotEmpty) ...[
                _buildInfoRow('${localizations.city}:', unit.city, isDark),
                SizedBox(height: 8.h),
              ],
              if (unit.address.isNotEmpty) ...[
                _buildContactRow('assets/icons/location_header_icon.svg', [unit.address], isDark),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(AppLocalizations localizations, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(localizations.description, 'assets/icons/company_stat_icon.svg', isDark),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            unit.description,
            style: TextStyle(
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              height: 24 / 15.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String iconPath, bool isDark) {
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
            fontSize: 15.4.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            height: 24 / 15.4,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 24 / 15.3,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 15.6.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              height: 24 / 15.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithBadge(String label, String value, bool isActive, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.4.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
            height: 24 / 15.4,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? const Color(0xFF065F46) : const Color(0xFFDCFCE7))
                : (isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2)),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: isActive
                  ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF016630))
                  : (isDark ? const Color(0xFFEF4444) : const Color(0xFF991B1B)),
              height: 20 / 13.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(String iconPath, List<String> lines, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: SvgIconWidget(
            assetPath: iconPath,
            size: 16.sp,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines.asMap().entries.map((entry) {
              final isFirst = entry.key == 0;
              return Text(
                entry.value,
                style: TextStyle(
                  fontSize: isFirst ? 15.4.sp : 15.1.sp,
                  fontWeight: FontWeight.w400,
                  color: isFirst
                      ? (isDark ? AppColors.textPrimaryDark : const Color(0xFF101828))
                      : (isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565)),
                  height: 24 / (isFirst ? 15.4 : 15.1),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildContactIconRow(String iconPath, String value, bool isDark) {
    return Row(
      children: [
        SvgIconWidget(
          assetPath: iconPath,
          size: 16.sp,
          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              height: 24 / 15.3,
            ),
          ),
        ),
      ],
    );
  }
}
