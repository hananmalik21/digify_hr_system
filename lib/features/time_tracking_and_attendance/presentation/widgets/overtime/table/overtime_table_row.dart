import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_avatar.dart';
import 'package:digify_hr_system/core/widgets/common/digify_square_capsule.dart';
import 'package:digify_hr_system/core/enums/overtime_status.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../data/config/overtime_table_config.dart';
import '../../../providers/overtime/overtime_actions_provider.dart';
import '../../../providers/overtime/overtime_provider.dart';
import '../overtime_status_chip.dart';

class OvertimeTableRow extends ConsumerWidget {
  final OvertimeRecord record;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(OvertimeRecord)? onEdit;

  const OvertimeTableRow({
    super.key,
    required this.record,
    required this.localizations,
    required this.isDark,
    required this.isExpanded,
    required this.onToggle,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      fallbackInitial: record.employeeNameDisplay,
                      textColor: AppColors.textPrimary,
                    ),
                    Gap(11.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            record.employeeNameDisplay.toUpperCase(),
                            style: context.theme.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                          ),
                          Gap(2.h),
                          Text(
                            record.employeeIdDisplay,
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
                      record.dateDisplay,
                      style: context.theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.dialogTitle,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      'Requested: ${record.requestedDateDisplay}',
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
                  label: record.typeDisplay,
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
                      '${record.overtimeHoursDisplay} hrs',
                      style: context.theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.dialogTitle,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      'Regular: ${record.regularHoursDisplay} hrs',
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
                  '${record.rateDisplay}x',
                  style: context.theme.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
                ),
                OvertimeTableConfig.rateWidth.w,
              ),
            if (OvertimeTableConfig.showAmount)
              _buildDataCell(
                Text(
                  'KWD ${record.amountDisplay}',
                  style: context.theme.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
                ),
                OvertimeTableConfig.amountWidth.w,
              ),
            if (OvertimeTableConfig.showStatus)
              _buildDataCell(
                OvertimeStatusChip(status: OvertimeStatus.fromString(record.approvalInformation?.status ?? "")),
                OvertimeTableConfig.statusWidth.w,
              ),
            if (OvertimeTableConfig.showActions)
              _buildDataCell(_buildActionsCell(context, ref), OvertimeTableConfig.actionsWidth.w),
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

  Widget _buildActionsCell(BuildContext context, WidgetRef ref) {
    final status = OvertimeStatus.fromString(record.approvalInformation?.status ?? '');
    final state = ref.watch(overtimeManagementProvider);

    if (status == OvertimeStatus.draft) {
      final guid = record.otRequestGuid ?? '';
      final isCanceling = state.cancelingOvertimeGuid == guid;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAssetButton(
            assetPath: Assets.icons.editIconGreen.path,
            onTap: isCanceling ? null : () => onEdit?.call(record),
            width: 17.w,
            height: 17.h,
            color: AppColors.editIconGreen,
          ),
          Gap(8.w),
          DigifyAssetButton(
            assetPath: Assets.icons.closeIcon.path,
            isLoading: isCanceling,
            onTap: isCanceling ? null : () => OvertimeActions.cancelDraftOvertimeRequest(context, ref, record),
            width: 17.w,
            height: 17.h,
            color: AppColors.error,
          ),
        ],
      );
    }

    if (status == OvertimeStatus.submitted || status == OvertimeStatus.pending) {
      final guid = record.otRequestGuid ?? '';
      final isApproving = state.approvingOvertimeGuid == guid;
      final isRejecting = state.rejectingOvertimeGuid == guid;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAssetButton(
            assetPath: Assets.icons.checkIconGreen.path,
            isLoading: isApproving,
            onTap: isApproving || isRejecting
                ? null
                : () => OvertimeActions.approveOvertimeRequest(context, ref, record),
            width: 17.w,
            height: 17.h,
            color: AppColors.success,
          ),
          Gap(8.w),
          DigifyAssetButton(
            assetPath: Assets.icons.closeIcon.path,
            isLoading: isRejecting,
            onTap: isApproving || isRejecting
                ? null
                : () => OvertimeActions.rejectOvertimeRequest(context, ref, record),
            width: 17.w,
            height: 17.h,
            color: AppColors.error,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
