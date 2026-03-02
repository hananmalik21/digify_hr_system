import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_avatar.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/core/widgets/common/digify_square_capsule.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../data/config/overtime_table_config.dart';

class OvertimeTableRow extends StatelessWidget {
  final OvertimeRecord record;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(OvertimeRecord) onView;
  final Function(OvertimeRecord) onEdit;
  final Function(OvertimeRecord) onDelete;

  const OvertimeTableRow({
    super.key,
    required this.record,
    required this.localizations,
    required this.isDark,
    required this.isExpanded,
    required this.onToggle,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: isExpanded
              ? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarActiveBg.withAlpha(128))
              : null,
          border: isExpanded
              ? null
              : Border(
                  bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
                ),
        ),
        child: Row(
          children: [
            Gap(24.w),
            AnimatedRotation(
              turns: isExpanded ? 0.25 : 0,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              child: Icon(
                Icons.keyboard_arrow_right,
                color: isExpanded
                    ? AppColors.statIconBlue
                    : isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.dialogCloseIcon,
                size: 20.r,
              ),
            ),
            if (OvertimeTableConfig.showEmployee)
              _buildDataCell(
                Row(
                  children: [
                    AppAvatar(
                      size: 35.w,
                      fallbackInitial: record.employeeDetail?.name,
                      textColor: AppColors.textPrimary,
                    ),
                    Gap(11.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (record.employeeDetail?.name ?? "").toUpperCase(),
                            style: context.theme.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                          ),
                          Gap(2.h),
                          Text(
                            record.employeeId,
                            style: context.theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.tableHeaderText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                OvertimeTableConfig.employeeWidth.w,
              ),
            if (OvertimeTableConfig.showDate)
              _buildDataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "--/--/--",
                      style: context.theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.dialogTitle,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      "Requested: --/--/--",
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.tableHeaderText,
                      ),
                    ),
                  ],
                ),
                OvertimeTableConfig.dateWidth.w,
              ),
            if (OvertimeTableConfig.showType)
              _buildDataCell(
                DigifySquareCapsule(
                  label: record.overtimeDetail?.type ?? "",
                  textColor: AppColors.statIconBlue,
                  backgroundColor: AppColors.statIconBlue.withValues(alpha: 0.1),
                ),
                OvertimeTableConfig.typeWidth.w,
              ),
            if (OvertimeTableConfig.showHours)
              _buildDataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${record.overtimeDetail?.overtimeHours} hrs",
                      style: context.theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.dialogTitle,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      "Regular: ${record.overtimeDetail?.regularHours} hrs",
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.tableHeaderText,
                      ),
                    ),
                  ],
                ),
                OvertimeTableConfig.hoursWidth.w,
              ),
            if (OvertimeTableConfig.showRate)
              _buildDataCell(
                Text(
                  "${record.overtimeDetail?.rate}x",
                  style: context.theme.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
                ),
                OvertimeTableConfig.rateWidth.w,
              ),
            if (OvertimeTableConfig.showAmount)
              _buildDataCell(
                Text(
                  "KWD ${record.amount}",
                  style: context.theme.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
                ),
                OvertimeTableConfig.amountWidth.w,
              ),
            if (OvertimeTableConfig.showStatus)
              _buildDataCell(
                DigifyCapsule(
                  label: record.approvalInformation?.status ?? "",
                  textColor: AppColors.statIconGreen,
                  backgroundColor: AppColors.statIconGreen.withValues(alpha: 0.1),
                ),
                OvertimeTableConfig.statusWidth.w,
              ),
            if (OvertimeTableConfig.showActions)
              _buildDataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.w,
                  children: [
                    DigifyAssetButton(assetPath: Assets.icons.blueEyeIcon.path, onTap: () => onView(record)),
                    DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: () => onEdit(record)),
                    DigifyAssetButton(assetPath: Assets.icons.redDeleteIcon.path, onTap: () => onDelete(record)),
                  ],
                ),
                OvertimeTableConfig.actionsWidth.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: OvertimeTableConfig.cellPaddingHorizontal.w, vertical: 16.h),
      child: child,
    );
  }
}
