import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/app_shadows.dart';
import '../../../../../../core/widgets/assets/digify_asset_button.dart';
import '../../../../../../core/widgets/common/app_avatar.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../../core/widgets/common/digify_square_capsule.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../domain/models/overtime/overtime_record.dart';

class OvertimeTableRow extends ConsumerWidget {
  final OvertimeRecord record;
  final AppLocalizations localizations;
  final Function(OvertimeRecord) onView;
  final Function(OvertimeRecord) onEdit;
  final Function(OvertimeRecord) onDelete;

  const OvertimeTableRow({
    super.key,
    required this.record,
    required this.localizations,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedRecord = ref.watch(
      overtimeManagementProvider.select((value) => value.expandedRecord),
    );
    final notifier = ref.watch(overtimeManagementProvider.notifier);

    return Container(
      width: context.screenWidth,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildDataCell(
                Row(
                  children: [
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: expandedRecord == record.employeeId ? 0.5 : 0,
                      child: DigifyAssetButton(
                        assetPath: Assets.icons.arrowIcon.path,
                        color: expandedRecord == record.employeeId
                            ? AppColors.primary
                            : Theme.of(context).iconTheme.color,
                        onTap: () {
                          if (expandedRecord == record.employeeId) {
                            notifier.toggleOvertimeRecord(null);
                          } else {
                            notifier.toggleOvertimeRecord(record.employeeId);
                          }
                        },
                      ),
                    ),
                    Gap(12.w),
                    AppAvatar(
                      size: 40.r,
                      fallbackInitial: record.employeeDetail?.name,
                      textColor: AppColors.textPrimary,
                    ),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.employeeDetail?.name ?? "",
                          style: context.theme.textTheme.bodyLarge,
                        ),
                        Gap(4.h),
                        Text(
                          record.employeeId,
                          style: context.theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                250.w,
              ),
              _buildDataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("--/--/--", style: context.theme.textTheme.bodyLarge),
                    Gap(4.h),
                    Text(
                      "Requested: --/--/--",
                      style: context.theme.textTheme.labelSmall,
                    ),
                  ],
                ),
                200.w,
              ),
              _buildDataCell(
                DigifySquareCapsule(
                  label: record.overtimeDetail?.type ?? "",
                  textColor: AppColors.statIconBlue,
                  backgroundColor: AppColors.statIconBlue.withValues(
                    alpha: 0.1,
                  ),
                ),
                150.w,
              ),
              _buildDataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${record.overtimeDetail?.overtimeHours} hrs",
                      style: context.theme.textTheme.bodyLarge,
                    ),
                    Gap(4.h),
                    Text(
                      "Regular: ${record.overtimeDetail?.regularHours} hrs",
                      style: context.theme.textTheme.labelSmall,
                    ),
                  ],
                ),
                150.w,
              ),
              _buildDataCell(
                Text(
                  "${record.overtimeDetail?.rate}x",
                  style: context.theme.textTheme.bodyLarge,
                ),
                100.w,
              ),
              _buildDataCell(
                Text(
                  "KWD ${record.amount}",
                  style: context.theme.textTheme.bodyLarge,
                ),
                150.w,
              ),
              _buildDataCell(
                DigifyCapsule(
                  label: record.approvalInformation?.status ?? "",
                  textColor: AppColors.statIconGreen,
                  backgroundColor: AppColors.statIconGreen.withValues(
                    alpha: 0.1,
                  ),
                ),
                150.w,
              ),
              _buildDataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.w,
                  children: [
                    DigifyAssetButton(
                      assetPath: Assets.icons.blueEyeIcon.path,
                      onTap: () => onView(record),
                    ),
                    DigifyAssetButton(
                      assetPath: Assets.icons.editIcon.path,
                      onTap: () => onEdit(record),
                    ),
                    DigifyAssetButton(
                      assetPath: Assets.icons.redDeleteIcon.path,
                      onTap: () => onDelete(record),
                    ),
                  ],
                ),
                200.w,
              ),
            ],
          ),
          if (expandedRecord == record.employeeId) ...[
            Container(
              width: context.screenWidth,
              color: context.isDark
                  ? AppColors.backgroundDark
                  : AppColors.tableHeaderBackground,
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Employee Details
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.isDark
                              ? AppColors.cardBackgroundDark
                              : AppColors.dashboardCard,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: AppShadows.primaryShadow,
                        ),
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                DigifyAsset(
                                  assetPath: Assets.icons.userIcon.path,
                                  color: AppColors.primary,
                                ),
                                Gap(12.w),
                                Text(
                                  "Employee Details",
                                  style: context.theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Gap(16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Position:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  record.employeeDetail?.position ?? "--",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Gap(8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Department:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  record.employeeDetail?.department ?? "--",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Gap(8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Line Manager:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  record.employeeDetail?.lineManager ?? "--",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Overtime Details
                    Gap(16.w),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.isDark
                              ? AppColors.cardBackgroundDark
                              : AppColors.dashboardCard,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: AppShadows.primaryShadow,
                        ),
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                DigifyAsset(
                                  assetPath: Assets.icons.clockIcon.path,
                                ),
                                Gap(12.w),
                                Text(
                                  "Overtime Details",
                                  style: context.theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Gap(16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Regular Hours:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  "${record.overtimeDetail?.regularHours} hrs",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Gap(8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Overtime Hours:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  "${record.overtimeDetail?.overtimeHours} hrs",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Gap(8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Overtime Type:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  record.overtimeDetail?.type ?? "--",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Gap(8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rate Multiplier:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  "${record.overtimeDetail?.rate}x",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Approval Information
                    Gap(16.w),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.isDark
                              ? AppColors.cardBackgroundDark
                              : AppColors.dashboardCard,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: AppShadows.primaryShadow,
                        ),
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // DigifyAsset(assetPath: Assets.icons),
                                Gap(12.w),
                                Text(
                                  "Approval Information",
                                  style: context.theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Gap(16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Status:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                DigifyCapsule(
                                  label:
                                      record.approvalInformation?.status ?? "",
                                  backgroundColor: AppColors.statIconGreen
                                      .withValues(alpha: .2),
                                  textColor: AppColors.statIconGreen,
                                ),
                              ],
                            ),
                            Gap(8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Approved By:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  record.approvalInformation?.byUser ?? "--",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Gap(8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Approved Date:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Text(
                                  record.approvalInformation?.date.toString() ??
                                      "--",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Divider(
                              color: context.isDark
                                  ? AppColors.borderGreyDark
                                  : AppColors.borderGrey,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reason:",
                                  style: context.theme.textTheme.labelSmall,
                                ),
                                Gap(4.h),
                                Text(
                                  record.approvalInformation?.reason ?? "--",
                                  style: context.theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 20.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }
}
