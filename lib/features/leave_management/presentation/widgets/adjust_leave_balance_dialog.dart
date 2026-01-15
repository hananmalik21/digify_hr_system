import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustLeaveBalanceDialog extends StatefulWidget {
  final String employeeName;
  final String employeeId;
  final int currentAnnualLeave;
  final int currentSickLeave;
  final int currentUnpaidLeave;

  const AdjustLeaveBalanceDialog({
    super.key,
    required this.employeeName,
    required this.employeeId,
    required this.currentAnnualLeave,
    required this.currentSickLeave,
    required this.currentUnpaidLeave,
  });

  static void show(
    BuildContext context, {
    required String employeeName,
    required String employeeId,
    required int currentAnnualLeave,
    required int currentSickLeave,
    required int currentUnpaidLeave,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AdjustLeaveBalanceDialog(
        employeeName: employeeName,
        employeeId: employeeId,
        currentAnnualLeave: currentAnnualLeave,
        currentSickLeave: currentSickLeave,
        currentUnpaidLeave: currentUnpaidLeave,
      ),
    );
  }

  @override
  State<AdjustLeaveBalanceDialog> createState() => _AdjustLeaveBalanceDialogState();
}

class _AdjustLeaveBalanceDialogState extends State<AdjustLeaveBalanceDialog> {
  late TextEditingController _annualLeaveController;
  late TextEditingController _sickLeaveController;
  late TextEditingController _unpaidLeaveController;
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _annualLeaveController = TextEditingController(text: widget.currentAnnualLeave.toString());
    _sickLeaveController = TextEditingController(text: widget.currentSickLeave.toString());
    _unpaidLeaveController = TextEditingController(text: widget.currentUnpaidLeave.toString());
    _reasonController = TextEditingController();

    // Add listeners to update comparison section when values change
    _annualLeaveController.addListener(() => setState(() {}));
    _sickLeaveController.addListener(() => setState(() {}));
    _unpaidLeaveController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _annualLeaveController.dispose();
    _sickLeaveController.dispose();
    _unpaidLeaveController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 500.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(localizations, isDark),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(21.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLeaveBalanceFieldsRow(isDark),
                      Gap(14.h),
                      _buildComparisonSection(isDark),
                      Gap(14.h),
                      _buildReasonField(isDark),
                      Gap(14.h),
                      _buildWarningNote(isDark),
                      Gap(14.h),
                      _buildFooter(localizations, isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 21.w, vertical: 21.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adjust Leave Balance',
                  style: TextStyle(
                    fontSize: 15.1.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
                    height: 23.63 / 15.1,
                  ),
                ),
                Gap(0.01.h),
                Text(
                  widget.employeeName,
                  style: TextStyle(
                    fontSize: 13.7.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
                    height: 21 / 13.7,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: DigifyAsset(
                  assetPath: Assets.icons.closeIcon.path,
                  width: 17.5,
                  height: 17.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceFieldsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildLeaveBalanceField(
            label: 'Annual Leave',
            labelSuffix: '(days)',
            controller: _annualLeaveController,
            isDark: isDark,
            fontSize: 13.7.sp,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildLeaveBalanceField(
            label: 'Sick Leave',
            labelSuffix: '(days)',
            controller: _sickLeaveController,
            isDark: isDark,
            fontSize: 14.sp,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: _buildLeaveBalanceField(
            label: 'Unpaid Leave',
            labelSuffix: '(days)',
            controller: _unpaidLeaveController,
            isDark: isDark,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveBalanceField({
    required String label,
    String? labelSuffix,
    required TextEditingController controller,
    required bool isDark,
    required double fontSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelSuffix != null ? '$label\n$labelSuffix' : label,
          style: TextStyle(
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? context.themeTextSecondary : const Color(0xFF364153),
            height: 21 / 13.6,
          ),
        ),
        Gap(7.h),
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
              height: 21 / fontSize,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 11.5.w, vertical: 8.h),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintText: null,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonSection(bool isDark) {
    final previousAnnual = widget.currentAnnualLeave;
    final previousSick = widget.currentSickLeave;
    final newAnnual = int.tryParse(_annualLeaveController.text) ?? previousAnnual;
    final newSick = int.tryParse(_sickLeaveController.text) ?? previousSick;

    return Container(
      // height: 42.h,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Previous Annual:',
                      style: TextStyle(
                        fontSize: 12.1.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
                        height: 17.5 / 12.1,
                      ),
                    ),
                    Gap(7.w),
                    Text(
                      '$previousAnnual days',
                      style: TextStyle(
                        fontSize: 11.9.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
                        height: 17.5 / 11.9,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'New Annual:',
                      style: TextStyle(
                        fontSize: 12.1.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
                        height: 17.5 / 12.1,
                      ),
                    ),
                    Gap(7.w),
                    Text(
                      '$newAnnual days',
                      style: TextStyle(
                        fontSize: 11.9.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF155DFC),
                        height: 17.5 / 11.9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Previous Sick:',
                      style: TextStyle(
                        fontSize: 12.1.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
                        height: 17.5 / 12.1,
                      ),
                    ),
                    Gap(7.w),
                    Text(
                      '$previousSick days',
                      style: TextStyle(
                        fontSize: 12.1.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? context.themeTextPrimary : const Color(0xFF101828),
                        height: 17.5 / 12.1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'New Sick:',
                      style: TextStyle(
                        fontSize: 12.1.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? context.themeTextSecondary : const Color(0xFF4A5565),
                        height: 17.5 / 12.1,
                      ),
                    ),
                    Gap(7.w),
                    Text(
                      '$newSick days',
                      style: TextStyle(
                        fontSize: 12.1.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF155DFC),
                        height: 17.5 / 12.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReasonField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adjustment Reason *',
          style: TextStyle(
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? context.themeTextSecondary : const Color(0xFF364153),
            height: 21 / 13.6,
          ),
        ),
        Gap(7.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: TextField(
              controller: _reasonController,
              maxLines: null,
              minLines: 3,
              style: TextStyle(
                fontSize: 13.8.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
                height: 21 / 13.8,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 11.5.w,
                  right: 11.5.w,
                  top: 8.h,
                  bottom: 29.h,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: 'E.g., Annual leave accrual, Manual correction, Carried forward from previous year...',
                hintStyle: TextStyle(
                  fontSize: 13.8.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                  height: 21 / 13.8,
                ),
                isDense: true,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWarningNote(bool isDark) {
    return Container(
      padding: EdgeInsets.all(11.5.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCE8),
        border: Border.all(
          color: const Color(0xFFFFF085),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 12.1.sp,
            height: 17.5 / 12.1,
            color: const Color(0xFF894B00),
          ),
          children: [
            const TextSpan(
              text: 'Note: ',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const TextSpan(
              text: 'Balance adjustments will be logged in the audit trail. Ensure ',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            const TextSpan(
              text: 'you provide a clear reason for the adjustment.',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations localizations, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? AppColors.inputBorderDark : const Color(0xFFD1D5DC),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? context.themeTextPrimary : const Color(0xFF0A0A0A),
                  height: 21 / 13.7,
                ),
              ),
            ),
          ),
          Gap(10.5.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.75.h),
            decoration: BoxDecoration(
              color: const Color(0xFF155DFC),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: TextButton(
              onPressed: () {
                // TODO: Validate and save changes
                final annualLeave = int.tryParse(_annualLeaveController.text) ?? 0;
                final sickLeave = int.tryParse(_sickLeaveController.text) ?? 0;
                final unpaidLeave = int.tryParse(_unpaidLeaveController.text) ?? 0;
                final reason = _reasonController.text;

                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a reason for the adjustment')),
                  );
                  return;
                }

                // TODO: Call API to save adjustments
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Update Balance',
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 21 / 13.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
