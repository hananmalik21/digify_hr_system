import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/mixins/datetime_conversion_mixin.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/duration_formatter.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_status_badge.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/update_shift_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftDetailsDialog extends ConsumerWidget with DateTimeConversionMixin {
  final ShiftOverview shift;

  const ShiftDetailsDialog({super.key, required this.shift});

  static Future<void> show(BuildContext context, ShiftOverview shift) {
    return showDialog(
      context: context,
      builder: (context) => ShiftDetailsDialog(shift: shift),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor = Color(shift.colorValue);

    return AppDialog(
      title: 'Shift Details',
      width: 600.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(color: bgColor.withValues(alpha: 0.125), shape: BoxShape.circle),
                child: DigifyAsset(assetPath: shift.iconPath, width: 32.w, height: 32.h, color: bgColor),
              ),
              Gap(16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shift.name, style: context.textTheme.titleLarge?.copyWith(fontSize: 19.0)),
                  Text(
                    textDirection: TextDirection.rtl,
                    shift.nameAr,
                    style: context.textTheme.bodyLarge?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
                  ),
                  Gap(12.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(4.r)),
                    child: Text(
                      shift.code.toUpperCase(),
                      style: context.textTheme.labelMedium?.copyWith(color: AppColors.infoText),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(20.h),
          const DigifyDivider(),
          Gap(20.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 4,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildDetailItem(context, 'Shift Type', shift.shiftType.displayName),
              _buildDetailItem(context, 'Status', '', widget: ShiftStatusBadge(isActive: shift.isActive)),
              _buildDetailItem(context, 'Start Time', shift.startTime),
              _buildDetailItem(context, 'End Time', shift.endTime),
              _buildDetailItem(context, 'Duration', '${DurationFormatter.formatHours(shift.totalHours)} hours'),
              _buildDetailItem(
                context,
                'Break Duration',
                '${DurationFormatter.formatHours(shift.breakHours.toDouble())} hour(s)',
              ),
              _buildDetailItem(context, 'Created Date', formatDate(shift.createdDate)),
              _buildDetailItem(context, 'Updated By', shift.updatedBy ?? '-'),
            ],
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Close', width: null, onPressed: () => Navigator.of(context).pop()),
        Gap(8.w),
        AppButton(
          label: 'Edit Shift',
          width: null,
          onPressed: () {
            context.pop();
            final enterpriseId = ref.read(timeManagementEnterpriseIdProvider);
            if (enterpriseId != null) {
              UpdateShiftDialog.show(context, shift, enterpriseId: enterpriseId);
            }
          },
          svgPath: Assets.icons.editIcon.path,
          backgroundColor: AppColors.greenButton,
        ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, {Widget? widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Gap(4.h),
        widget ?? Text(value, style: context.textTheme.titleSmall?.copyWith(color: AppColors.dialogTitle)),
      ],
    );
  }
}
