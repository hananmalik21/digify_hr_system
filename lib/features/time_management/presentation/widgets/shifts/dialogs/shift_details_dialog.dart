import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/mixins/datetime_conversion_mixin.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_status_badge.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftDetailsDialog extends StatelessWidget with DateTimeConversionMixin {
  final ShiftOverview shift;

  const ShiftDetailsDialog({super.key, required this.shift});

  static Future<void> show(BuildContext context, ShiftOverview shift) {
    return showDialog(
      context: context,
      builder: (context) => ShiftDetailsDialog(shift: shift),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(shift.colorValue);

    return AppDialog(
      title: 'Shift Details',
      width: 500.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(color: bgColor.withValues(alpha: 0.125), shape: BoxShape.circle),
                child: DigifyAsset(assetPath: shift.iconPath, width: 24.w, height: 24.h, color: bgColor),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shift.name,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    shift.nameAr,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(4.r)),
                    child: Text(
                      shift.code,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.infoText),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const DigifyDivider(),
          SizedBox(height: 20.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 4,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildDetailItem('Shift Type', shift.shiftType.displayName),
              _buildDetailItem('Status', '', widget: ShiftStatusBadge(isActive: shift.isActive)),
              _buildDetailItem('Start Time', shift.startTime),
              _buildDetailItem('End Time', shift.endTime),
              _buildDetailItem('Duration', '${shift.totalHours.toStringAsFixed(1)} hours'),
              _buildDetailItem('Break Duration', '${shift.breakHours} hour(s)'),
              _buildDetailItem('Created Date', formatDate(shift.createdDate)),
              _buildDetailItem('Updated By', shift.updatedBy ?? '-'),
            ],
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Close', width: null, onPressed: () => Navigator.of(context).pop()),
        SizedBox(width: 8.w),
        AppButton(
          label: 'Edit Shift',
          width: null,
          onPressed: () {},
          svgPath: Assets.icons.editIcon.path,
          backgroundColor: AppColors.greenButton,
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, {Widget? widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: 4.h),
        widget ??
            Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
      ],
    );
  }
}
