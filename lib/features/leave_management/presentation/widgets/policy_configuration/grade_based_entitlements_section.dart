import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/core/widgets/forms/date_selection_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_detail.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeBasedEntitlementsSection extends StatelessWidget {
  final bool isDark;
  final List<GradeEntitlement> gradeRows;
  final String effectiveDate;
  final bool enableProRata;
  final String accrualMethod;
  final bool isEditing;

  const GradeBasedEntitlementsSection({
    super.key,
    required this.isDark,
    required this.gradeRows,
    required this.effectiveDate,
    required this.enableProRata,
    required this.accrualMethod,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Grade-Based Entitlements & Accrual',
      iconPath: Assets.icons.leaveManagementIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          ...gradeRows.map(
            (grade) => _GradeRowCard(grade: grade, isDark: isDark, accrualMethod: accrualMethod, isEditing: isEditing),
          ),
          if (isEditing)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton.primary(label: 'Add Grade', svgPath: Assets.icons.addIcon.path, onPressed: () {}),
            ),
          _EffectiveDateCard(effectiveDate: effectiveDate, isDark: isDark, isEditing: isEditing),
          _ProRataCard(enableProRata: enableProRata, isDark: isDark, isEditing: isEditing),
        ],
      ),
    );
  }
}

class _GradeRowCard extends StatelessWidget {
  final GradeEntitlement grade;
  final bool isDark;
  final String accrualMethod;
  final bool isEditing;

  const _GradeRowCard({required this.grade, required this.isDark, required this.accrualMethod, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.workforce.fillRate.path,
            width: 20.w,
            height: 20.h,
            color: AppColors.primary,
          ),
          Row(
            spacing: 12.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildNumberField(context, label: 'Grade From', value: grade.gradeFrom?.toString() ?? ''),
              ),
              Expanded(
                child: _buildNumberFieldWithHint(
                  context,
                  label: 'Grade To',
                  value: grade.gradeTo?.toString() ?? '',
                  hint: 'Leave empty for "and above"',
                ),
              ),
              Expanded(
                child: _buildNumberField(context, label: 'Days', value: grade.entitlementDays.toString()),
              ),
              Expanded(child: _buildAccrualMethodDropdown(context)),
              Expanded(
                child: _buildNumberField(
                  context,
                  label: 'Accrual Rate',
                  value: grade.accrualRate?.toStringAsFixed(2) ?? '',
                ),
              ),
              Expanded(child: _buildStatusDropdown(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(BuildContext context, {required String label, required String value}) {
    return DigifyTextField.number(
      controller: TextEditingController(text: value),
      labelText: label,
      filled: true,
      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      enabled: isEditing,
    );
  }

  Widget _buildAccrualMethodDropdown(BuildContext context) {
    final accrualOptions = ['Monthly', 'Yearly', 'None'];

    return DigifySelectFieldWithLabel<String>(
      label: 'Accrual Method',
      items: accrualOptions,
      itemLabelBuilder: (item) => item,
      value: accrualMethod,
      onChanged: isEditing ? (_) {} : null,
    );
  }

  Widget _buildNumberFieldWithHint(
    BuildContext context, {
    required String label,
    required String value,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyTextField.number(
          controller: TextEditingController(text: value),
          labelText: label,
          filled: true,
          fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          enabled: false,
        ),
        SizedBox(height: 4.h),
        Text(
          hint,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 11.sp,
            color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    final statusOptions = ['Active', 'Inactive'];
    final currentStatus = grade.isActive ? 'Active' : 'Inactive';

    return DigifySelectFieldWithLabel<String>(
      label: 'Status',
      items: statusOptions,
      itemLabelBuilder: (item) => item,
      value: currentStatus,
      onChanged: isEditing ? (_) {} : null,
    );
  }
}

class _EffectiveDateCard extends StatelessWidget {
  final String effectiveDate;
  final bool isDark;
  final bool isEditing;

  const _EffectiveDateCard({required this.effectiveDate, required this.isDark, this.isEditing = false});

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty || dateStr == '-') return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.lightWhiteBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: DateSelectionField(
        label: 'Effective Date (applies to all grade ranges)',
        labelIconPath: Assets.icons.clockIcon.path,
        date: _parseDate(effectiveDate),
        hintText: 'Select effective date',
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        onDateSelected: isEditing ? (_) {} : (_) {},
        enabled: isEditing,
      ),
    );
  }
}

class _ProRataCard extends StatelessWidget {
  final bool enableProRata;
  final bool isDark;
  final bool isEditing;

  const _ProRataCard({required this.enableProRata, required this.isDark, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.roleBadgeBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.permissionBadgeBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyCheckbox(value: enableProRata, onChanged: isEditing ? (_) {} : null),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  'Enable Pro-Rata Calculation',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.infoTextDark : AppColors.statIconBlue,
                  ),
                ),
                Text(
                  'Calculate leave entitlement proportionally for partial years (new joiners, resignations)',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontSize: 12.sp,
                    color: isDark ? AppColors.infoTextDark.withValues(alpha: 0.8) : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
